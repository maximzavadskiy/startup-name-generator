import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartupNameList(title: 'Startup Name Generator'),
    );
  }
}

class StartupNameList extends StatefulWidget {
  const StartupNameList({super.key, required this.title});

  final String title;

  @override
  State<StartupNameList> createState() => _StartupNameListState();
}

class _StartupNameListState extends State<StartupNameList> {
  Map<WordPair, bool> namesSelected = {};
  bool showOnlySelected = false;

  final _startupNames = <WordPair>[];

  List<WordPair> _getFilteredStartupNames() {
    if (showOnlySelected) {
      return _startupNames
          .where((wordpair) => namesSelected.containsKey(wordpair) && (namesSelected[wordpair] ?? false))
          .toList();
    }
    return _startupNames;
  }

  void _generateMoreStartupNames() {
    _startupNames.addAll(generateWordPairs().take(10));
  }

  void _toggleNameSelection(index) {
    var startupNames = _getFilteredStartupNames();
    setState(() {
      namesSelected[startupNames[index]] =
          !(namesSelected[startupNames[index]] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
          child: ListView.builder(
              restorationId: 'list_view',
              padding: const EdgeInsets.symmetric(vertical: 8),
              // Set strict item count when showing only selected to prevent from auto-generating new words
              itemCount:
                  showOnlySelected ? _getFilteredStartupNames().length : null,
              itemBuilder: (context, index) {
                var startupNames = _getFilteredStartupNames();
                if (index >= startupNames.length) {
                  // Generate more names when reaching end
                  _generateMoreStartupNames();
                }
                return ListTile(
                    onTap: () => _toggleNameSelection(index),
                    leading: Checkbox(
                      value: namesSelected[startupNames[index]] ?? false,
                      onChanged: (value) => _toggleNameSelection(index),
                    ),
                    title: Text(startupNames[index].asPascalCase));
              })),
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                showOnlySelected = !showOnlySelected;
              }),
          tooltip: 'Show selected',
          child: showOnlySelected
              ? const Icon(Icons.filter_alt_off)
              : const Icon(Icons.filter_alt)),
    );
  }
}
