import 'package:flutter/material.dart';

class Photos {
  int albumid = 0; //no debe ser string por que en la api es int
  int id = 0; //no debe ser string por que en la api es int
  String title = "";
  String url = "";
  String thumbnailUrl = "";

  Photos(albumid, id, title, url, thumbnailUrl) {
    this.albumid = albumid;
    this.id = id;
    this.title = title;
    this.url = url;
    this.thumbnailUrl = thumbnailUrl;
  }
}
