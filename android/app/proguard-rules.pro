# ------------------------------
# Stripe
# ------------------------------
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**

# ------------------------------
# Firebase
# ------------------------------
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# ------------------------------
# Gson
# ------------------------------
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# ------------------------------
# Glide
# ------------------------------
-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**
