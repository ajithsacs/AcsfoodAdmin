import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MaterialApp(
    title: 'AdminFoodApp',
    home: Adminapp(),
    debugShowCheckedModeBanner: false,
  ));
}

class Adminapp extends StatefulWidget {
  const Adminapp({Key? key}) : super(key: key);

  @override
  State<Adminapp> createState() => _AdminappState();
}

class _AdminappState extends State<Adminapp> {
  late bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ACS Lunch"),
        backgroundColor: const Color.fromARGB(255, 227, 18, 87),
        actions: [
          IconButton(
              onPressed: () async {
                await fetchAlbum();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchAlbum(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!["items"];
            // print(listofiteam);
            return Column(children: [
              const Text(""),
              Text(
                "${snapshot.data!['text']}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var item_count = data[index]["count"] ?? 0;
                      var item_original_count =
                          data[index]?['original_count'] ?? item_count;
                      if (item_count == 0) {
                        return Column(
                          children: [
                            Text("${data!['text']}"),
                          ],
                        );
                      } else {
                        return Card(
                          child: ListTile(
                            title: Text(
                              "${snapshot.data!["items"][index]["name"]}",
                            ),
                            trailing: Text(
                              "$item_count ( $item_original_count )",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }

                      //Text("${snapshot.data!["items"][index]["name"]}");
                    }),
              ),
            ]);
          } else if (snapshot.hasError) {
            Text("Error :${snapshot.error}");
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchAlbum() async {
    final responce =
        await http.get(Uri.parse('https://pm.agilecyber.co.uk/report/api.php'));
    if (responce.statusCode == 200) {
      final decodeapistring = jsonDecode(responce.body);
      setState(() {
        decodeapistring;
      });
      return decodeapistring;
    } else {
      throw Exception();
    }
  }
}

// Future<Map<String, dynamic>> fetchAlbum() async {
//   final responce =
//       await http.get(Uri.parse('https://pm.agilecyber.co.uk/report/api.php'));
//   if (responce.statusCode == 200) {
//     final decodeapistring = jsonDecode(responce.body);
//     return decodeapistring;
//   } else {
//     throw Exception();
//   }
// }
