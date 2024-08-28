import 'dart:io';

class MyFile{
  String? fileName;
  String? extension;
  File? file;
  String? url; 
  MyFile({this.extension,this.file,this.fileName, this.url});
}