import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobisen_app/configs.dart';
import 'package:mobisen_app/constants.dart';
import 'package:mobisen_app/net/model/account.dart';
import 'package:mobisen_app/net/model/user.dart';
import 'package:mobisen_app/provider/account_provider.dart';
import 'package:mobisen_app/services/zego_im_service.dart';
import 'package:mobisen_app/widget/custom_dialog.dart';
import 'package:provider/provider.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  String _result = "Tap button to test HTTP";

  Future<void> _testHttp() async {
    setState(() {
      _result = "Testing...";
    });

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      final response = await dio.get("http://192.168.1.241:3000/api/test");

      setState(() {
        _result = "Success: ${response.statusCode}\n${response.data}";
      });
    } catch (e) {
      setState(() {
        _result = "Error: ${e.toString()}";
      });
    }
  }

  Future<void> _testMobi() async {
    setState(() {
      _result = "Testing mobi...";
    });

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      final response = await dio.get("http://192.168.1.241:3000/api/mobi/test");

      setState(() {
        _result = "Mobi Success: ${response.statusCode}\n${response.data}";
      });
    } catch (e) {
      setState(() {
        _result = "Mobi Error: ${e.toString()}";
      });
    }
  }

  Future<void> _mockLoginData() async {
    // 根据手机品牌生成固定ID
    String uniqueId;
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final brand = androidInfo.brand?.toLowerCase() ?? '';
      final model = androidInfo.model?.toLowerCase() ?? '';

      // 判断品牌或机型是否包含 "mi"
      if (brand.contains('mi') || model.contains('mi')) {
        uniqueId = 'xiaomi12345';
        print('检测到小米设备，使用固定ID: $uniqueId');
      } else {
        uniqueId = 'others12345';
        print('检测到非小米设备，使用固定ID: $uniqueId');
      }
    } else {
      uniqueId = 'ios12345';
      print('检测到iOS设备，使用固定ID: $uniqueId');
    }

    final mockUser = User(
      999999,
      uniqueId,
      '$uniqueId@test.com',
      false,
      1000,
      'Test User $uniqueId',
      null,
    );

    final mockAccount = Account(mockUser, 'mock_jwt_token_for_development');

    context.read<AccountProvider>().setAccount(mockAccount);

    // 登录 ZIM（用于即时通讯）
    try {
      await ZegoIMService().login(
        mockUser.username,
        mockUser.displayName ?? mockUser.username,
        '',
      );
      print('ZIM 登录成功: ${mockUser.username}');
    } catch (e) {
      print('ZIM 登录失败: $e');
    }

    // 直接退出所有页面并跳转到首页
    Navigator.of(context).pushNamedAndRemoveUntil(
      RoutePaths.home,
      (route) => false,
    );

    setState(() {
      _result =
          "Mock login success!\nUser: ${mockUser.username}\nCoins: ${mockUser.coins}";
    });
  }

  Future<void> _mockPersonalizedData() async {
    // 根据手机品牌生成固定ID
    String uniqueId;
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final brand = androidInfo.brand?.toLowerCase() ?? '';
      final model = androidInfo.model?.toLowerCase() ?? '';

      // 判断品牌或机型是否包含 "mi"
      if (brand.contains('mi') || model.contains('mi')) {
        uniqueId = 'xiaomi12345';
        print('检测到小米设备，使用固定ID: $uniqueId');
      } else {
        uniqueId = 'others12345';
        print('检测到非小米设备，使用固定ID: $uniqueId');
      }
    } else {
      uniqueId = 'ios12345';
      print('检测到iOS设备，使用固定ID: $uniqueId');
    }

    final mockUser = User(
      999999, // 固定数字ID
      uniqueId, // 固定用户名
      '$uniqueId@test.com',
      false,
      1000,
      'Test User $uniqueId',
      null,
      personalizeEdit: 1,
    );

    final mockAccount = Account(mockUser, 'mock_jwt_token_for_development');

    context.read<AccountProvider>().setAccount(mockAccount);

    // 登录 ZIM（用于即时通讯）
    try {
      print('正在登录 ZIM...');
      print('AppID: ${ZegoConfig.appID}');
      print('UserID: $uniqueId');

      await ZegoIMService().login(
        uniqueId,
        mockUser.displayName ?? uniqueId,
        '', // 测试环境 token 为空
      );
      print('ZIM 登录成功: $uniqueId');
    } catch (e) {
      print('ZIM 登录失败: $e');
      print('错误码 6000003 表示 AppID 无效，请检查:');
      print('1. ZEGO 控制台中项目 630742642 是否已启用 ZIM 服务');
      print('2. AppSign 是否正确配置');
      print('3. 项目是否已完成审核');
    }

    // 直接退出所有页面并跳转到首页
    Navigator.of(context).pushNamedAndRemoveUntil(
      RoutePaths.home,
      (route) => false,
    );

    setState(() {
      _result =
          "Mock personalized login success!\nUser: ${mockUser.username}\npersonalizeEdit: 1";
    });
  }

  void _clearPersonalizedData() {
    final account = context.read<AccountProvider>().account;
    if (account != null) {
      account.user.personalizeEdit = null;
      context.read<AccountProvider>().setAccount(account);
      setState(() {
        _result = "Personalize edit cleared!\nLogin state preserved.";
      });
    } else {
      setState(() {
        _result = "No login data to modify.";
      });
    }
  }

  void _clearLoginData() {
    context.read<AccountProvider>().setAccount(null);

    setState(() {
      _result = "Login data cleared!";
    });
  }

  Widget _buildGroup({required String title, required List<Widget> buttons}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: buttons,
        ),
      ],
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroup(
              title: "跳转页面",
              buttons: [
                _buildButton(
                  text: "Go to Login",
                  onPressed: () {
                    Navigator.of(context).pushNamed(RoutePaths.login);
                  },
                ),
                _buildButton(
                  text: "Go to PersonalizeEdit",
                  onPressed: () {
                    Navigator.of(context).pushNamed(RoutePaths.personalizeEdit);
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildGroup(
              title: "弹窗",
              buttons: [
                _buildButton(
                  text: "Test CustomDialog",
                  onPressed: () {
                    CustomDialog.show(
                      context,
                      title: "Welcome to Ume",
                      description:
                          "By continuing, you agree to our Terms of Service and Privacy Policy.",
                      onCancel: () {},
                      onConfirm: () {},
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildGroup(
              title: "测试 HTTP",
              buttons: [
                _buildButton(
                  text: "Test HTTP GET",
                  onPressed: _testHttp,
                ),
                _buildButton(
                  text: "Test mobi",
                  onPressed: _testMobi,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildGroup(
              title: "Mock 数据",
              buttons: [
                _buildButton(
                  text: "Mock 登录数据",
                  onPressed: _mockLoginData,
                ),
                _buildButton(
                  text: "Mock 资料已编辑",
                  onPressed: _mockPersonalizedData,
                ),
                _buildButton(
                  text: "清除资料已编辑",
                  onPressed: _clearPersonalizedData,
                ),
                _buildButton(
                  text: "清除登录数据",
                  onPressed: _clearLoginData,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _result,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
