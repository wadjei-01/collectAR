import 'package:flutter/material.dart';

class DropDownPlusOne extends StatefulWidget {
  DropDownPlusOne({Key? key, required this.value}) : super(key: key);
  bool value;

  @override
  State<DropDownPlusOne> createState() => _DropDownPlusOneState();
}

class _DropDownPlusOneState extends State<DropDownPlusOne> {
  @override
  Widget build(BuildContext context) {
    return widget.value
        ? Container(
            child: Text('Email is Already in use'),
          )
        : Container();
  }
}
