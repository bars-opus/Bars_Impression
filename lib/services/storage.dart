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
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child('images/users/$currentUserId/userProfile_$photoId.jpg')
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
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        photoId = match[1];
      }
      // photoId = exp.firstMatch(url)![1];
    }
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture1/$currentUserId/professionalPicture1Url_$photoId.jpg')
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
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        photoId = match[1];
      }
      // photoId = exp.firstMatch(url)![1];
    }
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture2/$currentUserId/professionalPicture2Url_$photoId.jpg')
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
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        photoId = match[1];
      }
      // photoId = exp.firstMatch(url)![1];
    }
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child(
            'images/professionalPicture3/$currentUserId/professionalPicture3Url_$photoId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadPost(File imageFile) async {
    String postId = Uuid().v4();
    File? image = await compressImage(postId, imageFile);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child('images/new_posts/$currentUserId/post_$postId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadEvent(File imageFile) async {
    String eventId = Uuid().v4();
    File? image = await compressImage(eventId, imageFile);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child('images/new_events/$currentUserId/event_$eventId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadMessageImage(File imageFile) async {
    String messageId = Uuid().v4();
    File? image = await compressImage(messageId, imageFile);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child(
            'images/new_messageImage/$currentUserId/new_message_$messageId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadEventRooomMessageImage(
      File imageFile, String eventId) async {
    String messageId = Uuid().v4();
    File? image = await compressImage(messageId, imageFile);
    // String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    UploadTask uploadTask = storageRef
        .child(
            'images/new_eventRoonMessageImage/$eventId/message_$messageId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  // static Future<String> uploadThoughtImage(File imageFile) async {
  //   String thoughtId = Uuid().v4();
  //   File? image = await compressImage(thoughtId, imageFile);
  //   String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //   UploadTask uploadTask = storageRef
  //       .child('images/thoughtImage/$currentUserId/message_$thoughtId.jpg')
  //       .putFile(image!);
  //   String downloadUrl = await (await uploadTask).ref.getDownloadURL();
  //   return downloadUrl;
  // }

  static Future<String> gvIdImageUrl(File imageFile) async {
    String gvId = Uuid().v4();
    File? image = await compressImage(gvId, imageFile);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    UploadTask uploadTask = storageRef
        .child('images/validate/$currentUserId/new_post_$gvId.jpg')
        .putFile(image!);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> virIdImageUrl(File imageFile) async {
    String virId = Uuid().v4();
    File? image = await compressImage(virId, imageFile);
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    UploadTask uploadTask = storageRef
        .child('images/validate/$currentUserId/post_$virId.jpg')
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
      quality: 50,
    );
    return compressImageFile;
  }
  // static Future<String> uploadUserprofessionalVideo1(
  //     String url, PickedFile videoFile) async {
  //   String? videoId = Uuid().v4();
  //   // File? image = await compressImage(videoId, imageFile);

  //   // if (url.isNotEmpty) {
  //   //   RegExp exp = RegExp(r'professionalPicture1Url_(.*).jpg');
  //   //   videoId = exp.firstMatch(url)![1];
  //   // }
  //   String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  //   UploadTask uploadTask = storageRef
  //       .child(
  //           'videos/professionalVideo1/$currentUserId/professionalVideoUrl_$videoId.mp4')
  //       .putFile(videoFile as File);
  //   String downloadUrl = await (await uploadTask).ref.getDownloadURL();
  //   return downloadUrl;
  // }
}
