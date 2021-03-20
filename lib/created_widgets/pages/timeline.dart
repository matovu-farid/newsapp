import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CloudList(stream:Provider.of<WritersModel>(context).orignalArticlesFollowing().asStream()),
    );
  }
}
