import 'package:expandable/expandable.dart';
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


List<String> listOfTitles = List.generate(10, (index) => lorem(paragraphs: 1,words: 3));
List<String> listOfSubtitles = List.generate(10, (index) => lorem(paragraphs: 1,words: 2));
List<String> listOfContent = List.generate(10, (index) => lorem(paragraphs: 3,words: 600));
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
delete(int index){
  setState(() {
    listOfTitles.removeAt(index);
    listOfContent.removeAt(index);
    listOfSubtitles.removeAt(index);
  });

}
ExpandableController _expandableController = ExpandableController(initialExpanded: false);

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
                child: ExpandableNotifier(
                  child: ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      controller: _expandableController,
                      //builder: ,
                      header: Center(child: Text(listOfTitles[index],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                      collapsed: Text(listOfContent[index], softWrap: true, maxLines: 3, overflow: TextOverflow.ellipsis,),
                      expanded: GestureDetector(
                        onDoubleTap: (){
                          setState(() {
                            _expandableController.expanded=false;
                          });
                        },
                          child: Text(listOfContent[index], softWrap: true, )),


                    ),
                  ),
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

