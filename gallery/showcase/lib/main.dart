import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'views/color_tokens_view.dart';
import 'views/components_view.dart';
import 'views/layout_tokens_view.dart';
import 'views/typography_view.dart';

void main() => runApp(const ShowcaseApp());

/// 브랜드 프리셋 — 같은 컴포넌트가 BrandConfig에 따라 어떻게 변하는지 확인용.
const brandPresets = <(String, BrandConfig)>[
  (
    'Factory Blue',
    BrandConfig(seed: Color(0xFF3182F6), radius: 16),
  ),
  (
    'D-Day Coral',
    BrandConfig(seed: Color(0xFFFF5B7F), radius: 16),
  ),
  (
    'Egg Purple',
    BrandConfig(seed: Color(0xFF7E5BEF), radius: 16),
  ),
];

/// 디자인 시스템 쇼케이스 앱 루트. 브랜드를 골라 전체 테마를 갈아끼운다.
class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  // 현재 선택된 브랜드 프리셋 인덱스
  int _brandIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppFactory(
      brand: brandPresets[_brandIndex].$2,
      title: 'Design System',
      home: HomeShell(
        brandIndex: _brandIndex,
        onBrandChanged: (i) => setState(() => _brandIndex = i),
      ),
    );
  }
}

/// 탭 셸 — 컬러/타이포/레이아웃/컴포넌트.
class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.brandIndex,
    required this.onBrandChanged,
  });

  /// 현재 브랜드 인덱스
  final int brandIndex;

  /// 브랜드 변경 콜백
  final ValueChanged<int> onBrandChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // 현재 탭 인덱스
  int _tab = 0;

  static const _titles = ['컬러', '타이포그래피', '레이아웃', '컴포넌트'];

  static const _views = <Widget>[
    ColorTokensView(),
    TypographyView(),
    LayoutTokensView(),
    ComponentsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(_titles[_tab]),
        actions: [
          // 브랜드 스위처 — 코드 1벌이 브랜드마다 다른 피부가 되는 것을 즉석 확인
          PopupMenuButton<int>(
            icon: const Icon(Icons.palette_outlined),
            initialValue: widget.brandIndex,
            onSelected: widget.onBrandChanged,
            itemBuilder: (context) => [
              for (var i = 0; i < brandPresets.length; i++)
                PopupMenuItem(value: i, child: Text(brandPresets[i].$1)),
            ],
          ),
        ],
      ),
      body: _views[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.palette_outlined), label: '컬러'),
          NavigationDestination(icon: Icon(Icons.text_fields), label: '타이포'),
          NavigationDestination(
              icon: Icon(Icons.space_dashboard_outlined), label: '레이아웃'),
          NavigationDestination(
              icon: Icon(Icons.widgets_outlined), label: '컴포넌트'),
        ],
      ),
    );
  }
}
