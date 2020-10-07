class PhotoMemo {
  //field name for Firestore Documents
  static const COLLECTION = 'photoMemos';
  static const IMAGE_FOLDER = 'photoMemoPictures';
  static const TITLE = 'Title';
  static const MEMO = 'Memo';
  static const CREATED_BY = 'CreatedBy';
  static const PHOTO_URL = 'PhotoURL';
  static const PHOTO_PATH = 'PhotoPath';
  static const UPDATED_AT = 'UpdateAt';

  String docId; //Firestore doc id
  String createdBy;
  String title;
  String memo;
  String photoPath; //Firebase Storage: image file name
  String photoURL; //Firebase Stroage: image URL for internet access
  DateTime updatedAt; //created or revised time

  PhotoMemo({
    this.docId,
    this.createdBy,
    this.title,
    this.memo,
    this.photoPath,
    this.photoURL,
    this.updatedAt,
  });

  // convert DART object to FIRESTORE document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: title,
      CREATED_BY: createdBy,
      MEMO: memo,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      UPDATED_AT: updatedAt,
    };
  }

  // convert FIRESTORE document to DART object
  static PhotoMemo deserialized(Map<String, dynamic> data, String docId) {
    return PhotoMemo(
      docId: docId,
      createdBy: data[PhotoMemo.CREATED_BY],
      title: data[PhotoMemo.TITLE],
      memo: data[PhotoMemo.MEMO],
      photoPath: data[PhotoMemo.PHOTO_PATH],
      photoURL: data[PhotoMemo.PHOTO_URL],
      updatedAt: data[PhotoMemo.UPDATED_AT] != null
          ? DateTime.fromMillisecondsSinceEpoch(data[PhotoMemo.UPDATED_AT])
          : null,
    );
  }
}
