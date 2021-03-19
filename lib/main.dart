import 'package:articlemodel/articlemodel.dart';
import 'package:firebase_wrapper/firebase_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:provider/provider.dart';
import 'created_widgets/pages/search.dart';
import 'created_widgets/pages/timeline.dart';
import 'package:unathenticated_widget/unathenticated_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FirebaseWrapper(
      child: MultiProvider(providers: [
    ChangeNotifierProvider<WritersModel>(
      create: (_) => WritersModel(),
    ),
    ChangeNotifierProvider(create: (_) => ViewModel())
  ], child: MyApp())));
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
        home: MyHomePage(title: 'Reader App'),
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
  List<String> listOfTitles =
      List.generate(10, (index) => lorem(paragraphs: 1, words: 3));
  List<String> listOfSubtitles =
      List.generate(10, (index) => lorem(paragraphs: 1, words: 2));
  List<String> listOfContent =
      List.generate(10, (index) => lorem(paragraphs: 3, words: 600));
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  delete(int index) {
    setState(() {
      listOfTitles.removeAt(index);
      listOfContent.removeAt(index);
      listOfSubtitles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(tabs: [
            Tab(text: 'Search'),
            Tab(
              text: 'TimeLine',
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
