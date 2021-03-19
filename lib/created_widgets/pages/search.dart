import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:articlemodel/articlemodel.dart';
import 'package:firebase_wrapper/firebase_wrapper.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MyFloatingSearchBar()
      ],
    );
  }
}
class MyFloatingSearchBar extends StatefulWidget{
  //final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  @override
  _MyFloatingSearchBarState createState() => _MyFloatingSearchBarState();
}

class _MyFloatingSearchBarState extends State<MyFloatingSearchBar> {
StreamController<List<Map<String,String>>> _controller;
  @override
  void initState() {
    super.initState();
    _controller = StreamController<List<Map<String,String>>>();

  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

Widget build(BuildContext context){
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  WritersModel model = Provider.of<WritersModel>(context);

  return  FloatingSearchBar(
    hint: 'Search...',
    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
    transitionDuration: const Duration(milliseconds: 800),
    transitionCurve: Curves.easeInOut,
    physics: const BouncingScrollPhysics(),
    axisAlignment: isPortrait ? 0.0 : -1.0,
    openAxisAlignment: 0.0,
    width: isPortrait ? 600 : 500,
    debounceDelay: const Duration(milliseconds: 500),
    onQueryChanged: (query) async{
       List<Map<String,String>> list= await Provider.of<WritersModel>(context,listen: false).searchQuery(query);
       _controller.sink.add(list);

    },

    transition: CircularFloatingSearchBarTransition(),
    actions: [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.book),
          onPressed: () {

          },
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ],
    builder: (context, transition) {
      return StreamBuilder<List<Map<String,String>>>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if(snapshot.hasError)Center(child: Text(snapshot.error));

            if(snapshot.hasData)
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color: Colors.white,
                elevation: 4.0,
                child: Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_,index){
                        return Card(child: Center(child:
                        ListTile(
                          leading: Container(
                            height: 40,
                            width: 40,
                            child: CircleAvatar(
                              child: Image.network(snapshot.data[index]['url']),
                              // child: StreamBuilder<Uint8List>(
                              //   stream :model.fetchProfilePic(snapshot.data[index]).asStream(),
                              //   builder: (context, imagesnapshot) {
                              //     print(imagesnapshot.connectionState);
                              //
                              //       if(snapshot.hasData){
                              //         return Image.network(model.modelgetPicUrl(snapshot.data[index]));
                              //
                              //       }
                              //       //return Container(color: Colors.black,);
                              //
                              //
                              //
                              //     return CircularProgressIndicator();
                              //   }
                              // )
                            ),
                          ),
                            title: Text(snapshot.data[index]['name']),

                        )));
                      }),
                ),
              ),
            );
              return Center(child: CircularProgressIndicator());
          }
      );
    },
  );
}


}