package com.famizyo.store_user_app.flutter_jailbreak_detection

import android.util.Log

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.famizyo.store_user_app.flutter_jailbreak_detection.DeviceChecker
import com.famizyo.store_user_app.flutter_jailbreak_detection.IntegrityChecker

import com.scottyab.rootbeer.RootBeer
import android.provider.Settings

import android.content.pm.PackageManager
import android.content.pm.Signature
import android.os.Build

import java.security.MessageDigest
import java.util.*

/** FlutterJailbreakDetectionPlugin */
class FlutterJailbreakDetectionPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext : Context
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_jailbreak_detection")
    applicationContext = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result): Unit {
    if (call.method.equals("jailbroken")) {
      val rootBeer = RootBeer(applicationContext)
      result.success(rootBeer.isRooted)
    } else if (call.method.equals("developerMode")) {
      result.success(isDevMode())
    } else if(call.method.equals("isRealDevice")){
        result.success(DeviceChecker.isRealDevice())
    }else if(call.method.equals("hasCorrectlyInstalled")){
      result.success(IntegrityChecker.hasCorrectlyInstalled(applicationContext))
    } else if(call.method.equals("getAppSignature")){
      result.success(getAppSignature())
    } else {
      result.notImplemented()
    }
  }

  private fun isDevMode(): Boolean {
    try {
      // Birden fazla yöntemi deneyelim
      // 1. Global ayarını kontrol et
      val globalDevSettings = Settings.Global.getInt(applicationContext.contentResolver,
        Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0)
      
      // 2. ADB kontrol et - bu genellikle emülatörlerde açıktır
      val adbEnabled = Settings.Global.getInt(applicationContext.contentResolver,
        Settings.Global.ADB_ENABLED, 0)

      // 3. Debug build kontrolü
      val isDebuggable = applicationContext.applicationInfo.flags and android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE != 0
      
      // 4. Emülatör kontrolü
      val isEmulator = !DeviceChecker.isRealDevice()
      
      // Eğer emülatörde ise, geliştirici mod olarak kabul et
      return (globalDevSettings != 0) || (adbEnabled != 0) || isDebuggable || isEmulator
    } catch (e: Exception) {
      // Hata durumunda safe bir değer döndür
      return false
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  private fun getAppSignature(): List<String> {
    try {
      val packageName = applicationContext.packageName
      val packageManager = applicationContext.packageManager
      val signatures = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
        val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
        packageInfo.signingInfo?.apkContentsSigners
      } else {
        @Suppress("DEPRECATION")
        val packageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
        @Suppress("DEPRECATION")
        packageInfo.signatures
      }

      return if (!signatures.isNullOrEmpty()) {
        val response:List<String> = List<String>(signatures.count()) { i -> signatureToSha256(signatures[i]) }
        response
      } else {
        emptyList<String>()
      }
    } catch (e: Exception) {
      return List<String>(1){ "Error getting signature: ${e.message}"}
    }
  }

  private fun signatureToSha256(signature: Signature): String {
    val md = MessageDigest.getInstance("SHA-256")
    md.update(signature.toByteArray())
    return bytesToHex(md.digest())
  }

  private fun bytesToHex(bytes: ByteArray): String {
    val hexChars = CharArray(bytes.size * 2)
    for (i in bytes.indices) {
      val v = bytes[i].toInt() and 0xFF
      hexChars[i * 2] = "0123456789ABCDEF"[v ushr 4]
      hexChars[i * 2 + 1] = "0123456789ABCDEF"[v and 0x0F]
    }
    return String(hexChars)
  }
}
