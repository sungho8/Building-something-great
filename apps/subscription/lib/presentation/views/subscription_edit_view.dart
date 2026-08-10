import 'package:design_system/design_system.dart'
    show AppSpacing, AppRadius, AppTypography;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/subscription_providers.dart';
import '../../domain/entities/subscription.dart';
import '../../theme/sub_theme.dart';
import '../../theme/sub_widgets.dart';
import '../../utils/currency_format.dart';
import '../category_style.dart';

/// 인기 구독 프리셋. 탭하면 이름·카테고리·대표색(KeyColor)을 자동 채운다.
/// color는 브랜드 로고가 아니라 대표색만 accent로 쓴다(저작권 무관).
typedef _Preset = ({String name, SubscriptionCategory cat, int color});
const _presets = <_Preset>[
  (name: '넷플릭스', cat: SubscriptionCategory.entertainment, color: 0xFFE50914),
  (name: '유튜브 프리미엄', cat: SubscriptionCategory.entertainment, color: 0xFFFF0000),
  (name: '디즈니+', cat: SubscriptionCategory.entertainment, color: 0xFF1A48E0),
  (name: '티빙', cat: SubscriptionCategory.entertainment, color: 0xFFE7344C),
  (name: '쿠팡플레이', cat: SubscriptionCategory.entertainment, color: 0xFF5B3EE8),
  (name: '멜론', cat: SubscriptionCategory.music, color: 0xFF00CD3C),
  (name: '스포티파이', cat: SubscriptionCategory.music, color: 0xFF1DB954),
  (name: '유튜브 뮤직', cat: SubscriptionCategory.music, color: 0xFFFF0000),
  (name: '쿠팡 와우', cat: SubscriptionCategory.shopping, color: 0xFFE52528),
  (name: '네이버플러스', cat: SubscriptionCategory.shopping, color: 0xFF03C75A),
  (name: '배민클럽', cat: SubscriptionCategory.shopping, color: 0xFF2AC1BC),
  (name: '배달의민족', cat: SubscriptionCategory.shopping, color: 0xFF2AC1BC),
  (name: '챗GPT', cat: SubscriptionCategory.productivity, color: 0xFF10A37F),
  (name: 'Claude', cat: SubscriptionCategory.productivity, color: 0xFFD97757),
  (name: 'Gemini', cat: SubscriptionCategory.productivity, color: 0xFF4C7BF5),
  (name: '노션', cat: SubscriptionCategory.productivity, color: 0xFF191919),
];

const _cycleLabels = {
  BillingCycle.monthly: '월',
  BillingCycle.yearly: '연',
  BillingCycle.weekly: '주',
};

const _reminderLabels = {
  SubReminder.onDay: '당일',
  SubReminder.dayBefore: '1일 전',
  SubReminder.threeDaysBefore: '3일 전',
};

/// 구독 추가/편집 화면. item이 null이면 신규.
class SubscriptionEditView extends ConsumerStatefulWidget {
  const SubscriptionEditView({super.key, this.item});

  final Subscription? item;

  @override
  ConsumerState<SubscriptionEditView> createState() =>
      _SubscriptionEditViewState();
}

class _SubscriptionEditViewState extends ConsumerState<SubscriptionEditView> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  late BillingCycle _cycle;
  late DateTime _firstPaymentDate;
  late SubscriptionCategory _category;
  late int? _colorValue; // 프리셋 대표색(KeyColor). null이면 카테고리색.
  late Set<SubReminder> _reminders;
  late bool _active;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item?.name ?? '');
    _amountController =
        TextEditingController(text: item == null ? '' : item.amount.toString());
    _cycle = item?.cycle ?? BillingCycle.monthly;
    _firstPaymentDate = item?.firstPaymentDate ?? DateTime.now();
    _category = item?.category ?? SubscriptionCategory.etc;
    _colorValue = item?.colorValue;
    _reminders = {...?item?.reminders};
    if (item == null) _reminders = {SubReminder.dayBefore};
    _active = item?.active ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _applyPreset(_Preset p) {
    setState(() {
      _nameController.text = p.name;
      _category = p.cat;
      _colorValue = p.color;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _firstPaymentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _firstPaymentDate = picked);
  }

  void _toast(String message) {
    final c = SubColors.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.surfaceAlt,
        content: Text(message,
            style: AppTypography.body2.copyWith(color: c.textPrimary)),
      ));
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _toast('이름을 입력해주세요');
      return;
    }
    final amount = int.tryParse(_amountController.text.trim()) ?? 0;

    final base = widget.item;
    final item = (base ??
            Subscription(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: name,
              amount: amount,
              firstPaymentDate: _firstPaymentDate,
              createdAt: DateTime.now(),
            ))
        .copyWith(
      name: name,
      amount: amount,
      cycle: _cycle,
      firstPaymentDate: _firstPaymentDate,
      category: _category,
      colorValue: _colorValue,
      reminders: _reminders.toList()..sort((a, b) => a.index - b.index),
      active: _active,
    );

    await ref.read(subscriptionListProvider.notifier).save(item);
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final c = SubColors.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('삭제할까요?',
            style: AppTypography.title3.copyWith(color: c.textPrimary)),
        content: Text('«${widget.item!.name}»을(를) 삭제합니다.',
            style: AppTypography.body2.copyWith(color: c.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('취소',
                style: AppTypography.label2.copyWith(color: c.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('삭제',
                style: AppTypography.label2
                    .copyWith(color: const Color(0xFFF04452))),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(subscriptionListProvider.notifier).remove(widget.item!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = SubColors.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '편집' : '새 구독'),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: _delete,
              icon: Icon(Icons.delete_outline, color: c.textSecondary),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.s20, AppSpacing.s16, AppSpacing.s20, AppSpacing.s32),
        children: [
          if (!_isEditing) ...[
            const SubSectionLabel('빠른 추가'),
            _PresetDropdown(onSelected: _applyPreset),
            const SizedBox(height: AppSpacing.s24),
          ],

          const SubSectionLabel('서비스명'),
          SubTextField(
            controller: _nameController,
            hint: '예: 넷플릭스',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.s20),

          const SubSectionLabel('금액'),
          SubTextField(
            controller: _amountController,
            hint: '13500',
            prefixText: '₩ ',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.s20),

          const SubSectionLabel('결제 주기'),
          SubSegmented<BillingCycle>(
            value: _cycle,
            onChanged: (v) => setState(() => _cycle = v),
            segments: [
              for (final cy in BillingCycle.values)
                SubSegment(value: cy, label: _cycleLabels[cy]!),
            ],
          ),
          const SizedBox(height: AppSpacing.s20),

          const SubSectionLabel('기준 결제일'),
          SubTile(
            icon: Icons.event_outlined,
            title: '결제일',
            value: cycleDateLabel(_firstPaymentDate, _cycle.index),
            onTap: _pickDate,
          ),
          const SizedBox(height: AppSpacing.s20),

          const SubSectionLabel('카테고리'),
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final cat in SubscriptionCategory.values)
                SubChip(
                  label: CategoryStyle.label(cat),
                  icon: CategoryStyle.icon(cat),
                  selected: _category == cat,
                  color: CategoryStyle.color(cat),
                  onTap: () => setState(() => _category = cat),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s20),

          const SubSectionLabel('알림'),
          Wrap(
            spacing: AppSpacing.s8,
            children: [
              for (final r in SubReminder.values)
                SubChip(
                  label: _reminderLabels[r]!,
                  selected: _reminders.contains(r),
                  onTap: () => setState(() {
                    if (_reminders.contains(r)) {
                      _reminders.remove(r);
                    } else {
                      _reminders.add(r);
                    }
                  }),
                ),
            ],
          ),

          if (_isEditing) ...[
            const SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('사용 중',
                          style: AppTypography.body1
                              .copyWith(color: c.textPrimary)),
                      Text('끄면 총액·알림에서 제외돼요',
                          style: AppTypography.caption1
                              .copyWith(color: c.textTertiary)),
                    ],
                  ),
                ),
                Switch(
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.s32),

          SubButton(label: '저장', icon: Icons.check, onPressed: _save),
        ],
      ),
    );
  }
}

/// 인기 구독 프리셋 드롭다운. 탭하면 목록이 펼쳐지고, 선택하면 자동 채운다.
class _PresetDropdown extends StatelessWidget {
  const _PresetDropdown({required this.onSelected});

  final ValueChanged<_Preset> onSelected;

  @override
  Widget build(BuildContext context) {
    final c = SubColors.of(context);
    return PopupMenuButton<_Preset>(
      onSelected: onSelected,
      offset: const Offset(0, 56),
      constraints: const BoxConstraints(minWidth: 260, maxHeight: 360),
      itemBuilder: (context) => [
        for (final p in _presets)
          PopupMenuItem(
            value: p,
            child: Row(
              children: [
                Icon(CategoryStyle.icon(p.cat), size: 18, color: Color(p.color)),
                const SizedBox(width: AppSpacing.s8),
                Text(p.name),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16, vertical: AppSpacing.s16),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border.all(color: c.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Text('인기 구독에서 선택',
                style: AppTypography.body1.copyWith(color: c.textTertiary)),
            const Spacer(),
            Icon(Icons.arrow_drop_down_rounded, color: c.textSecondary),
          ],
        ),
      ),
    );
  }
}
