import 'package:flutter/material.dart';

class TipsScren extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Security Tips"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "Never share confidential information with another user (i.e. passwords, banking information). Check out our blog for ways to stay protected online.",
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "Don't share your phone number. Chat through the Mamaket app! Follow our tips for messaging.",
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "Research the person, product, and place before accepting to pay",
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "Look at the item photos. Do they give you enough detail?",
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(
                " Pick a safe place during a busy time of day especially the public area like malls or bus stops. Never send your home address for meetup",
              ),
            ),
          )
        ],
      ),
    );
  }
}
