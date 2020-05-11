import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:GooNow/models/contact.dart';
import 'package:GooNow/provider/user_provider.dart';
import 'package:GooNow/resources/chat_methods.dart';
import 'package:GooNow/screens/callscreens/pickup/pickup_layout.dart';
import 'package:GooNow/screens/pageviews/widgets/contact_view.dart';
import 'package:GooNow/screens/pageviews/widgets/new_chat_button.dart';
import 'package:GooNow/screens/pageviews/widgets/quiet_box.dart';
import 'package:GooNow/utils/universal_variables.dart';

class ChatListScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
