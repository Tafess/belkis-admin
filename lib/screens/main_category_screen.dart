import 'package:belkis_web_admin/firebase_service.dart';
import 'package:belkis_web_admin/widgets/main_category_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'main-category';
  const MainCategoryScreen({super.key});

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  TextEditingController _mainCategory = TextEditingController();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;

  final _formKey = GlobalKey<FormState>();

  Widget _dropDownButton() {
    return DropdownButton(
        value: _selectedValue,
        hint: Text('Select  Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['categoryName'],
            child: Text(e['categoryName']),
          );
        }).toList(),
        onChanged: (selectedCategory) {
          setState(() {
            _selectedValue = selectedCategory;
            _noCategorySelected = false;
          });
        });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  clear() {
    _selectedValue = null;
    _mainCategory.clear();
  }

  getCategoryList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Main categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            ),
            Divider(color: Colors.grey, thickness: 3),
            snapshot == null ? CircularProgressIndicator() : _dropDownButton(),
            SizedBox(
              height: 8,
            ),
            if (_noCategorySelected == true)
              Text(
                'No category selected',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Container(
                  width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Main Category Name';
                      }
                    },
                    controller: _mainCategory,
                    decoration: InputDecoration(
                      labelText:
                          'Enter main Category name', // Use 'labelText' instead of 'label'
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(width: 50),
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
                ElevatedButton(
                  onPressed: () {
                    if (_selectedValue == null) {
                      setState(() {
                        _noCategorySelected = true;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      //    saveImageToDatabase();
                      EasyLoading.show();
                      _service.saveCategory(
                        data: {
                          'category': _selectedValue,
                          'mainCategory': _mainCategory.text,
                          'approved': true,
                        },
                        docName: _mainCategory.text,
                        reference: _service.mainCategories,
                      ).then((value) {
                        clear();
                        EasyLoading.dismiss();
                      });
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
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
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
            Divider(color: Colors.grey, thickness: 3),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Main Category List',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(height: 20),
            const MainCategoryListWidget(),
          ],
        ),
      ),
    );
  }
}
