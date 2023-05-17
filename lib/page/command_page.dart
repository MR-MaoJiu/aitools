import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:motion_toast/motion_toast.dart';

import '../utils/ColorUtils.dart';

class CommandPage extends StatefulWidget {
  const CommandPage({Key? key}) : super(key: key);

  @override
  State<CommandPage> createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
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
                      'Stable Diffusion',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => command(i),
                    childCount: 20,
                  ),
                ),
              )),
      reverse: false,
    ));
  }

  Widget command(index) {
    return ListTile(
      leading: CircleAvatar(
        child: ExtendedImage.network(
            'https://img5.arthub.ai/user-uploads/9f9f29e929e0b146b9e94240e26ece4de5058da6/e0067814-8d2a-4391-9520-38e4c38a3d68/ah3-b3276462caae.jpeg'),
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
          onPressed: () {
            String text = '''
            Black lace dudou,1girl, large breasts, beautiful face, solo, candle, brown hair, long hair, <lora:flowergirl:0.9>,ulzzang-6500-v1.1,(raw photo:1.2),((photorealistic:1.4))best quality ,masterpiece, illustration, an extremely delicate and beautiful, extremely detailed ,CG ,unity ,8k wallpaper, Amazing, finely detail, masterpiece,best quality,official art,extremely detailed CG unity 8k wallpaper,absurdres, incredibly absurdres, huge filesize, ultra-detailed, highres, extremely detailed,beautiful detailed girl, extremely detailed eyes and face, beautiful detailed eyes,cinematic lighting,1girl,see-through,looking at viewer,full body,full-body shot,outdoors,arms behind back,(chinese clothes), <lora:BellyWrapAKindOfChinese_v02:0.8>
            Negative prompt: (((mole))),sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, skin blemishes, bad anatomy,(long hair:1.4),DeepNegative,(fat:1.2),facing away, looking away,tilted head, lowres,bad anatomy,bad hands, text, error, missing fingers,extra digit, fewer digits, cropped, worstquality, low quality, normal quality,jpegartifacts,signature, watermark, username,blurry,bad feet,cropped,poorly drawn hands,poorly drawn face,mutation,deformed,worst quality,low quality,normal quality,jpeg artifacts,signature,watermark,extra fingers,fewer digits,extra limbs,extra arms,extra legs,malformed limbs,fused fingers,too many fingers,long neck,cross-eyed,mutated hands,polar lowres,bad body,bad proportions,gross proportions,text,error,missing fingers,missing arms,missing legs,extra digit, extra arms, extra leg, extra foot,(freckles),(mole:2)
            Steps: 30, Sampler: DPM++ SDE Karras, CFG scale: 7, Seed: 1537971479, Size: 640x960, Model hash: fc2511737a, Model: chilloutmix_NiPrunedFp32Fix, Clip skip: 2, ENSD: 31337''';

            Clipboard.setData(ClipboardData(text: text));
            MotionToast.success(
              title: const Text("复制成功"),
              description: Text(text),
            ).show(context);
          },
          child: const Text(
            "复制",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
