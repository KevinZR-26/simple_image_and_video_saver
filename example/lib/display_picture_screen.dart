import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_image_and_video_saver/simple_image_and_video_saver.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String filePath;
  final String exampleName;
  final MediaType mediaType; // "image" o "video"

  const DisplayPictureScreen({super.key, required this.filePath, required this.mediaType,  this.exampleName = 'NombreEjemplo'});

  Future<void> _saveToGallery(BuildContext context) async {
    try{
      final finalName = '${exampleName}_${DateTime.now().millisecondsSinceEpoch}';//puedes colocar el nombre de tu preferencia
      final result = await SimpleImageAndVideoSaver.saveMediaToGallery(
        filePath: filePath,
        fileName: finalName,
        mediaType: mediaType,
      );
      if(context.mounted){
        _showMessage(context,'Guardado en galería: $result');
      }
    } on PlatformException catch (e) {
      if(context.mounted){
        _showMessage(context,'Error al guardar: ${e.message}');
      }
    }
  }

  Future<void> _saveToDownloads(BuildContext context) async {
    try{
      final finalName = '${exampleName}_${DateTime.now().millisecondsSinceEpoch}';//puedes colocar el nombre de tu preferencia
      final result = mediaType == MediaType.image
      ? await SimpleImageAndVideoSaver.saveImageToDownloads(
          filePath: filePath,
          fileName: finalName,
        )
      : await SimpleImageAndVideoSaver.saveVideoToDownloads(
          filePath: filePath,
          fileName:finalName,
        );
      
      if(context.mounted){
        _showMessage(context,'Guardado en Descargas: $result');
      }
    } on PlatformException catch (e) {
      if(context.mounted){
        _showMessage(context,'Error al guardar: ${e.message}');
      }
    }
  }

  Future<void> _savePrivate(BuildContext context) async {
    try{
      final finalName = '${exampleName}_${DateTime.now().millisecondsSinceEpoch}';//puedes colocar el nombre de tu preferencia
      final result = await SimpleImageAndVideoSaver.savePrivateMedia(
        filePath: filePath,
        fileName:finalName,
        mediaType: mediaType,
      );
      
      if(context.mounted){
        _showMessage(context,'Guardado privado: $result');
      }
    } on PlatformException catch (e) {
      if(context.mounted){
        _showMessage(context,'Error al guardar: ${e.message}');
      }
    }
  }

  void _showMessage(BuildContext context,String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto tomada')),
      body: Stack(
        children: [
          Center(
            child: mediaType == MediaType.image
                ? Image.file(File(filePath))
                : Text('Aquí iría tu reproductor de video'),
          ),
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _saveToDownloads(context),
                  icon: const Icon(Icons.download),
                  label: const Text('Guardar en Descargas'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _saveToGallery(context),
                  icon: const Icon(Icons.image),
                  label: const Text('Guardar en Galeria'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _savePrivate(context),
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar en modo privado'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
