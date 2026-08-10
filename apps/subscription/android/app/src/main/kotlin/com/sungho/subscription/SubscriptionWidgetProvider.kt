package com.sungho.subscription

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/// 홈 화면 위젯. Flutter가 home_widget으로 저장한 데이터를 읽어 표시한다.
class SubscriptionWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.subscription_widget).apply {
                val total = widgetData.getString("sub_total", "₩0") ?: "₩0"
                val next = widgetData.getString("sub_next", "등록된 구독 없음") ?: "등록된 구독 없음"
                setTextViewText(R.id.widget_total, total)
                setTextViewText(R.id.widget_next, next)

                // 위젯 탭 → 앱 열기
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
