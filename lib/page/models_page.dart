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
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 80),
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
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
                          'Stable Diffusion',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => models(i),
                        childCount: 20,
                      ),
                    ),
                  )),
          reverse: false,
        ));
  }

  Widget models(index) {
    final downloadController = _downloadControllers[index];
    return ListTile(
      leading: CircleAvatar(
        child: ExtendedImage.network(
            'https://img5.arthub.ai/user-uploads/cde0ae4800303678568d224f11505bb78f69ee15/9fcbd6da-350d-4086-a094-be01c6b2e672/ah3-67e96463ea7a.jpeg'),
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
