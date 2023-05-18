import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_document/open_document.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/DownloadButton.dart';

class BaseEnvironmentInstall extends StatefulWidget {
  const BaseEnvironmentInstall({Key? key}) : super(key: key);

  @override
  State<BaseEnvironmentInstall> createState() => _BaseEnvironmentInstallState();
}

class _BaseEnvironmentInstallState extends State<BaseEnvironmentInstall> {
  late final List<DownloadController> _downloadControllers;
  String printStr = '如安装过程有问题，请联系lovemaojiu@gmail.com';
  String buttonStr = '安装';
  late SharedPreferences prefs;

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      buttonStr = prefs.getString('OneClickInstall') ?? '安装';
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    var en = [
      {
        "name": "git",
        "url": Platform.isWindows
            ? "https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/Git-2.34.1-64-bit.exe"
            : Platform.isMacOS
                ? "https://nchc.dl.sourceforge.net/project/git-osx-installer/git-2.15.0-intel-universal-mavericks.dmg"
                : "https://mirrors.edge.kernel.org/pub/software/scm/git/git-manpages-2.9.5.tar.xz"
      },
      {
        "name": "python",
        "url": Platform.isWindows
            ? "https://www.python.org/ftp/python/3.10.10/python-3.10.10-amd64.exe"
            : Platform.isMacOS
                ? "https://www.python.org/ftp/python/3.10.10/python-3.10.10-macos11.pkg"
                : "https://www.python.org/ftp/python/3.10.10/Python-3.10.10.tgz"
      },
      {
        "name": "cuda",
        "url":
            "https://developer.download.nvidia.cn/compute/cuda/11.8.0/network_installers/cuda_11.8.0_windows_network.exe"
      },
    ];
    _downloadControllers = List<DownloadController>.generate(
      3,
      (index) => SimulatedDownloadController(
          onOpenDownload: () async {
            final Directory appDocumentsDir =
                await getApplicationDocumentsDirectory();
            OpenDocument.openDocument(
                filePath:
                    '$appDocumentsDir/${en[index]['name']!}/${path.basename(en[index]['url']!)}');
          },
          downloadUrl: en[index]['url']!,
          downloadName: en[index]['name']!)
        ..getDownloadStatus(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? const Center(
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
                  backgroundImage: ExtendedNetworkImageProvider(
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
                  backgroundImage: ExtendedNetworkImageProvider(
                      'https://cdn.icon-icons.com/icons2/2108/PNG/96/python_icon_130849.png'),
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
              if (!kIsWeb && Platform.isWindows)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExtendedNetworkImageProvider(
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
                    backgroundImage: ExtendedNetworkImageProvider(
                        'https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/f39bbb06-3d4b-40cf-36ef-0abac596a000/width=450/375791.jpeg'),
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
                  backgroundImage: ExtendedNetworkImageProvider(
                      'https://android-artworks.25pp.com/fs08/2021/01/06/10/110_31ee1d58453b39860d8c9a5eac670efb_con_130x130.png'),
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
              if (Platform.isWindows)
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: ExtendedNetworkImageProvider(
                        'https://is4-ssl.mzstatic.com/image/thumb/Purple118/v4/30/d2/58/30d258f6-294e-8704-a416-d6b4cbbb08d6/source/256x256bb.jpg'),
                  ),
                  title: Text('一键安装上面所有环境并使用Github加速'),
                  subtitle: Text('部分机器可能运行失败因此该功能仅测试使用：$printStr'),
                  trailing: SizedBox(
                    width: 96,
                    child: MaterialButton(
                      //背景颜色
                      // color: Colors.white,
                      //边框样式
                      shape: RoundedRectangleBorder(
                        //边框颜色
                        side: BorderSide(
                          color:
                              buttonStr != '已完成' ? Colors.blue : Colors.black54,
                          width: 1,
                        ),
                        //边框圆角
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),

                      //点击事件
                      onPressed: buttonStr != '已完成' ? () => run() : null,
                      child: Text(
                        buttonStr,
                        style: TextStyle(
                            color: buttonStr != '已完成'
                                ? Colors.blue
                                : Colors.black54),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }

  void run() {
    setState(() {
      printStr = "检查 Python 版本 3.10...";
      buttonStr = '安装中';
    });

    Process.run('py', ['-3.10', '--version']).then((result) {
      if (result.exitCode == 0) {
        setState(() {
          printStr = "Python 3.10 已经安装";
        });
      } else {
        setState(() {
          printStr = "Python 3.10 未安装，开始下载...";
        });

        Process.run('curl', [
          'https://www.python.org/ftp/python/3.10.10/python-3.10.10-amd64.exe',
          '-o',
          'python-3.10.10-amd64.exe'
        ]).then((result) {
          setState(() {
            printStr = "安装 Python 3.10...";
          });
          Process.run('python-3.10.10-amd64.exe',
              ['/quiet', 'InstallAllUsers=1', 'PrependPath=1']).then((result) {
            setState(() {
              printStr = "清理安装器...";
            });
            File('python-3.10.10-amd64.exe').deleteSync();
          });
        });
      }
    });
    setState(() {
      printStr = "检查 Git 版本...";
    });

    Process.run('git', ['--version']).then((result) {
      if (result.exitCode == 0) {
        setState(() {
          printStr = "Git 已经安装";
        });
      } else {
        setState(() {
          printStr = "Git 未安装，开始下载...";
        });

        Process.run('curl', [
          '-L',
          'https://github.com/git-for-windows/git/releases/download/v2.34.1.windows.1/Git-2.34.1-64-bit.exe',
          '-o',
          'Git-2.34.1-64-bit.exe'
        ]).then((result) {
          setState(() {
            printStr = "安装 Git...";
          });
          Process.run('Git-2.34.1-64-bit.exe', ['/SILENT']).then((result) {
            setState(() {
              printStr = "清理安装器...";
            });
            File('Git-2.34.1-64-bit.exe').deleteSync();
          });
        });
      }
    });

    setState(() {
      printStr = "切换 Git 镜像...";
    });

    Process.run('git', [
      'config',
      '--global',
      'url."https://kgithub.com/".insteadOf',
      '"https://github.com/"'
    ]);

    setState(() {
      printStr = "检查 GPU...";
    });
    Process.run('nvidia-smi', []).then((result) {
      if (result.exitCode == 0) {
        setState(() {
          printStr = "检查CUDA...";
        });
        Process.run('nvcc', ['--version']).then((result) {
          if (result.exitCode == 0) {
            setState(() {
              printStr = "CUDA 已经安装";
            });
          } else {
            setState(() {
              printStr = "未检测到CUDA";
            });
          }

          setState(() {
            printStr = "检查 cuDNN...";
          });
          if (File(
                  'C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v11.8\\bin\\cudnn64_8.dll')
              .existsSync()) {
            setState(() {
              printStr = "cuDNN 已经安装";
              setState(() {
                buttonStr = '已完成';
              });
            });
          } else {
            setState(() {
              printStr = "未检测到cuDNN";
              buttonStr = '重试';
            });
          }
        });
      } else {
        setState(() {
          printStr = "未找到可用GPU";
        });
      }
    });

    prefs.setString('OneClickInstall', buttonStr);
    // print('正在创建虚拟环境（需要一点时间，请耐心等待）...\n\n');
    //
    // Process.run('py', ['-3.10', '-m', 'venv', 'venv']).then((result) {
    //   print('升级 pip 和 wheel...\n\n');
    //   Process.run('venv\\Scripts\\python.exe', [
    //     '-m',
    //     'pip',
    //     'install',
    //     '--upgrade',
    //     'pip',
    //     'wheel'
    //   ]).then((result) {
    //     print('按任意键开始安装Stable Diffusion\n\n');
    //     stdin.readLineSync();
    //     print('安装 Stable Diffusion...\n\n');
    //     Process.run('webui.bat');
    //   });
    // });
  }
}
