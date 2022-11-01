import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? originalImage;
  File? compressedImage;
  String compressedImagePath = "/storage/emulated/0/Download/";

  Future pickImage() async {
    final pickedFile =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        originalImage = File(pickedFile.path);
      });
    }
  }

  Future compressImage() async {
    if (originalImage == null) return null;

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      originalImage!.path,
      "$compressedImagePath/file1.jpg",
      quality: 10,
    );

    if (compressedFile != null) {
      setState(() {
        compressedImage = compressedFile;
      });
      print(await originalImage!.length());
      print(await compressedFile.length());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Original Image",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  originalImage != null
                      ? Image.file(originalImage!)
                      : TextButton(
                          onPressed: pickImage,
                          child: Text("Pick an Image"),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Compressed Image",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  compressedImage != null
                      ? Image.file(compressedImage!)
                      : TextButton(
                          onPressed: compressImage,
                          child: Text("Compress Image"),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
