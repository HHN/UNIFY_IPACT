import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../data/local/constants.dart';
import 'common_utils.dart';
import 'dimens.dart';

class TextFieldView extends StatelessWidget {
  const TextFieldView(
      {super.key,
      this.controller,
      this.inputType,
      this.maxLines,
      this.isObscure,
      this.isEnable,
      this.onTextChange,
      this.onSaved,
      this.hint,
      this.validator,
      this.suffix,
      this.errorMaxLines,
      this.helperText,
      this.helperMaxLines});

  final TextEditingController? controller;
  final TextInputType? inputType;
  final int? maxLines;
  final int? errorMaxLines;
  final int? helperMaxLines;
  final bool? isObscure;
  final bool? isEnable;
  final Function(String)? onTextChange;
  // final Function(String)? onSaved;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String? hint;
  final String? helperText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines ?? 1,
        cursorColor: context.theme.primaryColor,
        obscureText: isObscure ?? false,
        enabled: isEnable,
        style: context.textTheme.bodyMedium!.copyWith(color: context.theme.primaryColor),
        onChanged: onTextChange,
        validator: validator,
        onSaved: onSaved,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            filled: true,
            fillColor: context.theme.primaryColorLight,
            hoverColor: context.theme.primaryColorDark,
            isDense: true,
            hintText: hint,
            hintStyle: context.textTheme.bodyMedium?.copyWith(color: context.theme.disabledColor, fontSize: Dimens.fontSizeSmall, height: 1),
            errorMaxLines: errorMaxLines ?? 1,
            errorStyle: context.textTheme.bodyMedium?.copyWith(
                color: Colors.redAccent,
                fontSize: Dimens.fontSizeSmall,
                height: 1),
            helperText: helperText,
            helperMaxLines: helperMaxLines ?? 10,
            helperStyle: context.textTheme.bodyMedium?.copyWith(color: context.theme.disabledColor, fontSize: Dimens.fontSizeSmall, height: 1),
            contentPadding: const EdgeInsets.all(Dimens.paddingLarge),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.cornerRadiusMid)),
              borderSide: BorderSide(
                  width: 1, color: context.theme.secondaryHeaderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.cornerRadiusMid)),
              borderSide: BorderSide(color: context.theme.primaryColorDark),
            ),
            suffixIcon: suffix));
  }
}

class TextFieldNoBorder extends StatelessWidget {
  const TextFieldNoBorder(
      {super.key,
      this.controller,
      this.inputType,
      this.onTextChange,
      this.hint});

  final TextEditingController? controller;
  final TextInputType? inputType;
  final Function(String)? onTextChange;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: inputType,
        cursorColor: context.theme.primaryColorDark,
        style: context.textTheme.bodyMedium,
        onChanged: onTextChange,
        decoration: InputDecoration(
            filled: false,
            isDense: true,
            hintText: hint,
            contentPadding: const EdgeInsets.all(Dimens.paddingMid),
            border: InputBorder.none));
  }
}

class TextFieldPinCode extends StatelessWidget {
  TextFieldPinCode({super.key, this.controller, this.validator});

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final errorController = StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    final size = (Get.width - 100) / LimitConst.codeLength;
    return PinCodeTextField(
      length: LimitConst.codeLength,
      obscureText: true,
      animationType: AnimationType.slide,
      keyboardType: TextInputType.number,
      validator: validator,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        borderWidth: 0.5,
        fieldHeight: size,
        fieldWidth: size,
        activeColor: context.theme.focusColor,
        activeFillColor: Colors.transparent,
        inactiveColor: context.theme.disabledColor,
        inactiveFillColor: Colors.transparent,
        selectedColor: context.theme.focusColor,
        selectedFillColor: Colors.transparent,
        errorBorderColor: context.theme.colorScheme.error,
      ),
      cursorColor: context.theme.focusColor,
      animationDuration: const Duration(milliseconds: 100),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      hintCharacter: "*",
      textStyle: Get.textTheme.bodyMedium!.copyWith(color: context.theme.primaryColor),
      errorAnimationController: errorController,
      controller: controller,
      onCompleted: (value) {},
      onChanged: (value) {},
      beforeTextPaste: (text) => false,
      appContext: Get.context!,
    );
  }
}

class TextFieldSearch extends StatelessWidget {
  const TextFieldSearch(
      {super.key,
      this.controller,
      this.inputType,
      this.isEnable,
      this.onTextChange});

  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool? isEnable;
  final Function(String)? onTextChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        cursorColor: context.theme.primaryColorDark,
        enabled: isEnable,
        cursorErrorColor: Colors.redAccent,
        style: context.textTheme.bodyMedium,
        onChanged: onTextChange,
        decoration: InputDecoration(
            filled: true,
            focusColor: context.theme.primaryColorDark,
            fillColor: context.theme.primaryColorLight,
            // isDense: true,
            hintText: "Search".tr,
            contentPadding: const EdgeInsets.all(Dimens.paddingMid),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.cornerRadiusMid)),
                borderSide: BorderSide(color: context.theme.primaryColorDark)),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.cornerRadiusMid)),
              borderSide: BorderSide(color: context.theme.primaryColorDark),
            ),
            prefixIcon: Icon(Icons.search,color: context.theme.primaryColorDark,)));
  }
}

class TextFieldValidator {
  static String? emailValidator(String? text) {
    if (!GetUtils.isEmail((text ?? '').trim())) {
      return "Input a valid Email".tr;
    }
    return null;
  }

  static String? emptyValidator(String? text, {String? message}) {
    if (text == null || text.trim().isEmpty) {
      return message ?? "Field is required".tr;
    }
    return null;
  }

  static String? passwordValidator(String? text, {String? message}) {
    if (!isValidPassword(text ?? '')) {
      return "Password_invalid_message"
          .trParams({"count": LimitConst.passwordLength.toString()});
    }
    return null;
  }

  static String? confirmPasswordValidator(String? text, {String? password}) {
    if (password != text) {
      return "Password and confirm password not matched".tr;
    }
    return null;
  }

  static String? confirmPinValidator(String? confirmPin, {String? pin}) {
    if (pin != confirmPin) {
      return "PIN and confirm PIN not matched".tr;
    }
    return null;
  }

  static String? codeValidator(String? text) {
    if (text == null || text.length < LimitConst.codeLength) {
      return "code_invalid_message"
          .trParams({"count": LimitConst.codeLength.toString()});
    }
    return null;
  }

  static String? usernameValidator(String? text) {
    if (text == null ||
        text.length < LimitConst.usernameMinLength ||
        text.length > LimitConst.usernameMaxLength) {
      return "username_invalid_message".trArgs([
        LimitConst.usernameMinLength.toString(),
        LimitConst.usernameMaxLength.toString()
      ]);
    }
    return null;
  }
}
