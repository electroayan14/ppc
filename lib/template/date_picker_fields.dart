import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

class DatePickerTextFields extends StatefulWidget {
  const DatePickerTextFields(
      {required this.hintText,
      this.firstDate,
      this.lastDate,
      required this.fieldIcon,
      required this.onChanged,
      required this.selectedDateTime,
      required this.mode,
      super.key});
  final String hintText;
  final Widget fieldIcon;
  final void Function(DateTime?) onChanged;
  final DateTime? firstDate, lastDate;
  final DateTime? selectedDateTime;
  final DateTimeFieldPickerMode mode;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerTextFieldsState();
  }
}

class _DatePickerTextFieldsState extends State<DatePickerTextFields> {
  @override
  Widget build(BuildContext context) {
    DateFormat outputDateFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputTimeFormat = DateFormat(DateFormat.HOUR_MINUTE_TZ);
    DateFormat format = widget.mode == DateTimeFieldPickerMode.date
        ? outputDateFormat
        : outputTimeFormat;
    return DateTimeField(
      onChanged: widget.onChanged,
      mode: widget.mode,
      dateFormat: format,
      value: widget.selectedDateTime,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        constraints: BoxConstraints.tight(
          const Size.fromHeight(50),
        ),
        suffixIcon: widget.fieldIcon,
        suffixIconColor: const Color.fromRGBO(224, 171, 67, 1),
        labelText: widget.hintText,
        contentPadding: const EdgeInsets.only(
          top: 0.1,
          bottom: 0.1,
          left: 15,
        ),
        labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromRGBO(102, 102, 102, 1),
            ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(39, 39, 39, 1),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(224, 171, 67, 1),
          ),
        ),
      ),
      firstDate: (widget.firstDate != null) ? widget.firstDate : DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      hideDefaultSuffixIcon: true,
    );
  }
}
