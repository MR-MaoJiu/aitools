import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../utils/ColorUtils.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
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
                    child: const Text(
                      '图片相关',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _appWidget(i),
                    childCount: 20,
                  ),
                ),
              )),
      reverse: false,
    ));
  }

  Widget _appWidget(index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: ExtendedNetworkImageProvider(
            'https://pic4.zhimg.com/80/v2-40ededbfefa214151502f06b18fbb57f_720w.webp'),
      ),
      title: Text('咒语名称：$index'),
      subtitle: Text('咒语描述：xxx,xxxx,xx,xxxxx,xx,xxxx'),
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
          onPressed: () {},
          child: const Text(
            "启动",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
