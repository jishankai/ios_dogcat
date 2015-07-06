//
//  RockViewController.m
//  MyPetty
//
//  Created by zhangjr on 14-9-19.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "RockViewController.h"
#import "GiftShopModel.h"
#define GRAYBLUECOLOR [UIColor colorWithRed:127/255.0 green:151/255.0 blue:179/255.0 alpha:1]
#define LIGHTORANGECOLOR [UIColor colorWithRed:252/255.0 green:123/255.0 blue:81/255.0 alpha:1]
#import "ResultOfSendViewController.h"

@interface RockViewController () <UMSocialUIDelegate>
{
    UILabel *timesLabel;
//    UILabel *rewardLabel;
//    UIImageView *rewardImage;
//    UILabel *descRewardLabel;
    UIImageView *floating1;
    UIImageView *floating2;
    UIImageView *floating3;

}
//@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
//@property (nonatomic,retain)NSMutableArray *badGiftDataArray;

@property (nonatomic,strong)UIScrollView *upView;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic)BOOL isShaking;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic)CGFloat distance;
@property (nonatomic)BOOL isBack1;
@property (nonatomic)BOOL isBack2;
@property (nonatomic)BOOL isBack3;
@end

@implementation RockViewController
//-(void)dealloc
//{
//    [super dealloc];

//    [totalView release];
//    [timesLabel release];
//    [rewardLabel release];
//    [rewardImage release];
//    [descRewardLabel release];
//    [floating1 release];
//    [floating2 release];
//    [floating3 release];
//    [_upView release];
//    NSLog(@"Rock release");
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self blackBackGround];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    [MobClick event:@"shake_button"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rocking" ofType:@"wav"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"rocked" ofType:@"mp3"];
    
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path2], &soundID2);
    
    if ([self.titleString isEqualToString:@"捣捣乱"]) {
        self.isTrouble = YES;
    }
//    self.goodGiftDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.goodGiftDataArray = [ControllerManager getGift:NO];
//    self.badGiftDataArray = [ControllerManager getGift:YES];
    [self loadShakeDataInit];
    [self createShakeUI];
    
//    BOOL flag = [self.view becomeFirstResponder];
//    if (flag) {
//        NSLog(@"当前视图是第一响应对象");
//    } else {
//        NSLog(@"不是第一响应对象");
//    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
    
}
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"shake+++++++++++++++++");
//}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (isLoaded) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
//    }
//}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    isLoaded = YES;
//}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [self resignFirstResponder];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
//}
//- (BOOL)canBecomeFirstResponder
//{
//    return NO;
//}
#pragma mark - 加载摇一摇数据
- (void)loadShakeDataInit
{
    LOADING;
//    self.animalInfoDict = [USER objectForKey:@"petInfoDict"];
    NSString *shakeSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    NSString *shakeString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@",SHAKEAPI, self.pet_aid, shakeSig,[ControllerManager getSID]];
    NSLog(@"摇一摇：%@",shakeString);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:shakeString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"摇一摇数据：%@",load.dataDict);
        if (isFinish) {
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
            
            int index = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
            self.count = index;
            
            
            timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%ld",self.count] insertAtIndex:4];
            
            if (self.count <= 0) {
                self.upView.contentOffset = CGPointMake(300*3, 0);
                self.distance = self.upView.frame.size.width*3;
                floating1.frame = CGRectMake(230+self.distance, 40, 70, 25);
                floating2.frame = CGRectMake(23+self.distance, 90, 70, 25);
                floating3.frame = CGRectMake(180+self.distance, 180, 70, 25);
                timesLabel.attributedText = nil;
                timesLabel.text = @"每日第一次成功分享后可以多送1个礼物~";
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)shake
{
    LOADING;
    AudioServicesPlaySystemSound (soundID);
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_shake=%ddog&cat", self.pet_aid, 1]];
    NSString *url = [NSString stringWithFormat:@"%@%@&is_shake=%d&sig=%@&SID=%@",SHAKEAPI, self.pet_aid, 1, sig,[ControllerManager getSID]];
    NSLog(@"摇一摇shake：%@",url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                self.count = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
                [self pickGift];
                [MobClick event:@"shake_suc"];
                [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
            }
            
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
#pragma mark - 赠送礼物界面
- (void)pickGift
{
//    if (self.count <= 0) {
//        self.upView.contentOffset = CGPointMake(300*3, 0);
//    }
    GiftsModel * model = nil;
    int index=0,a=0;
//    NSString * add_rq;
    
    index = arc4random()%1000+1;
    
    NSDictionary *dict = [ControllerManager returnTotalGiftDict];
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dict allKeys]];
    //随机基数
    NSInteger count = 0;
    if (!self.isTrouble) {
//        index = arc4random()%(self.goodGiftDataArray.count);
        if (index<=800) {
            //1档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/1000 == 1 && [giftId integerValue]%1000/100 == 1) {
                    count++;
                }
            }
            a = arc4random()%count+1+1100;
        }else if(index<=900){
            //2档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/1000 == 1 && [giftId integerValue]%1000/200 == 1) {
                    count++;
                }
            }
            a = arc4random()%4+1+1200;
        }else if(index<=970){
            //3档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/1000 == 1 && [giftId integerValue]%1000/300 == 1) {
                    count++;
                }
            }
            a = arc4random()%4+1+1300;
        }else{
            //4档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/1000 == 1 && [giftId integerValue]%1000/400 == 1) {
                    count++;
                }
            }
            a = arc4random()%4+1+1400;
        }
        model = [ControllerManager returnGiftsModelWithGiftId:[NSString stringWithFormat:@"%d", a]];
//        NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:[NSString stringWithFormat:@"%d", a]];
//        [model setValuesForKeysWithDictionary:dict];
//        model = self.goodGiftDataArray[index];
//        add_rq = [NSString stringWithFormat:@"+%@",model.add_rq];
    }else{
//        index = arc4random()%(self.badGiftDataArray.count);
        if (index<=800) {
            //捣乱1档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/2000 == 1 && [giftId integerValue]%2000/100 == 1) {
                    count++;
                }
            }
            a = arc4random()%4+1+2100;
        }else {
            //礼物1档
            for (NSString *giftId in allKeys) {
                if ([giftId integerValue]/1000 == 1 && [giftId integerValue]%1000/100 == 1) {
                    count++;
                }
            }
            a = arc4random()%7+1+1100;
        }
        
        model = [ControllerManager returnGiftsModelWithGiftId:[NSString stringWithFormat:@"%d", a]];
//        NSDictionary * dict = [ControllerManager returnGiftDictWithItemId:[NSString stringWithFormat:@"%d", a]];
//        [model setValuesForKeysWithDictionary:dict];
//        model = self.badGiftDataArray[index];
//        add_rq = model.add_rq;
    }
//    rewardLabel.text = [NSString stringWithFormat:@"%@",model.name];
//    self.giftName = model.name;
//    
//    rewardImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.no]];
//    descRewardLabel.text = [NSString stringWithFormat:@"%@ 人气 %@",self.pet_name, model.add_rq];
//    if ([model.add_rq rangeOfString:@"-"].location == NSNotFound) {
//        descRewardLabel.text = [NSString stringWithFormat:@"%@ 人气 +%@",self.pet_name, model.add_rq];
//    }
//    AudioServicesPlaySystemSound (soundID);
    //固定礼物1102
//    NSString *item = @"1102";
//    NSLog(@"%@--%@", model.name, model.no);
    AudioServicesPlaySystemSound(soundID2);
    
    
    //跳转到摇完结果页面
    ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    result.isFromShake = YES;
    [UIView animateWithDuration:0.3 animations:^{
        result.alpha = 1;
    } completion:^(BOOL finished) {
//        totalView.hidden = YES;
    }];
    NSLog(@"%ld", self.count);
    result.leftShakeTimes = self.count;
    [result configUIWithName:self.pet_name ItemId:model.gift_id Tx:self.pet_tx];
    [self.view addSubview:result];
    result.sendThis = ^(){
        //送礼
        [self sendGift:model];
    };
    
    result.shakeMore = ^(){
//        [UIView animateWithDuration:0.3 animations:^{
            self.upView.contentOffset = CGPointMake(0, 0);
//        }completion:^(BOOL finished) {
            self.isShaking = NO;
//        }];
        timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%ld",self.count] insertAtIndex:4];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shakeAction) name:@"shake" object:nil];
    };
    
    result.closeBlock = ^(){
        [self colseGiftAction];
    };
//    [model release];
    [result release];
    
    if (self.isFromStar) {
        self.unShakeNum(self.count);
    }
}


-(void)sendGift:(GiftsModel *)model
{
    LOADING;
    NSString *item = model.gift_id;
    NSString *sendSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&is_shake=1&item_id=%@dog&cat", self.pet_aid, item]];
    NSString *sendString = [NSString stringWithFormat:@"%@%@&is_shake=1&item_id=%@&sig=%@&SID=%@",SENDSHAKEGIFT, self.pet_aid,item,sendSig,[ControllerManager getSID]];
    NSLog(@"赠送url:%@",sendString);
    httpDownloadBlock *request  = [[httpDownloadBlock alloc] initWithUrlStr:sendString Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"赠送数据：%@",load.dataDict);
        if (isFinish) {
            ENDLOADING;
            
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                //更新贡献度
                if(self.isFromStar){
                    self.updateContri(model.add_rq);
                }
                
                ResultOfSendViewController * send = [[ResultOfSendViewController alloc] init];
                send.giftName = model.name;
                send.pet_aid = self.pet_aid;
                send.share = ^(int cnt){
                    self.count = cnt;
                };
                [self.view addSubview:send.view];
                [send release];
                [send configUIWithName:self.pet_name ItemId:model.gift_id Tx:self.pet_tx];
                [UIView animateWithDuration:0.3 animations:^{
                    send.view.alpha = 1;
                }];
                
                send.closeBlock = ^(){
                    [self colseGiftAction];
                    [send release];
                };

                
                int newexp = [[[load.dataDict objectForKey:@"data"] objectForKey:@"exp"] intValue];
                int exp = [[USER objectForKey:@"exp"] intValue];
                [USER setObject:[NSString stringWithFormat:@"%d", exp+newexp] forKey:@"exp"];

//                int index = newexp;
                //            AudioServicesPlaySystemSound(soundID2);
//                self.isShaking = NO;
//                self.upView.contentOffset = CGPointMake(self.upView.frame.size.width, 0);
//                timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%d",self.count] insertAtIndex:4];
//                [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:index];
                //
                if (self.isFromStar) {
                    //送过之后更新成0次
                    self.count=0;
                    self.unShakeNum(0);
                }

            }
        }else{
            LOADFAILED;
        }
        
    }];
    [request release];
    
}
#pragma mark - 通知触发的方法
//-(BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    NSLog(@"shake>>");
//}
- (void)shakeAction
{
    if (self.count >0) {
        if (!self.isShaking) {
            AudioServicesPlaySystemSound (soundID);
            self.isShaking = YES;
//            [self pickGift];
            [self shake];
//            self.count -= 1;
        }
    }else{
        self.upView.contentOffset = CGPointMake(self.upView.frame.size.width*3, 0);
        self.distance = self.upView.frame.size.width*3;
        floating1.frame = CGRectMake(230+self.distance, 40, 70, 25);
        floating2.frame = CGRectMake(23+self.distance, 90, 70, 25);
        floating3.frame = CGRectMake(180+self.distance, 180, 70, 25);
        timesLabel.attributedText = nil;
        timesLabel.text = @"每日第一次成功分享后可以多送1个礼物~";
    }
}
#pragma mark - 创建界面
- (void)createShakeUI
{
    totalView = [MyControl createViewWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
//    totalView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-212, 300, 425)];
    totalView.layer.cornerRadius = 10;
    totalView.layer.masksToBounds = YES;
    [self.view addSubview:totalView];
    
    UIImageView *titleView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 300, 40) ImageName:@"title_bg.png"];
    [totalView addSubview:titleView];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:titleView.frame Font:17 Text:@"摇一摇"];
    titleLabel.text = self.titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [totalView addSubview:titleLabel];
    
    UIImageView *closeImageView = [MyControl createImageViewWithFrame:CGRectMake(260, 10, 20, 20) ImageName:@"30-1.png"];
    [totalView addSubview:closeImageView];
    
    UIButton *closeButton = [MyControl createButtonWithFrame:CGRectMake(252.5, 2.5, 35, 35) ImageName:nil Target:self Action:@selector(colseGiftAction) Title:nil];
    closeButton.showsTouchWhenHighlighted = YES;
    [totalView addSubview:closeButton];
    
    
    //    bodyView = nil;
    UIView *bodyView = [MyControl createViewWithFrame:CGRectMake(0, 40, 300, 385)];
    bodyView.backgroundColor = [UIColor whiteColor];
    [totalView addSubview:bodyView];
    
    //创建滚动视图
    _upView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bodyView.frame.size.width, bodyView.frame.size.height-70)];
    _upView.pagingEnabled = YES;
    _upView.showsHorizontalScrollIndicator = NO;
    _upView.showsVerticalScrollIndicator = NO;
    _upView.contentSize = CGSizeMake(_upView.frame.size.width*4, _upView.frame.size.height);
    _upView.scrollEnabled = NO;
    /**
     *  dd
     */
    [bodyView addSubview:_upView];
    [_upView release];
#pragma mark - one
    //1
//    UIView *view1 = [MyControl createViewWithFrame:CGRectMake(0, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
//    [self.upView addSubview:view1];
//    UIView *view2 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
//    [self.upView addSubview:view2];
//    UIView *view3 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width*2, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
//    [self.upView addSubview:view3];
//    UIView *view4 = [MyControl createViewWithFrame:CGRectMake(self.upView.frame.size.width*3, 0, self.upView.frame.size.width, self.upView.frame.size.height)];
//    [self.upView addSubview:view4];

    
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
    CGFloat upViewWidth= self.upView.frame.size.width;
    self.distance = 0;
    
    UIImageView *shakeBg1 = [MyControl createImageViewWithFrame:CGRectMake(0, 110, upViewWidth, 200) ImageName:@"bluecloudbg.png"];
    [self.upView addSubview:shakeBg1];
    floating1 = [MyControl createImageViewWithFrame:CGRectMake(230, 40, 70, 25) ImageName:@"yellowcloud.png"];
    floating1.tag = 30;
    [self.upView addSubview:floating1];
    
    floating2 = [MyControl createImageViewWithFrame:CGRectMake(23, 90, 70, 25) ImageName:@"yellowcloud.png"];
    floating2.tag = 31;
    [self.upView addSubview:floating2];
    
    floating3 = [MyControl createImageViewWithFrame:CGRectMake(180, 180, 70, 25) ImageName:@"yellowcloud.png"];
    floating3.tag = 32;
    [self.upView addSubview:floating3];
    self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [self.timer fire];
    UILabel *shakeDescLabel1 = [MyControl createLabelWithFrame:CGRectMake(self.upView.frame.size.width/2 - 115, 10, 230, 20) Font:16 Text:@"每天摇一摇，精美礼品大放送~"];
    shakeDescLabel1.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel1.textColor = GRAYBLUECOLOR;
    [self.upView addSubview:shakeDescLabel1];
    UIImageView *shakeImageView1 = [MyControl createImageViewWithFrame:CGRectMake(self.upView.frame.size.width/2 - 95, 65, 190, 190) ImageName:@"rock1.png"];
    //6.30 摇一摇的点击。
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shakeAction)];
    [shakeImageView1 addGestureRecognizer:tapImage];
    [self.upView addSubview:shakeImageView1];

#pragma mark - four

    //4
    
    UILabel *shakeDescLabel = [MyControl createLabelWithFrame:CGRectMake(upViewWidth/2 - 115+upViewWidth*3, 10, 230, 100) Font:16 Text:[NSString stringWithFormat:@"摇一摇，摇到外婆桥。\n%@今天的摇一摇次数用完啦~\n换个萌星试试吧~", self.pet_name]];
    shakeDescLabel.textAlignment = NSTextAlignmentCenter;
    shakeDescLabel.textColor = GRAYBLUECOLOR;
    [self.upView addSubview:shakeDescLabel];
    
    UIView * shakeBg4 = [MyControl createViewWithFrame:CGRectMake(upViewWidth*3, 140, upViewWidth, 120+53)];
    [self.upView addSubview:shakeBg4];
    
    UIImageView * grassBg4 = [MyControl createImageViewWithFrame:CGRectMake(0, 0, upViewWidth, 120) ImageName:@"grassbg.png"];
    [shakeBg4 addSubview:grassBg4];
    
    //259  227
    UIImageView *shakeImageView = [MyControl createImageViewWithFrame:CGRectMake(upViewWidth/2 - 65, 0, 130, 113) ImageName:@"record_upload.png"];
    [shakeBg4 addSubview:shakeImageView];
    
    //分享
    UIView * shareBg = [MyControl createViewWithFrame:CGRectMake(0, 120, upViewWidth, 53)];
    [shakeBg4 addSubview:shareBg];
    
    UIView * shareAlphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, shareBg.frame.size.width, shareBg.frame.size.height)];
    shareAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [shareBg addSubview:shareAlphaView];
    
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 0, 50, shareBg.frame.size.height) Font:12 Text:@"分享"];
    shareLabel.textColor = BGCOLOR;
    [shareBg addSubview:shareLabel];
    
    NSArray * array = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    float space = (upViewWidth-50-50-37*3)/2.0;
    
    for (int i=0; i<3; i++) {
        UIButton * btn = [MyControl createButtonWithFrame:CGRectMake(50+(space+37)*i, 8, 37, 37) ImageName:array[i] Target:self Action:@selector(shareClick:) Title:nil];
        [shareBg addSubview:btn];
        btn.tag = 100+i;
    }
    
    //底部视图
    
    
#pragma mark - bottom
    UIView *downView = [MyControl createViewWithFrame:CGRectMake(0, bodyView.frame.size.height-70, bodyView.frame.size.width, 70)];
    [bodyView addSubview:downView];
    
    UIImageView *cricleHeadImageView = [MyControl createImageViewWithFrame:CGRectMake(8, -2, 60, 60) ImageName:@"head_cricle1.png"];
    [downView addSubview:cricleHeadImageView];
    
//    10, 0, 54, 54
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(3, 3, 54, 54) ImageName:@"defaultPetHead.png"];
    if (!([self.pet_tx isKindOfClass:[NSNull class]] || [self.pet_tx length]== 0)) {
        [MyControl setImageForImageView:headImageView Tx:self.pet_tx isPet:YES isRound:YES];
        
//        NSString *pngFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", self.pet_tx]];
//        UIImage * image = [UIImage imageWithContentsOfFile:pngFilePath];
//        if (image) {
//            headImageView.image = image;
//        }else{
//            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",PETTXURL, self.pet_tx] Block:^(BOOL isFinish, httpDownloadBlock *load) {
//                if (isFinish) {
//                    headImageView.image = load.dataImage;
//                    [load.data writeToFile:pngFilePath atomically:YES];
//                }
//            }];
//            [request release];
//        }
    }
//    headImageView.layer.cornerRadius = 28;
//    headImageView.layer.masksToBounds = YES;
    [cricleHeadImageView addSubview:headImageView];
    
    
    UILabel *helpPetLabel = [MyControl createLabelWithFrame:CGRectMake(70, 5, 200, 20) Font:12 Text:nil];
    
    NSAttributedString *helpPetString = [self firstString:@"帮摇一摇" formatString:self.pet_name insertAtIndex:1];
    helpPetLabel.attributedText = helpPetString;
//    [helpPetString release];
    [downView addSubview:helpPetLabel];
    
    timesLabel = [MyControl createLabelWithFrame:CGRectMake(70, 27, 220, 20) Font:12 Text:nil];
    timesLabel.textColor = GRAYBLUECOLOR;
    timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%ld",self.count] insertAtIndex:4];
    [downView addSubview:timesLabel];
#pragma mark - 捣捣乱
    if (self.isTrouble) {
        titleLabel.text = @"捣捣乱";
        shakeBg1.image = [UIImage imageNamed:@"blackcloudbg.png"];
        floating1.image = [UIImage imageNamed:@"blackcloud.png"];
        floating2.image = [UIImage imageNamed:@"blackcloud.png"];
        floating3.image = [UIImage imageNamed:@"blackcloud.png"];
        shakeDescLabel1.text = @"小鬼捣捣乱，措手不及减人气";
        shakeImageView1.image = [UIImage imageNamed:@"rock2.png"];
//        shakeDescLabel2.text = @"哎呦够坏哟~成功摇出";
//        rewardbg.image = [UIImage imageNamed:@"badrewardbg.png"];
//        shakeBg3.image = [UIImage imageNamed:@"troublenothing.png"];
//        descNoGiftLabel.text = @"哈哈，上天没给你机会\n恶作剧不是每一个人都可以哟~";
        shakeDescLabel.text = @"够了~你真是够了！\n你今天的捣捣乱次数用完啦~\n换个萌主继续捣乱吧~";
        grassBg4.image = [UIImage imageNamed:@"troublenothing.png"];
        shakeImageView.hidden = YES;
        helpPetLabel.attributedText = [self firstString:@"给  恶作剧" formatString:self.pet_name insertAtIndex:2];
    }
}
#pragma mark - button点击事件
//分享
- (void)shareClick:(UIButton *)sender
{
    UIImage * image = nil;
    if([self.pet_tx isKindOfClass:[NSString class]] && self.pet_tx.length && headImageView.image != nil){
        image = headImageView.image;
    }else{
        image = [UIImage imageNamed:@"record_upload.png"];
    }

    /**************/
    if(sender.tag == 100){
        NSLog(@"微信");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", SHAKESHAREAPI, self.pet_aid];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"摇一摇，手不酸了~";
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"你有事儿么？没事摇一摇~" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){

            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 101){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", SHAKESHAREAPI, self.pet_aid];
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"你有事儿么？没事摇一摇~";
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){

            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShakeShare];
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(sender.tag == 102){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"你有事儿么？没事摇一摇~%@ #我是大萌星#", [NSString stringWithFormat:@"%@%@", SHAKESHAREAPI, self.pet_aid]];
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                [self loadShakeShare];
//                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
//            }else{
//                NSLog(@"失败原因：%@", response);
//                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
//            }
//            
//        }];
    }
}
#pragma mark -
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [self loadShakeShare];
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}

-(void)loadShakeShare
{
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.pet_aid]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SHAKESHARERESULTAPI, self.pet_aid, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                self.count = [[[load.dataDict objectForKey:@"data"] objectForKey:@"shake_count"] intValue];
                if (self.count) {
                    self.isBack1 = YES;
                    self.upView.contentOffset = CGPointMake(0, 0);
                    self.distance = 0;
                    floating1.frame = CGRectMake(230+self.distance, 40, 70, 25);
                    floating2.frame = CGRectMake(23+self.distance, 90, 70, 25);
                    floating3.frame = CGRectMake(180+self.distance, 180, 70, 25);
                    self.timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(floatingAnimation) userInfo:nil repeats:YES];
                    timesLabel.attributedText = [self firstString:@"今天还有次机会哦~" formatString:[NSString stringWithFormat:@"%ld",self.count] insertAtIndex:4];
                }
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
- (void)colseGiftAction
{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shake" object:nil];
    
    if (self.isFromStar) {
        self.unShakeNum(self.count);
    }
    [self.timer invalidate];
    self.timer = nil;
    
    [ControllerManager deleTabBarViewController:self];
    
//    [totalView release];
//    [timesLabel release];
//    [rewardLabel release];
//    [rewardImage release];
//    [descRewardLabel release];
//    [floating1 release];
//    [floating2 release];
//    [floating3 release];
//    [_upView release];
//    NSLog(@"Rock release");
    
//    [self dealloc];
//    [self removeFromParentViewController];
    
}
//- (void)shareAction:(UIButton *)sender
//{
//    //截图
//    UIImage * image = [MyControl imageWithView:totalView];
//    
//    /**************/
//    if(sender.tag == 77){
//        NSLog(@"微信");
//        //强制分享图片
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                StartLoading;
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                StartLoading;
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//            
//        }];
//    }else if(sender.tag == 78){
//        NSLog(@"朋友圈");
//        //强制分享图片
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//            if (response.responseCode == UMSResponseCodeSuccess) {
//                NSLog(@"分享成功！");
//                StartLoading;
//                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
//            }else{
//                StartLoading;
//                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
//            }
//            
//        }];
//    }else if(sender.tag == 79){
//        NSLog(@"微博");
//        NSString * str = nil;
//        if (!self.isTrouble) {
//            str = [NSString stringWithFormat:@"随便一摇就摇出了一个%@，好惊喜，你也想试试吗？http://home4pet.imengstar.com/ #我是大萌星#", self.giftName];
//        }else{
//            str = [NSString stringWithFormat:@"嘿嘿~我在宠物星球捉弄了萌宠%@，恶作剧的感觉真是妙不可言~http://home4pet.imengstar.com/(分享自@宠物星球社交应用）", self.pet_name];
//        }
//        
//        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//        NSLog(@"%d", oauth);
//        if (oauth) {
//            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
//                //设置分享内容和回调对象
//                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//            }];
//        }else{
//            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:self];
//            //设置分享内容和回调对象
//            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
//        }
////        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:str image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
////            if (response.responseCode == UMSResponseCodeSuccess) {
////                NSLog(@"分享成功！");
////                StartLoading;
////                [MMProgressHUD dismissWithSuccess:@"分享成功" title:nil afterDelay:0.5];
////            }else{
////                NSLog(@"失败原因：%@", response);
////                StartLoading;
////                [MMProgressHUD dismissWithError:@"分享失败" afterDelay:0.5];
////            }
////            
////        }];
//    }
//}
//一句话两种颜色
- (NSAttributedString *)firstString:(NSString *)string1 formatString:(NSString *)string2 insertAtIndex:(NSInteger)number
{
    NSMutableAttributedString *attributeString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    
    [attributeString2 addAttribute:NSForegroundColorAttributeName value:LIGHTORANGECOLOR range:NSMakeRange(0, attributeString2.length)];
    NSMutableAttributedString *attributeString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributeString1 addAttribute:NSForegroundColorAttributeName value:GRAYBLUECOLOR range:NSMakeRange(0, attributeString1.length)];
    [attributeString1 insertAttributedString:attributeString2 atIndex:number];
    [attributeString2 release];
    return [attributeString1 autorelease];
}
#pragma mark - 浮云
- (void)floatingAnimation
{
    UIImageView *floatinga = (UIImageView *)[self.view viewWithTag:30];
    if (!self.isBack1) {
        floatinga.frame = CGRectMake(floatinga.frame.origin.x-1, 40, 70, 25);
        if (floatinga.frame.origin.x<=0+self.distance) {
            self.isBack1 = YES;
        }
    }else{
        floatinga.frame = CGRectMake(floatinga.frame.origin.x+1, 40, 70, 25);
        if (floatinga.frame.origin.x > 230+self.distance) {
            self.isBack1 = NO;
        }
    }
    UIImageView *floatingb = (UIImageView *)[self.view viewWithTag:31];
    if (self.isBack2) {
        floatingb.frame =CGRectMake(floatingb.frame.origin.x+0.5, 90, 70, 25);
        if (floatingb.frame.origin.x >230+self.distance) {
            self.isBack2 = NO;
        }
    }else{
        floatingb.frame =CGRectMake(floatingb.frame.origin.x-0.5, 90, 70, 25);
        if (floatingb.frame.origin.x <0+self.distance) {
            self.isBack2 = YES;
        }
    }
    
    UIImageView *floatingc = (UIImageView *)[self.view viewWithTag:32];
    if (self.isBack3) {
        floatingc.frame =CGRectMake(floatingc.frame.origin.x-0.75, 180, 70, 25);
        if (floatingc.frame.origin.x <0+self.distance) {
            self.isBack3 = NO;
        }
    }else{
        floatingc.frame =CGRectMake(floatingc.frame.origin.x+0.75, 180, 70, 25);
        if (floatingc.frame.origin.x >230+self.distance) {
            self.isBack3 = YES;
        }
    }
}
- (void)blackBackGround
{
    UIView *alpaView = [MyControl createViewWithFrame:self.view.frame];
    alpaView.backgroundColor = [UIColor blackColor];
    alpaView.alpha = 0.6;
    [self.view addSubview:alpaView];
}
@end
