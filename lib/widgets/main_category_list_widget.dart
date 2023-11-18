import 'package:belkis_web_admin/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainCategoryListWidget extends StatefulWidget {
  const MainCategoryListWidget({super.key});

  @override
  State<MainCategoryListWidget> createState() => _MainCategoryListWidgetState();
}

class _MainCategoryListWidgetState extends State<MainCategoryListWidget> {
  FirebaseService _service = FirebaseService();
  Object? _selectedValue;

  QuerySnapshot? snapshot;

  Widget categoryWidget(data) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(data['mainCategory'])),
            ],
          ),
        ),
      ),
    );
  }

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
          });
        });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
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
    return Column(
      children: [
        snapshot == null
            ? Text('Loading...')
            : Row(
                children: [
                  _dropDownButton(),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedValue = null;
                        });
                      },
                      child: Text('Show All'))
                ],
              ),
        SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _service.mainCategories
              .where('category', isEqualTo: _selectedValue)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            if (snapshot.data!.size == 0) {
              return const Text('No main categories added to the database');
            } else {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 3,
                      childAspectRatio: 6 / 2,
                      mainAxisSpacing: 3),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return categoryWidget(data);
                  });
            }
          },
        ),
      ],
    );
  }
}
