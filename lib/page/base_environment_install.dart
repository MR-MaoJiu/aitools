import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/DownloadButton.dart';

class BaseEnvironmentInstall extends StatefulWidget {
  const BaseEnvironmentInstall({Key? key}) : super(key: key);

  @override
  State<BaseEnvironmentInstall> createState() => _BaseEnvironmentInstallState();
}

class _BaseEnvironmentInstallState extends State<BaseEnvironmentInstall> {
  late final List<DownloadController> _downloadControllers;
  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      2,
      (index) => SimulatedDownloadController(onOpenDownload: () {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Center(
            child: Text("暂不支持Web端"),
          )
        : Column(
            children: [
              Container(
                  margin: EdgeInsets.all(16),
                  child: Text(
                      "为了方便定位问题，请安装软件时不更换安装位置直接进行下一步${Platform.isWindows || Platform.isLinux ? "，Nvidia显卡需要安装CUDA。" : "。"}如果您已安装以下软件则不必再次安装。",
                      style: TextStyle(fontSize: 15, color: Colors.redAccent))),
              ListTile(
                leading: CircleAvatar(
                  child: ExtendedImage.network(
                      'https://git-scm.com/images/logos/logomark-orange@2x.png'),
                ),
                title: Text('Git安装'),
                subtitle: Text(
                    'Git 是一个开源的分布式版本控制系统，用于敏捷高效地处理任何或小或大的项目，安装完毕后如需配置环境变量请自行百度配置'),
                trailing: SizedBox(
                  width: 96,
                  child: AnimatedBuilder(
                    animation: _downloadControllers[0],
                    builder: (context, child) {
                      return DownloadButton(
                        status: _downloadControllers[0].downloadStatus,
                        downloadProgress: _downloadControllers[0].progress,
                        onDownload: _downloadControllers[0].startDownload,
                        onCancel: _downloadControllers[0].stopDownload,
                        onOpen: _downloadControllers[0].openDownload,
                      );
                    },
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: ExtendedImage.network(
                      'https://docs.python.org/zh-cn/3/_static/py.svg'),
                ),
                title: Text('Python安装'),
                subtitle:
                    Text('Python 是一门易于学习、功能强大的编程语言，安装完毕后如需配置环境变量请自行百度配置。'),
                trailing: SizedBox(
                  width: 96,
                  child: AnimatedBuilder(
                    animation: _downloadControllers[1],
                    builder: (context, child) {
                      return DownloadButton(
                        status: _downloadControllers[1].downloadStatus,
                        downloadProgress: _downloadControllers[1].progress,
                        onDownload: _downloadControllers[1].startDownload,
                        onCancel: _downloadControllers[1].stopDownload,
                        onOpen: _downloadControllers[1].openDownload,
                      );
                    },
                  ),
                ),
              ),
              // https://developer.download.nvidia.cn/compute/cuda/11.8.0/network_installers/cuda_11.8.0_windows_network.exe

              if (kIsWeb && Platform.isWindows)
                ListTile(
                  leading: CircleAvatar(
                    child: ExtendedImage.network(
                        'https://www.nvidia.cn/content/dam/en-zz/Solutions/about-nvidia/logo-and-brand/02-nvidia-logo-color-blk-500x200-4c25-d.png'),
                  ),
                  title: Text('CUDA Toolkit安装'),
                  subtitle: Text(
                      'CUDA是一种由NVIDIA公司开发的并行计算平台和编程模型,它可以利用GPU进行高效的并行计算，安装完毕后如需配置环境变量请自行百度配置。'),
                  trailing: SizedBox(
                    width: 96,
                    child: AnimatedBuilder(
                      animation: _downloadControllers[1],
                      builder: (context, child) {
                        return DownloadButton(
                          status: _downloadControllers[1].downloadStatus,
                          downloadProgress: _downloadControllers[1].progress,
                          onDownload: _downloadControllers[1].startDownload,
                          onCancel: _downloadControllers[1].stopDownload,
                          onOpen: _downloadControllers[1].openDownload,
                        );
                      },
                    ),
                  ),
                ),
              if (Platform.isLinux)
                ListTile(
                  leading: CircleAvatar(
                    child: ExtendedImage.network(
                        'https://www.nvidia.cn/content/dam/en-zz/Solutions/about-nvidia/logo-and-brand/02-nvidia-logo-color-blk-500x200-4c25-d.png'),
                  ),
                  title: Text('CUDA Toolkit安装'),
                  subtitle: Text(
                      'CUDA是一种由NVIDIA公司开发的并行计算平台和编程模型,它可以利用GPU进行高效的并行计算，安装完毕后如需配置环境变量请自行百度配置。'),
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
                        launchUrl(Uri.parse(
                            'https://developer.nvidia.com/cuda-11-7-1-download-archive?target_os=Linux&target_arch=x86_64'));
                      },
                      child: const Text(
                        "跳转",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ListTile(
                leading: CircleAvatar(
                  child: ExtendedImage.network(
                      'https://blog.theuniversalx.com/content/uploadfile/202305/4b1c1684250721.jpg'),
                ),
                title: Text('GitHub加速和Python镜像源切换'),
                subtitle: Text(
                    'Git Clone GitHub项目和Python安装依赖时候因网络原因可能会失败，如果您没有其他加速方式建议查看如何加速'),
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
                      launchUrl(
                          Uri.parse('https://blog.theuniversalx.com/?post=3'));
                    },
                    child: const Text(
                      "查看",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
