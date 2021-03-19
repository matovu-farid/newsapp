import 'package:articlemodel/articlemodel.dart';
import 'package:flutter/material.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
class WriterClicked extends StatelessWidget {
  final String downloadurl;
  final String name;

  const WriterClicked({Key key, @required this.downloadurl,@required  this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Center(child:CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(downloadurl),
            ),),
            Consumer<WritersModel>(
              builder: (context, model,child) {
                return TextButton(
                  child: Text('follow'),
                  onPressed: ()=> model.follow(name),
                  style: TextButton.styleFrom(

                  ),
                );
              }
            ),
            Card(
              child: ListTile(
                title: Text(name),
              ),
            )
          ],
        ),
      ),
    )
   ;
  }
}
