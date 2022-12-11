import 'package:dio/dio.dart';
import 'package:flutterdesigndemo/api/dio_client.dart';
import 'package:flutterdesigndemo/api/api_request.dart';
import 'package:flutterdesigndemo/api/api_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(Dio());
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(ApiRequest(dioClient: getIt<DioClient>()));
  getIt.registerSingleton(ApiRepository(getIt.get<ApiRequest>()));
}
