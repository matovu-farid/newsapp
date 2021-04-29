
import 'package:articleclasses/articleclasses.dart';
import 'package:flutter/material.dart';
import 'package:news_app/created_widgets/pages/timeline_widgets/top_tile.dart';

import 'bottom_tile.dart';

class TimelineTile extends StatelessWidget {
  final OriginalArticle article;

  const TimelineTile({Key key, this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopTile(article: article,),
        SubTile(article: article,)
      ],
    );
  }
}