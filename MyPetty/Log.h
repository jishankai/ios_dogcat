/*
 ---开发日志---
 
 阿猫阿狗项目
 开始时间：2014.05.26
 开发人员：苗翠林
 
 2014.05.26-2014.05.30
 1.了解熟悉项目流程，任务，目的。
 2.搜集素材，完成瀑布流，Aviary SDK模块的实现。
 3.界面构思，开始搭建界面：首页，随机页，详情页，喜爱页，个人中心页。多次利用单例解决
   页面跳转的问题。
 4.假数据填充，并各测试模块，修复bug。
 5.添加毛玻璃效果，在未登录时进入毛玻璃登录页，使用了
    [[UIApplication sharedApplication].keyWindow addSubview:view];
   代码，弹出能够盖住导航的UI控件。
 6.细节方面的处理，优化。
 
 2014.06.03
 1.相机拍照以及状态栏颜色bug修复。
 2.搭建注册页面，2个页面平铺到一个scrollView上。选择宠物种类中用到了UIPickerView。

 2014.06.04
 1.完成新浪微博的第三方登录，能够获取用户的数据。
 2.第三方登录与app注册模块结合，最终获取到一个api字符串，用于注册。字符串中有注册时填写的各种信息+用户第三方id+SID。
 3.尝试与自家服务器交互。
 4.注册数据的填充以及界面的优化。
 
 
 2014.06.05
 1.修改注册页，添加邀请码。
 2.将注册页面衔接到项目中。
 3.个人中心页添加积分功能。
 
 
 2014.06.06-2014.06.11
 1.与服务器进行各种交互，调试注册时的严重bug。bug原因是请求API中含有中文字符，转成UTF8格式即可。
 
 
 2014.06.12
 1.修改favorite页及random页的图片加载大小及心的点击和点赞数+1。favorite页
   增加用户头像及姓名。
 2.实现其他用户主页，关注及取消关注。
 
 2014.06.13
 1.实现个人主页的关注及取消关注。
 2.实现点赞功能。
 
 2014.06.16
 1.增加照片发布时间，几分钟前，几天前等。
 2.修复详情页进入崩溃问题。random页没有返回likers参数。
 3.个人中心添加经验一项，随着经验值变化进度条变化，相关图片也跟着变化。
 4.修改一些图片，添加图片。
 5.将个人中心页点击经验或设置后隐藏照片栏。
 
 2014.06.17
 1.修复粉丝关注的实时更新。
 2.解决mantis上的部分问题。
 
 2014.06.18
 1.增加每一页的照片，头像缓存到本地。
 2.favorite等页的图片展示横向充满屏幕处理。裁剪图片再选取其中一部分。原图和小图都存放到本地。
 
 2014.06.19-2014.06.20
 1.详情页页面调整，搭建新的页面Menu
 2.修改一些崩溃bug以及逻辑设计问题。
 
 2014.06.22
 1.微博绑定，微信无法授权。
 2.更改注册页面，添加有微博的注册。
 
 2014.06.23
 1.上下拉刷新改成中文。
 2.其他人主页，点击照片跳转详情页。
 3.修改几个地方宠物类型显示的bug。
 4.调整详情页点赞位置，3.5及4寸屏第一屏都会有点赞。
 5.微博授权页面暂时没有弹出。
 
 
 2014.06.24
 1.启动登录页面及初始界面的动画。
 2.注册页面的修改。
 3.设置页微信绑定去掉。
 4.Loading状态的显示。
 5.注册页及头像更换页面添加头像编辑功能。
 6.服务器返回errorCode为-1进行弹窗通知用户。
 
 --张景瑞接管--
 2014.06.25
 1.详情页面的修改，点击以后背景变为黑色，图片在最上层
 
 2014.06.26
 1.注册后菜单页不能及时更新用户信息。
 2.注册是的完成按钮的变化
 3.关注页面好友没有图片弹出提示

 2014.06.27
 1.进入应用主页，瀑布流下方显示有空白
 2.详情页评论超过1行后显示不全。
 
 --苗翠林接管--
 2014.06.29
 1.活动3个界面的搭建。
 2.了解这3天的改动以及API的变化。
 3.修复一些小BUG，着手增加各个页面的上下拉刷新。
 
 2014.06.30
 1.menu页增加动画。
 2.活动列表页与网络交互。
 3.修改mantis上M1的bug。包括关注页的上下拉刷新以及个人主页关注，取消关注之后的跳回问题等。
 4.一些图片及界面优化的细节调整。
 5.个人主页及其他人个人主页照片的上下拉刷新。
 6.照片编辑取消后，跳回选择照片或拍照页。
 
 2014.07.01
 1.降低推荐页留白出现概率。在cell中下载完新的图片后执行reloadData。未下载图片添加默认图片来增加用户体验。
 2.活动界面的数据交互及界面完善。
 3.menu页添加消息选项以及活动，消息通知数。
 4.个人主页增加或取消关注的bug修复。
 5.mantis上M1BUG修复。
 6.开始搭建新图片上传界面。
 
 2014.07.02
 1.修复mantis上M1,M2部分bug。
 2.搭建新的图片上传界面，微博分享，微信朋友圈分享，以及设置页的选项相联系。
 3.部分图片的更换。
 4.注册时种类的bug修复。
 
 2014.07.03
 1.mantis M1bug清空，部分M2 bug修改。
 2.增加消息界面。
 3.图片大小调整，注册页部分修改。
 4.图片详情页加载时增加返回键。
 5.增加上传照片长宽比及尺寸大小限制。
 
 2014.07.04 iOS
 1.个人主页关注及粉丝增加上下拉刷新
 2.注册增加年龄限制，小于100岁。
 3.增加发布图片文字限制，不多于40个字。
 4.活动详情页添加参加活动按钮。
 5.mantis上M2 bug修复，部分崩溃问题修复。
 
 2014.07.07
 1.个人主页添加新浪微博，点击查看自己的昵称和图片。
 2.照片发布页增加同步发布到微博和微信。
 3.mantis上部分问题修改。
 4.清除缓存弹窗修改。
 
 2014.07.08
 1.毛玻璃效果的处理。
 2.iOS部分界面矫正。
 3.详情页分享功能重新搭建。
 4.部分mantis M3 bug的修复。
 5.详情页点赞之后头像立即添加，取消赞之后立即消除。
 
 2014.07.09
 1.添加消息页与网络数据的交互，添加了上下拉刷新。
 2.menu页活动及消息数实时更新。
 3.上一个版本点赞crash的修复。
 4.消息页添加删除功能，每一行左滑点击删除即可。暂不支持垃圾箱一键删除。
 5.mantis部分 M3 bug修复。
 6.详情页分享界面更改。
 
 2014.07.10
 1.照片发布页输入框位置异常的修复。
 2.推荐及关注页添加新的加载动画。
 3.照片发布页文字输入及字数提示效果的修改。
 4.注册时键盘遮挡的问题。
 5.已结束的活动修改为不可再参加。
 6.个人主页，设置，经验页的微博点击查看自己的微博，未授权时为灰色图。
 7.mantis M3部分bug修复。
 8.为适配iOS6.0系统做出部分调整。
 
 2014.07.11
 1.添加评论功能。
 2.mantis M3 bug 修改。
 3.其他人主页上滑顶栏停靠。
 
 2014.07.14
 1.解决清除缓存之后再进入详情页点赞和评论会消失的问题。
 2.发消息功能的添加，在其他人主页右上角。
 
 2014.07.15
 1.反馈页面的搭建，现在可以发送，开发人员可以看到反馈。
 2.主页菜单按钮为避免快速点击做相应限制。
 3.修改进入消息页崩溃问题，测试人员可测试一下还有没有几率崩溃。
 4.发送消息页增加空消息限制。
 5.其它人主页界面微调整。
 6.解决menu界面中，按钮亮度在非点击情况也会发亮。
 7.消息发送页点击空白处键盘收回。
 8.菜单页和其他人主页头像点击放大。
 
 2014.07.16
 1.分析内存泄露与内存警告问题。
 2.详情页顶栏头像修改为不透明。
 3.修复关注和粉丝重复的问题。
 4.进入其他人主页动画颜色及位置的修正。
 5.mantis 453，441 的修改。
 
 2014.07.17
 1.照片详情页点评论之后点分享的问题。
 2.发布页跳回到照片编辑页。
 3.修复发送消息页发送时的崩溃问题。
 4.去掉了编辑照片之后图片自动保存到本地的功能，防止系统相册出现很多杂乱的照片，影响用户体验。
 5.分享时去掉取消按钮，背景图点击让分享消失。
 6.意见反馈页面邮箱添加格式判断，添加无阻隔弹框，对键盘类型及按键的相应处理。
 7.修复mantis bug 448.

 2014.07.18
 1.解决发送消息时消息及顶栏超出屏幕外的情况。
 2.mantis bug 455,474,412,279,105。
 3.对推荐页瀑布流图片高度进行优化，避免出现很窄的图片。
 4.推荐页滑到底端自动加载更多图片。
 
 2014.07.21
 1.研究毛玻璃效果。
 
 2014.07.22
 1.评论崩溃问题及细节调整。
 2.发消息页添加背景色毛玻璃底图。
 3.在首页逻辑上进行处理，解决了进入首页之后注册用户也让重新注册的情况。
  处理逻辑：【1】当先下载完登录数据，再出现动画，动画播放完后直接跳转。
          【2】当动画播放完后，登录数据还没下载完，等数据下载完后直接跳转。
          【3】当动画播放过程中，登录数据下载完，将isLogined置为1。等播放完后判断该值为1后直接跳转，否则设置isAnimation为1.

 2014.07.23
 请病假
 
 2014.07.24
 百度地图使用步骤:
 1.打开网站http://lbsyun.baidu.com/apiconsole/key创建应用，输入bundle identifier的全称，获取AK值。
 2.创建工程，导入inc文件夹(各种头文件)、mapapi.bundle、静态库：(合并后的，终端输入lipo -create Release-iphoneos/libbaidumapapi.a Release-iphonesimulator/libbaidumapapi.a -output libbaidumapapi.a)。
   导入框架:CoreLocation,QuartzCore,OpenGLES,SystemConfiguration,Security。
 3.AppDelegate扩展名改为.mm。导入头文件 "BMapKit.h"，创建全局变量 BMKMapManager * _mapManager;
 4.//启动百度地图
 _mapManager = [[BMKMapManager alloc] init];
 BOOL ret = [_mapManager start:@"LU6Ku2Z58cjiO1DuQlid0UNp" generalDelegate:nil];
 if (!ret) {
 NSLog(@"manager start failed");
 }
 5.【疑问】百度地图如何定位自己。
 _mapView.showsUserLocation = YES;
 -(void)createLocation
 {
 _locService = [[BMKLocationService alloc] init];
 _locService.delegate = self;
 
 [_locService startUserLocationService];
 
 _mapView.showsUserLocation = NO;//先关闭显示的定位图层
 _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
 _mapView.showsUserLocation = YES;//显示定位图层
 }
 #pragma mark - 代理
 -(void)didUpdateUserHeading:(BMKUserLocation *)userLocation
 {
    [_mapView updateLocationData:userLocation];
 }
 -(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
 {
    [_mapView updateLocationData:userLocation];
 }

 2014.07.25
 1.摇一摇
 
 2014.07.28
 1.录音和播放声音实现。
 2.了解内购系统。
 
 2014.07.29
 1.主页滑动效果设计。
 2.抽屉效果。
 
 2014.07.30
 1.抽屉菜单页各页面之间的切换的研究。
 2.录音及播放音频处理。

 2014.07.31
 1.使用苹果原生定位。
 2.修正了抽屉菜单页之间切换的问题。
 3.摇一摇功能扩展，看能否识别摇动时间及幅度。（遇到问题，广场中motionBegan方法不识别）
  结果：暂时没找到有该功能。
 
 2014.08.01
 1.新增开场2个界面，增加动画效果。
 2.首页导航栏两个按钮，抽屉和相机，加入未注册判断。
 3.界面连接，开场后点击汪星或喵星进入，之后点击创建或加入进入主页，主页点击左上角打开抽屉，右上角拍照传图片。

 2014.08.04
 1.选择王国和搜索王国界面的搭建。
 2.新注册页面的搭建。
 
 2014.08.05
 1.完善新注册页面。
 2.搭建新菜单页。
 
 2014.08.06
 1.注册页面增加全国省市区的选择器。
 2.界面中一些小功能的研究。
 
 2014.08.07
 1.Xcode证书修复。
 2.选择王国页，点击王国出现该国详细信息。
 3.点击“种类”和“按系统推荐”弹出二级菜单供选择。
 
 2014.08.08
 1.注册页面漏出半边的修改，坐标调整，修正其中的几个小bug。
 2.全国各地区去掉三级目录，将第三级的直辖市改到第二级。
   bug1:刚出现时北京的区在昌平。
   bug2:北京，滑到最下边，省份滑到其他省松手，第二栏消失了。
 以上两个bug已修复。
 3.侧边栏界面按照新模板修改。
  
 
 2014.08.11
 1.宠物资料页的重新构建。
 
 2014.08.12
 1.宠物资料头像背景毛玻璃化。
 2.人气值边角处理。
 3.用户资料页面的基本架构。
 4.国家列表的cell定制。
 
 2014.08.13
 1.实现左滑cell出现2个按钮，退出国家及置顶。
 2.实现底部的弹出菜单。弹出4个按钮。
 3.点击退出国家删除此条。
 
 2014.08.14
 1.底部弹出菜单简化修改，直接弹出4个按钮。
   修改4个按钮位置并且添加相应文字。
 2.底部菜单适配4.0寸屏幕。
 3.擦除毛玻璃效果。
 
 2014.08.15
 1.看效果图，考虑其中的功能点。
 2.总结流程疑问，开会解决。
 3.考虑底部头像按钮具体应用出现问题的解决方法。
 4.工作计划的制定。
 
 2014.08.19
 1.选择登录与创建国家界面的修改
 2.首页布局的修改以及3个按钮的添加（部分未完成）
 3.截屏毛玻璃化
 
 2014.08.20
 1.首页滑动切换。
 2.选择国家界面的修改。
 
 2014.08.21
 1.注册页面修改。
 2.选择国家页面图片查看可滑动。
 
 2014.08.22
 1.选择国家搜索界面实时筛选(中文搜索未实现)。
 2.注册页面键盘弹出bug修复。
 3.侧边栏的界面修改(国家循环未实现)。
 4.照片详情页的搭建。
 
 2014.08.23
 1.国家切换。
 
 2014.08.25
 1.照片详情页搭建。
 2.我的王国第一个界面。
 
 2014.08.26
 1.我的王国剩余3个界面。
 2.底部menu大小比例修改。
 3.个人资料页第一页修改。
 
 2014.08.27
 1.个人资料剩余3个页面。
 2.侧边栏搜索功能的添加。
 3.照片发布页的修改。
 
 
 2014.08.28
 1.@用户页 勾选时button复用会出现多个勾。已解决。
 2.#话题页。
 3.#话题回传。
 4.礼物商城。
 
 2014.08.29
 1.人气榜
 2.贡献榜
 
 2014.08.30
 1.活动页面修改。详情页未改动。以后做。
 2.王国、个人资料页more功能。
 3.个人主页第7种情况添加。
 
 2014.09.01
 1.menu直接关联的页面添加50%半透明黑色alphaBtn，当侧边栏出现时出现按钮出现，防止
   用户在侧边栏点击右边界面的控件。
 2.排行榜优化。
 3.关于我们页面。
 
 2014.09.02
 1.注册api的整合。
 2.城市代号规则：4位数字代表，1000  10代表北京，00代表北京第一个区。1108中11代表天津 08代表天津第9个区。
 //

 2014.09.03
 1.注册流程的铺设。
 2.照片详情页。
 3.照片发布基本交互。
 
 2014.09.04
 1.照片详情页的交互完善。
 
 2014.09.05
 1.围观群众
 2.侧边栏。
 3.用户资料。
 4.照片发布,#话题。
 
 2014.09.06-08  中秋放假
 
 2014.09.09
 1.认养注册。
 
 2014.09.10
 1.card页面，根据aid存储到一个大字典里，然后去字典里找。
 2.侧边栏。
 3.人气排行榜。
 
 2014.09.11
 1.星球关注页。
 2.发私信略微修改。
 3.FAQ。
 
 2014.09.12
 1.对话。
 2.侧边栏国家跳转列表。
 
 2014.09.13-14
 1.消息对话的调整。
 
 2014.09.15
 //0.本地没有文件一开始进入聊天界面时拿不到新消息。
 1.进入程序取消每次请求login，当SID过期时才请求。
 2.消息界面。
 
 2014.09.16
 1.消息列表。
 2.各处头像名称上传时加上时间戳。
 3.首页推荐。
 
 2014.09.17
 1.照片详情页关注可取消。
 2.消息列表聊天后返回更新。
 3.宠物动态。
 4.评论回复。
 
 2014.09.18
 1.关注左滑可取消关注
 2.商城购买礼物，背包展示，商品排序。
 3.个人主页物品背包。
 4.限制非自己进入用户资料不能退出国家或取消关注。
 5.王冠位置的调整以及设为默认和默认的调整。
 
 2014.09.19
 1.图片详情页分享次数。
 2.设置默认宠物。
 3.照片发布页。
 
 2014.09.20
 1.活动页面（报名中、已结束）、活动参与宠物页、活动详情页（注：已结束的还没加完整）。
 2.人物主页活动照片。

 2014.09.22
 1.人物主页活动照片。
 2.话题，@用户。
 3.用户资料修改。
 
 2014.09.23
 1.榜单(因效果要求不同，放到后面重新做)。
 
 2014.09.24
 1.动态里边的礼物是null。
 2.关注的人，点击进入没有传递usr_id和petHeadImage。
 3.长按之后就长按哪都显示保存（添加在BackgroundView即可）
 4.直接进个人主页时没有宠物头像。
 5.送礼物的弹窗布局有半页是竖着排放，小圆点少一个，+人气的文字部分显示不全。
 6.禁掉录音的scrollView的左右滑动开关。
 7.摇一摇3次之后，再进入直接显示不让叫。
 8.摇一摇次数用完之后的宠物图标没有播放按钮。
 9.左上角添加返回按钮。
 10.大使和切换图标的更换。
 
 2014.09.25
 1.逗一逗。
 2.图片详情页送礼物弹窗，送完礼物已收到的礼物数+1。
 3.加载头像的时候默认名字不显示。
 4.背包列表图片显示比例。
 5.送礼物滑动在礼物上滑有问题(概率出现)。
 6.魔法棒的图片错误（plist文件编号写错了）。
 7.链接超过30秒提示链接超时(暂时以点击取消代替)。
 8.选择国家，筛选改为 “推荐”和“人气”。
 9.选择国家，所有种族根据用户点击的是喵还是汪分开。
 10.侧边栏活动数。
 11.选择价格之后点击返回灰层会被盖到底下。
 12.背包上的礼物数在退出之后消失掉。
 13.清除缓存时不删除聊天记录，背景模糊图。
 14.活动未结束的也是已结束。
 15.选择王国头像、活动详情页、参与用户页 什么都不显示。
 16.发布图片页面勾选新浪微博、微信与设置里的开关关联。
 17.发布图片页面输入框在键盘弹出后位置变化的修正。
 18.送礼物并即时更新图片已收到礼物数。
 
 2014.09.26
 1.围观群众页送礼人和点赞人的处理。
 2.照片详情页点赞效果修正，中心点不变放大2倍。
 3.照片详情页点赞和送礼之后头像列表的刷新及位置摆放修正。
 4.未注册时首页相机、星球关注、4个动作及头像、侧边栏消息、宠来宠趣，提示注册。
 5.未注册侧边栏默认头像、金币、官职、姓名，不显示等级、性别。
 6.商城未注册时点击背包、购买礼物提示注册。
 7.注册页面默认头像更换为相机。
 
 2014.09.28
 1.选择星球界面汪星图片更换。
 2.图片详情页：
 ①取消右上角的关注按钮改为时间差；
 ②未注册点击宠物头像可以进宠物主页；
 ③加载时取消性别图标的显示；
 ④点赞图标、头像角标素材的替换；
 ⑤取消#话题和@小伙伴的显示和时间的显示；
 ⑥多处注册提示的修改；
 ⑦照片描述、头像行、送礼行的半透明白色背景的添加以及高度调整。
 ⑧礼物个数颜色调整。
 3.侧边栏搜索框图像更换，文字大小颜色调整，取消按钮出现时机调整。
 4.围观群众页地址的宽度增大。
 5.两个主页的工具条背景颜色及透明度调整。
 6.人物首页列表头像及低端横线贯穿。
 7.性别图标的替换，部分界面的性别图标大小调整。
 8.个人主页金币旗子的更换。
 9.宠物主页4个栏目图标的更换。
 10.经验条的更换。
 
 
 2014.09.29
 1.登录流程处理。
 2.选择王国
 ①下拉列表显示不全的处理。
 ②两个列表同时显示的处理。
 ③推荐筛选的动作实现(服务器添加人气的API)。
 ④选择种族每次都请求API，字段是种类:type。
 ⑤上拉加载更多的添加。
 ⑥名片信息中4个展示图片的大小按比率裁剪。
 
 
 2014.09.30
 1.注册页面
 ①注册限制的调整;
 ②注册时宠物头像上传失败。
 ③创建或加入国家，注册完毕后返回首页。
 2.发布照片页面及“发布到”页面的修改及添加。
 3.宠物收到的礼物背包。
 4.首页右上角相机按钮在非主人状态会隐藏掉。
 5.设置里设置默认宠物的同时更新本地默认宠物数据。
 6.调整选择国家加入的上拉刷新逻辑。
 7.星球登录页面、宠物大使页面、侧边栏，添加穿越api。
 8.发布照片页添加@小伙伴，现在为3段式。
 9.宠物主页标题栏根据宠物种类及姓名进行相应变化。
 10.个人主页国家信息--人气、动态、成员。
 11.个人主页标题改为：(我/TA)的档案。
 
 
 2014.10.08
 1.更换默认宠物后首页头像的变化。
 2.照片详情页，只@小伙伴和没有评论、@、#的情况白条位置不对。
 3.进入程序后，登录时下载本人的所有宠物及加入的王国，存储到本地，以便后边比对，决定是摇一摇还是捣捣乱，根据本页宠物的aid和本地判断是叫一叫还是摸一摸。
 4.宠物的礼物栏图片变形。
 
 
 2014.10.09
 1.官职，包含侧边栏、宠物主页、人物主页。
 2.宠物动态效果文字的添加。
 3.侧边栏人物信息、金币数目的刷新。
 4.评论丢失的情况。
 5.侧边栏搜索结果的修正，例如“球球”;
 6.宠物主页图片点赞重复问题、鱼和骨头区分的问题。
 7.设置未注册时变灰。
 
 2014.10.10
 1.侧边栏注册完刷新，注册完上传头像后保存返回结果到tx；注册完
   之后获取默认宠物数据。
 2.宠物相册点赞数颜色问题。
 3.4个动作。
 4.个人主页的经验值、贡献值。
 5.动态文字的修改。
 6.设置去掉修改资料。
 7.反馈联系方式可选。
 8.未注册时点击活动详情、排行榜，提示注册。
 9.国王动态里的送礼绿色按钮的实现。
 
 
 2014.10.11
 1.未注册，相册点赞提示，个人主页私信提示。
 2.注册取消默认性别。
 3.首页3个页面的照片开始坐标下移，避免被选择按钮挡住。
 4.？？ios8送礼弹窗点击卡片滑动不能翻页，暂时没找到解决方法。
 5.星球关注图片、宠物相册、我的档案页活动图片、选择王国名片图片，
   比例缩放算法调整，保证图片不变形。同时压缩本地图片，减少手机
   存储。
 6.修复图片详情页在一条评论的时候闪退的情况。
 7.送礼物弹窗、 礼物商城、2个人背包、1个宠物礼物背包，捣捣乱图片角标替换。
 //mark 18：40 发包
 8.宠物和个人主页的分享功能基本实现，暂未请求分享API。
 
 
 2014.10.13
 1.注册加入别人王国宠物的默认性别没有了的修正。
 2.修改用户、宠物资料。
 3.侧边栏注册刷新。
 4.年龄格式改为，X年X月。
 5.设置中新浪微博绑定与解绑。
 6.选择王国搜索界面叉叉总出现，头像消失修正。
 
 
 2014.10.14  #71
 1.人气榜、贡献榜，找我功能及注册提示；人气月榜和周榜的崩溃问题，根据登录星球不同标题为“喵星”或“汪星”。
 2.@用户点击确定之后发图，详情页显示@用户的处理。
 3.图片详情页右上角时间位置的调整，评论及分享的图片替换。
 4.王国主页成员列表分割线到头。
 5.侧边栏消息图标替换。
 6.王国主页成员列表经纪人排在最上面。
 7.发布页comment文字输入时变黑。
 8.宠物主页，个人主页，商城，背包，送礼弹窗的人气角标位置微调。
 9.宠物主页和个人主页名字可以显示6个字以上了。
 10.星球关注列表要等5分钟才可以看到最新图片的情况。
 11.一进入选择有没有喵或者选择王国页面自动退出情况的修复。
 12.只加入一个宠物时退出联萌提示错误。
 
 
 2014.10.15
 1.宠物主页，旗子变小，动态捣捣乱高度增加，送礼物和捣捣乱文字替换。
 2.个人主页，旗子变小，经纪人后"联萌"二字去掉。
 3.照片详情页，某某回复某某长度加宽。
 4.宠物主页成员点击进入有时候崩溃有时候报异常，原因是宠物的
    头像的API用错了。
 5.年龄选择器改动X年--X个月。
 6.人气榜总榜榜单重复，日周榜没有人气值，切换日周榜后滑动崩溃。
 mark - 发包
 7.在人物主页时点击上面的小宠物头像现在可以进入宠物主页了。
 8.摇一摇和捣捣乱没有奖品情况的修复。
 9.加经验等提示显示时间已调整为1秒。
 10.无宠物用户注册成功后应跳回主页。
 11.显示搜索结果之后，点击整条应打开折叠项，最右显示加入按钮。
 12.选择王国和搜索界面剔除自己已经加入的国家。
 
 
 2014.10.16
 1.选择星球页面在用户选过之后登陆不再显示。
 2.个人主页宠物列表和关注列表点击整条进入对应联萌。
 3.主人页和宠物页段头展示人物地区和宠物类别和年龄的地方太长
   做换行处理，以免被旗子遮住。
 4.宠物页等动态加载完之后才显示加载完成。
 5.主色调橘色统一调整为fc5c3b。
 6.详情页关掉评论的自动更正及首字母大写功能。
 7.评论完后点开侧边栏必崩。
 8.点击私信崩溃。
 9.启动图片、有喵没喵图片的替换。
 10.首页3个页面起始位置的调整。
 【注】当收到系统发来的消息时打开侧边栏会崩溃。
 
 
 2014.10.17-18
 1.接收到系统消息崩溃的问题。
 2.私信问题：
 ①私信消息数，一个人连续发2条时只显示1，应该取new_msg字段相加之和。
 ②本地连续记录1个人的2条消息需按talk_id将其合并。合并在侧边栏中进行，当点击消息按钮时合并。
 ③点进消息合并时有误。
 3.贡献排行榜容错。
 4.关于我们页面。
 
 2014.10.20  【今日服务器更改为release的】
 1.私信发送有时候对方收不到。
 2.一进入聊天界面自动下翻到最后一行。
 3.聊天界面时间戳的问题，间隔1分钟才显示。
 4.系统消息的头像的添加。
 5.私信过后@用户崩溃。
 //
 6.消息页展示消息字太多后面...省略。
 7.消息页多个对话排序，整体按时间排序，有未读的整体在没未读消息之前。
 8.侧边栏去掉活动和穿越。
 9.送礼物iOS8貌似可以在卡片上滑了。
 
 
 2014.10.21
 1.第一次进入没有状态栏。
 2.文字修改：
 ①选择王国和搜索--》经纪人名片。
 ②意见反馈文本。
 ③除送礼物的3个动作。
 ④侧边栏搜索默认，未注册时头像列表位置的文字。
 3.消息页名字长度修改。
 4.用户和宠物头像、评论和回复。
 5.选择有没有喵界面修改。
 6.选择萌主页种类及年龄行加宽。
 7.常见问题的修改。
 8.欢迎页图片。
 mark 发包
 9.分享之后+-金币的情况。
 10.摸一摸之后显示崩溃。
 11.猫-》联络官，狗-》事务官。
 12.加入王国后刷新列表，否则用户可以再次点击。
 13.进领养宠物主页退出，最后一个时提示不能退。
 14.+号逻辑。
 15.侧边栏每次出现都刷新。
 
 
 2014.10.22
 1.更多按钮修改。
 2.欢迎页定2秒。
 3.设备标识改用Open UDID+Keychain来保存。
 4.4个动作的名字修改。
 5.注册完之后图片详情页更新头像。
 6.刚注册完后摇一摇和捣捣乱逻辑不对。
 mark 发包
 7.注册完点头像崩溃。
 8.Open UDID的更正。
 
 
 2014.10.23
 1.宠物主页取消关注，加入，退出国家提示框。
 2.人的主页+号，10个联萌提示。
 3.选择王国和搜索王国加入的提示。
 4.人的主页退出国家和取消关注提示。
 5.加入国家后返回个人主页刷新国家。
 6.刚注册完后金币和等级、经验的值没有。
 7.侧边栏加载完成的停留时间缩短。
 8.个人主页和宠物主页未注册也可以点开更多分享。
 mark 发包#79
 
 9.照片详情页送礼物，给Ta送个礼物，填上宠物的名字。
 10.新用户认养完后还是没有金币和等级的问题。
 11.4个动作的分享，以及微博分享文字的添加。
 12.2个主页更多按钮点亮取消。
 13.选择萌主界面中的所有种族改为“所有，喵喵，汪汪”。
 14.注册完宠物信息获取存到本地。
 15.商城礼物筛选，标头变亮取消。
 16.活动页面替换成一个“敬请期待”的提示图
 17.绿色的“摸一摸”动作链接无法点击（可以隐藏不显示）
 18.私信的发送。
 mark 发包#80
 
 19.因为注册后宠物信息不请求而从各项数据里取，tx赋值本地为空崩
 溃，master_id未赋值，主页相机没有了。
 20.launchImage更换。
 mark 发包#81
 
 
 2014.10.24
 1.界面加载开始欢迎图片没加载出来之前用本地图代替，避免因网速慢黑屏的情况。
 2.常见问题...改为+。
 3.安卓回复在ios现实A回复了A@B，改为A回复B。
 4.个人主页“经纪人”--》萌主。
 5.搜索最近的小伙伴~。
 6.个人主页设置默认宠物，限制退出默认宠物。
 7.创建2个宠物，在哪个宠物的主页发图，就在哪个圈子发。
 8.发布图片之后将图片按服务器返回的url名字存到本地。
 9.商城背包界面的微调。


 2014.10.25
 1.选择有没有喵的界面图片替换。
 
 2014.10.27-30(病假)
 
 2014.10.31
 1.点赞之后sid过期问题。
 2.余额不足之后loading消失。
 3.聊天界面用户头像点击跳转，联络官发来图片评论等消息添加
   跳转箭头。
 4.瀑布流。
 
 
 2014.11.03
 1.launchImage替换。
 2.瀑布流加载优化。
 
 2014.11.04
 1.图片上传名字的修改。
 2.图片上传大小的限制在90k以内。
 3.其他人主页+号举报。
 4.图片详情页照片及评论举报。
 5.设置黑名单。
 6.私信可删除和拉黑。
 7.拉黑举报的提示框添加。
 8.围观群众名字长度。
 9.评论+经验提示+0的情况。
 10.添加用户协议及下划线button。
 
 2014.11.05
 1.用户协议长度修正。
 2.摇一摇加入概率。
 3.宠物主页点+加入或退出圈子后刷新摇一摇和捣捣乱。
 4.关于页版本号1.0-->1.0.0，微博名称的修改。
 5.人气排行榜筛选调整。
 6.推荐API调整。
 7.侧边栏左右箭头出现情况调整。
 
 
 2014.11.06
 1.瀑布流调整。
 2.新界面萌星推荐。
 
 
 2014.11.07
 1.新界面我的萌星。
 2.萌星推荐数据填充。
 
 
 2014.11.10
 1.图片详情页围观群众头像列表限制7个。
 2.新界面加载过之后在别的地方加入圈子后时候加入按钮没变，应该在每次点击我的萌星和萌星推荐的时候自动刷新。
 3.我的萌星数据填充。
 4.宠物动态及分享文字修改。
 
 
 2014.11.11
 1.摇一摇次数没有及时更新。
 2.宠物动态去掉type=1的加入消息。
 3.宠物主页+点击之后的关注去掉。
 4.4个动作及提示框等文字修改。
 5.叫过了的页面增加分享按钮。
 6.主页搜索功能的添加（目前只能搜宠物）。
 
 
 2014.11.12
 1.点击进我的萌星和萌星推荐，不加载页面。
 2.在非我的萌星页叫一叫和摸一摸崩溃。
 3.没注册也能摸一摸。
 4.送礼弹窗。
 5.FAQ的修改。
 6.修改按钮改为图片。
 7.版本号的动态修改。
 8.我的萌星页面查看邀请码及分享。
 
 
 2014.11.13
 1.瀑布流背景。
 2.我的萌星文字修改，摸一摸和叫一叫图片区别处理。
 3.邀请码分享中邀请码的修正。
 4.去掉瀑布流中预加载的毛玻璃猫的图片。
 5.部分文字细节修改。
 6.邀请机制，注册完和设置里。
 7.图片详情页右上角三个点点击之后添加分享按钮。
 8.搜用户及宠物和用户的上拉刷新。
 9.逗一逗分享到朋友圈。
 
 
 2014.11.14 (早上被第2次reject，原因：小游戏及图片存储)
 1.图片都存储到cashes里面,排查有Document的地方替换。
 2.叫一叫没有音频的时候隐藏播放按钮。
 3.没有叫一叫上边文本{宠物名}没有萌叫叫。
 4.摸一摸如果已经摸过了去掉服务器返回的弹窗。
 5.首页3个页面都不显示最下面的快捷按钮。
 6.摸一摸的背景照片，图片-》头像-》默认头像。
 7.填过邀请码之后直接提示已填过。
 8.未注册时关于我们灰掉了。
 9.检查更新。
 10.摇一摇产出概率的修改。
 11.去掉侧边栏搜索框，增加人气榜，消息数向上提。
 12.注册页面选择有没有宠物的修改，点+号进的时候隐藏协议。
 13.部分素材替换(捧TA)。
 14.2个背包图片大小调整，
    剔除不存在id的礼物：2个主页背包，宠物主页动态null，送礼弹窗。
 15.注意在摇一摇随机的时候礼物减少了，随机数%的也少了就。
 16.礼物商城界面修改。
 
 
 2014.11.17
 1.排行榜滑动多了会崩溃，内存不足的问题。
 2.选择王国页面的捧他按钮素材替换。
 3.主页侧边栏按钮右上角添加消息数提醒气泡。
 要求：和侧边栏的提醒数目动态匹配，同时在3个页面切换或者回到这个页面的时候重新刷新数据。
 4.背包界面修改。
 5.网络状况异常提示，提示框重新做。
 6.宠物主页粉丝去掉。
 7.击败了%多少的底替换。
 8.购买礼物成功提示框修改。
 9.下载图片文件加不备份标签，调用一个官方方法。
 10.友盟统计。
 
 
 
 2014.11.18
 1.点赞问题修改。
 2.主页消息数为0还显示问题修改。
 3.排行榜头像变形且模糊修改。
 4.萌星推荐图片变形处理。
 5.未注册侧边栏“加入星球”。
 6.注册用户协议文字抖动。
 7.未注册时点击侧边栏头像提示注册。
 8.我的萌星页面图片变形处理。
 mark 发包#10
 9.宠物主页动态里的照片变形。
 10.注册选择宠物页面下拉选择框，搜索宠物页面搜索中的加入按钮，
 头像加缩略图。
 11.友盟统计自定义事件。
 12.封掉邀请机制，包括：刚注册完、设置里、我的萌星。
 13.贡献榜title颜色修改。
 14.送礼结果界面修改。
 
 
 2014.11.19
 1.首次加载显示网络异常处理。
 2.萌星推荐没有图片的过滤掉。
 3.您已经点过赞了取消显示。
 4.欢迎图4s变形适配。
 5.加入圈子提示框(萌星推荐，选择王国，搜索王国，宠物主页)。
 6.同步发送照片微博添加@宠物星球社交应用。
 7.2个主页点击头像跳转相应修改资料页面，不是自己的宠物就放大。
 8.萌星推荐点击经纪人跳转用户主页。
 9.摇一摇和萌叫叫的萌图修改。
 10.注册的箭头和键盘也可以点击。
 11.加入10个圈子后的弹框文本。
 12.设置邀请码现在没禁掉。
 13.图片详情页评论的举报按钮测服显示，通过后不显示。
 14.礼物限制>=2200的过滤,type=4或7（宠物主页动态，2个主页背包，送礼弹窗，商城背包）。
 15.个人主页去掉关注那一页。
 16.评论回复控件更换。
 mark 12
 17.设置去掉检查更新和好评。
 18.黑名单为空显示小黑屋没人~。
 19.数据请求30s超时处理。
 20.部分文字改动。
 21.发照片会发2次一样的。
 mark 13
 22.个人主页上下滑，header不跟着走。
 23.1.应该放到temp文件夹里的地方（本地录音，本地截图，毛玻璃图片，card后缀，small后缀，middle后缀）。
 
 2014.11.20
 1.图片发布时分享到微博微信时界面跳回时机。
 2.没有网络的情况下的使用。
 3.无网络，个人主页打开私信后返回崩溃。
 4.无网络，侧边栏点击圈子头像崩溃。
 5.侧边栏请求用户数据。
 6.评论结构处理。
 
 7.捧他之后加黑背景，萌星推荐页捧完之后被segment压住。
 8.修改资料无效，回来之后点头像崩溃。
 9.进入页面时网络异常提示用户是否重新请求。
 10.用户主页私信之后返回再点侧边栏私信崩溃。
 11.瀑布流图片复用闪变问题修复。

<<<<<<< HEAD
=======
 2014.11.21
 1.图片详情页的修改。
 
 
 2014.11.24
 1.loading效果修改。
 2.图片详情页修改。
 
<<<<<<< HEAD
 
 
>>>>>>> dev-miao
=======
 2014.11.25
 1.照片详情页
   ①查看大图；
   ②界面出现和消失的过渡；
   ③评论弹出高度的动态变化。
   ④正面点击卡片外的地方关闭界面。
   ⑤加大背面4个按钮点击区域。  
   ⑥点赞，送礼物，评论，分享数据的及时变动。
 2.摇一摇改版，次数及分享之后再有3次机会有待修正。
 
 
 2014.11.26
 *1.评论列表点击崩溃修正。
 2.长图背面背景tableView还是只有4行。
 3.未注册时也能举报照片。
 4.检查图片详情页的友盟统计是否有丢失，对照旧的图片详情页。
 5.宠物主页动态分页。
 6.2个排行榜默认进入昨日榜。
 7.照片详情页评论的举报按钮，只在审核版本显示。
 8.照片详情页评论的文字宽度调整，以免碰到举报按钮。
 *9.摇一摇的改版细节修正。
 mark 发包
 10.某些图打开系统异常。
 11.送礼弹窗出现之后不识别左右滑动手势。
 12.大图点击放大。
 13.取消宠物主页下端的快捷按钮。
 14.侧边栏，点击+，萌星推荐的捧，宠物主页的捧，判断是否是10个以上，如果是判断金币是否够，注册和选择圈子，搜索圈子页面同样判断个数和扣金币。
 
 
 2014.11.27
 1.退出默认圈子将贡献度第二的设为默认，先改默认再退出。（个人主页,萌星推荐页,宠物主页）。
 //退出--判断--是默认--筛选，设置默认--退出
 2.点击 宠物 “豆子”的主页崩溃，动态数为1的时候的问题。
 3.邀请码超过10个圈子不提示已满。
 4.人气榜头像闪变。
 压缩包1
 5.瀑布流图片用sd。
 6.去掉所有经验值奖励提示。
 7.+号和侧边栏点击取消超过10个的提示。
 
 
 2014.11.28
 1.瀑布流有图片变形(待测试)。
 2.摇一摇送完和送礼之后加转动动画。
 3.送礼弹窗，点击价签也送。
 4.萌星推荐图片横向列表添加预加载图片。
 5.反面如果没加载成功数据每次点击应该都去访问网络。
 6.网速慢点评论也崩，崩在cell里92行，小泰泰的一张图片。
 7.网速慢加载图片详情页图片失败之后无法返回。
 8.网速慢图片加载失败之后图片详情页崩溃。
 9.我的萌星送礼物和摇一摇，即时更新贡献度，贡献度=人气。
 
 
 
 2014.12.01
 1.手动刷新瀑布流的时候刷新私信数目。
 2.重装后送礼物及摇一摇次数重置【SID变了】。
 3.瀑布流有时候图片不见了，【应该和Height[x]有关】。
 4.每次回到瀑布流自动刷新。
 5.2个宠物，给第二个修改头像改的是默认的。
 6.摇一摇有时候不响应(改用通知的方式)。

 
 2014.12.02
 1.上传图片大小限制120k。
 2.主页3页面切换滑动不刷新，点击刷新。
 mark 发包
 3.版本号写成固定。
 4.我的萌星，我的宠物排在上边。
 5.传照片访问我的照片流无反应。
 mark 发包，submit
 6.照片详情页反过来以后，能不能默认先显示评论，如果评论为0显示礼物，礼物为0显示点赞，点赞也为0显示转发，都是0的话就还是显示评论~
 7.头像裁剪中心(2个主页)。

 
 2014.12.03
 1.界面改版。
 
 2014.12.04
 1.探索页搜索人和宠物。
 2.欢迎图传不到下个界面的修正。
 3.求口粮页面。
 4.滑动列表下边界高度的问题。
 
 2014.12.05
 1.求口粮页面滑动列表位置4s及4s以上区别调整。
 2.照片详情页底部按钮替换。
 3.总口粮数及求口粮列表数据，赏API的添加。
 4.在求口粮页面再次点击本页按钮刷新数据。
 5.改标头及背景颜色及图片。
 6.进入到照片详情页之后底部4个气泡放大效果，持续0.7秒。
 7.求口粮，现在在我的萌星页面通过我的宠物的“求口粮”，原来的“游乐园”页面进入。
 
 2014.12.06
 1.兑换页面。
 2.账号页面简单获取微信用户信息。
 3.相机图标调整，照片发布页右上角美化功能，发布按钮调整。
 4.个人中心赚金币进入小游戏界面。
 5.发现界面顶栏选择控件位置大小颜色透明度调整。
 6.NSDictionary * dic = (NSDictionary *)response.data。
 
 2014.12.08
 1.登录页面。
 2.未注册个人中心。
 3.话题，小伙伴，发布到修改。
 
 2014.12.09
 *1.账号页面。
 2.挣口粮素材更换。
 *3.多个按钮同时点亮bug修复。
 4.挣口粮发布页面：话题固定为“挣口粮”，发布到固定为对应宠物，均不可修改。
 5.个人中心未注册点击，登录按钮抖动。
 6.赏，未注册提示注册。
 7.注册时候，如果是认养不应该是@“经纪人信息”，是@“粉丝档案”。
 *8.私信会出现接收到1条消息，但是显示0条新消息。
 9.点赞列表，越点越多的bug。
 10.图片详情页，翻页时再请求反面数据。
 11.图片详情页放大效果加快一倍。
 12.在我的萌星页面点照片在底层出照片详情。
 13.账号中设置密码，切换账号。
 
 
 2014.12.10
 1.新注册弹窗。
 2.设置页面更改。
 3.设置中只保留“其他”之后的几项（不要“其他”两字）；“收货地址”和“解除黑名单”放到“账号”中“切换账号”的后边。
 4.微信微博绑定。
 5.微博微信获取不到头像。
 
 
 2014.12.11
 1.注册完成后个人主页没刷新（成功登陆后个人主页也要刷新）。
 2.提示框。
 3.兑换页面。
 
 2014.12.12
 1.兑换。
 2.bug。
 3.其他细节改动。
 
 2014.12.15
 1.照片旋转的问题。
 2.设置去掉绑定微信微博。
 3.底部4个按钮点击刷新当前页。
 4.各种bug。
 
 2014.12.16
 1.发布照片的时候写了描述再美化确定回来描述应该还存在。
 2.切换账号时提示的文本修改，点击设置密码，是修改还是设置进行区分。
 3.兑换提示框的微调。
 4.求口粮分享提示框修改。
 5.所有顶栏不遮挡。
 6.注册过的用户登录未绑定过的第三方账号提示未绑定应用账号。
 7.“赏”按钮动画，间隔2秒。
 
 2014.12.17
 1.点赞和评论加金币处理。
 2.部分页面顶部截止位置调整。
 3.赏动画间隔调整为"1.5"秒。
 4.设置里滑动效果去掉。
 5.兑换，筛选页面加其，。
 6.个人中心性别图标位置变化。
 7.引导图。
 8.banner。
 9.bug。
 
 
 2014.12.18
 1.用户经验条隐藏.
 2.私信点击整条变色，发送消息后消息到了顶栏。
 3.私信头像不显示，时间不显示。
 4.个人中心按钮上私信数字为0的情况。
 5.个人中心按钮上私信数字与消息按钮上的私信数字联动。
 6.选择萌星种类添加其他。
 7.创建萌星时网络加载提示黑框的修改。
 8.搜索人和宠物，无的时候提示框提示查无此人或宠。
 9.搜索结果起始位置调整。
 10.登录注册及微博微信登录bug修复。
 11.banner图片轮播。
 12.打赏按钮新的改版。
 13.贡献榜数据加载黑框。
 14.修改资料页面黑框。
 
 15.宠物主页,用户主页，4个tab显示高度调整。
 16.人主页切换圈子、退出圈子、举报，人和宠物主页分享，黑框。
 17.地址页面，黑名单页的黑框。
 18.APP瘦身，删除无用的图片1.1M。
 
 2014.12.19
 1.消息列表中私信有时候发不出去的问题，usr_id传的有问题。
 2.我的萌星右上角照相机，在我有创建宠物时显示。
 3.发布照片页如果记录了我上次发布的圈子默认选中是上次的，没有的话发布到我的第一个圈子（最早创建的），发布赏口粮的照片时默认选中是要挣口粮的宠物。
 4.瀑布流照片重复的问题。
 
 
 2014.12.22
 1.
 
 
 
 
 5.打赏页面图片loading效果。
 2.瀑布流展示历史图片。
 3.瀑布流上方加一个滚动显示的多图片控件，随瀑布流上下动，可能
   该控件会没有图片，瀑布流就从顶端开始。
 
 14.利用晚上时间熟悉内购流程。
 
 
 
 2.照片详情页面“...”里加“捧TA”。
 1.摇一摇过渡会看到底下的摇完界面。
 6.选择王国页面加入不显示花费多少金币。
 
 
 2.小猫发图之后刷新瀑布流崩溃。
 4.图片详情页背面点击卡片外关闭界面。
 3.所有发生金币变化的地方，本地数据进行变动。
 
 1.内存管理。
 2.crash log。
 //1.shakeShareAPI。
 //2.每次摇动请求摇动API。
 //7.榜单头像下载用缩略图减少内存。
 //1.送礼界面弹出时会空一段时间。
 
 
 
 
 
>>>>>>> dev-miao
 *********************************
 1.个人主页，我的萌星列表左滑头像变形。
 2.瀑布流问题，内存溢出。
 3.项目内存管理。
 
 
 3.聊天别人给我发变成了我自己发的，消息丢失。
 4.各种弹窗，升官，首次登陆等。
 
 5.检查更新设置里边点击还没做处理。
 2.婉莹5s摇晃通知接收不到。
 
 
 8.时间格式的修改，超过一周之后显示日期。
 9.宠物动态分页。
 //10.注册用户名重复提示，不是注册失败。
 5.侧边栏和主页金币数不一致，主页是对的。
 
 //2.网络异常返回int值，如果为0是网络问题，报网络异常；不为0的话，分情况：
 ①=1，正常。
 ②=2，state=1，显示errorMessage的内容。
 ③=3，state=2，过期。要请求loginAPI，之后重新请求原API。
 ④=4，state=3，未注册。弹未注册弹窗。
 2.刚创建完新圈子回首页叫一叫头像名字等都是原来的宠物的，没有即时更新。
 
 ****************截止：11.14*********************
 
 
 
 
 1.礼物弹窗界面修改。
 2.相册新界面。
 21.侧边栏点商城卡顿，初步测是拿礼物数据的问题，算法太麻烦。
 22.瀑布流加载线程限制、内存管理。
 
 
 2.侧边栏注册提示变窄。
 9.服务器异常统一弹“数据异常”。
 
 
 
 
 
 6.ios8和iPhone6适配。

 //
 1.捣捣乱图片替换。
 2.欢迎页面，图片加载出来之前一直显示launch页面。
 3.更换文字。
 13.连接超时提示，用浮框“暂时没有响应，请重试”
 14.加入王国注册之后快捷动作宠物头像的更新；以及侧边栏联萌
 名称的更新。
 6.提示时间出现时机。
 5.人物主页，还是会有经验超过的情况 133/120. ren006，服务器
    数据的问题，lv还是1.
 10.各种提示+经验、金币、贡献、等级、金币的处理
 在请求API的地方统一处理，判断是否有以下几个字段lv,exp,rank,gold
 
 

 
 *********
 4.每天登陆奖励提示时机不对。
 6.摸一摸每天无次数限制，摸一摸图片随机。
 
 
 
 
 
 
 *******************
 1.动态里按钮的动作。送礼已做。
 //2.捣乱礼物的角标替换。
 3.宠物资料页设为默认点了没反应。
 4.两个主页的分享。
 5.更换资料。
 6.loading效果。
 7.消息、未读消息、系统消息。
 8.侧边栏头像1个、2个居中，3个及以下没有箭头。
 9.人为筛选王国成员列表，主人在顶层。
 10.x岁x个月。
 11.选择王国筛选出图片也有名片和加入。
 
 
 ******待修改********
 //1.主页的旗子。
 //2.列表间的横线，封到头。
 //3.经验条。
 4.！！摇一摇，捣捣乱崩溃。
 5.！！发布照片崩溃。
 
 /************************************
 1.注册、加入王国、发照片、评论、点赞、屏幕滑动流畅。
 2.蒙版、瀑布流。
 
 3.活动、商城、榜单可以先干掉。
 ************************************/


 /************9.23会议*****细节修改**********
 一、首页
 1.首页滑动或点击都提示注册。
 //2.首页显示宠物推荐，不是宠物广场。
 
 二、侧边栏
 1.未注册可以打开侧边栏。
 2.未注册时，金币初始值为500，名字是游荡的两脚兽，官衔是陌生人。
 3.侧边栏国家列表，小于4个不显示左右箭头，小于3个要居中。
 //4.活动数。
 //5.底层毛玻璃有没有。
 6.点击消息，未注册时的弹窗在屏幕中心而不是侧边栏弹出的中心。
 7.消息数，请求listApi，有新的就+上相应的数目，点进去之后有几个没显示本地要保存，直到点某一个对话进入之后该数字才清零，相应的本地未读消息数要减去相应值。
 
 
 三、商城
 1.未注册也可以进入。
 2.未注册点击背包、购买礼物弹出注册提示框。
 3.筛选类别变化，相应的筛选结果变化。
 //4.背包上的礼物数在退出之后消失掉。
 //5.选择价格之后点击返回灰层会被盖到底下。
 
 
 
 四、选择注册国家(ChooseIn)和选择国家(ChooseFamily)
 //1.左上角添加返回按钮。
 //2.大使和切换图标的更换。
 3.点击放大镜之后直接获取搜索的焦点(所有有放大镜的地方都这样处理)。
 4.筛选完种族之后如果数据为空，显示一个图片提示，美工给图。
 5.注册完之后返回主页。
 6.头像什么都不显示。
 /--------------------/
 //1.筛选改为 “推荐”和“人气”。
 //2.所有种族根据用户点击的是喵还是汪分开。
 
 
 五、设置
 1.前两段，未注册，不让点击。
 2.新浪微博绑定。
 //3.常见问题的段头去掉，具体条目有时候没有。
 //4.清除缓存时不删除聊天记录，背景模糊图。
 5.收货地址进入之后不显示保存，编辑之后再显示。
 
 
 六、穿越
 1.此版本是有的。
 
 七、宠物主页
 1.未注册是可以进入的，分享是可以的。
 2.导航栏标题变成 宠物名+国/族。
 //3.动态里边的礼物是null。
 //4.关注的人，点击进入没有传递usr_id和petHeadImage。
 5.关注的人点进去之后该宠物的4个列表信息有问题，主人头像也没有。
 6.宠物图片放大效果有问题，点赞的鱼和骨头。
 7.宠物王国动态 送礼物和捣捣乱 的说明的添加。
 8.动态的文本会变。
 
 
 八、图片详情页
 1.未注册是可以分享的。
 2.评论刷新。
 //3.评论最新的放上边。
 //4.评论默认文本“写个评论呗”。
 5.评论可能会丢失。
 //6.评论的话题和@用户如果用户没有的话就不显示。
 //7.加载头像的时候默认名字不显示。
 //8.长按之后就长按哪都显示保存（添加在BackgroundView即可）
 9.分享完之后次数的变化。
 //10.送礼物并即时更新图片已收到礼物数。
 //11.送礼物之后头像的即时更新(服务器会处理重复情况，但我点赞并送礼之后围观群众页服务器就屏蔽掉我点赞的了)。
  
  
 九、排行榜
 1.未注册可以进入，点我提示注册。
 
 十、注册页面
 1.注册页面头像默认是照相机。
 2.宠物性别默认不选中。
 3.宠物年龄用picker选择几年几月。
 4.两个名字都限制8个汉字。
 
 十一、注册搜索宠物
 1.搜索完之后文字变成取消。
 2.选择栏被遮住。
 3.某些头像图片无法显示。
 4.无法搜索中文。
 5.下拉框不让同时显示，下拉之后点击其他地方下拉框消失。
 6.注册完之后跳回主页，而不是跳回选择王国页。
 7.点击搜索结果行也显示4个图片，右边有加入按钮。
 
 十二、宠物关注
 1.点赞。
 2.点赞是鱼还是骨头取决于该照片的宠物是猫还是狗。
 
 
 十三、个人主页
 //1.直接进个人主页时没有宠物头像。
 2.等级和经验数目的更改。
 3.4个tv的背景是统一颜色。
 4.第一栏点击整条进入宠物的主页，官职的显示，送礼物等的按钮的点击事件。
 5.上下拉刷新。
 6.点+号之后进入选择又还是没有喵，之后再回个人主页。
 7.第二栏关注，加入改王国之后自动关注，点击整条进入该国家。
 8.活动显示空列表，显示一个热气球。
 9.标题变成我的资料和TA的资料。
 10.进入别人个人主页时可能会报错。
 11.设为默认。
 //12.背包列表图片显示比例。
 
 十四、四个动作
 1.摇一摇和摸一摸在其他人的主页，送礼物要送给该宠物，摸一摸变成叫一叫。
 //2.送礼物的弹窗布局有半页是竖着排放，小圆点少一个，+人气的文字部分显示不全。
 //3.禁掉录音的scrollView的左右滑动开关。
 4.给自己宠物送礼物有时候会出现-人气的礼物。
 //5.摇一摇3次之后，再进入直接显示不让叫。
 //6.摇一摇次数用完之后的宠物图标没有播放按钮。
 //7.逗一逗。
 //8.送礼物滑动在礼物上滑有问题(概率出现)。
 //9.魔法棒的图片错误（plist文件编号写错了）。
 10.摇一摇，捣捣乱崩溃。
 
 十五、Loading动画
 1.链接超过30秒提示链接超时(暂时以点击取消代替)。
 
 
 十六、活动列表
 1.活动未结束的也是已结束。
 
 
 十七、发布照片
 1.同时发布到多个圈子没有实现。
 
 
 ***************************/




 /*Zhangjr
 1.摇一摇。
 2.活动瀑布流。
 3.官职，经验，人气增加弹窗。
 */
/*iOS
 1.聊天时间，消息接收。
 2.首页推荐页。
 3.宠物第4栏，礼物盒。
 4.从国家成员页里跳转到他人主页没有usr_id。
 5.个人主页：退出国家，设置默认宠物。
 6.两个主页的微博，微信，朋友圈分享。
 7.官职，等级的更换。
 8.动态。
 9.穿越。
 10.切换默认国家。
 11.充值。
 12.送礼物。
 13.评论回复。
 */
 
 /*
 1.活动页面。
 2.对话。
 //4.1个榜单。
 8.侧边栏王国的搜索。
 //9.侧边栏国家跳转。
 //11.侧边栏个人头像跳转个人中心。
 12.用户资料第一栏左滑头像变形。
 14.接受一次性3次消息顺序会乱。
 
 3.商城。
 5.首页3个页面剩余的1个页面。
 6.@用户。
 7.内购。
 10.设置页面分支。
 13.SID的问题。
 */
 
 
 /*********************测试结果************************
王妍的测试：
Ios界面样式测试，机型4s

侧边栏：
搜索条在未输入的状态下不显示取消，应是点击之后再显示取消
放大镜图标太靠左了
背景应是毛玻璃效果
设置项显示不出穿越来，也不能向上滑动
设置项按住不放时的深色底高度不够

商城
价格选择“由高到低”之后再点击“由高到低”时最上面一栏应变为价格（参考安卓）

排行榜
高度应为普通项的1.5倍
选择日榜月榜的下拉菜单应取消阴影

我的王国
用户资料
创建王国的“+”应为居中显示

照片详情
页面显示不全，向上滑动时滑不到底部，看不到最下面评论和其他内容
/*********************测试结果(已解决)************************/
 /*
  1.设置收货地址
  保存按钮太小了

  2.
 */

 
 
 
 
 
 
 
 
 
 
 
 
 
 /*********************流程疑问**********************
 1.登录星球页效果。   地球周期性跳动，两个云彩移动。
 2.创建王国效果。
 3.注册页面可以不传头像注册么。  有默认头像。注册完进我的王国。
 4.选择王国两个下拉菜单的具体文字。
 5.加入跳注册页面自动填充第一页是吧？  是。
 6.国家详情有可以点的地方么。  图片点击放大，可以左右切换。点头像进主页。
 7.首页按钮只能点，不能不能滑吧。点击变橙色？  首页3个页面滑动切换。照片按钮只有主人登录时才有。
 8.底部4个按钮分别调到的页面还没给。  4个按钮做动作是对当前页面。需加判定。
 9.侧边栏各个按钮及国家切换具体效果。
 10.照片详情页各个按钮的功能。
 11.围观群众送礼物和发私信。
 12.我的王国。7个效果。       点头像进入自己主页。
 13.用户资料活动页解释。
 14.所有界面都是顶栏85%半透明橙色么？  是。
 15.设置页面底层图片是固定的么？同步开关默认开启么？
 16.收货地址3栏是么？  2栏
 17.各个弹窗出现的时机。  
 18.商城滑动效果？右上角是购物车么？
 19.人气榜与贡献榜的效果。
 20.发布照片页。
 21.@用户页。

 
 
 **************************************************/
 
 /***********************计划************************
   1.选择登录与创建国家。        1天。
   2.注册页面。                 半天。
   3.选择王国2个页面修改。       1天。
   4.主页瀑布流上3个悬浮按钮。    半天。
   5.侧边栏图标修改及国家切换效果。 半天。
   6.照片详情页。                1天。
   7.围观群众页。                3小时。
   8.我的王国界面4个选项。        2天。
   9.用户资料各个选项。           2天。
 
   11.设置页面。                1天。
   12.收货地址，意见反馈。        1天。
   13.消息界面，聊天界面。        1天。
   14.加金币弹窗，登录奖励弹窗，送礼物弹窗。  1天。
   15.礼物商城。                 2天。
   16.礼物详情页。               半天。
   17.人气榜，贡献榜。            2天。
   18.照片发布页，话题，用户页。    2天。
   19.底部菜单4个页面。           2天。
   20.内购功能                   2天。
  
   10.活动界面及详情页。          2天。
 约26天。
 **************************************************/


//未完成
/*
 5.tableView上滑过程中切换会出bug。(未解决)可以在滑动中关闭按钮交互。
 7.摸一摸做成一个毛玻璃，慢慢擦除之后就任务完成。
 9.国家的切换。
 10.宠物种类plist文件服务器取消回传，自己创建本地plist文件存储和取用。
 
 
 *******************未完成的任务**********************
 优先完成顺序：8,5,6,7,13,2,1。
 
 1.点赞红心会乱。                          半天
 //2.注册后菜单页不能及时更新用户信息。          半天
 //3.关注页增加上下拉刷新，尝试用MJRefresh。    半天
 4.瀑布流的改善。                          半天到一天
 //5.注册和可以换头像的地方增加头像编辑功能。     1-2小时
 6.点赞列表进入我的个人中心崩溃。              2小时
 //7.进入各个界面加载数据时显示Loading界面。     半天到一天
 //8.注册页面修改，直接注册。                   2-3小时
 //9.主页面展示服务器返回的图片，增加放大效果。    2小时
 10.注册重名，用毛玻璃view显示，盖在上层。      2小时-半天
 //11.修改照片投稿页。                         2-3小时
 12.设置页，反馈等信息的完善。                 半天
 //13.每次请求服务器数据，如果返回errorCode为-1都要弹窗，显示。  2-3小时。
 
 14.界面优化，动画效果的添加。
 15.代码优化，减少app体积，减少流量的使用。
 16.用户体验的修改，各种bug调试。
 17.中途更改需求预留时间。            14-17项所用时间视当时情况而定，暂定一周。
 
 由于25-27号要回学校参加毕业典礼，耽误3天，暂定上线时间2-3周，突发事件除外。
 
 补充：
 1.经验值的地方增加还差多少经验升级的Label。
 //2.开机启动图片，每天一换，检测本地图片是否跟要显示的一致，不一致，下载图片，并保存到本地。
 //3.详情页评论超过1行后显示不全。
 4.详情页可以识别重力感应。
 //5.菜单里，活动页面的添加。
 //6.各个地方图片超过10或30张的要请求更多API。
 7.推荐页列表由于两边不等长，有空白，要求请求到空白处就请求下一组数据。  &&&&&重要&&&&&&
 //8.下拉时上拉会崩溃。尝试free试试。
 9.关注页和详情页之间点赞切换还是有问题，不能及时更新，再有详情页点赞之后下面点赞人的现实也要及时更新。
 10.推送的添加。
 11.消息页面，活动详情页，反馈，注册页面修改，查看微博界面，输入密码找回界面。
 //12.新照片发布页的评论框位置变化异常。
 //13.菜单头像应该不透明
 14.自己关注或取消关注别人后一定要刷新关注页及个人首页。
 //15.照片详情页点赞之后重影了。底层的没有销毁。
 16.网络不好时推荐页的下拉刷新会卡住。
 //17.加载的时候加一个毛玻璃或半透明背景。
 18.点赞或取消赞之后进入参与用户页没有添加或删除自己。
 19.页面的虚化效果。
 20.点赞放大效果。
 21.发布-》取消授权-》发布快速重复3次会崩溃，提示message sent to deallocated instance.已向友盟邮箱发送邮件。
 //22.详情页图片太小的话无法充满屏。

 //23.清除缓存之后再进入详情页点赞和评论会消失。
 24.有时会出现进入大图白屏的情况，1分钟后会出结果。
 25.出现重新注册的情况，原因是loginApi未请求完。isSuccess的值为0.
 
 ***********新功能***************
 26.添加内购系统，涉及支付。
 27.LBS系统，搜索附近人等。
 28.连连看，2048等小游戏，玩会增加玩家经验，移植进APP即可。
 
 29.增加国王，丞相，将军等官职。
    4个功能点：送礼品、叫一声(摸一摸)、摇一摇、遛一遛。
    宠物点值：人气值、体力值。
    主人点值：金币、经验值、贡献值
    其   它：人气榜，贡献榜，最新动态，各种动画效果。
 
 
 *******************未完成的任务**********************
 */
