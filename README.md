# PopupMenuUtils

Flutter PopupMenuUtils

## 修改PopupMenu的系统弹出方式

### 展示
![UI展示](https://raw.githubusercontent.com/xunan623/xunan623.github.io/master/Flutter/%E7%B3%BB%E7%BB%9F%E5%BC%B9%E7%AA%97.png)

### 使用说明

``` dart
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

```