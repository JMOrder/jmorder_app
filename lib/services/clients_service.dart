import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jmorder_app/models/client.dart';
import 'package:jmorder_app/services/api_service.dart';

import 'exceptions/common_http_exception.dart';

class ClientsService {
  ApiService get _apiService => GetIt.I.get<ApiService>();

  Future<List<Client>> fetchClients() async {
    try {
      var response = await _apiService.getClient().get('/clients');
      return List.from(List<Map>.from(response.data)
          .map((Map model) => Client.fromJson(model)));
    } on DioError catch (e) {
      if (e.response != null) throw FetchFailedException();
      throw UnexpectedClientsException();
    }
  }
}

class UnexpectedClientsException extends DioError {}
