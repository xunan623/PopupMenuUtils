import 'package:PopupMenuUtils/popup_menu_utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  Offset tapPos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onTapDown: (TapDownDetails details) {
          tapPos = details.globalPosition;
        },
        onLongPress: () {
          _addPopupMenu();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '长按我',
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addPopupMenu() {

    List<PopupMenuItemBean> topList = List();
    PopupMenuItemBean item = PopupMenuItemBean();
    item.title = "点赞";
    item.id = "点赞value";
    item.icon = "images/business_live_menu_zan.png";
    topList.add(item);

    List<PopupMenuItemBean> bottomList = List();
    List<Map<String, String>> bottomListData = [
      {"title": "复制", "id": "复制id", "icon": "images/business_live_menu_copy.png"},
      {"title": "回复", "id": "回复id", "icon": "images/business_live_menu_reply.png"},
      {"title": "添加表情", "id": "添加表情id", "icon": "images/business_live_menu_emoji.png"},
      {"title": "撤回", "id": "撤回id", "icon": "images/business_live_menu_back.png"},
      {"title": "举报", "id": "举报id", "icon": "images/business_live_menu_report.png"},
      {"title": "屏蔽", "id": "屏蔽id", "icon": "images/business_live_menu_shielding.png"},
      {"title": "封禁", "id": "封禁id", "icon": "images/business_live_menu_forbidden.png"},
    ];

    bottomListData.forEach((Map item) {
      PopupMenuItemBean bottomItem = PopupMenuItemBean();
      bottomItem.title = item["title"];
      bottomItem.id = item["id"];
      bottomItem.icon = item["icon"];
      bottomList.add(bottomItem);
    });

    if (bottomList.length == 0) return;

    PopupMenuUtils.popupPositioned(
      context: context,
      topList: topList,
      bottomList: bottomList,
      tapPos: tapPos,
      onSelected: (PopupMenuItemBean item) {
        print(item.title);
      },
    );

  }
}
