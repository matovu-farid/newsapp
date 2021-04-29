import 'dart:developer';

import 'package:article_themedata/article_themedata.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:firebase_wrapper/firebase_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:news_app/created_widgets/provider_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'created_widgets/pages/search.dart';
import 'created_widgets/pages/timeline.dart';
import 'package:unathenticated_widget/unathenticated_widget.dart';
import 'package:articleclasses/articleclasses.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //
  // debugPrintGestureArenaDiagnostics=true;
  Logger.root.onRecord.listen((record) {
    print('${record.loggerName} : ${record.message}');
  });

  runApp(FirebaseWrapper(
      child: ProviderWrapper(child: MyApp(),)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<WritersModel>(context,listen: false).initApp(App.Reader);
    return LitAuthInit(
      authProviders: AuthProviders(google: true, emailAndPassword: false),
      child: MaterialApp(
        title: 'Readaz',
        theme: buildArticlesThemeData(context),
        routes: {
          '/':(_)=>MyHomePage(),
          '/Profile':(_)=>SetupPage()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage() ;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool isFirstTime;
  String firstTimeKey = 'first time';
  bool isFirstTime = false;

  Future<void> getIsFirstTime() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(firstTimeKey)) {
      isFirstTime= true;
      prefs.setBool(firstTimeKey, false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getIsFirstTime(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done)


            if(isFirstTime) {

              return SetupPage(
                switchCallBack: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>TabViews()));
                },
              );
            }
            return TabViews();

      }
    );


  }
}


class TabViews extends StatelessWidget {
   TabViews({
    Key key,

  }) : super(key: key);

  Map<String,Widget> tabMap = {
    'TimeLine':TimeLine(),
    'Search':Search(),
  };

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,

        drawer: MyDrawer(),
        floatingActionButton: ChangeFonts(),
        key: scaffoldKey,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(right:60),
            child: Center(child: Text('Readaz',style: Theme.of(context).textTheme.headline3,)),
          ),
          bottom: TabBar(tabs: [
            Tab(text: tabMap.keys.toList()[0],key: Key('${tabMap.keys.toList()[0]}_tab'),),
            Tab(
              text: tabMap.keys.toList()[1],
                key: Key('${tabMap.keys.toList()[0]}_tab')
            )
          ]),
        ),
        body: Container(
          constraints: BoxConstraints.expand(),

          child: LitAuthState(

            unauthenticated: Unauthenticated(),
              authenticated: TabBarView(children: [
                tabMap.values.toList()[0],


                tabMap.values.toList()[1]])),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
