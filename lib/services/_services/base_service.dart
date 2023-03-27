import 'dart:io';

abstract class BaseService {
  final HttpClient client;
  const BaseService(this.client) : assert(client != null);
}
