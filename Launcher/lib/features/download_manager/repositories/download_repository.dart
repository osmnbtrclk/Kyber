import 'dart:async';

import 'package:background_downloader/background_downloader.dart';

class DownloadRepository {
  const DownloadRepository();

  Future<List<TaskRecord>> getAllTasks() async {
    return FileDownloader().database.allRecords();
  }

  Future<List<TaskRecord>> getActiveTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.status.isNotFinalState).toList();
  }

  Future<List<TaskRecord>> getPausedTasks() async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.status == TaskStatus.paused).toList();
  }

  Future<TaskRecord?> getRunningTask() async {
    final tasks = await getAllTasks();
    try {
      return tasks.firstWhere((task) => task.status == TaskStatus.running);
    } catch (_) {
      return null;
    }
  }

  Future<TaskRecord?> getTaskById(String taskId) async {
    return FileDownloader().database.recordForId(taskId);
  }

  Stream<List<TaskRecord>> watchTasks() {
    return FileDownloader().database.updates.asyncMap((_) => getAllTasks());
  }

  Future<void> deleteTask(String taskId) async {
    await FileDownloader().database.deleteRecordWithId(taskId);
  }

  Future<void> clearCompletedTasks() async {
    final tasks = await getAllTasks();
    final completedTasks = tasks.where(
      (task) => task.status == TaskStatus.complete,
    );

    for (final task in completedTasks) {
      await deleteTask(task.taskId);
    }
  }
}
