class Message {
  //field name for Firestore Documents
  static const COLLECTION = 'messages';
  static const CREATED_BY = 'createdBy';
  static const SENT_TO = 'sentTo';
  static const TITLE = 'title';
  static const MESSAGE = 'message';
  static const DATE_SENT = 'dateSent';

  String docId; //Firestore doc id
  String createdBy;
  String sentTo;
  String title;
  String message;
  DateTime dateSent;

  Message({
    this.docId,
    this.createdBy,
    this.sentTo,
    this.title,
    this.message,
    this.dateSent,
  });

  // convert DART object to FIRESTORE document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: createdBy,
      SENT_TO: sentTo,
      TITLE: title,
      MESSAGE: message,
      DATE_SENT: dateSent,
    };
  }

  // convert FIRESTORE document to DART object
  static Message deserialized(Map<String, dynamic> data, String docId) {
    return Message(
      docId: docId,
      createdBy: data[Message.CREATED_BY],
      sentTo: data[Message.SENT_TO],
      title: data[Message.TITLE],
      message: data[Message.MESSAGE],
      dateSent: data[Message.DATE_SENT] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[Message.DATE_SENT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId \n $createdBy \n $title \n $message';
  }
}
