//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

//firebase.flutter.dev/docs/firestore/usage
//how to write data to firebase firestore using flutter


//Kurzanleitung zu Firestore:
//vorher in Firestore direkt eine
//Collection erstellen, die Userdaten und
//Passwortgedöns speichert
//dann in den TextFields in der changedMethode
//einen String mit einem value mappen
//den ich bevor ich das Widget bau oben angeb
//dann in onPressed, der FABs was adden
//ubd in dem add-Block quasi "variable Inputanteile"
//schreiben
//dann Datenbankzeug holen zur Berechnung
//bzw. auch unter Aktivities, wo ich neue anleg
//die Eingaben speichern


//zusätlich HIER:
//evtl. Futures mit Datenbankoperationen
//in diese DatabaseService-Klasse auslagern
//activities an users binden bzw. UserData
//auch in der activitie-Collectiuon abspeichern

//deprecated example
/*class DatabaseService {

  Future<void> userSetup(String displayName) async {
    //firebase auth instance to get uuid of user
    User user = FirebaseAuth.instance.currentUser;

    //now below I am getting an instance of firebaseiestore then getting the user collection
    //now I am creating the document if not already exist and setting the data.
    FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
        {
          'displayName': displayName, 'uid': uid
        });
    return;
  }
}*/