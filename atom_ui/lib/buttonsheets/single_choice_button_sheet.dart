import 'package:atom_ui/src/ConstantDimens.dart';
import 'package:flutter/material.dart';

typedef BottomSelectItemAsString<T> = String Function(T? item);
typedef ValueChangedCallBack<T> = void Function(T? item);

@immutable
class SingleChoiceBottomSheet<T> {
  final BottomSelectItemAsString asString;
  final List<T> items;
  final T? initValue;
  T? _selectedValue;
  final Color? textColor;
  final String? title;
  final bool _showSearch;
  String? hintText;
  double? sheetHeight;

  SingleChoiceBottomSheet({
    Key? key,
    this.title,
    this.initValue,
    required this.asString,
    required this.items,
    bool? showSearch,
    this.textColor,
    this.hintText,
    this.sheetHeight,
  })  : _selectedValue = initValue,
        _showSearch = showSearch ?? false;

  Future<T?> showSheetDialog(BuildContext context) async {
    // final double height = Responsive.currentHeight(context);
    double? height = items.length < 8
        ? (items.length * 60) + ((title != null) ? 60 : 0)
        : null;
    List<T> tempItems = items;

    return await showModalBottomSheet<T>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      isScrollControlled: true,
      // constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.7),
      builder: (context) {
        return Container(
          // height: 600,
          height: sheetHeight ?? height,
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: ConstantDimens.padding),
                if (title != null)
                  Text(title!, style: Theme.of(context).textTheme.titleLarge),
                if (_showSearch)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        hintText: hintText,
                      ),
                      onChanged: (value) {
                        tempItems = items
                            .where((element) => asString(element)
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                        setState(() {});
                      },
                    ),
                  ),
                if (_showSearch) const SizedBox(height: 20),
                Expanded(
                    child: ListView.builder(
                  itemCount: tempItems.length,
                  // itemCount: items.length,
                  itemBuilder: (context, index) {
                    return RadioListTile<T>(
                        title: Text(
                          asString(tempItems[index]),
                          style: TextStyle(color: textColor),
                        ),
                        value: tempItems[index],
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState.call(
                            () {
                              _selectedValue = value;
                            },
                          );
                          Future.delayed(const Duration(milliseconds: 200))
                              .then((value) {
                            Navigator.pop<T>(context, tempItems[index]);
                          });
                        });
                  },
                )),
              ],
            );
          }),
        );
      },
    );
  }
}
