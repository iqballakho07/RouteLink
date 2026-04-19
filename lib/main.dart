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
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 22, 75, 79)),
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
      appBar: AppBar(
        title:  Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RouteLink',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 4),
                const Text("Jamshoro - Hyderabad Bus Schedule",style: TextStyle(color: Colors.white70,fontSize: 20),),
                SizedBox(height: 8),
                
              ],
            ),
          ),
          
        backgroundColor:  const Color(0xFF1565C0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: const Color(0xB3FFFFFF),
        backgroundColor: const Color(0xFF2D3436),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],                
     ),
      body: Center(
        child: FutureBuilder<Bus>(
          future: futureBus,
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              return Container(
                padding: EdgeInsets.all(10),
                color: const Color.fromARGB(255, 12, 31, 48),
                child: Column(
                  children: [
                      Container(
                        height: 80,
                        child: Card(
                          elevation: 10,
                          color: const Color.fromARGB(45,52,54,0),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Total Routes",style: TextStyle(fontSize: 10,color: Colors.white70),),
                                    Text("Last Updated",style: TextStyle(fontSize: 10,color: Colors.white70),),
                                  ],
                                ),
                                 
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${snapshot.data!.data.length} Buses available",style: TextStyle(color: Colors.white),),
                                    Text("Today",style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              );
                            },
                            itemCount: 1,
                          ),
                        ),
                    ),
                  Expanded(
                    child: Container(
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 10,
                                  color: const Color.fromARGB(45,52,54,0),
                                  child: Container(
                                    
                                    child: ListTile(
                    
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1565C0),
                                              borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text("Route #${snapshot.data!.data[index].toString().split(',').first.split(':').last.replaceFirst('{', '')} ", style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white), ),
                                            )),
                                            SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${snapshot.data!.data[index].toString().split(",").elementAt(1).split(":").last}", style: TextStyle(color: Colors.white)),
                                            Container(
                                             decoration: BoxDecoration(
                                                color: const Color(0xFF2E7D32),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text(snapshot.data!.data[index].toString().split(',').last.split(":").last.replaceRange(snapshot.data!.data[index].toString().split(',').last.split(":").last.length-1, snapshot.data!.data[index].toString().split(',').last.split(":").last.length, ''),style: TextStyle(color: Color.fromARGB(255, 123, 206, 127))),
                                                ),),
                                            ],
                                          ),
                                          SizedBox(height: 8,),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("${snapshot.data!.data[index].toString().split(",").elementAt(1).split(":").last.split("to").first} ",style: TextStyle(color: const Color(0xFF1565C0)),),
                                              Text("--------------->---------------",style: TextStyle(color: Colors.white),),
                                              Text(" ${snapshot.data!.data[index].toString().split(",").elementAt(1).split(":").last.split("to").last}",style: TextStyle(color: Colors.red),),
                                            ],
                                          ),
                                          const Divider(height: 20, thickness: 0.5, color: Color(0xFFEEEEEE)),
                                          Row(
                                            children: [
                                              const Icon(Icons.access_time,
                                                  size: 18, color: Color(0xFF555555)),
                                              const SizedBox(width: 2),
                                              Text(
                                                " ${snapshot.data!.data[index].toString().split(",").elementAt(2).split("e:").last}",
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF43A047),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'On schedule',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ], 
                                      ),
                                      
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.data.length,
                            ),
                        ),
                  ),
                      
                  ],
                  
                
                ),
                
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

