// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Edite.dart';
import 'package:flutter_app/viewnotes.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesref = FirebaseFirestore.instance.collection("notes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("login");
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          }),
      body: FutureBuilder(
          future: notesref
              .where("userid",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Dismissible(
                      onDismissed: (Diriction) async {
                        await notesref.doc(snapshot.data!.docs[i].id).delete();
                        await FirebaseStorage.instance
                            .refFromURL(snapshot.data!.docs[i]['imageurl'])
                            .delete()
                            .then((value) => print("print"));
                      },
                      key: UniqueKey(),
                      child: ListNotes(
                          notes: snapshot.data!.docs[i],
                          docid: snapshot.data!.docs[i].id),
                    );
                  });
            }
          }),
    );
  }
}

class ListNotes extends StatelessWidget {
  final notes;

  final docid;

  ListNotes({this.notes, this.docid});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ViewNote(
            notes: notes,
          );
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['imageurl']}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text("${notes['title']}"),
                subtitle: Text(
                  "${notes['note']}",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Edite(
                        docid: docid,
                        list: notes,
                      );
                    }));
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
