import 'package:belkis_web_admin/firebase_service.dart';
import 'package:belkis_web_admin/models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SellersList extends StatelessWidget {
  final bool? approveStatus;
  const SellersList({this.approveStatus, super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _services = FirebaseService();
    Widget _sellerData({int? flex, String? text, Widget? widget}) {
      return Expanded(
          flex: flex!,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white54, border: Border.all(color: Colors.blue)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget ?? Text(text!),
            ),
          ));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _services.sellers
          .where('approved', isEqualTo: approveStatus)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.data!.size == 0) {
          return Center(
            child: Text(
              'No Seller To Show',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Semi-Bold'),
            ),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              Seller seller = Seller.fromJson(
                  snapshot.data!.docs[index].data() as Map<String, dynamic>);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _sellerData(
                    flex: 1,
                    widget: Container(
                        height: 50,
                        width: 50,
                        child: Image.network(seller.logo!)),
                  ),
                  _sellerData(flex: 3, text: seller.buisnessName),
                  _sellerData(flex: 2, text: seller.city),
                  _sellerData(flex: 2, text: seller.region),
                  _sellerData(
                      flex: 2,
                      widget: seller.approved == true
                          ? ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the value as needed
                                  ),
                                ),
                              ),
                              onPressed: () {
                                EasyLoading.show();
                                _services.updateData(
                                  data: {
                                    'approved': false,
                                  },
                                  docName: seller.uid,
                                  reference: _services.sellers,
                                ).then((value) {
                                  EasyLoading.dismiss();
                                });
                              },
                              child: FittedBox(
                                child: Text(
                                  'Regect',
                                  style: TextStyle(color: Colors.red.shade900),
                                ),
                              ))
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Adjust the value as needed
                                  ),
                                ),
                              ),
                              onPressed: () {
                                EasyLoading.show();
                                _services.updateData(
                                  data: {
                                    'approved': true,
                                  },
                                  docName: seller.uid,
                                  reference: _services.sellers,
                                ).then((value) {
                                  EasyLoading.dismiss();
                                });
                              },
                              child: FittedBox(
                                child: Text(
                                  'Approve',
                                  style: TextStyle(
                                      color: Colors.green.shade900,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))),
                  _sellerData(
                      flex: 2,
                      widget: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value as needed
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text('View More')))
                ],
              );
            });
      },
    );
  }
}
