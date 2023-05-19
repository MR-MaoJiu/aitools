import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:path/path.dart' as path;

import '../main.dart';
import '../utils/ColorUtils.dart';
import '../widget/DownloadButton.dart';

class AiInstallPage extends StatefulWidget {
  const AiInstallPage({Key? key}) : super(key: key);

  @override
  State<AiInstallPage> createState() => _AiInstallPageState();
}

class _AiInstallPageState extends State<AiInstallPage>
    with AutomaticKeepAliveClientMixin {
  // late final List<DownloadController> _downloadControllers;
  List dataList = [];
  Map<String, dynamic> appJson = {
    "data": [
      {"list": [], "type": "图片相关"}
    ]
  };
  getData() {
    Dio().get('https://ai.theuniversalx.com/app.json').then((value) {
      setState(() {
        dataList = value.data['data'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    // _downloadControllers = List<DownloadController>.generate(
    //   dataList.length,
    //   (index) => SimulatedDownloadController(
    //       onOpenDownload: () {
    //         _openDownload(index);
    //       },
    //       downloadUrl: '${dataList[index]['list'][0]['url']}',
    //       downloadName:
    //           '${dataList[index]['type']}/${dataList[index]['list'][0]['name']}'),
    // );
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
                              (context, i) => _appWidget(
                                  i,
                                  dataList[index]['list'],
                                  dataList[index]['type']),
                              childCount: dataList[index]['list'].length,
                            ),
                          ),
                        )),
                reverse: false,
              )
            : const Center(
                child:
                    Text("暂时还没有获取到可以用的AI应用", style: TextStyle(fontSize: 30))));
  }

  Widget _appWidget(index, _dataList, groupName) {
    // final downloadController = _downloadControllers[index];

    var downloadController = SimulatedDownloadController(
        onOpenDownload: () async {
          print(
              '${appDocumentsDir.path}/AiTools/${_dataList[index]['name']}/${path.basename(_dataList[index]['url'])}');

          String? outputFile = await FilePicker.platform.saveFile(
            dialogTitle: '解压${_dataList[index]['name']}到:',
            fileName: groupName,
          );
          if (outputFile != null) {
            extractFileToDisk(
                '${appDocumentsDir.path}/AiTools/${_dataList[index]['name']}/${path.basename(_dataList[index]['url'])}',
                '$outputFile/');
            String appData = prefs.getString("app") ?? json.encode(appJson);
            appJson = json.decode(appData);
            appJson['data'].forEach((element) {
              //有新的分类添加新的分类和列表没有的话就添加到当前列表
              if (element['type'] != groupName) {
                appJson['data'].add({
                  "list": [
                    {
                      "name": _dataList[index]['name'],
                      "desc": _dataList[index]['desc'],
                      "url":
                          "$outputFile/${path.basename(_dataList[index]['url']).split('.')[0]}",
                      "icon": _dataList[index]['icon'],
                      "version": _dataList[index]['version']
                    }
                  ],
                  "type": groupName
                });
              } else {
                if (element['list'].isNotEmpty) {
                  element['list'].forEach((elem) {
                    if (elem['name'] != _dataList[index]['name']) {
                      element['list'].add({
                        "name": _dataList[index]['name'],
                        "desc": _dataList[index]['desc'],
                        "url":
                            "$outputFile/${path.basename(_dataList[index]['url']).split('.')[0]}",
                        "icon": _dataList[index]['icon'],
                        "version": _dataList[index]['version']
                      });
                    }
                  });
                } else {
                  element['list'] = [
                    {
                      "name": _dataList[index]['name'],
                      "desc": _dataList[index]['desc'],
                      "url":
                          "$outputFile/${path.basename(_dataList[index]['url']).split('.')[0]}",
                      "icon": _dataList[index]['icon'],
                      "version": _dataList[index]['version']
                    }
                  ];
                }
              }
            });
            print("=================>>>>${json.encode(appJson)}");
            prefs.setString('app', json.encode(appJson));
          }
        },
        downloadUrl: '${_dataList[index]['url']}',
        downloadName: '${_dataList[index]['name']}')
      ..getDownloadStatus();
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(_dataList[index]['icon']),
      ),
      title: Text(_dataList[index]['name']),
      subtitle: Text(_dataList[index]['desc']),
      trailing: kIsWeb
          ? null
          : SizedBox(
              width: 96,
              child: AnimatedBuilder(
                animation: downloadController,
                builder: (context, child) {
                  return DownloadButton(
                    status: downloadController.downloadStatus,
                    downloadProgress: downloadController.progress,
                    onDownload: downloadController.startDownload,
                    onCancel: downloadController.stopDownload,
                    onOpen: downloadController.openDownload,
                    // buttonSt: (prefs.getBool(_dataList[index]['name'])??false)?"解压":"下載",
                    buttonEn: "解压",
                  );
                },
              ),
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
