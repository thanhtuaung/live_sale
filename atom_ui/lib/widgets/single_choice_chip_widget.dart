import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class SingleChoiceChipWidget extends StatefulWidget {
  final List<String> nameList;
  final OnClickCallBack<String> onCheckChangeListener;
  late int? defaultChecked;

  SingleChoiceChipWidget(this.nameList, this.onCheckChangeListener,
      {Key? key, this.defaultChecked})
      : super(key: key);

  @override
  _SingleChoiceChipWidgetState createState() => _SingleChoiceChipWidgetState();
}

class _SingleChoiceChipWidgetState extends State<SingleChoiceChipWidget> {
  late String selectedChoices = '';
  late int defaultChecked = -1;

  @override
  void initState() {
    super.initState();
    if (widget.defaultChecked != null && widget.defaultChecked! >= 0) {
      defaultChecked = widget.defaultChecked!;
      selectedChoices = widget.nameList[defaultChecked];
      WidgetsBinding.instance?.addPostFrameCallback(
          (_) => widget.onCheckChangeListener.call(selectedChoices));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: _buildHeaderChoice()),
      ),
    );
  }

  _buildHeaderChoice() {
    List<Widget> choices = [];
    for (int i = 0; i < widget.nameList.length; i++) {
      String item = widget.nameList[i];
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          selectedColor: Colors.redAccent,
          backgroundColor: Colors.green,
          label: Container(
            width: 75,
            height: 40,
            child: Center(
                child: Text(item, style: TextStyle(color: Colors.white))),
          ),
          selected: selectedChoices == item,
          onSelected: (selected) {
            setState(() {
              selectedChoices = item;
              // widget.onSelectionChanged(selectedChoices);
            });
            widget.onCheckChangeListener.call(selectedChoices);
          },
        ),
      ));
    }
    return choices;
  }
}
