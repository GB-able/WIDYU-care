import 'package:care/providers/user_provider.dart';
import 'package:care/routes/custom_router.dart';
import 'package:care/styles/theme.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_KEY'],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: MaterialApp.router(
          title: '위듀 케어',
          theme: MyTheme.myTheme,
          routerConfig: CustomRouter.router,
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '위듀 케어 앱',
          style: MyTypo.body1,
        ),
      ),
    );
  }
}
