import 'dart:async';

import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zefyr/zefyr.dart';

import 'timeline_widgets/timeline_tile.dart';

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
            child: TimelineView(stream: articleBloc.streamOfArticles,articleBloc: articleBloc,)),
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
              child: TimelineView(articleBloc: _articleBloc,stream: _timelineSearchBloc.getStream()));
        },
      ),
    );
  }
}

class TimelineView extends StatefulWidget {
  const TimelineView({
    Key key,
    @required this.stream, this.articleBloc,
  }) : super(key: key);

  final Stream<List<OriginalArticle>> stream;
  final ArticleBloc articleBloc;

  @override
  _TimelineViewState createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  ScrollController scrollController;
  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      widget.articleBloc.fetchNext();
    }
  }
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);

  }

  @override
  void dispose() {
  scrollController.dispose();
    super.dispose();
  }
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
                    controller: scrollController,
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
                              child: TimelineTile(article: article,)
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










class TileClipper extends CustomClipper<Path>{


  @override
  Path getClip(Size size) {
    var innerControl = Offset(size.width*0.7,size.height*0.75);
    var outerControl = Offset(size.width*0.5,size.height*0.9);
    var endPoint = Offset(size.width*0.8,size.height);

    // var firstCurveControl1 = Offset(80, size.height*0.9);
    // var firstCurveControl2 = Offset(40, size.height*0.65);
    var firstCurveEndPoint = Offset(60, size.height*0.65);


    Path path = Path()..
    moveTo(0, 0)
      ..lineTo(0, size.height)

    ..arcToPoint(firstCurveEndPoint,radius: Radius.circular(25),clockwise: false)
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

