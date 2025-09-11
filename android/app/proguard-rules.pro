# Keep Stripe SDK classes (including Push Provisioning)
-keep class com.stripe.android.** { *; }
-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.stripe.android.paymentsheet.** { *; }
-dontwarn com.stripe.android.**

# Some builds reference RN Stripe classes indirectly (safe to keep if present)
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# Google Play services Wallet (Google Pay / passes)
-keep class com.google.android.gms.wallet.** { *; }
-dontwarn com.google.android.gms.wallet.**

# OkHttp/Retrofit warnings (common when minifying)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
