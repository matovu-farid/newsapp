import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LikeButton extends StatelessWidget {
  final OriginalArticle article;

  const LikeButton({
    Key key, @required this.article
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NetworkProfile>(
        future: ProfileBloc(App.Reader).currentProfile,
        builder: (context, snapshot) {
          if(snapshot.connectionState ==ConnectionState.done) {
            var profile = snapshot.data;
            return StreamBuilder<bool>(
                stream: article.doesLike(profile),
                builder: (context, snapshot) {
                  var doesLike = snapshot.data;
                  if(snapshot.hasData)
                    return IconButton(

                        icon: Icon(
                          FontAwesomeIcons.solidHeart,

                          color: doesLike?Colors.red:null,),
                        onPressed: ()async{
                          var profile = await ProfileBloc(App.Reader).currentProfile;

                          (doesLike)?article.unLike(profile):article.like(profile);
                        });
                  return IconButton(

                      icon: Icon(
                        FontAwesomeIcons.heart,
                      ),
                      onPressed: ()async{
                        var profile = await ProfileBloc(App.Reader).currentProfile;

                        article.like(profile);
                      });
                }
            );
          }
          return Container();
        }
    );
  }
}