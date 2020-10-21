import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quizz/widgets/text_utils.dart';
import 'package:quizz/models/question.dart';
import 'package:quizz/widgets/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';


class QuizzPage extends StatefulWidget {
  @override
  _QuizzPageState createState() => new _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {

  Question question;
  List<Question> listQuestions = [
    new Question('Paris est elle la capital de la france ?', true, 'Et oui', 'bcaa.jpg'),
    new Question('Amin est null ?', true, 'Et oui il est null', 'false.png')
  ];

  int index = 0;
  int score = 0;

  // Question par default
  @override
  void initState() {
    super.initState();
    question = listQuestions[index];
  }



  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width * 0.5;
    return new Scaffold(
      appBar: new AppBar(
        title: new TextUtils('Quizz Partie'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new TextUtils('Question #${index + 1}',color: Colors.grey[900]),
            // mettre $index si on veux mettre sur le nombre total de question
            new TextUtils('Score : $score / ${index + 1}',color: Colors.grey[900]),
            new Card(
              elevation: 0.8,
              child: new Container(
                height: size,
                width: size,
                child: new Image.asset('assets/' + question.imagePath),
              ),
            ),
            new TextUtils(question.question, color: Colors.grey[900], textScaleFactor: 1.3),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                boutonBool(true),
                boutonBool(false)
              ],
            )
          ],
        )
      ),
    );
  }

  RaisedButton boutonBool(bool b){
    return new RaisedButton(
      elevation: 8.0,
      onPressed: (() => dialog(b)),
      color: Colors.green,
      child: TextUtils(b ? "Vrai" : "Faux", color: Colors.white,),
    );
  }

  Future<Null> dialog(bool b) async{
    bool bonneResponse = (b == question.response);
    String vrai = "assets/true.png";
    String faux = "assets/false.png";
    if (bonneResponse) {score++; }
    return showDialog(
        context: context,
        // Pour pas retourner en arriere et pas rejouer
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new SimpleDialog(
            // textScaleFactor : taille du texte
            title: new TextUtils(bonneResponse ? "Bravo !" : "Dommage !", textScaleFactor: 1.4, color: bonneResponse ? Colors.green : Colors.redAccent),
            contentPadding: EdgeInsets.all(18.0),
            children: <Widget>[
              // fit: BoxFit.cover pour que ce soit carre
              new Image.asset(bonneResponse ? vrai : faux, fit: BoxFit.cover),
              // creer un espace
              new Container(height: 20.0),
              new TextUtils(question.explication, textScaleFactor: 1.1, color: Colors.grey[900]),
              new Container(height: 20.0),
              new RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    getNextQuestion();
                  },
                color: Colors.green,
                child: new TextUtils("Question suivante", color: Colors.white, textScaleFactor: 1.2),
              )
            ],
          );
        }
    );
  }
  Future<Null> alerte() async {
    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: new TextUtils('Fin du quizz', color: Colors.deepPurpleAccent, textScaleFactor: 1.2),
          contentPadding: EdgeInsets.all(10.0),
          content: new TextUtils("Votre score : $score/${index+1}", color: Colors.grey[900]),
          actions: <Widget>[
            new FlatButton(
                onPressed: (() {
                  Navigator.pop(buildContext);
                  Navigator.pop(context);
                }),
                child: new TextUtils("Terminer", textScaleFactor: 1.4, color: Colors.deepPurpleAccent)
            )
          ],
        );
      }
    );
  }

  Future<void> getNextQuestion() async {
     if (index < listQuestions.length - 1) {
       index++;
       setState(() {
         question = listQuestions[index];
       });
     } else {
        alerte();
        globals.dejaJouer = true;
        globals.gscore = score;
        print(globals.gscore);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('counter', score);
     }
  }
}