import 'dart:math';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const StartupNameList(title: 'Startup Name Generator'),
    );
  }
}

class StartupNameList extends StatefulWidget {
  const StartupNameList({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StartupNameList> createState() => _StartupNameListState();
}

class _StartupNameListState extends State<StartupNameList> {
  Map<WordPair, bool> namesSelected = {};
  bool showOnlySelected = false;

  final _startupNames = <WordPair>[];

  List<WordPair> _getFilteredStartupNames() {
    if(showOnlySelected) {
      return _startupNames.where((wordpair) => namesSelected.containsKey(wordpair)).toList();
    }
    return _startupNames;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print(_getFilteredStartupNames().length);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Scrollbar(
          child: ListView.builder(
        restorationId: 'list_view',
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: showOnlySelected ? _getFilteredStartupNames().length : null,
        itemBuilder:(context, index) {
          var names = _getFilteredStartupNames();
          print('index  $index');
          var len = names.length;
          print('names in list $len');
          // Showing only selected causes index to overflow due to collapsed items, so we disable it here
          if(!showOnlySelected && index >= _startupNames.length) {
            // Generate more names when reaching end
             _startupNames.addAll(generateWordPairs().take(10));
          }
          return ListTile(
                  leading: Checkbox(
                      value: namesSelected[names[index]] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          namesSelected[names[index]] = value ?? false;
                        });
                      }),
                  title: Text(names[index].asPascalCase));
        }
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                showOnlySelected = !showOnlySelected;
              }),
          tooltip: 'Show selected',
          child: showOnlySelected
              ? const Icon(Icons.filter_alt_off)
              : const Icon(Icons
                  .filter_alt)), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

String nextRandStartupName() => WordPair.random().asPascalCase;
