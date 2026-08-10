// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    _Subscription(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toInt(),
      cycle:
          $enumDecodeNullable(_$BillingCycleEnumMap, json['cycle']) ??
          BillingCycle.monthly,
      firstPaymentDate: DateTime.parse(json['firstPaymentDate'] as String),
      category:
          $enumDecodeNullable(
            _$SubscriptionCategoryEnumMap,
            json['category'],
          ) ??
          SubscriptionCategory.etc,
      emoji: json['emoji'] as String? ?? '',
      colorValue: (json['colorValue'] as num?)?.toInt(),
      reminders:
          (json['reminders'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$SubReminderEnumMap, e))
              .toList() ??
          const [SubReminder.dayBefore],
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SubscriptionToJson(
  _Subscription instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'amount': instance.amount,
  'cycle': _$BillingCycleEnumMap[instance.cycle]!,
  'firstPaymentDate': instance.firstPaymentDate.toIso8601String(),
  'category': _$SubscriptionCategoryEnumMap[instance.category]!,
  'emoji': instance.emoji,
  'colorValue': instance.colorValue,
  'reminders': instance.reminders.map((e) => _$SubReminderEnumMap[e]!).toList(),
  'active': instance.active,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$BillingCycleEnumMap = {
  BillingCycle.monthly: 'monthly',
  BillingCycle.yearly: 'yearly',
  BillingCycle.weekly: 'weekly',
};

const _$SubscriptionCategoryEnumMap = {
  SubscriptionCategory.entertainment: 'entertainment',
  SubscriptionCategory.music: 'music',
  SubscriptionCategory.shopping: 'shopping',
  SubscriptionCategory.productivity: 'productivity',
  SubscriptionCategory.game: 'game',
  SubscriptionCategory.etc: 'etc',
};

const _$SubReminderEnumMap = {
  SubReminder.onDay: 'onDay',
  SubReminder.dayBefore: 'dayBefore',
  SubReminder.threeDaysBefore: 'threeDaysBefore',
};
