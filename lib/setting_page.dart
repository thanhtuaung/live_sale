import 'package:atom_ui/buttonsheets/single_choice_button_sheet.dart';
import 'package:atom_ui/dialogs/alert_dialog.dart';
import 'package:atom_ui/dialogs/show_circular_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_sale/sh_utils.dart';
import 'package:live_sale/share_preference/sh_keys.dart';
import 'package:live_sale/src/constant_strings.dart';
import 'package:live_sale/widgets/show_host_edit_bottom_sheet.dart';

import 'bloc/fetch_database/fetch_database_cubit.dart';
import 'bloc/login/cubit/login_cubit.dart';
import 'bloc/session_check/session_check_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? host;
  String? username;
  String? database;
  String? password;
  bool canBeGoHome = true;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  late LoginCubit _loginCubit;
  late ShowCircularProgressDialog showCircularProgressDialog;

  @override
  void initState() {
    _loginCubit = context.read<LoginCubit>();
    context.read<SessionCheckCubit>().checkSession();
    getDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => canBeGoHome,
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
          children: [
            const SizedBox(height: 8.0),
            _titleWidget(
                Text('Host Settings', style: theme.textTheme.titleLarge)),
            BlocBuilder<SessionCheckCubit, SessionCheckState>(
              builder: (context, state) {
                if (state is SessionCheckSuccess) {
                  host = state.wifiName;
                }
                return ListTile(
                    title: const Text('host name'),
                    trailing: Text(host ?? ''),
                    onTap: () async {
                      String? hostName = await showHostNameInputBottomSheet(
                          context,
                          cancelable: true,
                          hostname: host ?? '');
                      if (hostName != null) {
                        context.read<SessionCheckCubit>().giveSuccess(hostName);
                      }
                    });
              },
            ),
            // ListTile(
            //     title: const Text('host name'),
            //     trailing: Text(host ?? ''),
            //     onTap: () => showHostNameInputBottomSheet(context,
            //         cancelable: true, hostname: host ?? '')),
            const Divider(thickness: 1, color: Colors.grey),
            _titleWidget(Text('Odoo', style: theme.textTheme.titleLarge)),
            _databaseSelector(context),
            BlocListener<LoginCubit, LoginState>(
              listener: (context, state) {
                print(state);
                if (state is LoginFail) {
                  canBeGoHome = false;
                }
                if (state is LoginSuccess) {
                  canBeGoHome = true;
                }
              },
              child: ListTile(
                title: const Text('Username'),
                trailing: Text(username ?? ''),
                onTap: () => _showOdooLoginInput(),
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _titleWidget(Widget widget) => Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8, top: 8.0),
      child: widget);

  void _showOdooLoginInput() {
    String? _name;
    String? _password;
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      builder: (context) {
        return Form(
          key: _loginFormKey,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) => _name = value,
                    onSaved: (newValue) => _name = newValue,
                    validator: (value) =>
                        (value?.isEmpty ?? false) ? 'Required Field' : null,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                      focusColor: Colors.black,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (value) => _password = value,
                    onSaved: (newValue) => _password = newValue ?? '',
                    validator: (value) =>
                        (value?.isEmpty ?? false) ? 'Required Field' : null,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      focusColor: Colors.black,
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('cancel')),
                      TextButton(
                          onPressed: () async {
                            if (database == null) {
                              Navigator.pop(context);
                              showSnackBar(
                                context,
                                'Firstly, Select Database',
                                isError: true,
                              );
                              return;
                            }
                            if (_loginFormKey.currentState?.validate() ??
                                false) {
                              _loginCubit.login(
                                  _name ?? '', _password ?? '', database!);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('confirm')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _databaseSelector(BuildContext context) {
    return StatefulBuilder(builder: (context, innerState) {
      return BlocListener<FetchDatabaseCubit, FetchDatabaseState>(
        listener: (context, state) async {
          if (state is FetchDatabaseFetching) {
            showCircularProgressDialog = ShowCircularProgressDialog(context);
          }

          if (state is FetchDatabaseFail) {
            closeDialog(context);
            showSnackBar(context, state.apiError.message, isError: true);
          }

          if (state is FetchDatabaseSuccess) {
            closeDialog(context);
            SingleChoiceBottomSheet singleChoiceBottomSheet =
                SingleChoiceBottomSheet<String>(
              initValue: database,
              asString: (item) => item,
              items: state.databaseList,
            );
            String? db = await singleChoiceBottomSheet.showSheetDialog(context);
            database = db ?? database;
            innerState(() {});
          }
        },
        child: ListTile(
          title: const Text('Database'),
          trailing: Text(database ?? ''),
          onTap: () => context
              .read<FetchDatabaseCubit>()
              .fetchDatabase(baseUrl: ConstantStrings.initServerUrl),
        ),
      );
    });
  }

  void closeDialog(BuildContext context) {
    if (showCircularProgressDialog.isShowingDialog()) {
      Navigator.pop(context);
    }
  }

  Future<void> _showSuccessFailDialog(
      {required BuildContext context,
      required String message,
      VoidCallback? onClick,
      required AlertDialogType type}) async {
    return showDialog(
      context: context,
      builder: (builder) => CustomAlertDialog(
        onPressed: onClick,
        dialogType: type,
        title: ConstantStrings.loginProcess,
        content: message,
      ),
    );
  }

  Future<void> getDatabase() async {
    host = await SharePrefUtils().getString(ShKeys.wifiKey);
    database = await SharePrefUtils().getString(ShKeys.database);
    database ??= ConstantStrings.defaultDatabase;
    username = await SharePrefUtils().getString(ShKeys.currentUser);
    final password = await SharePrefUtils().getString(ShKeys.password);
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      setState(() {});
    });
  }
}

const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);

void showSnackBar(BuildContext context, String content,
    {bool isError = false, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: duration ?? _snackBarDisplayDuration,
      backgroundColor: isError ? Colors.red : Colors.green,
    ),
  );
}

// child: InkWell(
//   onTap: () {
//
//   },
//   // child: Column(
//   //   mainAxisAlignment: MainAxisAlignment.start,
//   //   mainAxisSize: MainAxisSize.min,
//   //   crossAxisAlignment: CrossAxisAlignment.start,
//   //   children: [
//   //     Text(ConstantStrings.database,
//   //         style: Theme.of(context)
//   //             .textTheme
//   //             .bodySmall
//   //             ?.copyWith(color: Colors.black54)),
//   //     if (database == null) const SizedBox(height: 20),
//   //     if (database != null)
//   //       SizedBox(
//   //         height: 20,
//   //         child: Text(
//   //           database ?? '',
//   //           style: const TextStyle(
//   //             color: Colors.black,
//   //           ),
//   //         ),
//   //       ),
//   //     const SizedBox(
//   //       width: 250,
//   //       child: Divider(
//   //         thickness: 1,
//   //         color: Colors.black38,
//   //       ),
//   //     ),
//   //     if (database == null)
//   //       const Text(
//   //         ConstantStrings.fieldRequired,
//   //         style: TextStyle(color: Colors.red),
//   //       ),
//   //   ],
//   // ),
// ),
