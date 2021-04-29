import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter/material.dart';
import 'package:profile_page/profile_page.dart';
import 'package:provider/provider.dart';

class TopTile extends StatelessWidget {
  final OriginalArticle article;

  const TopTile({Key key, this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: TextButton(
        onPressed: () => Navigator.of(context)
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
                    return ReaderTile(
                      orginalArticle: article,
                    );
                  }),
            ),
            Flexible(
                flex: 3,
                child: StreamBuilder<String>(
                  // key: Key('timestream${article.articleId}'),
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
    );
  }
}