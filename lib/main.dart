/*
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(primaryColor: Colors.blue),
        home: MyHomePage(
          title: 'flutter demo home page',
        ));
  }
}

//StatefulWidget 类；
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  String title;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

//状态类 StatefulWidget 类本身是不变的，但是 State类中持有的状态在widget生命周期中可能会发生变化。
class _HomePageState extends State<MyHomePage> {
  // 保存 计数的值
  int _counter = 0;

  */
/**
 *设置 一个函数;当按钮点击时，会调用此函数，该函数的作用是先自增_counter，然后调用
 * setState 方法。
 * setState方法的作用是通知Flutter框架，有状态发生了改变，
 * Flutter框架收到通知后，会执行build方法来根据新的状态重新构建界面
 **/ /*


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('为你计入了'),
            new Text(
              '$_counter',
              style: TextStyle(color: Colors.deepOrangeAccent, fontSize: 16.0),
            ),
            //路由跳转
            RaisedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AnotherRouter();
                }));
              },
              child: Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        backgroundColor: Colors.green,
        tooltip: '点击计数',
        child: Icon(Icons.add),
      ),
    );
  }
}

class AnotherRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新的界面')),
      body: Center(
        child: Text('这是一个新的界面'),
      ),
    );
  }
}
*/

// Create an infinite scrolling lazily loaded list

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set(); //被选中的
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          //生成 rows
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          //分界线
          final List<Widget> divided = ListTile.divideTiles(
            color: Colors.red,
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  //列表 widget
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return const Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }
// 列表中的row widget
  Widget _buildRow(WordPair pair) {
    // 判断是否存在已选中的集合中
    final bool alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
