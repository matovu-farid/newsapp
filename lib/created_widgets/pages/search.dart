import 'dart:async';


import 'package:articleclasses/articleclasses.dart';
import 'package:articlemodel/articlemodel.dart';
import 'package:articlewidgets/articlewidgets.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:news_app/created_widgets/writer_profile.dart';
import 'package:profile_page/profile_page.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            top: 70,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            left: 0,
            child: FollowingGrid()),
        MyFloatingSearchBar(),

      ],
    );
  }
}
class FollowingGrid extends StatelessWidget {
  FollowingBloc followingProfileBloc = FollowingBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.8,
      child: StreamBuilder<List<NetworkProfile>>(
        stream: followingProfileBloc.followingProfileStream,
        builder: (context, snapshot) {
          if(snapshot.hasData)
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                 var profile = snapshot.data[index];
                return TappedWriter(
                  networkProfile: profile,
                  child: Card(
                    child: Container(
                      height: 300,
                      child: Column(

                        children: [
                          Flexible(
                            child: Center(child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(profile.picUrl),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(profile.name,),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                );
              });
          return Container();
        }
      ),
    );
  }
}

class MyFloatingSearchBar extends StatefulWidget{
  //final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
  @override
  _MyFloatingSearchBarState createState() => _MyFloatingSearchBarState();
}

class _MyFloatingSearchBarState extends State<MyFloatingSearchBar> {
//StreamController<List<Map<String,String>>> _controller;
  @override
  void initState() {
    super.initState();
    //controller = StreamController<List<Map<String,String>>>();

  }

  @override
  void dispose() {
    _writerSearchBloc.dispose();
    super.dispose();
  }
  WriterSearchBloc _writerSearchBloc = WriterSearchBloc();

Widget build(BuildContext context){


  return  Container(
    child: MySearchBar(
      key:Key('search_bar'),
      // debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) async{
         _writerSearchBloc.addToStream(query);

      },


      builder: (context, transition) {
        return StreamBuilder<List<NetworkProfile>>(
            stream: _writerSearchBloc.getStream(),
            builder: (context, snapshot) {
              if(snapshot.hasError)Center(child: Text(snapshot.error));

              if(snapshot.hasData) {

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
                          var profile = snapshot.data[index];
                          return TappedWriter(
                            networkProfile: profile,

                            child: Card(child: Center(child:
                            ListTile(
                              leading: SizedBox(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(profile.picUrl),

                                ),
                              ),
                                title: Text(profile.name),

                            ))),
                          );
                        }),
                  ),
                ),
              );
              }
                return Center(child: CircularProgressIndicator());
            }
        );
      },
    ),
  );
}


}
class TappedWriter extends StatelessWidget {
  final NetworkProfile networkProfile;
  final Widget child;

  const TappedWriter({Key key, this.networkProfile, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:(){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_)=>WriterClicked(networkProfile:networkProfile)
        ));
      },
      child: child,
    );
  }
}

