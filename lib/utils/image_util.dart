import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unify_secret/utils/spacers.dart';
import '../ui/helper/app_widgets.dart';
import 'button_util.dart';
import 'common_utils.dart';
import 'common_widgets.dart';
import 'dimens.dart';

// _getColorFilter(Color? color) => color == null ? null : ColorFilter.mode(color, BlendMode.srcIn);

class ImageAsset extends StatelessWidget {
  const ImageAsset({super.key, this.imagePath, this.width, this.height, this.color});

  final String? imagePath;
  final BoxFit? boxFit = BoxFit.cover;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return (imagePath != null && imagePath!.isNotEmpty)
        ? Image.asset(imagePath!, fit: boxFit!, width: width, height: height, color: color)
        : vSpacer0();
  }
}

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({super.key, this.imagePath, this.width, this.height, this.bgColor, this.padding});

  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit boxFit = BoxFit.cover;
  final Color? bgColor;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: bgColor ?? Colors.grey.withOpacity(0.25),
      padding: EdgeInsets.all(padding ?? 0),
      child: imagePath != null && imagePath!.isNotEmpty
          ? Image.network(imagePath!,
              fit: boxFit,
              loadingBuilder: (context, child, loadingProgress) => loadingProgress == null ? child :const AppLogo(),
              errorBuilder: (context, error, stackTrace) => const AppLogo())
          : const AppLogo(),
    );
  }
}

void showImageChooser(BuildContext context, Function(File, bool) onChoose, {bool isCamera = true, bool isGallery = true, bool isCrop = true}) {
  hideKeyboard(context: context);
  choosePhotoModalBottomSheet(
      onTakePic: isCamera
          ? () {
              Get.back();
              getImage(false, onChoose);
            }
          : null,
      onChoosePic: isGallery
          ? () {
              Get.back();
              getImage(true, onChoose);
            }
          : null,
      width: Get.width * 0.85);
}

choosePhotoModalBottomSheet({VoidCallback? onTakePic, VoidCallback? onChoosePic, double width = 0}) {
  return Get.bottomSheet(
    Container(
        alignment: Alignment.bottomCenter,
        height: Get.width / 2,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingLargeDouble),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onTakePic != null) ButtonFillMain(title: "Take a picture".tr, onPress: onTakePic, textColor: Colors.black, bgColor: Colors.white),
            if (onTakePic != null) const DividerHorizontal(),
            if (onChoosePic != null)
              ButtonFillMain(title: "Choose a picture".tr, onPress: onChoosePic, textColor: Colors.black, bgColor: Colors.white),
            if (onChoosePic != null) const DividerHorizontal(),
            ButtonFillMain(title: "Cancel".tr, onPress: () => Get.back(), textColor: Colors.black, bgColor: Colors.grey),
            const SizedBox(height: 10)
          ],
        )),
    isDismissible: true,
  );
}

Future getImage(bool isGallery, Function(File, bool) onChoose) async {
  XFile? res;
  if (isGallery) {
    res = await ImagePicker().pickImage(source: ImageSource.gallery);
  } else {
    res = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);
  }
  if (res != null) {
    onChoose(File(res.path), isGallery);
  }
}
