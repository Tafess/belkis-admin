import 'package:belkis_web_admin/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatefulWidget {
  final CollectionReference? reference;
  const CategoryListWidget({super.key, this.reference});

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  FirebaseService _service = FirebaseService();

  Object? _selectedValue;
  bool _noCategorySelected = false;
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
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Image.network(data['image']),
              ),
              Text(widget.reference == _service.categories
                  ? data['categoryName']
                  : data['subCategory']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropDownButton() {
    return DropdownButton(
      value: _selectedValue,
      hint: Text('Select Main Category'),
      items: snapshot!.docs.map(
        (e) {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
        },
      ).toList(),
      onChanged: (selectedCategory) {
        setState(
          () {
            _selectedValue = selectedCategory;
            _noCategorySelected = false;
          },
        );
      },
    );
  }

  @override
  void initState() {
    getMainCategoryList();
    super.initState();
  }

  getMainCategoryList() {
    return _service.mainCategories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.reference == _service.subCategories && (snapshot != null))
          Row(
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
        SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
          stream: widget.reference!
              .where('mainCategory', isEqualTo: _selectedValue)
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
              return const Text('No categories added to the database');
            } else {
              return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 3,
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
