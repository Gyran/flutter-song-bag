import 'package:flutter/material.dart';
import "dart:math";
import 'package:flutter/animation.dart';

// generates a new Random object
final _random = new Random();

void main() => runApp(MyApp());

class Song {
  final String name;
  final String assetName;

  const Song({this.name, this.assetName});
}

const List<Song> songs = [
  const Song(
    name: 'Imse vimse spindel',
    assetName: 'assets/spider.jpg',
  ),
  const Song(
    name: 'Liten tomte tittar ute',
    assetName: 'assets/santa.png',
  ),
];

class AnimatedSongImage extends AnimatedWidget {
  AnimatedSongImage({Key key, Animation<double> animation, this.song})
      : super(key: key, listenable: animation);

  final Song song;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    print("building animation ${animation.value}");

    return Image.asset(
      this.song.assetName,
      height: animation.value,
      width: animation.value,
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sångpåsen',
      home: SongBagScreen(),
    );
  }
}

class SongBagScreen extends StatefulWidget {
  @override
  _SongBagState createState() => _SongBagState();
}

class _SongBagState extends State<SongBagScreen>
    with SingleTickerProviderStateMixin {
  Song _song;
  AnimationController controller;
  Animation<double> animation;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 300.0).animate(controller);
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  void _bagPressed() {
    controller.forward();
    setState(() {
      var song = songs[_random.nextInt(songs.length)];
      _song = song;
    });
  }

  void _closeSongPressed() {
    setState(() {
      _song = null;
    });
    controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (this._song != null) {
      body = Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: this._closeSongPressed,
              )
            ],
          ),
          Center(
              child: AnimatedSongImage(
            animation: animation,
            song: this._song,
          )),
        ],
      );
    } else {
      body = Center(
          child: FlatButton(
              child: Image.asset('assets/bag.png'),
              onPressed: this._bagPressed));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('First Screen'),
        ),
        body: body);
  }
}

class SongScreen extends StatelessWidget {
  SongScreen({Key key, this.song}) : super(key: key);

  final Song song;

  @override
  Widget build(BuildContext context) {
    print('wioo');
    print(this.song);

    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(child: Image.asset(this.song.assetName)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
