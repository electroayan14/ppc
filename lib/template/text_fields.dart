import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextFields extends StatelessWidget {
  const TextFields(
      {required this.hintText,
      required this.fieldIcon,
      required this.textController,
      this.keyboardType = TextInputType.text,
      //required this.onChanged,
      super.key});
  final TextInputType keyboardType;
  final String hintText;
  final Widget fieldIcon;
  final TextEditingController textController;
  //final void Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: textController,
      //onChanged: onChanged,
      cursorHeight: 25,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        constraints: BoxConstraints.tight(
          const Size.fromHeight(50),
        ),
        suffixIcon: fieldIcon,
        suffixIconColor: const Color.fromRGBO(224, 171, 67, 1),
        hintText: hintText,
        contentPadding: const EdgeInsets.only(
          top: 3,
          left: 15,
        ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromRGBO(102, 102, 102, 1),
            ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color.fromRGBO(39, 39, 39, 1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(224, 171, 67, 1),
          ),
        ),
      ),
    );
  }
}
