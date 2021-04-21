
import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class WriterClicked extends StatelessWidget {
  final NetworkProfile networkProfile;

  const WriterClicked({Key key, @required this.networkProfile}) : super(key: key);

  Future<bool> checkFollowing(String uid)async{
    var user = FirebaseAuth.instance.currentUser.uid;
    String chain=await  getChain(user, FirebaseFirestore.instance);

    return (chain.contains(uid))?true:false;
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<WritersModel>(context,listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Center(child:CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(networkProfile.picUrl),
            ),),
            StreamBuilder<DocumentSnapshot>(
                stream: model.fireStore.collection(model.user).doc('following_chain').snapshots(),
                builder: (context, snapshot) {

                  if(snapshot.hasData&& snapshot.data.data()!=null) {

                    String chain = snapshot.data.data().values.first.toString();
                    bool isFollowing = chain.contains(networkProfile.uid);
                    return TextButton(
                      child: Text(chain.contains(networkProfile.uid)?'following':'follow'),
                      onPressed: ()async=> await model.followOrUnFollow(networkProfile.uid,networkProfile.name,isFollowing),

                    );
                  }
                  return TextButton(onPressed: ()async=> await model.followOrUnFollow(networkProfile.uid,networkProfile.name,false),
                  child: Text('follow'));
                }
            ),
            Card(
              child: ListTile(
                title: Text(networkProfile.name),
              ),
            )
          ],
        ),
      ),
    )
   ;
  }
}
