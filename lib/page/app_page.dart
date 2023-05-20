import 'dart:convert';
import 'dart:io';

import 'package:aitools/page/run_page.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:open_document/open_document.dart';
import 'package:process_run/process_run.dart';

import '../main.dart';
import '../utils/ColorUtils.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late Map<String, dynamic> appJson = {"data": []};
  String appData = prefs.getString("app") ?? '';
  List dataList = [];
  // final controller = StreamController();
  // Shell shell = Shell(
  //   workingDirectory:
  //       Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'],
  //   environment: Platform.environment,
  //   throwOnError: false,
  //   stderrEncoding: const Utf8Codec(),
  //   stdoutEncoding: const Utf8Codec(),
  // );
  getData() {
    if (appData.isNotEmpty) {
      appJson = json.decode(appData);
      print(appJson);
    }
    setState(() {
      dataList = appJson['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    // 只监听一次 Stream
    // controller.stream.listen((data) {
    //   // 处理数据
    //   print(data);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: dataList.isNotEmpty
            ? CustomScrollView(
                slivers: List.generate(
                    dataList.length,
                    (index) => SliverStickyHeader.builder(
                          builder: (context, state) => GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 60,
                              color: ColorUtils.getRandomColor(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                dataList[index]['type'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) =>
                                  _appWidget(i, dataList[index]['list']),
                              childCount: dataList[index]['list'].length,
                            ),
                          ),
                        )),
                reverse: false,
              )
            : const Center(
                child:
                    Text("您还没有下载AI应用请去商店下载", style: TextStyle(fontSize: 30))));
  }

  Widget _appWidget(index, _dataList) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(_dataList[index]['icon']),
      ),
      title: Text(_dataList[index]['name']),
      subtitle: Text(_dataList[index]['desc']),
      trailing: SizedBox(
        width: 96,
        child: MaterialButton(
          //背景颜色
          // color: Colors.white,
          //边框样式
          shape: const RoundedRectangleBorder(
            //边框颜色
            side: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            //边框圆角
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),

          //点击事件
          onPressed: () async {



            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RunPage(app: _dataList[index]);
            }));

            // if (!Platform.isWindows) {
            //   shell.run('chmod 775 "${_dataList[index]['url']}/webui.sh"');
            // }
            //
            // shell.run(
            //   '"${_dataList[index]['url']}/webui.sh"',
            //   //     onProcess: (Process process) {
            //   //   process.stdout
            //   //       .transform(const SystemEncoding().decoder)
            //   //       .listen((data) {
            //   //     print(data);
            //   //     controller.add(data);
            //   //   });
            //   // }
            // );
            // Process.start(
            //         'cmd.exe', ['/c', '${_dataList[index]['url']}/webui.sh'],
            //         runInShell: true)
            //     .then((Process process) {
            //   process.stdout
            //       .transform(const SystemEncoding().decoder)
            //       .listen((data) {
            //     print(data);
            //   });
            // });

            // Process.run(
            //   'cmd.exe',
            //   ['/c', '${_dataList[index]['url']}/webui.bat'],
            // ).then((ProcessResult results) {
            //   print('============>${results.stdout}');
            // });
          },
          child:  Text(
            (prefs.getBool("insealled_${_dataList[index]['name']}")??false)?"启动":"安装",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
