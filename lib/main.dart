import 'package:flutter/material.dart';
import 'package:wxq_flutter/FirstPage.dart';
import 'package:wxq_flutter/SharePreferencesStore.dart';
import 'package:wxq_flutter/FileStore.dart';
import 'package:wxq_flutter/SqfliteStore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 注册路由表
      routes: {
        "new_page":(context) => NewRoute(),
        "shared_preferences_page":(context) => shared_preferences_Route(),
        "file_page":(context) => file_Route(),
        "sqflite_page":(context) => Sqflite_Route(),

        "/":(context) => MyHomePage(title: 'Flutter Demo Home Page')
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
//            Image(
//              image: AssetImage("images/pintuan.png"),
//              width: 30.0,
//              height: 30.0,
//            ),
//            Image.asset("images/pintuan.png",
//              width: 30.0,
//              height: 30.0,
//            ),
            Image(
              image: NetworkImage(
                "https://static-xesapi.speiyou.cn/teach_point_home/background_img/teachpoint_home_background.png"
              ),
              width: 200.0,
            ),
            FlatButton(
              onPressed: (){
              // 导航到新路由
                Navigator.pushNamed(context, "new_page");
//                Navigator.push(context,
//                 MaterialPageRoute(
//                   // 模态视图
////                     fullscreenDialog: true,
//                     builder: (context){
//                  return NewRoute();
////                     return RouterTestRoute();
//                }));
            },
              child: Text("open new route"),
              textColor: Colors.white,
              color: Colors.black,

            ),
            FlatButton(
              onPressed: (){
                  Navigator.pushNamed(context, "shared_preferences_page");
              },
              child: new Text("Shared Preferences 存储"),
              textColor: Colors.white,
              color: Colors.black,
            ),
            FlatButton(
              onPressed: (){
                  Navigator.pushNamed(context, "file_page");
              },
              child: new Text("文件存储"),
              textColor: Colors.white,
              color: Colors.black,
            ),
            FlatButton(
              onPressed: (){
                Navigator.pushNamed(context, "sqflite_page");
              },
              child: new Text("sqflite存储"),
              textColor: Colors.white,
              color: Colors.black,
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



// 传值新界面
class TipRoute extends StatelessWidget {
  TipRoute({
    Key key,
    @required this.text, // 接收一个text参数
  }) : super(key:key);
  final String text;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("这是新界面"),
      ),
      body: Padding(
          padding: EdgeInsets.all(18),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(text),
                  RaisedButton(onPressed: () => Navigator.pop(context, "我是返回值"),
                  child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RouterTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: RaisedButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
            MaterialPageRoute(
                builder: (context) {
                  return TipRoute(
                    text: "我是提示xxx",
                  );
                },
            ),
          );
          print("路由返回值：$result");
        },
        child: Text("打开提示页"),
        ),
    );
  }
}
