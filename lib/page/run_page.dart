import 'package:flutter/material.dart';

class RunPage extends StatefulWidget {
  final app;
  const RunPage({Key? key, required this.app}) : super(key: key);

  @override
  State<RunPage> createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.app);
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${widget.app['name']}"),
          ),
          body: Column(
            children: [],
          ),
        ),
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
