//
//  AppDelegate.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "OpenUDID.h"
#import "Keychain.h"

#import "UMSocial.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"

#import "MobClick.h"

//#import "PetRecommendViewController.h"

//
#import "FrontImageDetailViewController.h"
#import "ResultOfSendViewController.h"
#import "LoginViewController.h"
#import "SetPasswordViewController.h"
#import "VariousAlertViewController.h"

#import "EaseMob.h"
//#import "ChatSender"

@implementation AppDelegate
-(void)dealloc
{
    [_window release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    NSLog(@"%@", [MyControl imageSizeFrom:[NSURL URLWithString:@"http:/pet4upload.oss-cn-beijing.aliyuncs.com/267_1414125022848.jpg"]]);
    
    NSString * const KEY_UDID = @"uuid4Pet";
    NSString * uuid = [Keychain load:KEY_UDID];
    
    NSLog(@"%@", uuid);
    if (uuid == nil || uuid.length == 0) {
        [Keychain save:KEY_UDID data:[OpenUDID value]];
    }
    NSLog(@"%@", [Keychain load:KEY_UDID]);
//    NSLog(@"%@", NSTemporaryDirectory());
//    [NSSearchPathForDirectoriesInDomains(NSTemporaryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    http://itunes.apple.com/us/app/id932758265
    
    [USER setObject:[Keychain load:KEY_UDID] forKey:@"UDID"];
    
    NSLog(@"UDID:%@", [USER objectForKey:@"UDID"]);
    NSLog(@"本机UUID:%@", [OpenUDID value]);

    FirstViewController * info = [[FirstViewController alloc] init];
//    SendResultViewController * info = [[SendResultViewController alloc] initWithNibName:@"SendResultViewController" bundle:[NSBundle mainBundle]];
    /*****************************/
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController1* vc =  [board instantiateInitialViewController];
//    [self presentViewController:vc animated:YES completion:nil];
    self.window.rootViewController = info;
    [info release];

    
    [UMSocialData setAppKey:@"538fddca56240b40a105fcfb"];
    //微信
    [UMSocialWechatHandler setWXAppId:@"wx8461378bbf9bda70" appSecret:@"60dd005c505bf45fe1b2e61af48e58c0" url:@"http://home4pet.imengstar.com"];
    //微博
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
//    [UMSocialWechatHandler setWXAppId:@"wx8461378bbf9bda70" appSecret:@"a5287571075736dc5760aafc1e5ff34e" url:@"http://imengstar.com"];
//    [UMSocialWechatHandler setWXAppId:@"wx8461378bbf9bda70" url:@"http://imengstar.com"];
//    [UMSocialConfig set];
//    新浪
//    阿猫阿狗
//    App Key：3262547447
//    App Secret：02dac057213bf470aed73f492b39a8aa
//    宠物星球
//    App Key：4013993168
//    App Secret：e3e8a9fde01202ea049095f79ddc904e
    
//    微信
//    AppID：wx8461378bbf9bda70
//    AppSecret：60dd005c505bf45fe1b2e61af48e58c0
    
    //渠道，策略
//  channelId为nil或@""时默认AppStore
    [MobClick startWithAppkey:@"538fddca56240b40a105fcfb" reportPolicy:BATCH channelId:nil];
    //版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //将通知数量角标归零
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //归零
//    if([UIApplication sharedApplication].applicationIconBadgeNumber){
//         [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    }
    
    /**********环信***********/
//    aps_development.cer
    NSString * apnsCertName = @"imengstar";
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"aidigame#imengstar" apnsCertName:apnsCertName];//aidigame#imengstar
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];

    [self registerRemoteNotification];
    
    //注册
//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:@"miaocuilin" password:@"123456" withCompletion:^(NSString *username, NSString *password, EMError *error) {
//        if (!error) {
//            NSLog(@"注册成功");
//        }else{
//            NSLog(@"%@", error);
//        }
//    } onQueue:nil];
    
    //登录
//    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"miaocuilin" password:@"123456" completion:^(NSDictionary *loginInfo, EMError *error) {
//        if (!error) {
//            NSLog(@"登录成功");
//
//            EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
//            NSLog(@"%@", options.nickname);
//            
//            [[EaseMob sharedInstance].chatManager setApnsNickname:@"miaocuilin"];
//            EMPushNotificationOptions *options = [[EMPushNotificationOptions alloc] init];
//            options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
//            [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {
//                if (error) {
//                    NSLog(@"%@", error);
//                }else{
//                    NSLog(@"更新成功");
//                }
//            } onQueue:nil];
    
            
//            EMChatText *text = [[EMChatText alloc] initWithText:@"hello world!"];
//            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
//            EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:@"jj" bodies:[NSArray arrayWithObject:body]];
//            retureMsg.requireEncryption = NO;
//            retureMsg.isGroup = NO;
//            [[EaseMob sharedInstance].chatManager sendMessage:retureMsg progress:nil error:nil];
//        }else{
//            NSLog(@"%@", error);
//        }
//    } onQueue:nil];
    
    
//    [ChatSendHelper sendTextMessageWithString:@"hello world!" toUsername:@"miaocuilin" isChatGroup:NO requireEncryption:NO];
//    EMChatText *text = [[EMChatText alloc] initWithText:@"hello world!"];
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
//    
//    EMMessage *msg = [[EMMessage alloc]
//                      initWithReceiver:@"miaocuilin"
//                      bodies:[NSArray arrayWithObject:body]];
//    //msg.ext = ...;
//
    
    /**********环信***********/
    
//    Class cls = NSClassFromString(@"UMANUtil");
//    SEL deviceIDSelector = @selector(openUDIDString);
//    NSString *deviceID = nil;
//    if(cls && [cls respondsToSelector:deviceIDSelector]){
//        deviceID = [cls performSelector:deviceIDSelector];
//    }
//    NSLog(@"{\"oid\": \"%@\"}", deviceID);
    
    //开启网络状况的监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name: kReachabilityChangedNotification
//                                               object: nil];
//    hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
//    [hostReach startNotifier];
    
    //判断版本号 从本地获取
    NSString * versionKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSLog(@"%@", versionKey);
    if (![[USER objectForKey:@"versionKey"] isEqualToString:versionKey]) {
        [USER setObject:@"0" forKey:@"guide_star"];
        [USER setObject:@"0" forKey:@"guide_food"];
        [USER setObject:@"0" forKey:@"guide_detail"];
        [USER setObject:@"0" forKey:@"guide_center"];
        [USER setObject:@"0" forKey:@"guide_detail_back_comment"];
        [USER setObject:@"0" forKey:@"guide_discover"];
        [USER setObject:@"0" forKey:@"guide_petmain"];
        [USER setObject:@"0" forKey:@"guide_handpick"];
        [USER setObject:@"0" forKey:@"guide_masselection"];
        [USER setObject:@"0" forKey:@"guide_handpick_recom"];
        
        [USER setObject:@"0" forKey:@"setMsgDetail"];
        [USER setObject:@"1" forKey:@"showCostAlert"];
//        [USER setObject:@"1" forKey:@"notShowVoteCostAlert"];
        [USER setObject:versionKey forKey:@"versionKey"];
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    
    //判断是否有talkData.plist文件，如果有删除
    NSFileManager * manager = [[NSFileManager alloc] init];
    NSString * path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
//    NSDictionary * dict = [NSDictionary dictionaryWithObject:@"1" forKey:@"1"];
//    [dict writeToFile:path atomically:YES];
    if ([manager fileExistsAtPath:path]) {
        BOOL a = [manager removeItemAtPath:path error:nil];
        NSLog(@"文件存在，删除结果：%d", a);
    }
    [manager release];
    
    //
    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
//        NSLog(@"%@", remoteNotification);
        
        [USER setObject:@"1" forKey:@"hasRemoteNotification"];
//        [MyControl createAlertViewWithTitle:[NSString stringWithFormat:@"启动：%@", [USER objectForKey:@"hasRemoteNotification"]]];
    }
    
    /*****************/
    //查收货地址API
//    NSLog(@"%@%@&sig=%@&SID=%@", @"http://release4pet.imengstar.com/index.php?r=animal/addressApi&aid=", @"497", [MyMD5 md5:@"aid=497dog&cat"], @"uovn0advruo160oss94cjceho0");
    /*****************/
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark -
// 连接改变
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接异常" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if(status == ReachableViaWWAN){
//        if(notAlert){
//            return;
//        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"星球检测您正在使用移动网络！" message:@"流量告急时要谨慎使用哦~" delegate:nil cancelButtonTitle:@"不再提醒" otherButtonTitles:@"省点，不刷了", @"流量多，任性", nil];
        [alert show];
        [alert release];
//        notAlert = YES;
    }
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake>>");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shake" object:self];
}
/****************************/
//自定义方法
- (void)registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
#endif
}

//系统方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken：%@", deviceToken);
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
//系统方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


//系统方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

//系统方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

//-(void)segmentClick:(UISegmentedControl *)seg
//{
//    NSLog(@"%d", seg.selectedSegmentIndex);
//    int a = seg.selectedSegmentIndex;
//    tbc.selectedIndex = a;
//    UIViewController * vc = tbc.viewControllers[a];
//    [vc.view addSubview:sc];
//}

#pragma mark -UMeng
-(void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService applicationDidBecomeActive];
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    NSLog(@"软件已经开始活动");
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
//    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[EaseMob sharedInstance] applicationWillResignActive:application];
    NSLog(@"软件进入非活动状态");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    NSLog(@"软件已经进入后台");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    NSLog(@"软件将进入前台");
}

//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
//    [USER setObject:nil forKey:@"petsData"];
    NSLog(@"软件即将关闭");
//    [USER removeAllObjects];
//    [USER setObject:@"0" forKey:@"isSuccess"];
//    NSLog(@"%@", [USER objectForKey:@"SID"]);
}
- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}
@end
//820174868e10024d4eeb2933e2e355b25505ed2e
//isSuccess:0,SID:j19otbd5ojknvjdu4rodn7kgs2