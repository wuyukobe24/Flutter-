import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// 创建一个新路由
class NewRoute extends StatelessWidget {
  @override // 重写
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("WangXueqi"),
      ),
      body: Center(
        child: Text("this is new router from wangxueqi"),
      ),
    );
  }
}
