class NotificationMod {
  String conversationId;
  String refProduct;
  List<ParticipantMod> participants;

  NotificationMod(this.conversationId, this.refProduct, this.participants);
}

class ParticipantMod {
  String id;
  String name;
  String image;

  ParticipantMod(this.id, this.name, this.image);
}
