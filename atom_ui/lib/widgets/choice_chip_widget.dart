import 'package:atom_ui/on_clicked_listener.dart';
import 'package:flutter/material.dart';

class MultiChoiceChipWidget extends StatefulWidget {
  final List<String> nameList;
  final OnClickCallBack<List<String>> onCheckChangeListener;
  late int? defaultChecked;
  late OnClickCallBack<String>? lastModifiedItemListener;

  MultiChoiceChipWidget(this.nameList, this.onCheckChangeListener,
      {Key? key, this.defaultChecked, this.lastModifiedItemListener})
      : super(key: key);

  @override
  _MultiChoiceChipWidgetState createState() => _MultiChoiceChipWidgetState();
}

class _MultiChoiceChipWidgetState extends State<MultiChoiceChipWidget> {
  late List<String> selectedChoices = [];
  late int defaultChecked = -1;

  @override
  void initState() {
    super.initState();
    if (widget.defaultChecked != null && widget.defaultChecked! >= 0) {
      defaultChecked = widget.defaultChecked!;
      selectedChoices.add(widget.nameList[defaultChecked]);
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (widget.lastModifiedItemListener != null) {
          widget.lastModifiedItemListener
              ?.call(widget.nameList[defaultChecked]);
        }
        widget.onCheckChangeListener.call(selectedChoices);
      });
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
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            if (widget.lastModifiedItemListener != null) {
              widget.lastModifiedItemListener?.call(item);
            }
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
            });
            widget.onCheckChangeListener.call(selectedChoices);
          },
        ),
      ));
    }
    return choices;
  }
}
