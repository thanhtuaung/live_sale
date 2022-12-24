import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_sale/home_page.dart';
import 'package:live_sale/sh_utils.dart';

import 'bloc/session_check/session_check_cubit.dart';

class WifiLogin extends StatefulWidget {
  const WifiLogin({Key? key});

  @override
  State<WifiLogin> createState() => _WifiLoginState();
}

class _WifiLoginState extends State<WifiLogin> {
  String? _networkname;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SharePrefUtils _sharePrefUtils = SharePrefUtils();
  final String wifi_name = 'wifi_name';

  @override
  void initState() {
    context.read<SessionCheckCubit>().checkSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCheckCubit, SessionCheckState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SessionCheckSuccess) {
            print('going to home page');
            Future.delayed(
              Duration.zero,
              () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        title: "My home page",
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
            );
          }
          return Stack(children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 350,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required user name';
                              }
                              return null;
                            },
                            onChanged: (value) => _networkname = value,
                            onSaved: (newValue) {
                              _networkname = newValue ?? '';
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.wifi),
                              labelText: "Wifi Name",
                            ),
                          ),
                          ElevatedButton(
                            child: Text('Login'),
                            onPressed: () async {
                              _sharePrefUtils.saveString(
                                  wifi_name, _networkname!);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyHomePage(
                                      title: "My home page",
                                    ),
                                  ),
                                  (Route<dynamic> route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: const Size(150, 44),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        });
  }
}
