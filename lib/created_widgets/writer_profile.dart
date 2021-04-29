import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// the writers page
class WriterClicked extends StatelessWidget {
  final NetworkProfile networkProfile;

  const WriterClicked({Key key, @required this.networkProfile})
      : super(key: key);
  Widget counterText(int number,String text){
    switch(number){
      case 0: return Text('');
      case 1: return Text('1 $text');
      default: return Text('${number} ${text}s');
    }
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<WritersModel>(context, listen: false);
    model.initProfileBloc();

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage(networkProfile.picUrl),
              ),
            ),
            StreamBuilder<bool>(
                stream: model.profileBloc.checkFollowing(networkProfile.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool isFollowing = snapshot.data;
                    return TextButton(
                      child: Text(isFollowing ? 'following' : 'follow'),
                      onPressed: () async => await model.profileBloc
                          .followOrUnFollow(networkProfile, isFollowing),
                    );
                  }
                  return TextButton(
                      onPressed: () async => await model.followOrUnFollow(
                          networkProfile.uid, networkProfile.name, false),
                      child: Text('follow'));
                }),
            Card(
              child: ListTile(
                title: Text(networkProfile.name),
                subtitle: StreamBuilder<int>(
                    stream:
                        model.profileBloc.numberOfFollowers(networkProfile.uid),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var number = snapshot.data;
                       return counterText(number, 'reader');

                      }
                      return Text('');
                    }),
                trailing: FutureBuilder<int>(
                  future: networkProfile.noOfArticles,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState ==ConnectionState.done) {
                      var number = snapshot.data;
                      return counterText(number, 'article');
                    }
                    return Text('');
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
