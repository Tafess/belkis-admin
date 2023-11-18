import 'dart:io';
import 'dart:js_interop';

import 'package:belkis_web_admin/screens/category_screen.dart';
import 'package:belkis_web_admin/screens/dashboard_screen.dart';
import 'package:belkis_web_admin/screens/main_category_screen.dart';
import 'package:belkis_web_admin/screens/sellers_screen.dart';
import 'package:belkis_web_admin/screens/sub_category_screen.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconly/iconly.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: kIsWeb || Platform.isAndroid
          ? FirebaseOptions(
              apiKey: "AIzaSyBHZGC4LorkY67uV1n7n96YCqZZXhcHi0c",
              appId: "1:359678373942:web:f712635b81c9d17b4a6897",
              messagingSenderId: "359678373942",
              projectId: "belkis-marketplace",
              storageBucket: "belkis-marketplace.appspot.com",
            )
          : null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belkis Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SideMenu(),
      builder: EasyLoading.init(),
    );
  }
}

class SideMenu extends StatefulWidget {
  static const String id = 'side-menu';
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Widget _selectedScreen = DashboardScreen();
  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.id:
        setState(() {
          _selectedScreen = DashboardScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;
      case MainCategoryScreen.id:
        setState(() {
          _selectedScreen = MainCategoryScreen();
        });
        break;
      case SubCategoryScreen.id:
        setState(() {
          _selectedScreen = SubCategoryScreen();
        });
        break;
      case SellerScreen.id:
        setState(() {
          _selectedScreen = SellerScreen();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade400,
          title: const Text('...... Dashboard'),
        ),
        sideBar: SideBar(
          backgroundColor: Colors.white,
          items: const [
            AdminMenuItem(
              title: 'Dashboard',
              route: DashboardScreen.id,
              icon: Icons.dashboard,
            ),
            AdminMenuItem(
              title: 'Categories',
              icon: IconlyLight.category,
              children: [
                AdminMenuItem(
                  title: 'Category',
                  route: CategoryScreen.id,
                ),
                AdminMenuItem(
                  title: 'Main Category',
                  route: MainCategoryScreen.id,
                ),
                AdminMenuItem(
                  title: 'Sub Category',
                  route: SubCategoryScreen.id,
                ),
              ],
            ),
            AdminMenuItem(
                title: 'Sellers', route: SellerScreen.id, icon: Icons.group_add)
          ],
          selectedRoute: SideMenu.id,
          onSelected: (item) {
            screenSelector(item);
            // if (item.route != null) {
            //   Navigator.of(context).pushNamed(item.route!);
            // }
          },
          header: Container(
            height: 50,
            width: double.infinity,
            color: Colors.blue,
            child: const Center(
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          footer: Container(
            height: 50,
            width: double.infinity,
            color: const Color(0xff444444),
            child: Center(
              child: Text(
                '${DateTimeFormat.format(DateTime.now(), format: AmericanDateFormats.dayOfWeek)}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: _selectedScreen,
        ));
  }
}
