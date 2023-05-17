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
  late final List<DownloadController> _downloadControllers;
  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(onOpenDownload: () {
        _openDownload(index);
      }),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open App ${index + 1}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: List.generate(
          1,
          (index) => SliverStickyHeader.builder(
                builder: (context, state) => GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 60,
                    color: ColorUtils.getRandomColor(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '图片相关',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => app(i),
                    childCount: 20,
                  ),
                ),
              )),
      reverse: false,
    ));
  }

  Widget app(index) {
    final downloadController = _downloadControllers[index];
    return ListTile(
      leading: CircleAvatar(
        child: ExtendedImage.network(
            'https://img5.arthub.ai/user-uploads/9f9f29e929e0b146b9e94240e26ece4de5058da6/e0067814-8d2a-4391-9520-38e4c38a3d68/ah3-b3276462caae.jpeg'),
      ),
      title: Text('项目名称：Stable Diffusion+WebUI'),
      subtitle: Text(
          '项目描述：Stable Diffusion是一款功能异常强大的AI图片生成器。它不仅支持生成图片，使用各种各样的模型来达到你想要的效果，还能训练你自己的专属模型。'),
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
                  );
                },
              ),
            ),
    );
  }
}