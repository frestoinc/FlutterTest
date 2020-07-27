import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class PictureDirectory {
  Future<Directory> getDirectory();

  Future<String> generateFilename();

  Future<List<FileSystemEntity>> getFilesInDirectory();

  Future<File> getLastPictureInDirectory();
}

class PictureDirectoryImpl implements PictureDirectory {
  const PictureDirectoryImpl();

  @override
  Future<String> generateFilename() async {
    var directory = await getDirectory();
    var currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    return '${directory.path}/${currentTime}.jpg';
  }

  @override
  Future<Directory> getDirectory() async {
    var appDirectory = await getApplicationDocumentsDirectory();
    var pictureDirectory = '${appDirectory.path}/Pictures';
    return await Directory(pictureDirectory).create(recursive: true);
  }

  //todo review change extension to mime type
  @override
  Future<File> getLastPictureInDirectory() async {
    var files = await getFilesInDirectory();
    if (files == null) return null;
    //final mimeType = lookupMimeType('/some/path/to/file/file.jpg');
    var file = files.firstWhere((element) => element.path.endsWith('.jpg'));
    return file ?? null;
  }

  @override
  Future<List<FileSystemEntity>> getFilesInDirectory() async {
    var directory = await getDirectory();
    var files = directory.listSync().toList();
    if (files.isEmpty) {
      return null;
    }
    files.sort((a, b) => b.path.compareTo(a.path));
    return files;
  }
}
