//
//  ControllerManager.m
//  MyPetty
//
//  Created by Aidi on 14-5-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ControllerManager.h"
#import "RandomViewController.h"
#define DEFAULT_VOID_COLOR [UIColor whiteColor]
#import <CoreText/CoreText.h>


@implementation ControllerManager

static RandomViewController * rvc = nil;
static UINavigationController * nc1 = nil;
//static UINavigationController * nc2 = nil;
//static UINavigationController * nc3 = nil;

static NSUserDefaults * user = nil;
static NSString * SID = nil;
static int isSuccess;

static LoadingView * load = nil;
static PopupView * pop = nil;

static NSOperationQueue * queue = nil;

MBProgressHUD *HUD;

static FirstTabBarViewController * tabBar = nil;

static NSInteger checkUpdate;
static UIImageView *catLoadingImageView = nil;

+(id)shareManagerRandom
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rvc = [[RandomViewController alloc]init];
        nc1 = [[UINavigationController alloc] initWithRootViewController:rvc];
    });
    return nc1;
}

+(id)shareUserDefault
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[NSUserDefaults alloc] init];
    });
    return user;
}
+(void)setIsSuccess:(int)a
{
    isSuccess = a;
}
+(int)getIsSuccess
{
    return isSuccess;
}
+(void)setSID:(NSString *)str
{
    SID = str;
}
+(id)getSID
{
    return [SID retain];
}

+(void)startLoading:(NSString *)string
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithStatus:string];
}
+(void)loadingSuccess:(NSString *)string
{
    [MMProgressHUD dismissWithSuccess:string];
}
+(void)loadingFailed:(NSString *)string
{
    [MMProgressHUD dismissWithError:string];
}


+(id)shareTabBar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [[FirstTabBarViewController alloc] init];
    });
    return tabBar;
}

+(id)shareLoading
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        load = [[LoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        load.frame = [UIScreen mainScreen].bounds;
//        [load makeUI];
    });
    [load startAnimation];
    return load;
}
+(id)sharePopView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pop = [[PopupView alloc] init];
    });
    return pop;
}
//+(id)shareSliding
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        sliding = [[NTSlidingViewController alloc] init];
//        RandomViewController * rvc = [[RandomViewController alloc] init];
//        FavoriteViewController * fvc = [[FavoriteViewController alloc] init];
//        SquareViewController * svc = [[SquareViewController alloc] init];
////        RewardViewController * vc = [[RewardViewController alloc] init];
////        sliding = [[NTSlidingViewController alloc] initSlidingViewControllerWithTitle:@"推荐" viewController:rvc];
////        [sliding addControllerWithTitle:@"推荐" viewController:rvc];
////        [sliding addControllerWithTitle:@"关注" viewController:fvc];
////        [sliding addControllerWithTitle:@"广场" viewController:svc];
////        [sliding addControllerWithTitle:@"奖励" viewController:vc];
//    });
////    return sliding;
//}

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//每一行作为一个元素存到数组中返回
+ (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


#pragma mark - 金币、星星、红心弹窗
+ (void)HUDText:(NSString *)string showView:(UIView *)inView yOffset:(float) offset
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    //    HUD.minSize = CGSizeMake(string.length * 5, 30);
    HUD.minSize = CGSizeMake(200, 30);
    HUD.margin = 10;
    HUD.labelText = string;
    
    HUD.mode =MBProgressHUDModeText;
    [HUD show:YES];
    HUD.yOffset = offset;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    [HUD hide:YES afterDelay:1.0];
}

+ (void)HUDImageIcon:(NSString *)iconImageString showView:(UIView *)inView yOffset:(float)offset Number:(int)num
{
    HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [inView addSubview:HUD];
    HUD.minSize = CGSizeMake(130, 60);
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.yOffset = offset;
    HUD.margin = 0;
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 42, 42)];
    [totalView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 70, 30)];
    label.text = [NSString stringWithFormat:@"+ %d",num];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentLeft;
    [totalView addSubview:label];
    HUD.customView = totalView;
    HUD.color = [UIColor colorWithRed:247/255.0 green:243/255.0 blue:240/255.0 alpha:1];
    UIImage *imageBG = [UIImage imageNamed:iconImageString];
    imageView.image = imageBG;
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.0];
    
}

//+ (void)loginHUDAlertView:(UIView *)showInView
//{
//    HUD = [[MBProgressHUD alloc] initWithWindow:showInView.window];
//    [showInView.window addSubview:HUD];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.color = [UIColor clearColor];
//    HUD.dimBackground = YES;
//    HUD.margin = 0 ;
//    HUD.removeFromSuperViewOnHide = YES;
//    
//    
//    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 0, 290, 215)];
//    bodyView.backgroundColor = [UIColor clearColor];
//    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 215)];
//    alphaView.backgroundColor = [UIColor whiteColor];
//    alphaView.alpha = 0.8;
//    [bodyView addSubview:alphaView];
//    bodyView.layer.cornerRadius = 10;
//    bodyView.layer.masksToBounds = YES;
//    //创建取消和确认button
//    
//    UIImageView *cancelImageView = [MyControl createImageViewWithFrame:CGRectMake(250, 5, 30, 30) ImageName:@"button_close.png"];
//    [bodyView addSubview:cancelImageView];
//    
//    UIButton *cancelButton = [MyControl createButtonWithFrame:CGRectMake(250, 5, 30, 30) ImageName:nil Target:self Action:@selector(cancelAction) Title:nil];
//    cancelButton.showsTouchWhenHighlighted = YES;
//    [bodyView addSubview:cancelButton];
//    
//    UILabel *sureLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2-50, 160, 100, 35) Font:16 Text:@"确认"];
//    
//    sureLabel.backgroundColor = BGCOLOR;
//    sureLabel.layer.cornerRadius = 5;
//    sureLabel.layer.masksToBounds = YES;
//    sureLabel.textAlignment = NSTextAlignmentCenter;
//    [bodyView addSubview:sureLabel];
//    
//    UIButton *sureButton = [MyControl createButtonWithFrame:sureLabel.frame ImageName:nil Target:self Action:@selector(sureAction) Title:nil];
//    sureButton.showsTouchWhenHighlighted = YES;
//    [bodyView addSubview:sureButton];
//    UILabel *askLabel1 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 -80, 40, 160, 20) Font:16 Text:@"确定加入一个新国家？"];
//    askLabel1.textColor = [UIColor grayColor];
//    [bodyView addSubview:askLabel1];
//    UILabel *askLabel2 = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 80, 70, 160, 20) Font:16 Text:@"这将花费您 100"];
//    
//    
//    askLabel2.textColor = [UIColor grayColor];
//    [bodyView addSubview:askLabel2];
//    
//    UIImageView *coinImageView = [MyControl createImageViewWithFrame:CGRectMake(bodyView.frame.size.width/2 +35, 63, 30, 30) ImageName:@"gold.png"];
//    [bodyView addSubview:coinImageView];
//    
//    UILabel *descLabel = [MyControl createLabelWithFrame:CGRectMake(bodyView.frame.size.width/2 - 120, 130, 230, 20) Font:13 Text:@"星球提示：每个人最多加入10个圈子"];
//    descLabel.textColor = [UIColor grayColor];
//    [bodyView addSubview:descLabel];
//    HUD.customView = bodyView;
//    [HUD show:YES];
//}

#pragma mark - 返回方法
+(NSString *)returnCateNameWithType:(NSString *)type
{
    NSString * str = nil;
    int a = [type intValue];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
    if (a/100 == 1) {
        str = [[dict objectForKey:@"1"] objectForKey:type];
    }else if(a/100 == 2){
        str = [[dict objectForKey:@"2"] objectForKey:type];
    }else if(a/100 == 3){
        str = [[dict objectForKey:@"3"] objectForKey:type];
    }else{
        str = @"苏格兰折耳猫";
    }
    return str;
}
+(NSString *)returnCateTypeWithName:(NSString *)name
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
//    NSMutableArray * mutableArray = [NSMutableArray arrayWithCapacity:0];
//    NSDictionary
    NSDictionary * dict1 = [dict objectForKey:@"1"];
    NSDictionary * dict2 = [dict objectForKey:@"2"];
    NSDictionary * dict3 = [dict objectForKey:@"3"];
    for (NSString * key in [dict1 allKeys]) {
//        NSLog(@"%@", dic);
        if ([[dict1 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    for (NSString * key in [dict2 allKeys]) {
        if ([[dict2 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    for (NSString * key in [dict3 allKeys]) {
        if ([[dict3 objectForKey:key] isEqualToString:name]) {
            return key;
        }
    }
    
    return nil;
}
+(NSString *)returnProvinceAndCityWithCityNum:(NSString *)cityNum
{
    NSString * province = nil;
    NSString * city = nil;
    int code = [cityNum intValue];
    int pro = code/100-10;
    int cit = code%100;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
//    NSLog(@"%@", dict);
    NSDictionary * dictPro = [dict objectForKey:[NSString stringWithFormat:@"%d", pro]];
    province = [[dictPro allKeys] objectAtIndex:0];
    
    NSDictionary * dictCit = [[dictPro objectForKey:province] objectForKey:[NSString stringWithFormat:@"%d", cit]];;
    city = [[dictCit allKeys] objectAtIndex:0];
    if ([province isEqualToString:city]) {
        return province;
    }else{
        return [NSString stringWithFormat:@"%@ | %@", province, city];
    }
}
//#pragma mark -
+(NSArray *)returnAllGiftsArray
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
    NSMutableDictionary *DictData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
    [array addObjectsFromArray:level0];
    [array addObjectsFromArray:level1];
    [array addObjectsFromArray:level2];
    [array addObjectsFromArray:level3];
    
    
    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
//    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
//    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
    [array addObjectsFromArray:level4];
//    [array addObjectsFromArray:level5];
//    [array addObjectsFromArray:level6];
    return array;
}
+(NSDictionary *)returnGiftDictWithItemId:(NSString *)itemId
{
    NSArray * array = [self returnAllGiftsArray];
    
    NSDictionary * dict = nil;
    for (int i=0; i<array.count; i++) {
        if ([[array[i] objectForKey:@"no"] isEqualToString:itemId]) {
            dict = array[i];
            break;
        }
    }
    return dict;
}

+(NSString *)returnPositionWithRank:(NSString *)rank
{
    NSString * position = nil;
//    [[USER objectForKey:@"petInfoDict"] isKindOfClass:[NSDictionary class]] && [[[USER objectForKey:@"petInfoDict"] objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]
    if ([rank intValue] == -1) {
        //陌生人
        position = @"路人";
    }else if ([rank intValue] == 0) {
        //主人
        position = @"经纪人";
    }else if([rank intValue] == 1){
        position = @"凉粉";
    }else if([rank intValue] == 2){
        position = @"淡粉";
    }else if([rank intValue] == 3){
        position = @"狠粉";
    }else if([rank intValue] == 4){
        position = @"灰常粉";
    }else if([rank intValue] == 5){
        position = @"超级粉";
    }else if([rank intValue] == 6){
        position = @"铁杆粉";
    }else if([rank intValue] == 7){
        position = @"脑残粉";
    }else if([rank intValue] == 8){
        position = @"骨灰粉";
    }
//    NSString * totalPosition = [NSString stringWithFormat:@"%@联萌%@", [[USER objectForKey:@"petInfoDict"] objectForKey:@"name"], position];
    
    return position;
}

+(NSString *)returnActionStringWithItemId:(NSString *)item_id
{
    int a = [item_id intValue];
    NSString * actionStr = nil;
    switch (a) {
        case 1101:
            actionStr = @"盯着大鱼，口水流出来了~";
            break;
        case 1102:
            actionStr = @"舔了舔糖果，幸福到不行~";
            break;
        case 1103:
            actionStr = @"拨弄着铃铛，主人快被烦死了~";
            break;
        case 1104:
            actionStr = @"戴上了臭美哒蝴蝶结，照镜子去啦~";
            break;
        case 1201:
            actionStr = @"立刻精神抖擞地去追球球了~";
            break;
        case 1202:
            actionStr = @"纵身一跃，宇宙翱翔~";
            break;
        case 1203:
            actionStr = @"吃货本质终于暴露在你面前啦！";
            break;
        case 1204:
            actionStr = @"瞪大了圆圆滴眼睛，萌！";
            break;
        case 1301:
            actionStr = @"现在香喷喷哒，快来亲一口！";
            break;
        case 1302:
            actionStr = @"对着小兽撒了一通气，可爽啦！";
            break;
        case 1303:
            actionStr = @"得看你的表现才会决定跟不跟你约会哦！";
            break;
        case 1304:
            actionStr = @"顿时热乎乎的，夸赞你是暖男呢！";
            break;
        case 1401:
            actionStr = @"满意的躺到了新家里，身子暖暖哒~~";
            break;
        case 1402:
            actionStr = @"捧着萌星合约，决心一定要做大萌星！";
            break;
        case 1403:
            actionStr = @"戴上了新项圈，跑到镜子前臭美去了~~";
            break;
        case 1404:
            actionStr = @"戴上了皇冠，英姿飒爽的叫了一声！";
            break;
        case 2101:
            actionStr = @"被扔鸡蛋啦，蛋黄碎了一地！";
            break;
        case 2102:
            actionStr = @"碰到毛绒绒的虫纸啦，吓尿了！";
            break;
        case 2103:
            actionStr = @"踩到了你扔的便便，顿时昏厥！";
            break;
        case 2104:
            actionStr = @"痒屎了，抓耳挠腮中。。。";
            break;
        default:
            break;
    }
    return actionStr;
}

+(int)returnContributionOfNeedWithContribution:(NSString *)con
{
    int contribution = 0;
    int a = [con intValue];
    NSArray * array = @[@"0", @"480", @"1140", @"2064", @"3252" ,@"4704", @"6420", @"8400"];
    for (int i=0; i<array.count; i++) {
        if (a<[array[i] intValue]) {
            contribution = [array[i] intValue];
            break;
        }
    }
    return contribution;
}
+(int)returnExpOfNeedWithLv:(NSString *)lv
{
    int a = [lv intValue]+1;
    //a为要升到的级别
    int needExp = 110*(a-1)+5*(a+2)*(a-1)/2;
    return needExp;
}

+(void)clearTalkData
{
    NSString *path = [DOCDIR stringByAppendingPathComponent:@"talkData.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

/**添加viewController到TabBar*/
+ (void)addTabBarViewController:(UIViewController *)vc
{
    UITabBarController *tabBar = (UITabBarController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabBar addChildViewController:vc];
    [tabBar.view addSubview:vc.view];
//    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    [vc didMoveToParentViewController:tabBar];
}
/**从tabBar上删除viewController*/
+ (void)deleTabBarViewController:(UIViewController *)vc
{
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];

    [vc retain];
//    if (![[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
    [vc removeFromParentViewController];
//    }
    [vc release];
    
}
+ (void)addViewController:(UIViewController *)vc To:(UIViewController *)root
{
    [root addChildViewController:vc];
    [root.view addSubview:vc.view];
    //    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    [vc didMoveToParentViewController:root];
}

+(void)loadPetList
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"is_simple=0&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 0, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //            NSLog(@"%@", load.dataDict);
            //获取用户所有宠物，将信息存到本地
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && array.count>0){
                [USER setObject:array forKey:@"myPetsDataArray"];
            }
            //            NSMutableArray * aidArray = [NSMutableArray arrayWithCapacity:0];
            //            for (NSDictionary * dict in array) {
            //                [aidArray addObject:[dict objectForKey:@"aid"]];
            //            }
            //            [USER setObject:aidArray forKey:@"petAidArray"];
            //            NSLog(@"%@", [USER objectForKey:@"petAidArray"]);
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}


#pragma mark - 捧萌星的充值弹窗
+(void)addAlertWith:(UIViewController *)vc Cost:(NSInteger)cost SubType:(int)subType
{
    //充值弹窗
    Alert_2ButtonView2 * twoBtnView = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
    twoBtnView.type = 2;
    twoBtnView.subType = subType;
    twoBtnView.rewardNum = [NSString stringWithFormat:@"%ld", cost];
    [twoBtnView makeUI];
    twoBtnView.jumpCharge = ^(){
        //5.8
        Alert_oneBtnView * oneView = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        oneView.type = 4;
        [oneView makeUI];
        oneView.jumpTB = ^(){
            ChargeViewController * charge = [[ChargeViewController alloc] init];
            [vc presentViewController:charge animated:YES completion:nil];
            [charge release];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:oneView];
        [oneView release];
//        ChargeViewController * charge = [[ChargeViewController alloc] init];
//        [vc presentViewController:charge animated:YES completion:nil];
//        [charge release];
    };
    [vc.view addSubview:twoBtnView];
    [twoBtnView release];
}

//创建单例队列
+(NSOperationQueue *)createOperationQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:3];
    });
    return queue;
}

+(NSInteger)getCheckUpdate
{
    return checkUpdate;
}
+(void)setCheckUpdate
{
    checkUpdate = 1;
}


+(void)hideTabBar
{
    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabBar hideBottom];
}
+(void)showTabBar
{
    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabBar showBottom];
}


#pragma mark - 更新礼物列表
+(void)updateGiftList
{
    NSString *url = nil;
    if([[USER objectForKey:@"GiftCode"] isKindOfClass:[NSString class]] && [[USER objectForKey:@"GiftCode"] length]){
        //有code
        NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"code=%@dog&cat", @"e4789d5f60405c003f60250c8f843fd8"]];
        url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", GIFTLISTAPI2, @"e4789d5f60405c003f60250c8f843fd8", sig, [self getSID]];
        NSLog(@"updategift_url:%@", url);
    }else{
        //没有code
        url = [NSString stringWithFormat:@"%@%@", GIFTLISTAPI, [ControllerManager getSID]];
        NSLog(@"gift_url:%@", url);
    }
    
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSDictionary *dict = [load.dataDict objectForKey:@"data"];
//            NSLog(@"更新礼物列表：%@",dict);
            if ([[dict objectForKey:@"is_update"] intValue]) {
                //该更新
                [USER setObject:[dict objectForKey:@"code"] forKey:@"GiftCode"];
                //存成一个大字典，里边根据gift_id为key，model为value
                NSArray *array = [dict objectForKey:@"gifts"];
                NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:0];
                if ([array isKindOfClass:[NSArray class]] && array.count) {
                    for (NSDictionary *dic in array) {
//                        NSLog(@"%@",dic);
                        GiftsModel *model = [[GiftsModel alloc] init];
                        [model setValuesForKeysWithDictionary:dic];
                        [mutableDict setObject:model forKey:model.gift_id];
                        [model release];
                    }
                }
//                NSLog(@"%@",mutableDict);
                
                NSData *data = [MyControl returnDataWithDictionary:mutableDict];
                [USER setObject:data forKey:@"GiftData"];
            }
        }else{
            
        }
    }];
}
+(NSDictionary *)returnTotalGiftDict
{
    NSData *data = [USER objectForKey:@"GiftData"];
    NSDictionary *dict = [MyControl returnDictionaryWithData:data];
//    NSLog(@"%@",dict);
    if ([dict count]) {
        return dict;
    }else{
        return nil;
    }
}
+(GiftsModel *)returnGiftsModelWithGiftId:(NSString *)giftId
{
    NSDictionary *dict = [self returnTotalGiftDict];
//    NSLog(@"%@",dict);
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GiftsModel *model = [dict objectForKey:giftId];
        return model;
    }else{
        return nil;
    }
}

#pragma mark -
+(UIImageView *)shareCatLoading
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catLoadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-80)/2.0, (HEIGHT-50)/2.0, 80, 50)];
        catLoadingImageView.animationImages = @[[UIImage imageNamed:@"catload_1"], [UIImage imageNamed:@"catload_2"], [UIImage imageNamed:@"catload_3"], [UIImage imageNamed:@"catload_4"], [UIImage imageNamed:@"catload_5"], [UIImage imageNamed:@"catload_6"], [UIImage imageNamed:@"catload_7"], [UIImage imageNamed:@"catload_8"], ];
        catLoadingImageView.animationDuration = 0.4;
        catLoadingImageView.animationRepeatCount = 0;
    });
    return catLoadingImageView;
}
+(void)createLoading
{
    UIImageView *imageView = [self shareCatLoading];
    [imageView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:imageView];
}
+(void)removecatLoading
{
    UIImageView *imageView = [self shareCatLoading];
    [imageView stopAnimating];
    [imageView removeFromSuperview];
}

#pragma mark -
#pragma mark - 匹配图片
+ (NSAttributedString *)changToAttributedText:(NSString *)str{
    //创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[[NSMutableAttributedString alloc] initWithString:str] autorelease];
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    //
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [str substringWithRange:range];
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/lxh-info.plist" ofType:nil];
//        NSLog(@"%@",plist);
        NSArray *face = [[NSArray alloc] initWithContentsOfFile:plist];
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    //从后往前替换
    for (int i = (int)imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
    
}
@end
