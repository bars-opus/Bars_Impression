import 'package:bars/utilities/exports.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  static Future<String> uploadUserProfileImage(
      String url, File imageFile) async {
    String? photoId = Uuid().v4();
    File? image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      photoId = exp.firstMatch(url)![1];
    }

    UploadTask uploadTask = storageRef
        .child('images/users/userProfile_$photoId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadUserprofessionalPicture1(
      String url, File imageFile) async {
    String? photoId = Uuid().v4();
    File? image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'professionalPicture1Url_(.*).jpg');
      photoId = exp.firstMatch(url)![1];
    }

    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture1/professionalPicture1Url_$photoId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadUserprofessionalPicture2(
      String url, File imageFile) async {
    String? photoId = Uuid().v4();
    File? image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'professionalPicture2Url_(.*).jpg');
      photoId = exp.firstMatch(url)![1];
    }

    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture2/professionalPicture2Url_$photoId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadUserprofessionalPicture3(
      String url, File imageFile) async {
    String? photoId = Uuid().v4();
    File? image = await compressImage(photoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'professionalPicture3Url_(.*).jpg');
      photoId = exp.firstMatch(url)![1];
    }

    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture3/professionalPicture3Url_$photoId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<File?> compressImage(String photoId, File image) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    File? compressImageFile = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressImageFile;
  }

  static Future<String> uploadPost(File imageFile) async {
    String postId = Uuid().v4();
    File? image = await compressImage(postId, imageFile);

    UploadTask uploadTask =
        storageRef.child('images/posts/post_$postId.jpg').putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPostVideo(File videoFile) async {
    String postId = Uuid().v4();

    UploadTask uploadTask =
        storageRef.child('videos/posts/post_$postId.jpg').putFile(videoFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadEvent(File imageFile) async {
    String eventId = Uuid().v4();
    File? image = await compressImage(eventId, imageFile);

    UploadTask uploadTask =
        storageRef.child('images/events/event_$eventId.jpg').putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadMessageImage(File imageFile) async {
    String messageId = Uuid().v4();
    File? image = await compressImage(messageId, imageFile);

    UploadTask uploadTask = storageRef
        .child('images/messageImage/message_$messageId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> gvIdImageUrl(File imageFile) async {
    String gvId = Uuid().v4();
    File? image = await compressImage(gvId, imageFile);

    UploadTask uploadTask =
        storageRef.child('images/posts/post_$gvId.jpg').putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
