import 'dart:async';

import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
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

class TimelineView extends StatelessWidget {
  const TimelineView({
    Key key,
    @required this.stream,
  }) : super(key: key);

  final Stream<List<OriginalArticle>> stream;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ZefyrScaffold(
        child: Container(
          child: StreamBuilder<List<OriginalArticle>>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        final OriginalArticle article = snapshot.data[index];
                        return Dismissible(
                          onDismissed: (_) {
                            article.deleteFromTimeLine();
                          },
                          key: Key('dissible$index'),
                          child: TapCustomDetector(
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute<StoryView>(
                                    builder: (_) => StoryView(
                                          orginalArticle: article,
                                        ))),
                            // onhorizontalDrag: (DragUpdateDetails dragUpdateDetails) {  },
                            child: Card(
                              child: Consumer<WritersModel>(
                                  builder: (context, model, child) {
                                return ZefyrTheme(
                                  data:
                                      ZefyrThemeData.fallback(context).copyWith(
                                          defaultLineTheme: LineTheme(
                                    textStyle: model.style,
                                    padding: EdgeInsets.all(5),
                                  )),
                                  child: EditedField(
                                    orginalArticle: snapshot.data[index],
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      });
                return Center(
                    child: SizedBox(child: CircularProgressIndicator()));
              }),
        ),
      ),
    );
  }
}


