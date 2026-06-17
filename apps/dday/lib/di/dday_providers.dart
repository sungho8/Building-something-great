import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/dday_repository_impl.dart';
import '../domain/entities/dday_item.dart';
import '../domain/repositories/dday_repository.dart';
import '../presentation/viewmodels/dday_list_viewmodel.dart';

/// main에서 초기화 인스턴스로 override.
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// main에서 초기화 인스턴스로 override.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => throw UnimplementedError('main에서 override 필요'),
);

/// D-Day 리포지토리.
final ddayRepositoryProvider = Provider<DDayRepository>(
  (ref) => DDayRepositoryImpl(ref.watch(localStoreProvider)),
);

/// D-Day 목록 상태.
final ddayListProvider =
    NotifierProvider<DDayListViewModel, List<DDayItem>>(DDayListViewModel.new);
