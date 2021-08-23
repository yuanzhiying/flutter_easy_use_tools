import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easy_use_tools/flutter_easy_use_tools.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              color: Colors.green,
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(20),
              child: MaterialButton(
                onPressed: () {
                  print(NumUtil.formatNum(12.12345678, 2));
                },
                child: Text('测试NumUtil'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.green,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    child: MaterialButton(
                      onPressed: testDownloadTask,
                      child: Text('添加多个下载任务'),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(20),
                    child: MaterialButton(
                      onPressed: cancelDownloadTask,
                      child: Text('取消任务队列'),
                    ),
                  ),
                ),
              ],
            ),
            CustomInnerShadow(
              shadows: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.5),
                  offset: Offset(-1, -1),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.grey[400]!,
                  offset: Offset(0, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                margin: EdgeInsets.all(20),
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('内阴影'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 多个下载任务测试
  void testDownloadTask() async {
    /// 任务全部下载完成回调
    if (TaskQueueManager.instance('download').taskAllFinishedCallback == null) {
      TaskQueueManager.instance('download').taskAllFinishedCallback = () {
        print('任务全部完成 - queueName：download');
      };
    }

    TaskQueueManager.instance('download').addTask(() {
      return _download('download', 1);
    });
    TaskQueueManager.instance('download').addTask(() {
      return _download('download', 2);
    });
    TaskQueueManager.instance('download').addTask(() {
      return _download('download', 3);
    });
  }

  /// 取消下载任务
  void cancelDownloadTask() async {
    TaskQueueManager.instance('download').cancelTask();
    print('任务取消 - queueName：download');
  }

  /// 单个下载
  Future _download(String queueName, int taskNo) async {
    try {
      String downloadUrl = 'https://img-dev.xinxigu.com.cn/s1/2020/7/23/ca226be9814208db75cf000eb43cf12f.mp4';
      String downloadPath = await getDownloadPath(downloadUrl, taskNo);
      Response<dynamic> response = await dio.download(downloadUrl, downloadPath);
      if (response.statusCode == 200) {
        print('任务完成 - 下载成功  queueName：$queueName, taskNo: $taskNo');
      } else {
        print('任务完成 - 下载失败  queueName：$queueName, taskNo: $taskNo');
      }
      return response;
    } catch (e) {
      print('任务完成 - 下载失败  queueName：$queueName, taskNo: $taskNo Error: $e');
      return FlutterError('下载异常');
    }
  }

  /// 获取下载地址
  Future<String> getDownloadPath(String url, int taskNo) async {
    String savedDirPath = '';

    // 生成、获取结果存储路径
    final tempDic = await getTemporaryDirectory();
    Directory downloadDir = Directory(tempDic.path + '/download/');
    bool isFold = await downloadDir.exists();
    if (!isFold) {
      await downloadDir.create();
    }
    savedDirPath = downloadDir.path;

    String fileName = url.split('/').last.split('.').first;
    String extension = url.split('.').last;
    String videoPath = savedDirPath + fileName + '-$taskNo' + '.' + extension;
    return videoPath;
  }
}
