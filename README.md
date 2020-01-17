# wxq_flutter

![](https://upload-images.jianshu.io/upload_images/4037795-1638661f162e301f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最近开始着手做Flutter的项目，研究了一下Flutter的数据存储。
Flutter支持`Preferences`（`Shared Preferences` 和 `NSUserDefaults`） 、文件和`Sqflite`。使用时需要引入官方仓库的一些相应依赖，下面详细介绍这三种存储方式的使用方法。

#### 一、Preferences：（相当于iOS的`NSUserDefaults`和Android的`SharedPreferences`）

依赖导入步骤：

1）在`pubspec.yaml`文件下添加：
```
 # 添加sharedPreference依赖
 shared_preferences: ^0.5.0
```
2）点击`pubspec.yaml`文件右上角的“`Packages get`”按钮或者在当前`pubspec.yaml`文件目录下在终端中输入“`flutter packages get`”来同步该依赖。

3）在使用的Dart文件中引入依赖的头文件即可使用：
```
import 'package:shared_preferences/shared_preferences.dart';
```
###### pubspec.yaml文件中添加依赖方式如下图：
![添加依赖](https://upload-images.jianshu.io/upload_images/4037795-8bf909cc9f081f01.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


直接上代码：
```
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 创建一个新路由
class shared_preferences_Route extends StatefulWidget {
  @override // 重写
  State<StatefulWidget> createState() => StorageState();
}

class StorageState extends State {
  var _textFieldController = new TextEditingController();
  var _storageString = '';
  final STORAGE_KEY = 'storage_key';

  /**
   * 利用SharedPreferences存储数据
   */
  Future saveString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        STORAGE_KEY, _textFieldController.value.text.toString());
  }

  /**
   * 获取存在SharedPreferences中的数据
   */
  Future getString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _storageString = sharedPreferences.get(STORAGE_KEY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shared Preferences存储'),
      ),
      body: new Column(
        children: <Widget>[
          Text("请输入文本", textAlign: TextAlign.center),
          TextField(
            controller: _textFieldController,
          ),
          MaterialButton(
            onPressed: saveString,
            child: new Text("存储"),
            color: Colors.pink,
          ),
          MaterialButton(
            onPressed: getString,
            child: new Text("获取"),
            color: Colors.lightGreen,
          ),
          Text('shared_preferences存储的值为  $_storageString'),


        ],
      ),
    );
  }
}
```
`plist`文件中存储的数据如下图：

![plist文件路径](https://upload-images.jianshu.io/upload_images/4037795-3877a12e0746a179.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
存储内容展示：

![preferences存储](https://upload-images.jianshu.io/upload_images/4037795-04d7059316f782db.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 二、文件存储：
文件存储依赖导入方式和`Preferences`的依赖导入是一样的。依赖如下：
```
# 添加文件依赖
path_provider: ^0.5.0
```
在 Flutter 里实现文件读写，需要使用 `path_provider` 和 `dart` 的 `io` 模块。`path_provider` 负责查找` iOS`/`Android` 的目录文件，`IO` 模块负责对文件进行读写。引用的头文件如下：
```
import 'package:path_provider/path_provider.dart';
import 'dart:io';
```
###### 在`path_provider`中有三个获取文件路径的方法：
* `getTemporaryDirectory()` //获取应用缓存目录，等同iOS的`NSTemporaryDirectory()`和Android的`getCacheDir()` 方法。
* `getApplicationDocumentsDirectory()` //获取应用文件目录类似于iOS的`NSDocumentDirectory`和Android上的 `AppData`目录。
* `getExternalStorageDirectory()` //这个是存储卡，仅仅在Android平台可以使用。
 
直接上代码：
```
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// 创建一个新路由
class file_Route extends StatefulWidget {
  @override // 重写
  State<StatefulWidget> createState() => StorageState();
}

class StorageState extends State {
  var _textFieldController = new TextEditingController();
  var _storageString = '';

  /**
   * 利用文件存储数据
   */
  saveString() async {
    final file = await getFile('file.text');
    //写入字符串
    file.writeAsString(_textFieldController.value.text.toString());
  }

  /**
   * 获取存在文件中的数据
   */
  Future getString() async {
    final file = await getFile('file.text');
    var filePath  = file.path;
    setState(() {
      file.readAsString().then((String value) {
        _storageString = value +'\n文件存储路径：'+filePath;
      });
    });
  }

  /**
   * 初始化文件路径
   */
  Future<File> getFile(String fileName) async {
    //获取应用文件目录类似于Ios的NSDocumentDirectory和Android上的 AppData目录
    final fileDirectory = await getApplicationDocumentsDirectory();

    //获取存储路径
    final filePath = fileDirectory.path;

    //或者file对象（操作文件记得导入import 'dart:io'）
    return new File(filePath + "/"+fileName);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('文件存储'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("文件存储", textAlign: TextAlign.center),
          TextField(
            controller: _textFieldController,
          ),
          MaterialButton(
            onPressed: saveString,
            child: new Text("存储"),
            color: Colors.cyan,
          ),
          MaterialButton(
            onPressed: getString,
            child: new Text("获取"),
            color: Colors.deepOrange,
          ),
          Text('从文件存储中获取的值为  $_storageString'),
        ],
      ),
    );
  }
}
```
存储内容展示：

![文件存储](https://upload-images.jianshu.io/upload_images/4037795-e2afa2e69fffd28e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 三、Sqflite 数据库存储

官方说明：
```
SQLite plugin for Flutter. Supports both iOS and Android.

 Support transactions and batches
 Automatic version managment during open
 Helpers for insert/query/update/delete queries
 DB operation executed in a background thread on iOS and Android
```
意思是：`Sqflite`是一个同时支持Android跟iOS平台的数据库，并且支持标准的`CURD`操作。
使用时同样需要引入依赖：
```
#添加Sqflite依赖
sqflite: ^1.0.0
```
引入头文件：
```
import 'package:sqflite/sqflite.dart';
```
简单使用代码如下：
```
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite_Route extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StorageState();
}

class StorageState extends State {
  var _textFieldController = new TextEditingController();
  var _storageString = '';

  /**
   * 利用Sqflite数据库存储数据
   */
  saveString() async {
    final db = await getDataBase('my_db.db');
    //写入字符串
    db.transaction((trx) {
      trx.rawInsert(
          'INSERT INTO user(name) VALUES("${_textFieldController.value.text.toString()}")');
    });
  }

  /**
   * 获取存在Sqflite数据库中的数据
   */
  Future getString() async {
    final db = await getDataBase('my_db.db');
    var dbPath = db.path;
    setState(() {
      db.rawQuery('SELECT * FROM user').then((List<Map> lists) {
        print('----------------$lists');
        var listSize = lists.length;
        //获取数据库中的最后一条数据
        _storageString = lists[listSize - 1]['name'] +
            "\n现在数据库中一共有${listSize}条数据" +
            "\n数据库的存储路径为${dbPath}";
      });
    });
  }

  /**
   * 初始化数据库存储路径
   */
  Future<Database> getDataBase(String dbName) async {
    //获取应用文件目录类似于Ios的NSDocumentDirectory和Android上的 AppData目录
    final fileDirectory = await getApplicationDocumentsDirectory();

    //获取存储路径
    final dbPath = fileDirectory.path;

    //构建数据库对象
    Database database = await openDatabase(dbPath + "/" + dbName, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE user (id INTEGER PRIMARY KEY, name TEXT)");
        });

    return database;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('数据存储'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Sqflite数据库存储", textAlign: TextAlign.center),
          TextField(
            controller: _textFieldController,
          ),
          MaterialButton(
            onPressed: saveString,
            child: new Text("存储"),
            color: Colors.cyan,
          ),
          MaterialButton(
            onPressed: getString,
            child: new Text("获取"),
            color: Colors.deepOrange,
          ),
          Text('从Sqflite数据库中获取的值为  $_storageString'),
        ],
      ),
    );
  }
}

```
数据库展示：

![sqflite数据库存储](https://upload-images.jianshu.io/upload_images/4037795-6172aa8b54fd8e99.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其他方法：创建数据库、增删改查等方法如下：
```
// 获取数据库文件的存储路径
var databasesPath = await getDatabasesPath();
String path = join(databasesPath, 'demo.db');

// 创建数据库表
db = await openDatabase(path, version: 1,
       onCreate: (Database db, int version) async {
   await db.execute('''
        CREATE TABLE $tableBook (
            $columnId INTEGER PRIMARY KEY, 
            $columnName TEXT, 
            $columnAuthor TEXT, 
            $columnPrice REAL, 
            $columnPublishingHouse TEXT)
          ''');
    });

// 插入数据
Future<int> rawInsert(String sql, [List<dynamic> arguments]);

Future<int> insert(String table, Map<String, dynamic> values,
      {String nullColumnHack, ConflictAlgorithm conflictAlgorithm});


// 查询数据
Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic> arguments]);

Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset});

// 更新数据
Future<int> rawUpdate(String sql, [List<dynamic> arguments]);

Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm});

// 删除
Future<int> rawDelete(String sql, [List<dynamic> arguments]);

Future<int> delete(String table, {String where, List<dynamic> whereArgs});

// 关闭数据库
Future close() async => db.close();
```

以上就是三种存储方式的简单使用。

##### 下面贴一下`pubspec.yaml`文件中依赖包的代码：
```
name: wxq_flutter
description: A new Flutter application.

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.0+1

environment:
  sdk: ">=2.1.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.2
  #添加新的依赖
  english_words: ^3.1.3

  # 添加sharedPreference依赖
  shared_preferences: ^0.5.0

  # 添加文件依赖
  path_provider: ^0.5.0

  #添加Sqflite依赖
  sqflite: ^1.0.0

   # 引入本地资源图片
#  assets:
#    - images/pintuan.png

dev_dependencies:
  flutter_test:
    sdk: flutter


# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  # assets:
  #  - images/a_dot_burr.jpeg
  #  - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages

```
参考：
[Flutter 数据存储](https://www.jianshu.com/p/1fb8b61a85d8)
[Flutter 本地存储](https://www.jianshu.com/p/30c898123fa3)
[Flutter持久化存储之数据库存储](https://juejin.im/post/5c81e48c6fb9a049b07e2534)

简书：[Flutter 数据存储](https://www.jianshu.com/p/aeb7a769b710)
