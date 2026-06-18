/// 공용 디자인 시스템.
///
/// 브랜드(색·폰트)는 앱이 [BrandConfig]로 주입하고,
/// 컴포넌트는 색을 모른 채 `Theme.of(context)`만 본다.
library;

export 'src/app_factory.dart';
export 'src/components/app_button.dart';
export 'src/components/app_card.dart';
export 'src/theme/app_theme.dart';
export 'src/theme/brand_config.dart';
export 'src/tokens/colors.dart';
export 'src/tokens/spacing.dart';
export 'src/tokens/typography.dart';
