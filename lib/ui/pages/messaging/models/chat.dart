class ChatMessageDto {
  String receiver;
  String refProduct;
  String text;
  Sender sender;
  String createdAt;

  ChatMessageDto(
      {this.receiver, this.refProduct, this.text, this.sender, this.createdAt});

  ChatMessageDto.fromJson(Map<String, dynamic> json) {
    receiver = json['receiver'];
    refProduct = json['refProduct'];
    text = json['text'];
    createdAt = json['createdAt'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiver'] = this.receiver;
    data['refProduct'] = this.refProduct;
    data['text'] = this.text;
    data['createdAt'] = this.createdAt;
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    return data;
  }
}

class Sender {
  String id;
  String name;

  Sender({this.id, this.name});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
