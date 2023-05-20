import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aitools/main.dart';
import 'package:aitools/utils/ColorUtils.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:process_run/process_run.dart';

class RunPage extends StatefulWidget {
  final app;
  const RunPage({Key? key, required this.app}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  final controller = StreamController();
  bool _showProgress = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runCommand();
    //只监听一次 Stream
    // controller.stream.listen((data) {
    //   // 处理数据
    //   print(data);
    //
    // });
  }

  runCommand(){
    //已安装则直接运行
    // if(prefs.getBool("insealled_${widget.app['name']}")??false){
    //
    // }
    setState(() {
      _showProgress = true;
    });
    if (!Platform.isWindows) {
      Process.start('chmod 775 "${widget.app['url']}/webui.sh"',[]);
    }

    // shell.run(
    //   '"${widget.app['url']}/webui.bat"',
    //       onProcess: (Process process) {
    //     process.stdout
    //         .transform(const SystemEncoding().decoder)
    //         .listen((data) {
    //       print(data);
    //       // controller.add(data);
    //     });
    //   }
    // );

    Process.start('cmd', ['/k', 'call','${widget.app['url']}/${Platform.isWindows?"webui.bat":"webui.sh"}'],workingDirectory: '${widget.app['url']}/',runInShell: true).then((Process process) {
      process.stdout.transform(const SystemEncoding().decoder).listen((data) {
        print(data);
        controller.add(data);
        if (data.contains('请按任意键继续')) {
          process.stdin.write('k');
          process.stdin.flush();
        }
      },onDone: (){
        setState(() {
          _showProgress = false;
        });
      },onError: (e){
        MotionToast.error(
          title: const Text("安装出错请重试"),
          description: Text(e),
        ).show(context);
      });
    });

  }
String buff='';
  @override
  Widget build(BuildContext context) => WillPopScope(
        child:Theme(data: ThemeData.dark(), child:  Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${widget.app['name']}"),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showProgress ? LinearProgressIndicator() : Container(),
                StreamBuilder(
                  stream: controller.stream,
                  initialData: "正在执行命令\n",
                  builder: (_, snapshot) {
                    // buff+=snapshot.data;

                    if (snapshot.data.startsWith('[')) {
                      buff = buff.split('[')[0]+snapshot.data;
                    }
                    else {
                      buff += snapshot.data ;
                    }

                    return SelectableText(buff,style: const TextStyle(color: Colors.cyan),);
                  },)],
            ),
          ),
        )),
        onWillPop: () async {
          var result = await showDialog<bool>(
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('提示'),
                  content: const Text('确定要退出吗？退出前请确保所有命令已经执行完毕'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('确定')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          '取消',
                          style: TextStyle(color: Colors.redAccent),
                        )),
                  ],
                );
              },
              context: context);
          return result!;
        },
      );
}
