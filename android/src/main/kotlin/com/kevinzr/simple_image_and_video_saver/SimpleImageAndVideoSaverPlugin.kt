package com.kevinzr.simple_image_and_video_saver



import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import java.io.File
import java.io.FileInputStream
import java.io.OutputStream

import android.content.Context
import java.io.IOException


/** SimpleImageAndVideoSaverPlugin */
class SimpleImageAndVideoSaverPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_image_and_video_saver")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    when (call.method) {
      "saveMediaToGallery" -> {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")
        val mediaType = call.argument<String>("mediaType")

        if (filePath.isNullOrBlank() || fileName.isNullOrBlank() || mediaType.isNullOrBlank()) {
          result.error("INVALID", "Parámetros inválidos", null)
          return
        }

        try {
          val savedPath = saveMediaToGallery(filePath, fileName, mediaType)
          if (savedPath != null) {
            result.success(savedPath)
          } else {
            result.error("ERROR", "Error al guardar en galería", null)
          }
        } catch (e: IOException) {
          result.error("IO_ERROR", "Error de I/O: ${e.message}", null)
        }
      }

      "saveImageToDownloads" -> {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")

        if (filePath.isNullOrBlank() || fileName.isNullOrBlank()) {
          result.error("INVALID", "Parámetros inválidos", null)
          return
        }

        try {
          val savedPath = saveImageToDownloads(filePath, fileName)
          if (savedPath != null) {
            result.success(savedPath)
          } else {
            result.error("ERROR", "Error al guardar imagen en Downloads", null)
          }
        } catch (e: IOException) {
          result.error("IO_ERROR", "Error de I/O: ${e.message}", null)
        }
      }

      "saveVideoToDownloads" -> {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")

        if (filePath.isNullOrBlank() || fileName.isNullOrBlank()) {
          result.error("INVALID", "Parámetros inválidos", null)
          return
        }

        try {
          val savedPath = saveVideoToDownloads(filePath, fileName)
          if (savedPath != null) {
            result.success(savedPath)
          } else {
            result.error("ERROR", "Error al guardar video en Downloads", null)
          }
        } catch (e: IOException) {
          result.error("IO_ERROR", "Error de I/O: ${e.message}", null)
        }
      }

      "savePrivateMedia" -> {
        val filePath = call.argument<String>("filePath")
        val fileName = call.argument<String>("fileName")

        if (filePath.isNullOrBlank() || fileName.isNullOrBlank()) {
          result.error("INVALID", "Parámetros inválidos", null)
          return
        }

        try {
          val savedPath = saveMediaToPrivateStorage(filePath, fileName)
          if (savedPath != null) {
            result.success(savedPath)
          } else {
            result.error("ERROR", "Error al guardar en privado", null)
          }
        } catch (e: IOException) {
          result.error("IO_ERROR", "Error de I/O: ${e.message}", null)
        }
      }

      else -> {
        result.notImplemented()
      }
    }
  }
   
  private fun saveMediaToGallery(filePath: String, fileName: String, mediaType: String): String? {
    val resolver = this.context.contentResolver

    val (collection, mimeType) = when (mediaType) {
      "image" -> MediaStore.Images.Media.EXTERNAL_CONTENT_URI to "image/png"
      "video" -> MediaStore.Video.Media.EXTERNAL_CONTENT_URI to "video/mp4"
      else -> return null
    }

    val contentValues = ContentValues().apply {
      put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
      put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        put(
          MediaStore.MediaColumns.RELATIVE_PATH,
          when (mediaType) {
            "image" -> "Pictures"
            "video" -> "Movies"
            else -> "Download"
          }
        )
        put(MediaStore.MediaColumns.IS_PENDING, 1)
      }
    }

    val uri = resolver.insert(collection, contentValues) ?: return null

    resolver.openOutputStream(uri).use { outputStream ->
      FileInputStream(File(filePath)).use { inputStream ->
        inputStream.copyTo(outputStream!!)
      }
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      contentValues.clear()
      contentValues.put(MediaStore.MediaColumns.IS_PENDING, 0)
      resolver.update(uri, contentValues, null, null)
    }

    return uri.toString()
  }


  private fun saveImageToDownloads(filePath: String, fileName: String): String? {
    val resolver = this.context.contentResolver

    val contentValues = ContentValues().apply {
      put(MediaStore.Downloads.DISPLAY_NAME, fileName)
      put(MediaStore.Downloads.MIME_TYPE, "image/png")
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        put(MediaStore.Downloads.IS_PENDING, 1)
      }
    }

    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
        ?: return null

    resolver.openOutputStream(uri).use { outputStream ->
      FileInputStream(File(filePath)).use { inputStream ->
        inputStream.copyTo(outputStream!!)
      }
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      contentValues.clear()
      contentValues.put(MediaStore.Downloads.IS_PENDING, 0)
      resolver.update(uri, contentValues, null, null)
    }

    return uri.toString()
  }

  private fun saveVideoToDownloads(filePath: String, fileName: String): String? {
    val resolver = this.context.contentResolver

    val contentValues = ContentValues().apply {
      put(MediaStore.Downloads.DISPLAY_NAME, fileName)
      put(MediaStore.Downloads.MIME_TYPE, "video/mp4")
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        put(MediaStore.Downloads.IS_PENDING, 1)
      }
    }

    val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues) ?: return null

    resolver.openOutputStream(uri).use { outputStream ->
      FileInputStream(File(filePath)).use { inputStream ->
        inputStream.copyTo(outputStream!!)
      }
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      contentValues.clear()
      contentValues.put(MediaStore.Downloads.IS_PENDING, 0)
      resolver.update(uri, contentValues, null, null)
    }

    return uri.toString()
  }

  private fun saveMediaToPrivateStorage(filePath: String, fileName: String): String? {
    val srcFile = File(filePath)
    if (!srcFile.exists()) return null

    val destDir = this.context.getExternalFilesDir("MyMedia") ?: return null

    val destFile = File(destDir, fileName)

    srcFile.copyTo(destFile, overwrite = true)

    return destFile.absolutePath
  }
}
