import 'package:chatify2/misc/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String caption;
  String imageUrl;
  List<dynamic>? likes;
  Timestamp timestamp;
  String userId;
  String location;
  // String userHandle;
  // String userImageUrl;
  // var comments;

  Post({
    required this.caption,
    required this.imageUrl,
    required this.likes,
    required this.timestamp,
    required this.userId,
    required this.location,
    // required this.userHandle,
    // required this.userImageUrl,
    // required this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.caption: caption,
      AppConstants.imageUrl: imageUrl,
      AppConstants.likes: likes,
      AppConstants.timestamp: timestamp,
      AppConstants.userId: userId,
      // AppConstants.userHandle: userHandle,
      // AppConstants.userImageUrl: userImageUrl,
      // AppConstants.comments: comments,
    };
  }

  factory Post.fromMap(Map json) {
    return Post(
      caption: json[AppConstants.caption],
      imageUrl: json[AppConstants.imageUrl],
      likes: json[AppConstants.likes],
      timestamp: json[AppConstants.timestamp],
      userId: json[AppConstants.userId],
      location: json[AppConstants.location],
      // userHandle: json[AppConstants.userHandle],
      // userImageUrl: json[AppConstants.userImageUrl],
      // comments: json[AppConstants.comments],
    );
  }
}
