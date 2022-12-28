import 'dart:io';

import 'package:cmcp/main_theme/utils/AppConstant.dart';
import 'package:cmcp/theme_utils/T3widgets.dart';
import 'package:cmcp/theme_utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

class ComplainPicker extends StatefulWidget {
  final void Function(List<File> file) filePickFn;
  ComplainPicker(this.filePickFn);
  @override
  _ComplainPickerState createState() => _ComplainPickerState();
}

class _ComplainPickerState extends State<ComplainPicker> {
  File _pickedImage;
  File _pickedVideo;
  File _pickedFile;
  List<File> _files = [];
  final picker = ImagePicker();

  void _pickImage(bool camera) async {
    final pickedImageFile = await picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImageFile != null) {
      double data = await getFileSize(File(pickedImageFile.path));
      if (data > 3072) {
        toast('Image should be less than 3 mb!');
      } else {
        setState(() {
          _pickedImage = File(pickedImageFile.path);
          _files.add(_pickedImage);
        });
        print(pickedImageFile.path);
        widget.filePickFn(_files);
      }
    }
  }

  void _pickVideo(bool camera) async {
    final pickedVideoFile = await picker.pickVideo(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    if (pickedVideoFile != null) {
      double data = await getFileSize(File(pickedVideoFile.path));
      if (data > 15360) {
        toast('Video should be less than 15 mb!');
      } else {
        setState(() {
          _pickedVideo = File(pickedVideoFile.path);
          _files.add(_pickedVideo);
        });
        print(_pickedVideo);
        widget.filePickFn(_files);
      }
    }
  }

  void _pickFile() async {
    Navigator.of(context).pop();
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['docx', 'pdf', 'doc', 'mp3'],
      type: FileType.custom,
    );
    if (result != null) {
      double data = await getFileSize(File(result.files.single.path));
      if (data > 3072) {
        toast('File should be less than 3 mb!');
      } else {
        setState(() {
          _pickedFile = File(result.files.single.path);
          _files.add(_pickedFile);
        });
        print(_pickedFile.path);
        widget.filePickFn(_files);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _files.length < 4
                ? iconButton(
                    title: 'CHOOSE FILE',
                    color: t3_colorPrimary,
                    onPressed: () {
                      showSheet(
                          aContext: context,
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    mediaIcons(
                                      color: Colors.blue,
                                      icon: Icons.insert_drive_file_rounded,
                                      text: 'Document',
                                      onPressed: () {
                                        _pickFile();
                                      },
                                    ),
                                    mediaIcons(
                                      color: Colors.red,
                                      icon: Icons.image,
                                      text: 'Image',
                                      onPressed: () {
                                        _showPicker(context, true);
                                      },
                                    ),
                                    mediaIcons(
                                      color: Colors.purple,
                                      icon: Icons.video_camera_front,
                                      text: 'Video',
                                      onPressed: () {
                                        _showPicker(context, false);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ));
                    }).paddingOnly(left: 15)
                : Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'SIZE LIMIT',
                  style: TextStyle(
                      color: t3_colorPrimary,
                      fontFamily: fontSemibold,
                      fontSize: textSizeSmall),
                ),
                Text(
                  '- Image 3 MB',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: fontSemibold,
                      fontSize: textSizeXSmall),
                ),
                Text(
                  '- Video 15 MB',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: fontSemibold,
                      fontSize: textSizeXSmall),
                ),
                Text(
                  '- File 3 MB',
                  style: TextStyle(
                      color: redColor,
                      fontFamily: fontSemibold,
                      fontSize: textSizeXSmall),
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ).paddingOnly(right: 25)
          ],
        ),
        Row(
          children: [
            if (_files.isNotEmpty)
              ..._files
                  .map((attach) => preview(
                      file: attach,
                      size: size,
                      onPressed: () {
                        print('test');
                        setState(() {
                          _files.removeWhere((element) => element == attach);
                          widget.filePickFn(_files);
                        });
                      }))
                  .toList()
          ],
        )
      ],
    );
  }

  void _showPicker(context, bool image) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Library'),
                      onTap: () {
                        if (image) {
                          _pickImage(false);
                        } else {
                          _pickVideo(false);
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      if (image) {
                        _pickImage(true);
                      } else {
                        _pickVideo(true);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  getFileSize(File filepath) async {
    int sizeInBytes = filepath.lengthSync();
    double sizeInKb = sizeInBytes / (1024);
    return sizeInKb;
  }
}

Container preview({Function onPressed, File file, var size}) {
  return Container(
    key: UniqueKey(),
    margin: const EdgeInsets.only(left: 10),
    width: 70,
    child: Stack(
      children: [
        Container(
          height: size.height * 0.1,
          width: size.width * 0.25,
          child: (file.path.split('.').last == 'jpg' ||
                  file.path.split('.').last == 'png')
              ? FittedBox(
                  fit: BoxFit.fill,
                  child: Image.file(
                    file,
                  ),
                )
              : const Icon(Icons.insert_drive_file,
                  size: 60, color: Colors.grey),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: onPressed,
            child: (Container(
              height: 20,
              width: 20,
              child: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            )),
          ),
        ),
      ],
    ),
  );
}
