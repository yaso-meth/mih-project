# R8/ProGuard rules to prevent removal of necessary Facebook Infer annotations
-keep class com.facebook.infer.annotation.** { *; }
-keep interface com.facebook.infer.annotation.** { *; }
-dontwarn com.facebook.infer.annotation.Nullsafe$Mode
-dontwarn com.facebook.infer.annotation.Nullsafe