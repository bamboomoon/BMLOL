# BMLOL
仿写 掌上英雄联盟 ios 端

* 2016-3-31 完成 news板块的 topScrollView 的基本搭建，学习 coreData.完成 topScrollView 数据的存储，以及访问
* 4-10 好吧!今天都10号了.是自己太懒了  还有一个多月就要出去实习了.现在凌晨4.25 好像再写一会 不过头有点受不了.so,sleep
* 我发现 拿来写心情还不错耶!
* 更改 试图加载形式. 555:优化进入 资讯 tabbar 的时候,数据半天出不来,原因: 我 TM SB 的没在主线程刷新数据,创建 scrollImgeView 


##  掌上英雄联盟 api
* hero_list: http://ossweb-img.qq.com/upload/qqtalk/lol_hero/hero_list.js (get)
* package_info : http://ossweb-img.qq.com/upload/qqtalk/lol_hero/package_info.js (get)
* 咨询顶部：http://qt.qq.com/static/pages/news/phone/index.js （GET）
* 滚动图片：http://qt.qq.com/static/pages/news/phone/c13_list_1.shtml
navigation
* 最新： http://qt.qq.com/static/pages/news/phone/c12_list_1.shtml
* 赛事： http://qt.qq.com/static/pages/news/phone/c73_list_1.shtml
* 活动： http://qt.qq.com/static/pages/news/phone/c23_list_1.shtml
* 娱乐： http://qt.qq.com/static/pages/news/phone/c18_list_1.shtml
* 官方： http://qt.qq.com/static/pages/news/phone/c3_list_1.shtml
* 美女： http://qt.qq.com/static/pages/news/phone/c17_list_1.shtml
* 攻略： http://qt.qq.com/static/pages/news/phone/c10_list_1.shtml
* 视频： http://lol.qq.com/m/act/a20150319lolapp/video.htm?APP_BROWSER_VERSION_CODE=1&ios_version=873 

----

**4.27:**
* 完成资讯 tabBar 的所有布局.下一步:完成 navigationItem 中的 scrollView 中的按钮与内容中的 tableView 的关联逻辑
![](/Users/donglei/Documents/Ios/BMLOL4.4.0/readmeImage/Simulator Screen Shot 2016年4月27日 下午6.14.22.png
)

**4.30**
* 更改资讯 nagationitem 中的 titleVIew 策略
* 完善 咨询详情
* 增加 轮播视图 被点击事件（通过 NSNotificationCenter）
* **尝试去抓取视频的链接，但是未果**。 原因:需要验证 手机平台 和 cookie.下次再尝试

**5.7**
* 完成搜索页面
* 使用 sqlite 完成搜索历史记录
* 处理了相应的逻辑


