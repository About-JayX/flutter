import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mobisen_app/util/log.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/net/model/api_response.dart';
import 'package:mobisen_app/net/model/homepage.dart';
import 'package:mobisen_app/net/model/reward/reward.dart';
import 'package:mobisen_app/net/model/reward/seven_day_task.dart';
import 'package:mobisen_app/net/model/reward/task.dart';
import 'package:mobisen_app/net/model/show.dart';
import 'package:mobisen_app/net/model/shows.dart';
import 'package:mobisen_app/net/model/unlock_episode.dart';
import 'package:mobisen_app/net/model/user.dart' as account_user;
import 'package:mobisen_app/net/model/user_info.dart' as account_user_info;
import 'package:mobisen_app/net/model/wallet_records.dart';
import 'package:mobisen_app/util/text_utils.dart';
import 'package:mobisen_app/util/account_helper.dart';

enum HttpMethod { get, post }

class ApiService {
  final Duration _connectTimeout = const Duration(seconds: 8);
  final Duration _receiveTimeout = const Duration(seconds: 15);
  final Duration _sendTimeout = const Duration(seconds: 15);
  static const String _baseUrl = !kReleaseMode
      ? "http://192.168.1.241:3000"
      : "https://staging.mobisen.app";

  static final ApiService _instance = ApiService._();
  static ApiService get instance => _instance;

  late Dio _dio;
  final Map<String, dynamic> _baseCommonParams = {};
  final Map<String, dynamic> _commonParams = {};

  Map<String, dynamic> get commonParams => _commonParams;

  ApiService._() {
    _dio = Dio(BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      baseUrl: _baseUrl,
      headers: {'User-Agent': "Ume ${TextUtils.getPlatform()}"},
    ))
        // ..httpClientAdapter = Http2Adapter(
        //   ConnectionManager(idleTimeout: const Duration(seconds: 10)),
        // )
        ;
    if (kReleaseMode) {
      _dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(idleTimeout: const Duration(seconds: 10)),
      );
    }
  }

  Future<void> initBaseCommonParams() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final Map<String, dynamic> params = {
      "os": TextUtils.getPlatform(),
      "appName": packageInfo.appName,
      "pn": packageInfo.packageName,
      "v": packageInfo.version,
      "vc": packageInfo.buildNumber,
    };
    _baseCommonParams
      ..clear()
      ..addAll(params);
    _commonParams.addAll(params);
  }

  void initCommonParams(BuildContext context) {
    final Map<String, dynamic> params = {
      "lang": Localizations.localeOf(context).languageCode,
    };
    params.addAll(_baseCommonParams);
    _commonParams
      ..clear()
      ..addAll(params);
  }

  Map<String, dynamic> _copyCommonParams() {
    return Map.from(_commonParams);
  }

  Account? get _currentAccount => AccountHelper.instance.account;

  Future<Response> request(
    String endPoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
    HttpMethod method = HttpMethod.get,
    Account? account,
  }) async {
    final params = _copyCommonParams();
    if (queryParams != null) {
      params.addAll(queryParams);
    }
    // 优先使用传入的 account，否则自动从全局 AccountHelper 获取
    final effectiveAccount = account ?? _currentAccount;
    final jwt = effectiveAccount?.jwt;
    final options = Options(headers: {
      if (jwt != null && jwt.isNotEmpty) "Authorization": "Bearer $jwt",
      "Content-Type": "application/json",
    });

    // 打印请求日志
    print('🌐 [API Request] ==========================================');
    print('🌐 [API Request] URL: ${_dio.options.baseUrl}$endPoint');
    print(
        '🌐 [API Request] Method: ${method == HttpMethod.get ? "GET" : "POST"}');
    print('🌐 [API Request] Query Params: ${jsonEncode(params)}');
    if (body != null) {
      print('🌐 [API Request] Body: ${jsonEncode(body)}');
    }
    print('🌐 [API Request] Headers: ${jsonEncode(options.headers)}');
    print('🌐 [API Request] ==========================================');

    switch (method) {
      case HttpMethod.get:
        return _dio.get(endPoint, queryParameters: params, options: options);
      case HttpMethod.post:
        return _dio.post(endPoint,
            queryParameters: params, options: options, data: body);
    }
  }

  ApiResponse handleResponse(Response response) {
    print('🔵 [handleResponse] ==========================================');
    print(
        '🔵 [handleResponse] Response data type: ${response.data.runtimeType}');
    print('🔵 [handleResponse] Response data: ${jsonEncode(response.data)}');
    print('🔵 [handleResponse] Status Code: ${response.statusCode}');
    print('🔵 [handleResponse] Request Path: ${response.requestOptions.path}');

    try {
      dynamic responseData = response.data;

      // 如果响应包含 { head, body } 结构，提取 body
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('head') &&
          responseData.containsKey('body')) {
        print(
            '🔵 [handleResponse] Detected { head, body } structure, extracting body...');
        responseData = responseData['body'];
        print(
            '🔵 [handleResponse] Extracted body: ${jsonEncode(responseData)}');
      }

      final apiResponse = ApiResponse.fromJson(responseData);
      print('🟢 [handleResponse] Parsed successfully');
      print('🟢 [handleResponse] Status: ${apiResponse.status}');
      print('🟢 [handleResponse] StatusInfo: ${apiResponse.statusInfo}');
      print('🟢 [handleResponse] Data type: ${apiResponse.data.runtimeType}');
      print('🟢 [handleResponse] Data: ${jsonEncode(apiResponse.data)}');

      if (!apiResponse.isSuccess) {
        print('🔴 [handleResponse] Request failed: ${apiResponse.statusInfo}');
        throw Exception(apiResponse.statusInfo ?? 'Unknown error');
      }

      print('🟢 [handleResponse] ==========================================');
      return apiResponse;
    } catch (e, stackTrace) {
      print('🔴 [handleResponse] Parse error: $e');
      print('🔴 [handleResponse] Stack trace: $stackTrace');
      print('🔴 [handleResponse] ==========================================');
      rethrow;
    }
  }

  Future<Homepage> getHomepage(Account? account) async {
    return Homepage.fromJson(
        handleResponse(await request(ApiEndPoints.homepage, account: account))
            .data);
  }

  Future<Reward> getReward(Account? account) async {
    return Reward.fromJson(
        handleResponse(await request(ApiEndPoints.reward, account: account))
            .data);
  }

  Future<SevenDayTask> getSignInDetail(Account? account) async {
    dynamic res = handleResponse(
        await request(ApiEndPoints.signInDetail, account: account));
    //LogD("Future<SevenDayTask> getSignInDetail(Account? account):\n${json.encode(res)}");
    dynamic data = res.data;
    return SevenDayTask.fromJson(data);
  }

  Future<void> signIn(Account? account) async {
    dynamic res = handleResponse(await request(ApiEndPoints.signIn,
        account: account, method: HttpMethod.post));
    // LogD("Future<void> signIn(Account? account):\n${json.encode(res)}");
  }

  Future<Task> getTaskList(Account? account) async {
    dynamic res = handleResponse(
        await request(ApiEndPoints.getTaskList, account: account));
    //LogD("Future<Task> getTaskList(Account? account):\n${json.encode(res)}");
    dynamic data = res.data;
    return Task.fromJson(data);

    // return Task.fromJson(handleResponse(
    //         await request(ApiEndPoints.getTaskList, account: account))
    //     .data);
  }

  Future<void> finishTask(Account? account, int taskId) async {
    dynamic res = handleResponse(await request(ApiEndPoints.finishTask,
        account: account, body: {"taskId": taskId}, method: HttpMethod.post));
    //LogD("Future<void> finishTask(Account? account):\n${json.encode(res)}");
  }

  Future<Show> getShowDetail(Account? account, int showId) async {
    return Show.fromJson(handleResponse(await request(ApiEndPoints.showDetail,
            account: account, queryParams: {"showId": showId}))
        .data);
  }

  Future<UnlockEpisode> unlockEpisode(Account? account, int episodeId) async {
    return UnlockEpisode.fromJson(handleResponse(await request(
            ApiEndPoints.unlockEpisode,
            account: account,
            body: {"episodeId": episodeId},
            method: HttpMethod.post))
        .data);
  }

  Future<Shows> savedShows(Account? account, int offset, int pageSize) async {
    return Shows.fromJson(handleResponse(
      await request(
        ApiEndPoints.savedShows,
        account: account,
        queryParams: {
          "offset": offset,
          "pageSize": pageSize,
        },
      ),
    ).data);
  }

  Future<WalletRecords> getWalletRecords(
      String endPoint, Account? account, int offset, int pageSize) async {
    return WalletRecords.fromJson(handleResponse(
      await request(
        endPoint,
        account: account,
        queryParams: {
          "offset": offset,
          "pageSize": pageSize,
        },
      ),
    ).data);
  }

  Future<account_user.User> getAccountProfile(Account? account) async {
    print('🔵 [getAccountProfile] ==========================================');
    print('🔵 [getAccountProfile] Starting request...');
    print(
        '🔵 [getAccountProfile] Account: ${account?.user.username}, ID: ${account?.user.id}');
    print('🔵 [getAccountProfile] JWT: ${account?.jwt.substring(0, 20)}...');

    try {
      final response = await request(ApiEndPoints.profile, account: account);
      print('🟢 [getAccountProfile] Raw response received');
      print('🟢 [getAccountProfile] Response type: ${response.runtimeType}');
      print(
          '🟢 [getAccountProfile] Response data: ${jsonEncode(response.data)}');

      final handledResponse = handleResponse(response);
      print(
          '🟢 [getAccountProfile] Handled response data: ${jsonEncode(handledResponse.data)}');

      final userData = handledResponse.data["user"];
      print('🟢 [getAccountProfile] User data: ${jsonEncode(userData)}');
      print('🟢 [getAccountProfile] User data type: ${userData.runtimeType}');

      if (userData == null) {
        print('🔴 [getAccountProfile] ERROR: userData is null!');
        throw Exception('User data is null in response');
      }

      // 检查关键字段
      print('🔍 [getAccountProfile] Checking fields:');
      print(
          '🔍 [getAccountProfile] id: ${userData['id']} (type: ${userData['id']?.runtimeType})');
      print(
          '🔍 [getAccountProfile] username: ${userData['username']} (type: ${userData['username']?.runtimeType})');
      print(
          '🔍 [getAccountProfile] email: ${userData['email']} (type: ${userData['email']?.runtimeType})');
      print(
          '🔍 [getAccountProfile] personalize_edit: ${userData['personalize_edit']} (type: ${userData['personalize_edit']?.runtimeType})');
      print(
          '🔍 [getAccountProfile] personalizeEdit: ${userData['personalizeEdit']} (type: ${userData['personalizeEdit']?.runtimeType})');

      print('🟢 [getAccountProfile] Parsing User.fromJson...');
      final user = account_user.User.fromJson(userData);
      print('🟢 [getAccountProfile] User parsed successfully');
      print('🟢 [getAccountProfile] User ID: ${user.id}');
      print(
          '🟢 [getAccountProfile] User personalizeEdit: ${user.personalizeEdit}');
      print(
          '🟢 [getAccountProfile] ==========================================');
      return user;
    } catch (e, stackTrace) {
      print(
          '🔴 [getAccountProfile] ==========================================');
      print('🔴 [getAccountProfile] ERROR: $e');
      print('🔴 [getAccountProfile] Stack trace: $stackTrace');
      print(
          '🔴 [getAccountProfile] ==========================================');
      rethrow;
    }
  }

  Future<account_user_info.UserInfo> getAccountUserInfo(
      Account? account) async {
    return account_user_info.UserInfo.fromJson(
        handleResponse(await request(ApiEndPoints.userInfo, account: account))
            .data["userInfo"]);
  }

  Future<void> saveShow(Account? account, int showId) async {
    handleResponse(await request(ApiEndPoints.saveShow,
        account: account, body: {"showId": showId}, method: HttpMethod.post));
  }

  Future<void> unsaveShow(Account? account, int showId) async {
    handleResponse(await request(ApiEndPoints.unsaveShow,
        account: account, body: {"showId": showId}, method: HttpMethod.post));
  }

  Future<Account> loginWithFirebase(UserCredential userCredential) async {
    final user = userCredential.user!;
    final idToken = await user.getIdToken();
    final requestBody = {
      "idToken": idToken,
      "profileMetaData": {"email": user.email, "phoneNumber": user.phoneNumber}
    };

    print('🔵 [API] ==========================================');
    print('🔵 [API] Request: POST ${ApiEndPoints.firebaseAuth}');
    print('🔵 [API] BaseURL: ${_dio.options.baseUrl}');
    print(
        '🔵 [API] Full URL: ${_dio.options.baseUrl}${ApiEndPoints.firebaseAuth}');
    print('🔵 [API] Headers: ${{
      "Content-Type": "application/json",
    }}');
    print('🔵 [API] Body: ${jsonEncode(requestBody)}');
    print('🔵 [API] ==========================================');

    try {
      final response = await request(
        ApiEndPoints.firebaseAuth,
        method: HttpMethod.post,
        body: requestBody,
      );

      print('🟢 [API] ==========================================');
      print('🟢 [API] Response Status: ${response.statusCode}');
      print('🟢 [API] Response Data: ${jsonEncode(response.data)}');
      print('🟢 [API] ==========================================');

      // 注意：后端返回的数据结构是 {head, body}
      // 实际数据在 body 中
      final responseBody = response.data['body'] ?? response.data;
      final apiResponse = ApiResponse(
        responseBody['status']?.toString() ?? '0',
        responseBody['data'],
        responseBody['statusInfo']?.toString(),
      );

      if (!apiResponse.isSuccess) {
        throw Exception(apiResponse.statusInfo ?? 'Unknown error');
      }

      final responseData = apiResponse.data;

      print('🟢 [API] Response parsed successfully');
      print('🟢 [API] Status: ${apiResponse.status}');
      print('🟢 [API] StatusInfo: ${apiResponse.statusInfo}');
      print('🟢 [API] Data: ${jsonEncode(responseData)}');

      // 解析后端返回的数据
      // 后端返回: {access_token, uniqid, userId, personalizeEdit}
      final userId =
          int.tryParse(responseData['userId']?.toString() ?? '0') ?? 0;
      final displayName = user.displayName ?? '';
      final email = user.email ?? '';

      // 解析 personalizeEdit，支持多种字段名
      final personalizeEditRaw = responseData['personalizeEdit'] ??
          responseData['personalize_edit'] ??
          responseData['personalizeedit'] ??
          '0';
      final personalizeEdit = int.tryParse(personalizeEditRaw.toString()) ?? 0;

      print('🟢 [API] Parsed personalizeEdit: $personalizeEdit');

      final userModel = account_user.User(
        userId,
        displayName,
        email,
        false,
        0,
        displayName,
        null,
        personalizeEdit: personalizeEdit,
      );

      final account = Account(
        userModel,
        responseData['access_token']?.toString() ?? '',
      );

      print('🟢 [API] Account created: ${account.user.username}');
      print('🟢 [API] JWT Token: ${account.jwt.substring(0, 20)}...');
      return account;
    } catch (e) {
      print('🔴 [API] ==========================================');
      print('🔴 [API] Request Failed: $e');
      if (e is DioException) {
        print('🔴 [API] Error Type: ${e.type}');
        print('🔴 [API] Error Message: ${e.message}');
        if (e.response != null) {
          print('🔴 [API] Error Response Status: ${e.response?.statusCode}');
          print('🔴 [API] Error Response Data: ${e.response?.data}');
        }
      }
      print('🔴 [API] ==========================================');
      rethrow;
    }
  }

  Future<void> deleteAccount(Account? account) async {
    handleResponse(await request(ApiEndPoints.deleteAccount,
        account: account, method: HttpMethod.post));
  }

  Future<void> markPersonalized(Account? account) async {
    handleResponse(await request(ApiEndPoints.markPersonalized,
        account: account, method: HttpMethod.post));
  }

  Future<String> uploadAvatar(Account? account, String filePath) async {
    LogD('ApiService: uploadAvatar called');
    LogD('ApiService: filePath = $filePath');
    LogD('ApiService: account username = ${account?.user.username}');
    LogD('ApiService: account id = ${account?.user.id}');

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });

    LogD('ApiService: formData created');
    LogD(
        'ApiService: request URL = ${_dio.options.baseUrl}${ApiEndPoints.uploadAvatar}');

    try {
      final response = await _dio.post(
        ApiEndPoints.uploadAvatar,
        data: formData,
        options: Options(headers: {
          if (account?.jwt != null) "Authorization": "Bearer ${account!.jwt}",
        }),
      );

      LogD('ApiService: response status = ${response.statusCode}');
      LogD('ApiService: response data = ${response.data}');

      final res = handleResponse(response.data);
      final avatarUrl = res.data['avatarUrl'];

      LogD('ApiService: avatarUrl = $avatarUrl');

      return avatarUrl;
    } catch (e) {
      LogE('ApiService: uploadAvatar error = $e');
      rethrow;
    }
  }

  Future<void> saveProfile(
      Account? account, Map<String, dynamic> profileData) async {
    handleResponse(await request(ApiEndPoints.profile,
        account: account, method: HttpMethod.post, body: profileData));
  }

  Future<bool> checkIsEarlyUser(Account? account) async {
    final response = await request(ApiEndPoints.isEarlyUser, account: account);
    final res = handleResponse(response);
    return res.data['isEarlyUser'] == true;
  }
}
