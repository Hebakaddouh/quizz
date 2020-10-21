import 'package:flutter/material.dart';
import 'package:quizz/widgets/text_utils.dart';
import 'package:quizz/widgets/quizz_page.dart';
import 'package:quizz/widgets/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    getIntValuesSF();
    print ("je suis la ${globals.ss}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new TextUtils("helo ${globals.ss}"),
            new TextUtils(globals.dejaJouer ? "votre scrore est ${globals.gscore}" : "Pas jouer" , color: Colors.green),
            // Carte qui contient l'image home
            new Card(
              // ajout de l'ombre
              elevation: 10.0,
              child: new Container(
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                child: new Image.asset('assets/quizz_cover.jpg',fit : BoxFit.cover),
              ),
            ),
            new RaisedButton(
                child: Text('Quizz'),
                onPressed: navigateSecondPage,
            ),
          ],
        ),
      ),
    );
  }

  // Rafaichit la page
  onGoBack(dynamic value) {
    setState(() {});
    getIntValuesSF();
  }

  // Rafaichit la page
  void navigateSecondPage() {
    Route route = MaterialPageRoute(builder: (context) => QuizzPage());
    Navigator.push(context, route).then(onGoBack);
  }

  getIntValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    // Try reading data from the counter key. If it doesn't exist, return 0.
    globals.ss = prefs.getInt('counter') ?? 0;
    print ("je viens de la fonction ${globals.ss}");
    return globals.ss;
  }
}


