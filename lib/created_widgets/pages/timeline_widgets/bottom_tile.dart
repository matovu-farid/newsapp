import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter/material.dart';
import 'package:articleclasses/articleclasses.dart';
import 'package:shared_widgets/shared_widgets.dart';

import 'like_button.dart';
class SubTile extends StatelessWidget {
  final OriginalArticle article;

  const SubTile({Key key, this.article}) : super(key: key);
  Future<NetworkProfile> get profileFuture async => await ProfileBloc(App.Reader).fetchProfile(article.writerUid);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FutureBuilder<NetworkProfile>(
              future: profileFuture,
              builder: (context, snapshot) {
                var profile = snapshot.data;
                if(snapshot.connectionState == ConnectionState.done)
                  return Container(
                    height: 50,
                    width: 50,
                    child: FittedBox(

                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profile.picUrl),
                      ),
                    ),
                  );
                return Container();
              }
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              StreamBuilder<List<NetworkProfile>>(
                  stream: article.likes,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      encap('snapshot has data');
                      return NoLikesText(numberOfLikes: snapshot.data.length, article: article,);
                    }
                    return Container();
                  }
              ),
              LikeButton(article: article),
            ],
          ),
        ),
      ],
    );
  }
}