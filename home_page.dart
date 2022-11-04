  import 'package:flutter/material.dart';
  import 'package:gifzada/UI/gif_page.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:transparent_image/transparent_image.dart';
  import 'package:flutter_share/flutter_share.dart';


  class HomePage extends StatefulWidget {
    @override
    _HomePageState createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {

    String _search = "";
    int _offset = 0;

    //função para conectarmos a api e precisa ser assíncrona
    Future<Map> _getGifs() async{
      http.Response response;
      if(_search == ""){
        //pega os gifs do trending
        response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=4fNoXrKTa2ZJCLdp9gq54WHus0zrJXIX&limit=25&rating=g"));
      } else{
        //faz a pesquisa
        response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=4fNoXrKTa2ZJCLdp9gq54WHus0zrJXIX&q=$_search=&limit=25&$_offset=0&rating=g&lang=en"));
      }
      return json.decode(response.body);

    }

    int _getCount(List data){
      if (_search==""){
        return data.length;
      }
      else
        {
          return data.length+1;
        }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network("https://media.giphy.com/media/PDHMkTp8dbV9onH1Ck/giphy.gif"),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Pesquise Aqui",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                style: TextStyle(color: Colors.white, fontSize: 10.0),
                textAlign: TextAlign.center ,
                onSubmitted: (text){
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200.0,
                          height: 200.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5.0,
                          ),
                        );
                      default:
                        if(snapshot.hasError) return Container();
                        else return _createGifTable(context, snapshot);
                    }
                  }
              ),
            ),
          ],
        ) ,
      );
    }


    Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
      return GridView.builder(
          padding: EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//como os itens são organizados
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0
          ),
          itemCount: _getCount(snapshot.data["data"]), //quantos por tela
          itemBuilder: (context,index){
           if(_search=="" || index<snapshot.data["data"].length)
           {
            return GestureDetector( //para que o item seja clicável
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover),
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                );
              },
            );
          }
           else return Container(
             child: GestureDetector(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Icon(Icons.add, color: Colors.white, size: 70.0),
                   Text("Carregar mais.....",
                   style: TextStyle(color: Colors.white, fontSize: 22.0),)
                 ],
               ),
               onTap: (){
                 setState(() {
                   _offset+=25;
                 });
               },
             ),
           );


          }
      );
    }

  }