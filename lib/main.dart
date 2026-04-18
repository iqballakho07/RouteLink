import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

Future<Bus> fetchBus() async {
  final response = await http.get(
    Uri.parse('https://mock-api.net/api/JamHydTransit/api/v1/bus-schedule'),
    headers: {'Accept': 'application/json'},
  );
  if (response.statusCode == 200) {
    return Bus.fromjson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception("Failed to load bus data");
  }
}

class Bus {
  final String status;
  final List<dynamic> data;
  const Bus({required this.status, required this.data});
  factory Bus.fromjson(Map<String, dynamic> json) {
    return switch (json) {
      {'status': String status, 'data': List<dynamic> data} => Bus(
        status: status,
        data: data,
      ),

      _ => throw const FormatException("Failed to load bus data"),
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RouteLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 144, 225, 232)),
      home: const BusScreen(),
  // This widget is the root of your application.
    );
}
}

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  late Future<Bus> futureBus;

  @override
  void initState() {
    super.initState();
    futureBus = fetchBus();
  }

@override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(title: const Text('RouteLink'),backgroundColor: Colors.blue,),
        body: Center(
          child: FutureBuilder<Bus>(
            future: futureBus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 144, 225, 232),
                      child: ListTile(
                        leading: Icon(Icons.directions_bus),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" ID : ${snapshot.data!.data[index].toString().split(',').first.split(':').last.replaceFirst('{', '')} "),
                            Text("Origin : ${snapshot.data!.data[index].toString().split(',').elementAt(1).split(":").last.split("to").first} ",),
                            Text("Desitination : ${snapshot.data!.data[index].toString().split(',').elementAt(1).split(":").last.split("to").last}"),
                          ],
                        ),
                        subtitle: Text(snapshot.data!.data[index].toString().split(',').elementAt(2)) ,
                        trailing: Text(snapshot.data!.data[index].toString().split(',').last.replaceRange(snapshot.data!.data[index].toString().split(',').last.length-1, snapshot.data!.data[index].toString().split(',').last.length, '')),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.data.length,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ); }
  }
