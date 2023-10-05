import 'package:barikoi_map_demo_flutter/camera_map.dart';
import 'package:barikoi_map_demo_flutter/fill_map.dart';
import 'package:barikoi_map_demo_flutter/layer_map.dart';
import 'package:barikoi_map_demo_flutter/line_map.dart';
import 'package:barikoi_map_demo_flutter/symbol_map.dart';
import 'package:flutter/material.dart';
import 'package:barikoi_map_demo_flutter/example_page.dart';
import 'package:barikoi_map_demo_flutter/simple_map.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barikoi Map Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Barikoi Map Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<ExamplePage> pages=<ExamplePage>[
    ExamplePage("Simple Map",  SimpleMap()),
    ExamplePage("Camera Controls", CameraMap()),
    ExamplePage("Add a Symbol", SymbolMap()),
    ExamplePage("Add a Line", LineMap()),
    ExamplePage("Add a Polygon", FillMap()),
    ExamplePage("Add a layer", LayerMap())
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    pages[index].name,
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: Text(pages[index].name)),
                      body: pages[index].widget,
                    )));
              },
            );
          },
          itemCount: pages.length,
      )
    );
  }
}

