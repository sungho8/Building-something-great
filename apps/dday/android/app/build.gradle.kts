import groovy.json.JsonSlurper
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// dart_defines.json(gitignore)에서 카카오 네이티브 앱 키를 읽는다. 없으면 빈 값.
val kakaoNativeAppKey: String = run {
    val f = file("../../dart_defines.json")
    if (!f.exists()) return@run ""
    @Suppress("UNCHECKED_CAST")
    val json = JsonSlurper().parse(f) as Map<String, Any?>
    (json["KAKAO_NATIVE_APP_KEY"] as? String).orEmpty()
}

// 릴리스 서명 키: android/key.properties(gitignore)에서 읽는다. 없으면 debug로 폴백.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.sungho.dday"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // flutter_local_notifications 요구: core library desugaring
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.sungho.dday"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 카카오 로그인 리다이렉트 스킴(kakao{키})용 매니페스트 치환자
        manifestPlaceholders["kakaoNativeAppKey"] = kakaoNativeAppKey
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // key.properties가 있으면 릴리스 키로 서명, 없으면 debug 폴백(flutter run 유지).
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")

            // R8 minify 끔. Flutter 앱 용량은 Dart AOT/엔진이 대부분이라 자바/코틀린
            // 축소 이득은 작은 반면, flutter_local_notifications(Gson TypeToken)·Kakao·
            // Firebase 등 리플렉션 코드가 릴리스에서만 깨지는 위험이 크다.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
