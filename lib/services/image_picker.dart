import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<Uint8List?> pickimage(ImageSource imagesource) async {
  // final ImagePicker imagepicker = ImagePicker();
  final XFile? pickedimage = await ImagePicker().pickImage(source: imagesource);

  if (pickedimage != null) {
    if (kDebugMode) print("Imaged picked sucessfully🤩");

    XFile? cropedimage = await cropImagetoSquare(pickedimage);
    Uint8List uploadableimage = await cropedimage!.readAsBytes();

    return uploadableimage;
  }

  if (kDebugMode) print("image not selected😕");
  return null;
}

Future<XFile?> cropImagetoSquare(XFile selectedimage) async {
  CroppedFile? croppedimage = await ImageCropper().cropImage(
    sourcePath: selectedimage.path,
    compressFormat: ImageCompressFormat.jpg,
    aspectRatioPresets: [CropAspectRatioPreset.square],
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  );

  if (kDebugMode) print(croppedimage);
  if (kDebugMode) print(croppedimage);
  if (kDebugMode) print(croppedimage);

  return croppedimage != null ? XFile(croppedimage.path) : null;
}
