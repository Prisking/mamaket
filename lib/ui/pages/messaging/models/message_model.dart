class Message {
  String sId;
  String text;
  String createdAt;
  String conversation;
  Sender sender;
  String receiver;
  bool read;

  Message({
    this.sId,
    this.text,
    this.createdAt,
    this.conversation,
    this.sender,
    this.receiver,
    this.read,
  });

  Message.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    text = json['text'];
    createdAt = json['createdAt'];
    conversation = json['conversation'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver = json['receiver'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    data['conversation'] = this.conversation;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    data['receiver'] = this.receiver;
    data['read'] = this.read;
    return data;
  }
}

class Sender {
  String image;
  String sId;
  String name;

  Sender({this.image, this.sId, this.name});

  Sender.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
