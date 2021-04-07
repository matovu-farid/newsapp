import 'package:flutter/material.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/created_widgets/pages/search.dart';
import 'package:news_app/created_widgets/provider_wrapper.dart';
import 'package:test/test.dart';
void main(){
  testWidgets('top nav', (tester)async{
    await tester.pumpWidget(ProviderWrapper(child: MaterialApp(home: Scaffold(body: MyFloatingSearchBar()))));

  });
}