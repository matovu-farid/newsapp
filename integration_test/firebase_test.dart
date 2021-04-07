import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefunctions/firebasefunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/created_widgets/pages/search.dart';
import 'package:news_app/created_widgets/provider_wrapper.dart';

void main() async{

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  testWidgets("failing test example", (WidgetTester tester) async {
    expect(2 + 2, equals(4));
  });

  testWidgets('top nav', (tester)async{
    await tester.pumpWidget(ProviderWrapper(child: MaterialApp(home: Scaffold(body: MyFloatingSearchBar()))));

  });
  // testWidgets('add To Chain',(tester)async{
  //   String uid = 'G8rXUEyxqKcMlQNH8J27mObts6f1';
  //   String oldChain= await getChain(uid);
  //   expect(oldChain.contains(uid), false);
  //   await addToChain(uid);
  //   String newChain= await getChain(uid);
  //   expect(newChain.contains(uid), true);
  // });
  // testWidgets('delete From Chain',(tester)async{
  //   String uid = 'G8rXUEyxqKcMlQNH8J27mObts6f1';
  //   String oldChain= await getChain(uid);
  //   expect(oldChain.contains(uid), true);
  //   await deleteFromChain(uid);
  //   String newChain= await getChain(uid);
  //   expect(newChain.contains(uid), false);
  // });
}