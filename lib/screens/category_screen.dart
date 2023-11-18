import 'dart:typed_data';

import 'package:belkis_web_admin/firebase_service.dart';
import 'package:belkis_web_admin/screens/main_category_screen.dart';
import 'package:belkis_web_admin/widgets/category_list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';

  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _categoryName = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // for validation purposes
  dynamic image;
  String? fileName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;

        print('All Done');
      });
    } else {
      print('Faild image uploading');
    }
  }

  saveImageToDatabase() async {
    EasyLoading.show();
    var ref = FirebaseStorage.instance.ref('categoryImages/$fileName');
    try {
      await ref.putData(image);

      String downloadURL = await ref.getDownloadURL().then((value) {
        if (value.isNotEmpty) {
          _service.saveCategory(data: {
            'categoryName': _categoryName.text,
            'image': value,
            'active': true,
          }, docName: _categoryName.text, reference: _service.categories).then(
              (value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    }
  }

  clear() {
    setState(() {
      _categoryName.clear();
      EasyLoading.dismiss();
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              width: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 3,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade500,
                            border: Border.all(color: Colors.grey.shade800)),
                        child: Center(
                          child: image == null
                              ? Text('Category image')
                              : Image.memory(image),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),

                              // Customize the border radius here
                            ),
                          ),
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.blue, width: 3),
                          ),
                        ),
                        child: Text('Upload Image'),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Category Name';
                        }
                      },
                      controller: _categoryName,
                      decoration: InputDecoration(
                        labelText:
                            'Enter Category Name', // Use 'labelText' instead of 'label'
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      clear();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Customize the border radius here
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.red, width: 3)),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  image == null
                      ? Container()
                      : ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveImageToDatabase();
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Customize the border radius here
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            side: MaterialStateProperty.all(
                              BorderSide(color: Colors.blue.shade900, width: 3),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 3,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Category List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CategoryListWidget(
              reference: _service.categories,
            ),
          ],
        ),
      ),
    );
  }
}
