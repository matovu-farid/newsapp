import 'dart:async';
import 'dart:math';

import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_widgets/shared_widgets.dart';
import 'package:zefyr/zefyr.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  ArticleBloc articleBloc = ArticleBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    articleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            right: 0,
            top: 70,
            bottom: 0,
            child: TimelineView(stream: articleBloc.streamOfArticles)),
        TimeLineSearchBar(),
      ],
    );
  }
}

class TimeLineSearchBar extends StatefulWidget {
  @override
  _TimeLineSearchBarState createState() => _TimeLineSearchBarState();
}

class _TimeLineSearchBarState extends State<TimeLineSearchBar> {
  TimelineSearchBloc _timelineSearchBloc;
  ArticleBloc _articleBloc = ArticleBloc();

  @override
  void initState() {
    _timelineSearchBloc = TimelineSearchBloc(_articleBloc);
    super.initState();
  }

  @override
  void dispose() {
    _timelineSearchBloc.dispose();
    _articleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: MySearchBar(
        onQueryChanged: (query) async {
          await _timelineSearchBloc.addToStream(query);
        },
        builder: (_, __) {
          return Container(
              child: TimelineView(stream: _timelineSearchBloc.getStream()));
        },
      ),
    );
  }
}

class TimelineView extends StatefulWidget {
  const TimelineView({
    Key key,
    @required this.stream,
  }) : super(key: key);

  final Stream<List<OriginalArticle>> stream;

  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<WritersModel>(context,listen: false);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: ZefyrScaffold(
        child: Container(
          child: StreamBuilder<List<OriginalArticle>>(
              stream: widget.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<OriginalArticle> list = snapshot.data;
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final OriginalArticle article = list[index];
                        return Dismissible(
                          onDismissed: (_) async{

                              await article.deleteFromTimeLine(model.user);




                          },
                          key: Key('dissible${article.articleId}'),
                          child: ClipPath(
                            clipper: TileClipper(),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80,
                                    child: TapCustomDetector(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute<StoryView>(
                                          builder: (_) => StoryView(
                                            orginalArticle: article,
                                          ))),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 7,
                                            child: Consumer<WritersModel>(
                                                builder: (context, model, child) {
                                              return ZefyrTheme(
                                                data:
                                                    ZefyrThemeData.fallback(context).copyWith(
                                                        defaultLineTheme: LineTheme(
                                                  textStyle: model.style,
                                                  padding: EdgeInsets.all(5),
                                                )),
                                                child: ReaderTile(
                                                  orginalArticle: snapshot.data[index],
                                                ),
                                              );
                                            }),
                                          ),
                                          Flexible(
                                            flex: 3,
                                              child: StreamBuilder<String>(
                                                stream: article.timeStream,
                                                builder: (context, snapshot) {

                                                  if(snapshot.hasData)
                                                  return Text(snapshot.data);
                                                  return Container();
                                                }
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }
                return Center(
                    child: SizedBox(child: CircularProgressIndicator()));
              }),
        ),
      ),
    );
  }
}

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



class TileClipper extends CustomClipper<Path>{


  @override
  Path getClip(Size size) {
    print(size.height);
    var innerControl = Offset(size.width*0.7,size.height*0.75);
    var outerControl = Offset(size.width*0.5,size.height*0.9);
    var endPoint = Offset(size.width*0.8,size.height);
    


    Path path = Path()..
    moveTo(0, 0)
      ..lineTo(0, size.height*0.65)
    ..lineTo(size.width*0.6, size.height*0.65)
..cubicTo(innerControl.dx, innerControl.dy, outerControl.dx, outerControl.dy, endPoint.dx, endPoint.dy)
    ..lineTo(size.width*0.8,  size.height)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width, 0)
    ..close()
    ;

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}

