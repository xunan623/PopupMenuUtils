import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 上边ListView的高度
const double _kMenuTopItemHeight = 40.0;
// 上边ListView的高度
const double _kMenuBottomItemHeight = 55;

// 控件宽度
const double _kMenuWidth = 260;

// 左右边距
const double _kMenuMarginWidth = 16;
// 上边距
const double _kMenuMarginTopWidth = 40;

// 给点击往上一个偏移量
const double _kMenuMarginTopOffset = 20;

// 中间线
const double _kMenuTopLineHeight = 1.0;
// 一排显示几个Item
const int _kItemRowCount = 5;

typedef PopupMenuUtilsItemSelected<PopupMenuItemBean> = void Function(
    PopupMenuItemBean value);

class PopupMenuUtils {
  // 自定义PopupMenuButton 位置自定义
  static popupPositioned({
    @required BuildContext context,
    @required List<PopupMenuItemBean> bottomList,
    @required Offset tapPos,
    List<PopupMenuItemBean> topList,
    PopupMenuUtilsItemSelected<PopupMenuItemBean> onSelected,
    Function itemBlock,
  }) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromLTRB(tapPos.dx, tapPos.dy,
        overlay.size.width - tapPos.dx, overlay.size.height - tapPos.dy);
    Navigator.push(
        context,
        PopupPage(
            child: PopupPositioned(
              topList: topList,
              onSelected: onSelected,
              bottomList: bottomList,
              top: position.top ?? null,
              left: position.left ?? null,
              right: position.right ?? null,
              bottom: position.bottom ?? null,
            )));
  }

}

// 继承PopupRoute可以弹出透明的布局抽象路由
class PopupPage extends PopupRoute {
  Duration _duration = Duration(milliseconds: 100);
  final Widget child;

  PopupPage({@required this.child, Duration duration}) {
    if (duration != null) {
      _duration = duration;
    }
  }

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class PopupPositioned extends StatelessWidget {
//  final Widget child;
  final List<PopupMenuItemBean> topList;
  final List<PopupMenuItemBean> bottomList;
  final PopupMenuUtilsItemSelected<PopupMenuItemBean> onSelected;

  final double left;
  final double top;
  final double right;
  final double bottom;

  PopupPositioned(
      {this.topList,
        this.onSelected,
        this.bottomList,
        this.left,
        this.top,
        this.right,
        this.bottom});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        onVerticalDragStart: (DragStartDetails details) {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
                left: _gePositionX(context),
                top: _getPositionY(context),
                height: getTotalHeight(),
                child: Stack(
                  children: <Widget>[
                    Material(
                      elevation: 3,
                      color: PopupMenuColors.color_48484F,
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                          width: _kMenuWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: (topList.length == 0 || topList == null)
                                    ? 0
                                    : _kMenuTopItemHeight,
                                child: _buildTopList(context,topList, onSelected),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 16, right: 16),
                                height: (topList.length == 0 || topList == null)
                                    ? 0
                                    : _kMenuTopLineHeight,
                                color: PopupMenuColors.centerLineColor,
                              ),
                              Expanded(child: _buildBottomList(context, bottomList, onSelected))
                            ],
                          )
                      ),
                    ),
                    _buildArrowWidget(context)
                  ],
                  overflow: Overflow.visible,
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildArrowWidget(BuildContext context) {

    double y = 0.0;
    double sHeight = MediaQuery.of(context).size.height;
    double sortTop = 0.0;
    if (this.top != null) {
      sortTop = this.top;
    } else if (this.bottom != null) {
      sortTop = sHeight - this.bottom;
    } else {
      return Positioned(child: Container());
    }

    double leftX = 16;
    double x = _gePositionX(context);
    if (this.left != null) {
      leftX = this.left - x;
    } else if (this.right != null) {
      leftX = this.right - x;
    }

    // 在下面
    if (sortTop < getTotalHeight() + _kMenuMarginTopWidth) {
      return Positioned(
        top: -8,
        left: leftX,
        child: Container(
          width: 0,
          height: 0,
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.transparent, width: 8),
                top: BorderSide(
                    color: PopupMenuColors.color_48484F, width: 8),
                right: BorderSide(color: Colors.transparent, width: 8),
                left: BorderSide(color: Colors.transparent, width: 8),
              )),
        ),
      );
    } else {
      return Positioned(
        bottom: -8,
        left: leftX,
        child: Container(
          width: 0,
          height: 0,
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.transparent, width: 8),
                bottom: BorderSide(
                    color: PopupMenuColors.color_48484F, width: 8),
                right: BorderSide(color: Colors.transparent, width: 8),
                left: BorderSide(color: Colors.transparent, width: 8),
              )),
        ),
      );
    }
  }

  // 底部按钮
  static Widget _buildBottomList(
      BuildContext context,
      List<PopupMenuItemBean> bottomList,
      PopupMenuUtilsItemSelected<PopupMenuItemBean> onSelected) {
    return Wrap(
      spacing: 0, //主轴上子控件的间距
      runSpacing: 8, //交叉轴上子控件之间的间距
      children: bottomList.map((PopupMenuItemBean item) {
        return GestureDetector(
          onTap: () {
            if (onSelected != null) {
              Navigator.of(context).pop();
              onSelected(item);
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 6),
            width: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(item.icon, width: 26, height: 26, fit: BoxFit.fill,),
                ),
                Text(
                  item.title ?? " ",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 顶部列表
  static Widget _buildTopList(BuildContext context, List topList,
      PopupMenuUtilsItemSelected<PopupMenuItemBean> onSelected) {
    if (topList == null || topList.length == 0) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        PopupMenuItemBean item = topList[index];
        if (item == null) return Container();
        return GestureDetector(
          onTap: () {
            if (onSelected != null) {
              Navigator.of(context).pop();
              onSelected(item);
            }
          },
          child: Container(
              margin: EdgeInsets.only(left: 13, right: 13),
              child: Image.asset(item.icon, fit: BoxFit.fitWidth, width: 26, height: 20,),
              ),
        );
      },
      itemCount: topList.length,
    );
  }

  // 计算x
  double _gePositionX(BuildContext context) {
    double x = 0.0;
    double sWidth = MediaQuery.of(context).size.width;
    double sortLeft = 0.0;
    if (this.left != null) {
      sortLeft = this.left;
    } else if (this.right != null) {
      sortLeft = sWidth - this.right;
    } else {
      return _kMenuMarginWidth;
    }

    if (sortLeft < _kMenuWidth/2 + _kMenuMarginWidth) {
      return x = _kMenuMarginWidth;
    } else if (sortLeft > sWidth - (_kMenuWidth/2 + _kMenuMarginWidth)) {
      return x = sWidth - _kMenuWidth - _kMenuMarginWidth;
    } else {
      return x = sortLeft - _kMenuWidth/2;
    }
  }

  // 计算y
  double _getPositionY(BuildContext context) {
    double y = 0.0;
    double sHeight = MediaQuery.of(context).size.height;
    double sortTop = 0.0;
    if (this.top != null) {
      sortTop = this.top;
    } else if (this.bottom != null) {
      sortTop = sHeight - this.bottom;
    } else {
      return _kMenuMarginWidth;
    }

    if (sortTop < getTotalHeight() + _kMenuMarginTopWidth) {
      return sortTop;
    }
    return sortTop - getTotalHeight() - _kMenuMarginTopOffset;
  }

  // 计算高度
  double getTotalHeight() {
    double height = 0;
    if (topList != null && topList.length > 0) {
      height += _kMenuTopItemHeight;
      height += _kMenuTopLineHeight;
    }
    if (bottomList != null && bottomList.length > 0) {
      int line = bottomList.length % _kItemRowCount;
      if (line == 0) {
        height += (bottomList.length ~/ _kItemRowCount) * _kMenuBottomItemHeight;
      } else {
        height +=
            (bottomList.length ~/ _kItemRowCount + 1) * _kMenuBottomItemHeight;
      }
    }
    return height;
  }
}

class PopupMenuColors {
  //// 气泡弹窗颜色
  static const color_48484F = const Color(0xff48484F);

  //// 中间线的颜色
  static const centerLineColor = const Color.fromRGBO(3, 3, 13, 0.2);
}

class PopupMenuItemBean {
  // 标题
  String title;

  // id
  String id;

  // 图片本地路径
  String icon;
}
