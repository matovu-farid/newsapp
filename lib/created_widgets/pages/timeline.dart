import 'dart:async';

import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';


class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
ArticleBloc articleBloc = ArticleBloc();

  @override
  void initState() {
    articleBloc.orignalArticlesFollowing();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ZefyrScaffold(
      child: Container(
        child: StreamBuilder<List<OriginalArticle>>(
            stream: articleBloc.streamOfArticles,
            builder: (context, snapshot) {

              if(snapshot.hasData)
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_,index){
                      final OriginalArticle article = snapshot.data[index];
                      return TapCustomDetector(
                        onTap: ()=> Navigator.of(context).push(MaterialPageRoute<StoryView>(builder: (_)=>StoryView(orginalArticle: article,))),
                        child: Card(
                          child: EditedField(orginalArticle: snapshot.data[index],),
                        ),
                      );
                    });
              return Center(child: SizedBox(

                  child: CircularProgressIndicator()));
            }
        ),
      ),
    );
  }
}
class TapCustomDetector extends StatelessWidget{
  final GestureTapCallback onTap;
  final Widget child;

  TapCustomDetector({@required this.onTap,@required this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      child: child,
      gestures: {
        MyOnTapRecognizer: GestureRecognizerFactoryWithHandlers<MyOnTapRecognizer>(
            ()=>MyOnTapRecognizer(),
            (instance){
              instance.onTap=onTap;
            }
        )
      },
    );
  }

}

class MyOnTapRecognizer extends TapGestureRecognizer{

  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
    // super.acceptGesture(pointer);
  }
}