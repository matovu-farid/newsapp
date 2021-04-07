import 'package:articlemodel/articlemodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWrapper extends StatelessWidget{
  final Widget child;

  const ProviderWrapper({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<WritersModel>(
        create: (_) => WritersModel(),
      ),
      ChangeNotifierProvider(create: (_) => ViewModel())
    ], child: child);
  }

}