import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:firebase_wrapper/firebase_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:news_app/created_widgets/provider_wrapper.dart';
import 'package:provider/provider.dart';
import 'created_widgets/pages/search.dart';
import 'created_widgets/pages/timeline.dart';
import 'package:unathenticated_widget/unathenticated_widget.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //debugPrintGestureArenaDiagnostics=true;
  runApp(FirebaseWrapper(
      child: ProviderWrapper(child: MyApp(),)));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
      authProviders: AuthProviders(google: true, emailAndPassword: false),
      child: MaterialApp(
        title: 'Reader App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/':(_)=>MyHomePage(title: 'Reader App'),
          '/Profile':(_)=>Profile()
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(tabs: [
            Tab(text: 'Search',key: Key('search_tab'),),
            Tab(
              text: 'TimeLine',
                key: Key('timeline_tab')
            )
          ]),
        ),
        body: LitAuthState(

          unauthenticated: Unauthenticated(),
            authenticated: TabBarView(children: [Search(), TimeLine()])),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
