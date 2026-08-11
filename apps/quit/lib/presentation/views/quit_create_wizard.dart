import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/quit_providers.dart';
import '../../domain/entities/quit_item.dart';
import 'package:app_theme/app_theme.dart';
import '../../utils/format.dart';
import '../quit_type_style.dart';

enum _Step { type, name, when, amount, confirm }

/// 토스식 단계별 생성 마법사. 한 단계씩 선택하며 부드럽게 전환된다.
class QuitCreateWizard extends ConsumerStatefulWidget {
  const QuitCreateWizard({super.key});

  @override
  ConsumerState<QuitCreateWizard> createState() => _QuitCreateWizardState();
}

class _QuitCreateWizardState extends ConsumerState<QuitCreateWizard> {
  int _index = 0;
  bool _forward = true;

  QuitType? _type;
  DateTime? _quitDate;

  final _nameCtrl = TextEditingController();
  final _cigCtrl = TextEditingController(text: '10');
  final _packCtrl = TextEditingController(text: '4500');
  final _freqCtrl = TextEditingController();
  final _drinkCostCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _countCtrl = TextEditingController();

  List<_Step> get _steps => [
        _Step.type,
        if (_type == QuitType.custom) _Step.name,
        _Step.when,
        _Step.amount,
        _Step.confirm,
      ];

  _Step get _cur => _steps[_index];

  @override
  void dispose() {
    for (final c in [
      _nameCtrl, _cigCtrl, _packCtrl, _freqCtrl, _drinkCostCtrl, _costCtrl,
      _countCtrl // ignore: require_trailing_commas
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_index >= _steps.length - 1) return;
    HapticFeedback.selectionClick();
    setState(() {
      _forward = true;
      _index++;
    });
  }

  void _back() {
    FocusScope.of(context).unfocus();
    if (_index == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _forward = false;
      _index--;
    });
  }

  void _pickType(QuitType t) {
    setState(() => _type = t);
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) _next();
    });
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _quitDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_quitDate ?? now),
    );
    if (!mounted) return;
    final t = time ?? TimeOfDay.fromDateTime(now);
    setState(() => _quitDate =
        DateTime(date.year, date.month, date.day, t.hour, t.minute));
  }

  // 종류별 (하루비용, 하루소비량, 단위) 계산
  (int, double, String) _computeAmount() {
    switch (_type!) {
      case QuitType.smoking:
        final cig = double.tryParse(_cigCtrl.text.trim()) ?? 0;
        final pack = int.tryParse(_packCtrl.text.trim()) ?? 0;
        return ((cig / 20 * pack).round(), cig, '개비');
      case QuitType.drinking:
        final freq = double.tryParse(_freqCtrl.text.trim()) ?? 0;
        final per = int.tryParse(_drinkCostCtrl.text.trim()) ?? 0;
        return (((freq * per) / 7).round(), freq / 7, '회');
      case QuitType.custom:
        final cost = int.tryParse(_costCtrl.text.trim()) ?? 0;
        final cnt = double.tryParse(_countCtrl.text.trim()) ?? 0;
        return (cost, cnt, '회');
    }
  }

  Future<void> _finish() async {
    final (cost, units, unit) = _computeAmount();
    final name = switch (_type!) {
      QuitType.smoking => '담배',
      QuitType.drinking => '술',
      QuitType.custom =>
        _nameCtrl.text.trim().isEmpty ? '나의 목표' : _nameCtrl.text.trim(),
    };
    final item = QuitItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
      type: _type!,
      quitDate: _quitDate ?? DateTime.now(),
      dailyCost: cost,
      dailyUnits: units,
      unitLabel: unit,
      createdAt: DateTime.now(),
    );
    await ref.read(quitListProvider.notifier).save(item);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = UiColors.of(context);
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          children: [
            // 상단: 뒤로 + 진행바
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s8, AppSpacing.s8, AppSpacing.s20, AppSpacing.s8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _back,
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20, color: c.textSecondary),
                  ),
                  Expanded(child: _progressBar(c)),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 340),
                reverseDuration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                // 이전 단계는 제자리에서 페이드아웃, 새 단계만 슬라이드+스케일로 부드럽게.
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.topCenter,
                  children: [...previousChildren, ?currentChild],
                ),
                transitionBuilder: (child, anim) {
                  final dx = _forward ? 0.10 : -0.10;
                  final slide = Tween<Offset>(
                    begin: Offset(dx, 0),
                    end: Offset.zero,
                  ).animate(anim);
                  final scale = Tween<double>(begin: 0.98, end: 1.0).animate(anim);
                  return FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: slide,
                      child: ScaleTransition(scale: scale, child: child),
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(_cur),
                  child: _stepBody(c),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(UiColors c) {
    final target = (_index + 1) / _steps.length;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.max),
      child: Container(
        height: 6,
        color: c.surfaceAlt,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: target),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (_, v, _) => FractionallySizedBox(
              widthFactor: v.clamp(0.0, 1.0),
              child: Container(color: c.accent),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepBody(UiColors c) => switch (_cur) {
        _Step.type => _typeStep(c),
        _Step.name => _nameStep(c),
        _Step.when => _whenStep(c),
        _Step.amount => _amountStep(c),
        _Step.confirm => _confirmStep(c),
      };

  // 공통 레이아웃: 제목 + 본문 + (하단 버튼)
  Widget _scaffoldStep(UiColors c,
      {required String title, String? subtitle, required Widget body, Widget? bottom}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s24, AppSpacing.s12, AppSpacing.s24, AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.title1.copyWith(color: c.textPrimary)),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.s8),
            Text(subtitle,
                style: AppTypography.body2.copyWith(color: c.textSecondary)),
          ],
          const SizedBox(height: AppSpacing.s24),
          Expanded(child: SingleChildScrollView(child: body)),
          if (bottom != null) ...[const SizedBox(height: AppSpacing.s12), bottom],
        ],
      ),
    );
  }

  // Step 1 — 종류
  Widget _typeStep(UiColors c) => _scaffoldStep(
        c,
        title: '무엇을 끊을까요?',
        body: Column(
          children: [
            for (final t in QuitType.values) ...[
              _bigOption(
                c,
                icon: QuitTypeStyle.icon(t),
                color: QuitTypeStyle.color(t),
                label: QuitTypeStyle.label(t),
                selected: _type == t,
                onTap: () => _pickType(t),
              ),
              const SizedBox(height: AppSpacing.s12),
            ],
          ],
        ),
      );

  Widget _bigOption(UiColors c,
      {required IconData icon,
      required Color color,
      required String label,
      required bool selected,
      required VoidCallback onTap}) {
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            border: Border.all(
                color: selected ? c.accent : c.border,
                width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSpacing.s16),
              Text(label,
                  style:
                      AppTypography.itemTitle.copyWith(color: c.textPrimary)),
              const Spacer(),
              Icon(Icons.chevron_right, color: c.textTertiary),
            ],
          ),
        ),
      ),
    );
  }

  // Step 1b — 커스텀 이름
  Widget _nameStep(UiColors c) => _scaffoldStep(
        c,
        title: '무엇을 끊을 거예요?',
        body: UiTextField(
          controller: _nameCtrl,
          hint: '예: 카페인, 야식, 게임',
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _next(),
        ),
        bottom: ListenableBuilder(
          listenable: _nameCtrl,
          builder: (_, _) => UiButton(
            label: '다음',
            onPressed: _nameCtrl.text.trim().isEmpty ? null : _next,
          ),
        ),
      );

  // Step 2 — 언제부터
  Widget _whenStep(UiColors c) {
    final picked = _quitDate;
    return _scaffoldStep(
      c,
      title: '언제부터 시작할까요?',
      body: Column(
        children: [
          UiButton(
            label: '지금부터 시작',
            icon: Icons.bolt_rounded,
            onPressed: () {
              setState(() => _quitDate = DateTime.now());
              _next();
            },
          ),
          const SizedBox(height: AppSpacing.s12),
          UiButton(
            label: picked == null
                ? '날짜·시간 직접 선택'
                : _fmtDateTime(picked),
            icon: Icons.event_rounded,
            filled: false,
            onPressed: _pickDateTime,
          ),
        ],
      ),
      bottom: picked == null
          ? null
          : UiButton(label: '다음', onPressed: _next),
    );
  }

  // Step 3 — 이전 소비량
  Widget _amountStep(UiColors c) {
    return _scaffoldStep(
      c,
      title: '얼마나 쓰고 있었나요?',
      subtitle: '절약한 금액을 계산해드려요',
      body: Column(children: _amountInputs(c)),
      bottom: Column(
        children: [
          UiButton(label: '다음', onPressed: _next),
          const SizedBox(height: AppSpacing.s4),
          TextButton(
            onPressed: () {
              // 잘 모르겠어요 → 0으로 두고 넘어감
              _cigCtrl.text = '0';
              _packCtrl.text = '0';
              _freqCtrl.text = '0';
              _drinkCostCtrl.text = '0';
              _costCtrl.text = '0';
              _countCtrl.text = '0';
              _next();
            },
            child: Text('잘 모르겠어요 · 건너뛰기',
                style:
                    AppTypography.label3.copyWith(color: c.textTertiary)),
          ),
        ],
      ),
    );
  }

  List<Widget> _amountInputs(UiColors c) {
    switch (_type!) {
      case QuitType.smoking:
        return [
          const UiSectionLabel('하루에 몇 개비 피웠나요?'),
          UiTextField(
              controller: _cigCtrl,
              suffixText: '개비',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: AppSpacing.s16),
          const UiSectionLabel('한 갑 가격'),
          UiTextField(
              controller: _packCtrl,
              prefixText: '₩ ',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        ];
      case QuitType.drinking:
        return [
          const UiSectionLabel('일주일에 몇 번 마셨나요?'),
          UiTextField(
              controller: _freqCtrl,
              suffixText: '회',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: AppSpacing.s16),
          const UiSectionLabel('한 번에 얼마 썼나요?'),
          UiTextField(
              controller: _drinkCostCtrl,
              prefixText: '₩ ',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        ];
      case QuitType.custom:
        return [
          const UiSectionLabel('하루에 얼마 썼나요?'),
          UiTextField(
              controller: _costCtrl,
              prefixText: '₩ ',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
          const SizedBox(height: AppSpacing.s16),
          const UiSectionLabel('하루에 몇 번? (선택)'),
          UiTextField(
              controller: _countCtrl,
              suffixText: '회',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
        ];
    }
  }

  // Step 4 — 확인
  Widget _confirmStep(UiColors c) {
    final (cost, _, _) = _computeAmount();
    final name = switch (_type!) {
      QuitType.smoking => '담배',
      QuitType.drinking => '술',
      QuitType.custom =>
        _nameCtrl.text.trim().isEmpty ? '나의 목표' : _nameCtrl.text.trim(),
    };
    final color = QuitTypeStyle.color(_type!);
    return _scaffoldStep(
      c,
      title: '준비 끝!',
      subtitle: '지금부터 하루더 버텨봐요',
      body: Container(
        padding: const EdgeInsets.all(AppSpacing.s20),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child:
                  Icon(QuitTypeStyle.icon(_type!), color: Colors.white, size: 32),
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(name,
                style: AppTypography.title2.copyWith(color: c.textPrimary)),
            const SizedBox(height: AppSpacing.s4),
            Text(_quitDate == null ? '지금부터' : _fmtDateTime(_quitDate!),
                style: AppTypography.body3.copyWith(color: c.textSecondary)),
            const SizedBox(height: AppSpacing.s16),
            if (cost > 0)
              Text('하루 ${formatWon(cost)} 절약',
                  style: AppTypography.itemTitle.copyWith(color: c.accent)),
          ],
        ),
      ),
      bottom: UiButton(
        label: '하루더 시작하기',
        icon: Icons.check_rounded,
        onPressed: _finish,
      ),
    );
  }

  String _fmtDateTime(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}
