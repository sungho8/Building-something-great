package com.sungho.dday

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/// 홈 화면 위젯. Flutter가 home_widget으로 저장한 데이터를 읽어 표시한다.
class DDayWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.dday_widget).apply {
                val title = widgetData.getString("dday_title", "D-Day") ?: "D-Day"
                val label = widgetData.getString("dday_label", "+") ?: "+"
                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_label, label)

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
