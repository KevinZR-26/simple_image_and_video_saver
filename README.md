# simple_image_and_video_saver

[![Pub Version](https://img.shields.io/pub/v/simple_image_and_video_saver.svg)](https://pub.dev/packages/simple_image_and_video_saver)

Un plugin de Flutter para guardar imágenes y videos en carpetas específicas de Android como `Downloads`, `Pictures` o almacenamiento privado, compatible con Android 8 a 15.

---

## 💡 Características

- Guarda imágenes o videos en la galería (`Pictures` / `Movies`)
- Guarda imágenes o videos en la carpeta de descargas (`Downloads`)
- Guarda archivos en el almacenamiento privado de la app
- Compatible con Android 8.0 (API 26) a Android 15
- Basado en **Method Channels nativos (Kotlin)**.
- Soporte completo para errores (`PlatformException`) si ocurre un fallo.

---

## 📦 Instalación

Agrega este paquete a tu archivo `pubspec.yaml`:

```yaml
dependencies:
  simple_image_and_video_saver: ^0.1.0
```

Luego ejecuta:

```bash
flutter pub get
```


--- 

## 🧪 Uso rápido

Importa el paquete y llama a los métodos disponibles:

```dart
import 'package:simple_image_and_video_saver/simple_image_and_video_saver.dart';

final savedPath = await SimpleImageAndVideoSaver.saveMediaToGallery(
  filePath: '/storage/emulated/0/Download/sample.jpg',
  fileName: 'sample',
  mediaType: MediaType.image,
);
```
También puedes guardar en descargas o de forma privada:

---

## 🧩 Métodos disponibles

### 📁 Guardar en Galería

```dart
Future<String?> saveMediaToGallery({
  required String filePath,
  required String fileName,
  required MediaType mediaType, // image o video
});
```

### 📁 Guardar imagen en Descargas

```dart
Future<String?> saveImageToDownloads({
  required String filePath,
  required String fileName,
});
```

### 📁 Guardar video en Descargas

```dart
Future<String?> saveVideoToDownloads({
  required String filePath,
  required String fileName,
});
```

### 🔒 Guardar en almacenamiento privado

```dart
Future<String?> savePrivateMedia({
  required String filePath,
  required String fileName,
});
```

---
## ⚙️ Permisos requeridos

Debes agregar estos permisos en el archivo `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
```

Además, a partir de Android 10+, asegúrate de solicitar permisos en tiempo de ejecución y agregar esto dentro de la etiqueta `<application>`:

```xml
android:requestLegacyExternalStorage="true"
```

---

## 🧪 Ejemplo

Puedes encontrar un ejemplo completo en el directorio [`example/`](example/).

---

## 📁 Plataformas compatibles

    Plataforma	Compatibilidad
    Android	    ✅ Soportado (API 26 - 34)
    iOS	        ❌ No soportado (por ahora)

---

## 📍 Próximamente

- Soporte para iOS
- Soporte para otros tipos de archivos
- Más opciones de personalización

---

## 🧑‍💻 Contribuciones

¡Las contribuciones están abiertas! Por favor revisa el archivo CONTRIBUTING.md (próximamente) o abre un issue con tu propuesta.

---

## 📋 Licencia

MIT License  
Copyright © 2025




