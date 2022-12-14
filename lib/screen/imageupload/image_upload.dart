import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mystock/controller/controller.dart';
import 'package:provider/provider.dart';

class MyImagePicker extends StatefulWidget {
  // MyImagePicker({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  XFile? _imageFile;
  double? _progress;
  // final String uploadUrl = 'https://api.imgur.com/3/upload';
  final ImagePicker _picker = ImagePicker();
  Timer? _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        // _timer!.cancel();
      }
    });
    // EasyLoading.showSuccess('Use in initState');
  }

  // Future<String> uploadImage(filepath, url) async {
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //   request.files.add(await http.MultipartFile.fromPath('image', filepath));
  //   var res = await request.send();
  //   return res.reasonPhrase!;
  // }

  Future<void> retriveLostData() async {
    LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ' + response.exception!.code);
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(File(_imageFile!.path)),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                EasyLoading.show(status: 'uploading...');
                var res =await Provider.of<Controller>(context, listen: false)
                    .uploadImage(_imageFile!.path,context);
                // var res = await uploadImage(_imageFile!.path, uploadUrl);
                print("res-------------------$res");
                EasyLoading.showSuccess("success");

                // print(res);
              },
              child: const Text('Upload'),
            )
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: FutureBuilder<void>(
        future: retriveLostData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text('Picked an image');
            case ConnectionState.done:
              return _previewImage();
            default:
              return const Text('Picked an image');
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image from gallery',
        child: Icon(Icons.photo_library),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
