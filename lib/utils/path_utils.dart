import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constanst.dart';

class PathUtils{

  static String? workDirPath;

  static Future<String> getWorkDirPath() async{
    if(workDirPath != null){
      return workDirPath!;
    }
    Directory tempDir = await getLibraryDirectory();
    var workDir = "${tempDir.path}/$WORK_DIR_NAME";
    var dir = Directory(workDir);
    if(! (await dir.exists())){
      await dir.create();
    }
    workDirPath = workDir;
    return workDir;
  }

  static Future<String?> selectFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var path = result?.files.single.path;
    print(result?.files.single.path);
    if (path != null) {
      path = path.substring(path.indexOf("/", 9), path.length);
      print(path);
      return path;
    }
    return null;
  }

  static String addSrtSuffix(String filePath) {
    final directory = path.dirname(filePath);
    final fileName = path.basenameWithoutExtension(filePath);
    final extension = path.extension(filePath);

    final newFileName = '$fileName-with-srt$extension';
    return path.join(directory, newFileName);
  }

  // static String addSrtSuffix(String filePath) {
  //   final directory = File(filePath).parent.path;
  //   final fileName = File(filePath).pathSegments.last;
  //   final extension = File(filePath).extension;
  //
  //   final newFileName = '${fileName.split('.').first}-with-srt$extension';
  //   return '$directory/$newFileName';
  // }


  // static String addSrtSuffix1(var filePath) {
  //   // 获取文件路径的目录和文件名
  //   String directory = filePath.substring(0, filePath.lastIndexOf('/'));
  //   String fileName = filePath.substring(filePath.lastIndexOf('/') + 1);
  //
  //   // 获取文件名的扩展名
  //   String extension = '';
  //   int extensionIndex = fileName.lastIndexOf('.');
  //   if (extensionIndex != -1) {
  //     extension = fileName.substring(extensionIndex);
  //     fileName = fileName.substring(0, extensionIndex);
  //   }
  //
  //   // 拼接新的文件名并返回新的路径
  //   String newFileName = fileName + '-with-srt' + extension;
  //   return directory + '/' + newFileName;
  // }
}