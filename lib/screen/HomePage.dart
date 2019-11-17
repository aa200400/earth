import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:skyscrapeapi/skyscrape.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Earth.io")),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('earth').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return _buildBody(
                              index, snapshot.data.documents[index]);
                        },
                        itemCount: snapshot.data.documents.length,
                        scale: .9,
                        viewportFraction: 0.8
                    );
                  }
                ),
              height: 200,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int index, DocumentSnapshot doc) {
    return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onTap: () async {
          doc.reference.updateData({'times': FieldValue.increment(1)});
        },
        child: Card(
          color: index % 3 == 0
              ? Colors.green
              : index % 3 == 1 ? Colors.blue : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(child: Text(doc["times"].toString())),
        )
    );
  }
}
