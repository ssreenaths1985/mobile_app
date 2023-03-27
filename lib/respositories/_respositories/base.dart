import 'package:flutter/material.dart';
import './../../services/index.dart';

enum Status { loading, error, loaded }

abstract class BaseRepository<T extends BaseService> with ChangeNotifier {
  final BuildContext context;
  final T service;

  Status _status;

  BaseRepository(this.service, [this.context]) {
    startLoading();
    loadData();
  }

  Future<void> loadData();

  Future<void> refreshData() => loadData();

  bool get isLoading => _status == Status.loading;
  bool get loadingFailed => _status == Status.error;
  bool get isLoaded => _status == Status.loaded;

  void startLoading() {
    _status = Status.loading;
  }

  void finishLoading() {
    _status = Status.loaded;
  }

  void receivedError() {
    _status = Status.error;
    notifyListeners();
  }
}
