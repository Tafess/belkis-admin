import 'package:belkis_web_admin/widgets/sellers_list.dart';
import 'package:flutter/material.dart';

class SellerScreen extends StatefulWidget {
  static const String id = 'seller-screen';
  const SellerScreen({
    super.key,
  });

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  bool? selectedButton;
  Widget _rowHeader({int? flex, String? text}) {
    return Expanded(
        flex: flex!,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.white,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text!,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sellers',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value as needed
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                selectedButton == true
                                    ? Colors.green
                                    : Colors.grey)),
                        onPressed: () {
                          setState(() {
                            selectedButton = true;
                          });
                        },
                        child: Text('Approved',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(width: 20),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value as needed
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                selectedButton == false
                                    ? Colors.red
                                    : Colors.grey)),
                        onPressed: () {
                          setState(() {
                            selectedButton = false;
                          });
                        },
                        child: Text('Not Approved',
                            style: TextStyle(color: Colors.white))),
                    SizedBox(width: 20),
                    ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the value as needed
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                selectedButton == null
                                    ? Colors.orange
                                    : Colors.grey)),
                        onPressed: () {
                          setState(() {
                            selectedButton = null;
                          });
                        },
                        child:
                            Text('All', style: TextStyle(color: Colors.white))),
                    SizedBox(width: 20),
                  ],
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  _rowHeader(flex: 1, text: 'Logo'),
                  _rowHeader(flex: 3, text: 'BuisnessName'),
                  _rowHeader(flex: 2, text: 'City'),
                  _rowHeader(flex: 2, text: 'Region'),
                  _rowHeader(flex: 2, text: 'Action'),
                  _rowHeader(flex: 2, text: 'View more'),
                ],
              ),
            ],
          ),
          SellersList(
            approveStatus: selectedButton,
          ),
        ],
      ),
    );
  }
}
