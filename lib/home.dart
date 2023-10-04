import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List mydata = [];

  Future getData() async {
    var url = Uri.parse(
        'https://api2.usim.edu.my/finance/retdata/asrama.php?custid=1112386');

    //try and catch in case error we don't know
    try {
      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        print('Ok');
        print(jsonResponse);
        mydata = jsonResponse;
        return mydata;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      //add your alertdialog
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test JSON API')),
      body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Text(snapshot.data[index]['custid']),
                          title: Text(snapshot.data[index]['nama']),
                          subtitle: Text('RM${snapshot.data[index]['amaun']}'),
                          trailing: Text(snapshot.data[index]['thdenda']),
                        ),
                      );
                    });
              } else {
                return const Text('No Data');
              }
            } else if (snapshot.connectionState == ConnectionState.active) {
              return const Center(child: Text('Connection still active'));
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          }),
    );
  }
}
