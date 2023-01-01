import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/session_check/session_check_cubit.dart';

Future<String?> showHostNameInputBottomSheet(BuildContext context,
    {String hostname = '', bool cancelable = false}) {
  GlobalKey<FormState> hostNameInputFormKey = GlobalKey<FormState>();
  return showModalBottomSheet<String>(
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => cancelable,
        child: Form(
          key: hostNameInputFormKey,
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
                    'Live Sale အခန်းနာမည်',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: hostname,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Live Sale အခန်းနာမည် ထည့်ပါ';
                      }
                      return null;
                    },
                    onChanged: (value) => hostname = value,
                    onSaved: (newValue) {
                      hostname = newValue ?? '';
                    },
                    decoration: const InputDecoration(
                      hintText: 'Live Sale အခန်းနာမည်',
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
                  TextButton(
                      onPressed: () async {
                        if (hostNameInputFormKey.currentState?.validate() ??
                            false) {
                          Navigator.pop(context, hostname);
                        }
                      },
                      child: const Text('confirm')),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
