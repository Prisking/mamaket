class Conversation {
  String sId;
  String name;
  List<Participants> participants;
  String refProduct;
  LatestMessage latestMessage;

  Conversation({
    this.sId,
    this.name,
    this.participants,
    this.refProduct,
    this.latestMessage,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    if (json['participants'] != null) {
      participants = new List<Participants>();
      json['participants'].forEach((v) {
        participants.add(new Participants.fromJson(v));
      });
    }
    refProduct = json['refProduct'];
    latestMessage = json['latestMessage'] != null
        ? new LatestMessage.fromJson(json['latestMessage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.participants != null) {
      data['participants'] = this.participants.map((v) => v.toJson()).toList();
    }
    data['refProduct'] = this.refProduct;
    if (this.latestMessage != null) {
      data['latestMessage'] = this.latestMessage.toJson();
    }
    return data;
  }
}

class Participants {
  String sId;
  String image;
  String name;

  Participants({this.sId, this.image, this.name});

  Participants.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image'] = this.image;
    data['name'] = this.name;
    return data;
  }
}

class LatestMessage {
  String sId;
  String text;
  String createdAt;
  String conversation;
  String sender;
  String receiver;
  bool read;

  LatestMessage({
    this.sId,
    this.text,
    this.createdAt,
    this.conversation,
    this.sender,
    this.receiver,
    this.read,
  });

  LatestMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    createdAt = json['createdAt'];
    conversation = json['conversation'];
    sender = json['sender'];
    receiver = json['receiver'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    data['conversation'] = this.conversation;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['read'] = this.read;
    return data;
  }
}
