package com.sungho.quit

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/// 홈 화면 위젯. Flutter가 home_widget으로 저장한 데이터를 읽어 표시한다.
class QuitWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.quit_widget).apply {
                val title = widgetData.getString("quit_title", "하루더") ?: "하루더"
                val days = widgetData.getString("quit_days", "+0") ?: "+0"
                val saved = widgetData.getString("quit_saved", "") ?: ""
                setTextViewText(R.id.widget_title, title)
                setTextViewText(R.id.widget_days, days)
                setTextViewText(R.id.widget_saved, saved)

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
