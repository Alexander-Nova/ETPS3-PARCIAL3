import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parcial3/modelos/photos.dart';

void main() {
  runApp(parcial());
}

class parcial extends StatefulWidget {
  parcial({Key? key}) : super(key: key);

  @override
  State<parcial> createState() => _parcialState();
}

class _parcialState extends State<parcial> {
  late Future<List<Photos>> _listPhotos;
  Future<List<Photos>> _getPhotos() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    String cuerpo;
    List<Photos> lista = [];

    if (response.statusCode == 200) {
      print(response.body);
      cuerpo = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(cuerpo);
      for (var item in jsonData) {
        lista.add(Photos(item["albumId"], item["id"], item["title"],
            item["url"], item["thumbnailUrl"]));
      }
    } else {
      throw new Exception("Falla de conexion 500");
    }

    return lista;
  }

  @override
  void initState() {
    super.initState();
    _listPhotos = _getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listPhotos,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listPhoto(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parcial 3',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Parcial 3 - Photos API',
                style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.teal,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
          ),
          body: Container(
              // height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/wallpaper.jpg"),
                    fit: BoxFit.fill),
                // image: DecorationImage(
                //     // image: NetworkImage(
                //     //     "https://wallpapercave.com/wp/wp5273372.jpg"),
                //     image: DecorationImage(image:AssetImage("assets/img/wallpaper.jpg"))
                //     fit: BoxFit.fill),
              ),
              child: futureBuilder)),
    );
  }

  List<Widget> _listPhoto(data) {
    List<Widget> photo = [];
    for (var elemento in data) {
      photo.add(Card(
          elevation: 1.0,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Text(elemento.title),
              Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Column contents vertically,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Column contents horizontally,
                  children: <Widget>[
                    Center(
                        child: Text(
                      elemento.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          fontStyle: FontStyle.italic),
                    )),
                    Text("Album id: " + elemento.albumid.toString()),
                    Text("id: " + elemento.id.toString()),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Row contents horizontally,
                crossAxisAlignment:
                    CrossAxisAlignment.center, //Center Row contents vertically,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2.0),
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(elemento.url), scale: 0.05),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(2.0),
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(elemento.thumbnailUrl),
                          scale: 0.05),
                    ),
                  ),
                ],
              ),
            ],
          )));
    }
    return photo;
  }
}

// futureBuilder