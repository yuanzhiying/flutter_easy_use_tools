import 'dart:async';

/// 任务队列
class TaskQueueManager {
  /// 存放多个实例的Map
  static Map<String, TaskQueueManager> _taskQueueUtilMap = Map<String, TaskQueueManager>();

  /// 初始化
  TaskQueueManager._() {
    // 初始化
  }

  /// 根据key来获取实例Map中对应的单例
  static TaskQueueManager instance(String key) {
    if (_taskQueueUtilMap[key] == null) {
      _taskQueueUtilMap[key] = TaskQueueManager._();
    }
    return _taskQueueUtilMap[key]!;
  }

  /// 创建一个任务队列
  List<_TaskInfo> taskList = [];

  /// 是否任务正在执行
  bool _isTaskRunning = false;

  /// 是否取消了队列
  bool _isCancelQueue = false;

  /// 任务ID
  int _taskId = 0;

  /// 任务完成回调
  Function? taskAllFinishedCallback;

  /// 添加任务到队列
  Future<_TaskInfo> addTask(Function doSomeThing) async {
    _taskId++;
    _isCancelQueue = false;

    // 创建任务
    _TaskInfo taskInfo = _TaskInfo(id: _taskId, doSomeThing: doSomeThing);

    // 创建任务Future
    // Completer: 允许创建一个Future对象，稍后用一个值或者错误来完成它
    Completer<_TaskInfo> taskCompleter = Completer<_TaskInfo>();

    // 创建任务的stream
    // StreamController: 一个允许在包含的stream上发送数据、事件、错误的控制器。
    StreamController<_TaskInfo> streamController = StreamController();
    taskInfo.controller = streamController;

    // 添加任务到任务队列
    taskList.add(taskInfo);

    // 添加任务的监听
    streamController.stream.listen((completeTaskInfo) {
      // 完成当前任务
      if (completeTaskInfo.id == taskInfo.id) {
        taskCompleter.complete(completeTaskInfo);
        streamController.close();
      }
    });

    // 触发任务
    _doTask();

    return taskCompleter.future;
  }

  /// 执行任务
  _doTask() async {
    if (_isTaskRunning) return;
    if (taskList.isEmpty) {
      taskAllFinishedCallback?.call();
      return;
    }

    // 取出任务
    _TaskInfo taskInfo = taskList[0];
    _isTaskRunning = true;

    // 执行任务
    await taskInfo.doSomeThing?.call();

    // 任务执行完成，发送任务执行完成事件
    taskInfo.controller?.sink.add(taskInfo);

    // 队列取消之后，终止迭代
    if (_isCancelQueue) return;

    // 出队列
    taskList.removeAt(0);
    _isTaskRunning = false;

    // 迭代执行任务
    _doTask();
  }

  /// 取消任务
  void cancelTask() {
    _taskId = 0;
    taskList = [];
    _isTaskRunning = false;
    _isCancelQueue = true;
  }
}

/// 任务
class _TaskInfo {
  int id; // 任务唯一标识
  Function? doSomeThing; // 任务内容
  StreamController<_TaskInfo>? controller;

  _TaskInfo({
    required this.id,
    this.doSomeThing,
    this.controller,
  });
}
