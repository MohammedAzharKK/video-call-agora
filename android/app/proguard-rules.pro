# Add these rules
-keep class com.google.devtools.build.android.desugar.runtime.ThrowableExtension { *; }
-keepclassmembers class * implements java.io.Serializable {
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Agora related classes
-keep class io.agora.** { *; }
-dontwarn io.agora.** 