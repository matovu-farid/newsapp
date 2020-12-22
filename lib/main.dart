import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'News App'),
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


List<String> listOfTitles = List.generate(10, (index) => lorem(paragraphs: 1,words: 10));
List<String> listOfSubtitles = List.generate(10, (index) => lorem(paragraphs: 1,words: 2));
List<String> listOfContent = List.generate(10, (index) => lorem(paragraphs: 3,words: 30));
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
delete(int index){
  setState(() {
    listOfTitles.removeAt(index);
    listOfContent.removeAt(index);
    listOfSubtitles.removeAt(index);
  });

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(

        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: listOfTitles.length,
            itemBuilder: (context,index){
          return Card(
            child: Slidable(
              key: Key('${listOfTitles[index]}'),
              dismissal: SlidableDismissal(
                dismissThresholds: <SlideActionType, double>{
                  SlideActionType.primary: 1.0
                },
                child: SlidableDrawerDismissal(),
                // onWillDismiss: (actionType) {
                //   return showDialog<bool>(
                //     context: context,
                //     builder: (context) {
                //       return AlertDialog(
                //         title: Text('Delete'),
                //         content: Text('Item will be deleted'),
                //         actions: <Widget>[
                //           FlatButton(
                //             child: Text('Cancel'),
                //             onPressed: () => Navigator.of(context).pop(false),
                //           ),
                //           FlatButton(
                //             child: Text('Ok'),
                //             onPressed: () => Navigator.of(context).pop(true),
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // },
                onDismissed: (actionType) {
                  _showSnackBar(

                      actionType == SlideActionType.primary
                          ? 'Dismiss Archive'
                          : 'Dimiss Delete');
                  delete(index);
                },
              ),
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text(listOfTitles[index]),
                    foregroundColor: Colors.white,
                  ),
                  title: Text(listOfTitles[index]),
                  subtitle: Text(listOfSubtitles[index]),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Archive',
                  color: Colors.blue,
                  icon: Icons.archive,
                  onTap: () => _showSnackBar('Archive'),
                ),
                IconSlideAction(
                  caption: 'Share',
                  color: Colors.indigo,
                  icon: Icons.share,
                  onTap: () => Share.share('${listOfTitles[index]}\n\n ${listOfContent[index]}'),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'More',
                  color: Colors.black45,
                  icon: Icons.more_horiz,
                  onTap: () => _showSnackBar('More'),
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => delete(index),

                ),
              ],
            ),
          );;
        }),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showSnackBar(String s) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(s)));
  }
}

