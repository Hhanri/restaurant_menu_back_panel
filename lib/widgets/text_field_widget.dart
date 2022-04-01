import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_menu_back_panel/utils/extensions.dart';

class TextFieldWidget extends StatelessWidget {
  final Function(String) onChange;
  final String value;
  final TextFieldParameters parameters;
  const TextFieldWidget({
    Key? key,
    required this.onChange,
    required this.value,
    required this.parameters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        initialValue: value,
        onChanged: (value) {
          onChange(value);
        },
        focusNode: FocusNode(),
        enableSuggestions: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        ),
        validator: (String? value) {
          String? res;
          res = parameters.validator(value);
          if (value == null || value.isEmpty) {
            res = "Empty field";
          }
          return res;
        },
        inputFormatters: parameters.formatters,
      ),
    );
  }
}

class TextFieldParameters {
  final Function(String?) validator;
  final List<TextInputFormatter> formatters;

  TextFieldParameters({
    required this.validator,
    required this.formatters
  });
}

class NormalTextFieldParameters extends TextFieldParameters{
  NormalTextFieldParameters() : super(
    validator: (String? value) {
      return null;
    },
    formatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[\\]'))
    ]
  );
}

class PriceTextFieldParameters extends TextFieldParameters{
  PriceTextFieldParameters() : super(
    validator: (String? value) {
      if (!value!.isNumeric()) {
        return "Only digits";
      }
    },
    formatters: [
      FilteringTextInputFormatter.digitsOnly,
    ]
  );
}

class HexTextFieldParameters extends TextFieldParameters{
  HexTextFieldParameters() : super(
    validator: (String? value) {
      if (!value!.isARGB()) {
        return "Must be ARGB format";
      }
    },
    formatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[A-F 0-9]')),
      LengthLimitingTextInputFormatter(8)
    ]
  );
}