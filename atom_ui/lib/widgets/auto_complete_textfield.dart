import 'package:atom_ui/widgets/responsive.dart';
import 'package:atom_ui/widgets/text_field_with_round_corner.dart';
import 'package:flutter/material.dart';

class AutoCompleteTextField extends StatelessWidget {
  AutoCompleteTextField({Key? key}) : super(key: key);

  List<String> hintList = [
    'Coconut',
    'Orange',
    'Apple',
    'Pineapple',
    'Strawberry',
    'Lady\'s-finger',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.currentWidth(context) * 0.8,
      child: Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return hintList
              .where((location) => location
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()))
              .toList();
        },
        onSelected: (value) => print(value),
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          print(options.length);
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: Responsive.currentWidth(context) * 0.8,
                height: options.length > 4 ? 200 : options.length * 50,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return ListTile(
                      onTap: () => onSelected(option),
                      title: Text(option,
                          style: const TextStyle(color: Colors.white)),
                    );
                  },
                ),
              ),
            ),
          );
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          return TextFieldWithRoundCorner(
            textEditingController: fieldTextEditingController,
            focusNode: fieldFocusNode,
            // style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
