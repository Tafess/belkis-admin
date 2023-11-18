import 'package:belkis_web_admin/firebase_service.dart';
import 'package:belkis_web_admin/widgets/category_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SubCategoryScreen extends StatefulWidget {
  static const String id = 'sub-category';
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _subCategory = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // for validation purposes
  dynamic image;
  String? fileName;

  Object? _selectedValue;
  bool _noCategorySelected = false;

  Future<QuerySnapshot?> getMainCategoryList() async {
    return _service.mainCategories.get();
  }

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
      print('Failed image uploading');
    }
  }

  saveImageToDatabase() async {
    EasyLoading.show();
    var ref = FirebaseStorage.instance.ref('subCategoryImages/$fileName');
    try {
      UploadTask uploadTask = ref.putData(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      if (downloadURL.isNotEmpty) {
        _service.saveCategory(
          data: {
            'subCategory': _subCategory.text,
            'mainCategory': _selectedValue,
            'image': downloadURL,
            'active': true,
          },
          docName: _subCategory.text,
          reference: _service.subCategories,
        ).then((value) {
          clear();
          EasyLoading.dismiss();
        });
      }
    } on FirebaseException catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    }
  }

  clear() {
    setState(() {
      _subCategory.clear();
      EasyLoading.dismiss();
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sub Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              Row(children: [
                Column(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey,
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Center(
                        child: image == null
                            ? Text('Sub Category image')
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
                          ),
                        ),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.blue, width: 3),
                        ),
                      ),
                      child: Text('Upload Image'),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(children: [
                  FutureBuilder<QuerySnapshot?>(
                    future: getMainCategoryList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Text('No main categories available');
                      } else {
                        return DropdownButton(
                          value: _selectedValue,
                          hint: Text('Select Main Category'),
                          items: snapshot.data!.docs.map((e) {
                            return DropdownMenuItem<String>(
                              value: e['mainCategory'],
                              child: Text(e['mainCategory']),
                            );
                          }).toList(),
                          onChanged: (selectedCategory) {
                            setState(() {
                              _selectedValue = selectedCategory;
                            });
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (_noCategorySelected == true)
                    Text(
                      'No category selected',
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter sub Category Name';
                        }
                      },
                      controller: _subCategory,
                      decoration: InputDecoration(
                        labelText: 'Enter sub Category name',
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ]),
                SizedBox(width: 30),
                Row(
                  children: [
                    SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: () {
                        clear();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade300),
                        side: MaterialStateProperty.all(
                          BorderSide(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if (image != null)
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedValue == null) {
                            setState(() {
                              _noCategorySelected = true;
                            });
                            return;
                          }
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
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          side: MaterialStateProperty.all(
                            BorderSide(color: Colors.blue.shade900, width: 3),
                          ),
                        ),
                      ),
                    Divider(
                      color: Colors.grey,
                      thickness: 3,
                    ),
                  ],
                ),
              ]),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sub Category List',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              CategoryListWidget(
                reference: _service.subCategories,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
