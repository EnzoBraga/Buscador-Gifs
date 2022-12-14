import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget{
  final Map _gifData;
  GifPage(this._gifData);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon:Icon(Icons.share),
              onPressed: (){
                FlutterShare.share(
                    title: _gifData["title"],
                    linkUrl:_gifData ["url"],
                    text: "Gif enviado através de Achador de Gifs do Praga"
                );
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}