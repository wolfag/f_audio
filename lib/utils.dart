import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static Future<File> moveFile(File src, String des) async {
    try {
      return await src.rename(des);
    } on FileSystemException catch (e) {
      final newFile = await src.copy(des);
      await src.delete();
      return newFile;
    }
  }

  static Future<File> moveFile2(String src, String des) async {
    return moveFile(File(src), des);
  }

  static Future saveText(String text) async {
    try {
      Directory folder = await getApplicationDocumentsDirectory();

      print(folder.path);
      File file = File("${folder.path}/tai.txt");
      file.writeAsString(text);
      print("ok");
    } catch (e) {
      print(e.toString());
    }
  }

  static Future saveToAppFolder(String src, String fileName) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          Directory appFolder = await getApplicationDocumentsDirectory();
          print(appFolder.path);
          String newPath = '';

          if (directory == null) {
            return false;
          }

          List<String> paths = directory.path.split("/");

          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/my_audio";
          // print(src);
          // print(directory.path);
          // print(newPath);
          directory = Directory(newPath);
        } else {
          return false;
        }
      }
      File srcFile = File(src);
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }
      await srcFile.copy("${directory.path}/${fileName}.aac");
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      print("true");
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        print("true");
        return true;
      }
    }
    print("false");
    return false;
  }
}
