import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../utils/ColorUtils.dart';
import '../widget/DownloadButton.dart';

class AiInstallPage extends StatefulWidget {
  const AiInstallPage({Key? key}) : super(key: key);

  @override
  State<AiInstallPage> createState() => _AiInstallPageState();
}

class _AiInstallPageState extends State<AiInstallPage> {
  // late final List<DownloadController> _downloadControllers;
  List dataList = [];
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
        body: CustomScrollView(
      slivers: List.generate(
          dataList.length,
          (index) => SliverStickyHeader.builder(
                builder: (context, state) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 60,
                    color: ColorUtils.getRandomColor(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dataList[index]['type'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _appWidget(i, dataList[index]['list']),
                    childCount: dataList[index]['list'].length,
                  ),
                ),
              )),
      reverse: false,
    ));
  }

  Widget _appWidget(index, _dataList) {
    // final downloadController = _downloadControllers[index];
    var downloadController = SimulatedDownloadController(
        onOpenDownload: () {
          // extractZip(path: 'path', updateFilesList: () {});
        },
        downloadUrl: '${_dataList[index]['url']}',
        downloadName: '${_dataList[index]['name']}');
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
                    buttonEn: "解压",
                  );
                },
              ),
            ),
    );
  }
}
