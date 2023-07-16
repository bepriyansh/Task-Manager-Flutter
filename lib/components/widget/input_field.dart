import 'package:flutter/material.dart';
import 'package:taskmanager/components/theme.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            // width: 190,
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                border: Border.all(
                  color: greyColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  readOnly: widget == null ? false : true,
                  autofocus: false,
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                )),
                widget == null
                    ? const SizedBox(
                        width: 14,
                      )
                    : Container(child: widget!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
