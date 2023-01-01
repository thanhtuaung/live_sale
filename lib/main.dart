import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:live_sale/setting_page.dart';
import 'package:wakelock/wakelock.dart';

import 'bloc/fetch_database/fetch_database_cubit.dart';
import 'bloc/login/cubit/login_cubit.dart';
import 'bloc/product_fetch/product_fetch_cubit.dart';
import 'bloc/session_check/session_check_cubit.dart';
import 'home_page.dart';

List<Device> connectedDeviceList = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(const MyApp());
}

const String settingRoute = '/setting';
const String home = '/';
const String deviceListRoute = '/device_list';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchDatabaseCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Sale Screen',
        theme: ThemeData(primarySwatch: Colors.purple),
        onGenerateRoute: routeGenerate,
        initialRoute: home,
        // home: const MyHomePage(title: 'Mari gold Live'),
      ),
    );
  }

  Route? routeGenerate(RouteSettings settings) {
    switch (settings.name) {
      case settingRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SessionCheckCubit()),
              BlocProvider(create: (context) => LoginCubit()),
            ],
            child: const SettingPage(),
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => SessionCheckCubit()),
              BlocProvider(create: (context) => LoginCubit()),
              BlocProvider(create: (context) => ProductFetchCubit()),
            ],
            child: const MyHomePage(
              title: 'Marigold Live Sale',
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: const NoPage(),
          ),
        );
    }
  }
}

class NoPage extends StatelessWidget {
  const NoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found page')),
      body: const Center(
        child: Text('Not Found Page'),
      ),
    );
  }
}
