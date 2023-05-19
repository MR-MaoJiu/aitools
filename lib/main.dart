import 'dart:io';

import 'package:aitools/page/ai_install_page.dart';
import 'package:aitools/page/app_page.dart';
import 'package:aitools/page/base_environment_install.dart';
import 'package:aitools/page/command_page.dart';
import 'package:aitools/page/models_page.dart';
import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/Widgets/top_tabbar.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  appDocumentsDir = await getApplicationDocumentsDirectory();
  runApp(const MyApp());
}

late SharedPreferences prefs;
late Directory appDocumentsDir;

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Tools',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
        canvasColor: Colors.grey[50],
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.indigoAccent,
        brightness: Brightness.dark,
        canvasColor: const Color.fromARGB(255, 37, 37, 37),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TabItem> topTabbarTabItemlist({required Brightness brightness}) {
    List<TabItem> topTabbarTabItemlist = [
      TabItem(
        onTap: () {},
        title: const Text("应用"),
        tab: const AiInstallPage(),
      ),
      TabItem(
        onTap: () {},
        title: const Text("模型"),
        tab: const ModelsPage(),
      ),
      TabItem(
        onTap: () {},
        title: const Text("咒语"),
        tab: const CommandPage(),
      ),
    ];
    return topTabbarTabItemlist;
  }

  Widget floatingTabBarPageView({required Brightness brightness}) {
    List<TabItem> tabList() {
      List<TabItem> _list = [
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.egg),
          title: const Text("环境"),
          tab: const BaseEnvironmentInstall(),
        ),
        // TabItem(
        //   onTap: () {},
        //   selectedLeadingIcon: const Icon(Icons.library_books),
        //   title: const Text("文章"),
        //   tab: const Center(child: Text("文章", style: TextStyle(fontSize: 30))),
        // ),
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.dashboard),
          title: const Text("应用"),
          tab: const AppPage(),
        ),
        TabItem(
          title: const Text("商店"),
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.shopping_cart),
          tab: TopTabbar(tabList: topTabbarTabItemlist(brightness: brightness)),
          // showBadge: true,
          // badgeCount: 10,
        ),
        TabItem(
          title: const Text("模型"),
          onTap: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const ShowCase()));
          },
          selectedLeadingIcon: const Icon(Icons.pets_outlined),
          tab: const Center(child: Text("关于", style: TextStyle(fontSize: 30))),
        ),
      ];
      return _list;
    }

    return FloatingTabBar(
      children: tabList(),
      // useNautics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return floatingTabBarPageView(brightness: brightness);
  }
}
