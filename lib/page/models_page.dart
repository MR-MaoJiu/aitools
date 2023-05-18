import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../utils/ColorUtils.dart';
import '../widget/DownloadButton.dart';

class ModelsPage extends StatefulWidget {
  const ModelsPage({Key? key}) : super(key: key);

  @override
  State<ModelsPage> createState() => _ModelsPageState();
}

class _ModelsPageState extends State<ModelsPage> {
  late final List<DownloadController> _downloadControllers;
  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(
          onOpenDownload: () {
            _openDownload(index);
          },
          downloadUrl: 'https://blog.theuniversalx.com/?post=3',
          downloadName: '88'),
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
        // floatingActionButton: Container(
        //   margin: EdgeInsets.only(bottom: 80),
        //   child: FloatingActionButton(
        //     onPressed: () {},
        //     child: Icon(Icons.add),
        //   ),
        // ),
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
                    child: const Text(
                      'Stable Diffusion',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _modelsWidget(i),
                    childCount: 20,
                  ),
                ),
              )),
      reverse: false,
    ));
  }

  Widget _modelsWidget(index) {
    final downloadController = _downloadControllers[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(
            'https://picx.zhimg.com/v2-68ca977c1ae3e0c1233b6a1d04ae792e_1440w.jpg'),
      ),
      title: Text('模型名称：$index'),
      subtitle: Text('描述：这是一个很厉害的模型，该模型版本主要是基于xxxx模型训练的'),
      trailing: SizedBox(
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
