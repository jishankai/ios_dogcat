//
//  PublishViewController.m
//  MyPetty
//
//  Created by Aidi on 14-7-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PublishViewController.h"
//#import "UMSocialDataService.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import <AviarySDK/AviarySDK.h>
static NSString * const kAFAviaryAPIKey = @"b681eafd0b581b46";
static NSString * const kAFAviarySecret = @"389160adda815809";
#import "AtUsersViewController.h"
#import "TopicViewController.h"
#import "PublishToViewController.h"
#import "UserPetListModel.h"
//#import "IQKeyboardManager.h"
#import "MenuModel.h"

//1
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"

@interface PublishViewController () <UITextViewDelegate,AFPhotoEditorControllerDelegate,UMSocialUIDelegate>
{
    HMEmotionTextView * _textView;
    //表情button点击状态
    BOOL isClick;
    UIView *_toolBarView;
    
    CGRect rect;
    UILabel * limitLabel;
    UIButton * sina;
    UIButton * weChat;
    //textView的起始高度+textView高度
    NSInteger tHeight;
}
//4、表情button
@property(nonatomic, retain)UIButton *emoticonButton;
//5、表情键盘
@property (nonatomic, retain) HMEmotionKeyboard *kerboard;
//6.是否正在切换键盘
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@property (nonatomic, retain) NSMutableArray *nameArray;

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) NSMutableArray * sessions;

@property (nonatomic, retain) NSDictionary * menuDataDict;
@end

@implementation PublishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self setToolbar];
    _textView.inputAccessoryView = _toolBarView;
    //    [self resignFirstResponder];
    
    if ([[USER objectForKey:@"selectTopic"] intValue] == 1) {
        [topic setTitle:[NSString stringWithFormat:@"#%@#", [USER objectForKey:@"topic"]] forState:UIControlStateNormal];
        [USER setObject:@"0" forKey:@"selectTopic"];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
//    [[IQKeyboardManager sharedManager] setEnable:YES];
    //    isInPublish = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.delegate = self;
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //清空topic
    self.menuDataDict = [MyControl returnDictionaryWithData:[USER objectForKey:@"MenuData"]];
    
    if (self.publishType == 0) {
        if(self.isFromMasselection){
            [USER setObject:self.MasselctionName forKey:@"topic"];
        }else{
            [USER setObject:@"点击添加话题" forKey:@"topic"];
        }
        
    }else if (self.publishType == 1){
        [USER setObject:@"挣口粮" forKey:@"topic"];
    }else{
        MenuModel * model = [self.menuDataDict objectForKey:[NSString stringWithFormat:@"%d", self.publishType]];
        [USER setObject:model.subject forKey:@"topic"];
    }
    
    //    if (self.isBeg) {
    //        [USER setObject:@"挣口粮" forKey:@"topic"];
    //    }else{
    //
    //    }
    
    //    NSLog(@"%d--%@--%@", self.isBeg, self.aid, self.name);
    // Do any additional setup after loading the view.
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];
    
    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    [sessions release];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
//    [self createIQ];
    [self createBg];
    [self createFakeNavigation];
    [self makeUI];
    //    if (self.aid == nil || self.aid.length == 0) {
    //        self.aids = [NSMutableString stringWithString:[USER objectForKey:@"aid"]];
    //5.6 ！改为 == 0
    if(self.publishType == 0){
        if (self.aid != nil) {
            
            self.aids = [NSMutableString stringWithString:self.aid];
            NSLog(@"%@>>>>>>>>>%@",self.aid , self.aids);
        }
    }
    if(self.publishType != 0){
        self.aids = [NSMutableString stringWithString:self.aid];
    }

//    if(self.publishType != 0){
//        self.aids = [NSMutableString stringWithString:self.aid];
//    }
    [self loadData];
    //4.20 *******************************//
    //    [self kerboard];
    //
    [self setToolbar];
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) return;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        sv.contentOffset = CGPointMake(0, sv.contentSize.height-sv.frame.size.height);
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //        CGFloat keyboardH = keyboardF.size.height;
        //        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
        sv.contentOffset = CGPointMake(0, sv.contentSize.height-sv.frame.size.height+keyboardF.size.height+40-(sv.contentSize.height-tHeight));
    }];
}
#pragma mark - 4.18
// 添加工具条
- (void)setToolbar
{
    _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 40)];
    _toolBarView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    _textView.inputAccessoryView = _toolBarView;
    
    //增加键盘button
    self.emoticonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.emoticonButton.frame = CGRectMake(10, 7.5, 25, 25);
    //    [self.emoticonButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background@2x"] forState:UIControlStateNormal];
    //    [emoticonButton setTitle:@"图标" forState:UIControlStateNormal];
    [self.emoticonButton setBackgroundImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted@2x"] forState:UIControlStateNormal];
    [self.emoticonButton addTarget:self action:@selector(emoticonButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_toolBarView addSubview:self.emoticonButton];
    
    UIButton * sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(resignKeyboard) Title:@"完成"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [_toolBarView addSubview:sendButton];
}
//键盘
- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = HMScreenW;
        self.kerboard.height = 216;
    }
    return _kerboard;
}
//隐藏键盘
-(void)resignKeyboard
{
    [_textView resignFirstResponder];

//    [self performSelector:@selector(test) withObject:nil afterDelay:0.3];
}
//-(void)IQKeyboardHide
//{
//    [self performSelector:@selector(test) withObject:nil afterDelay:0.3];
//}

//4.10.图标点击方法
- (void)emoticonButtonAction{
    if(isClick == NO)
    {
        [self.emoticonButton setBackgroundImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted@2x"] forState:UIControlStateNormal];
        isClick = YES;
    }else {
        [self.emoticonButton setBackgroundImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted@2x"] forState:UIControlStateNormal];
        //        [self.emoticonButton setTitle:@"Play" forState:UIControlStateNormal];
        isClick = NO;
    }
    NSLog(@"打开表情键盘");
    [_textView resignFirstResponder];
    [self openEmotion];
    
    
}
#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 *  当textView的文字改变就会调用
 */
//- (void)textViewDidChange:(UITextView *)textView
//{
//    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
//}
#pragma mark - 打开表情
/**
 *  打开表情
 */
- (void)openEmotion
{
    [self kerboard];
    // 正在切换键盘
    self.changingKeyboard = YES;
    
    if (_textView.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
//        UIView *view = [MyControl createViewWithFrame:CGRectZero];
        _textView.inputView = nil;
//        [[IQKeyboardManager sharedManager] setEnable:YES];
        // 显示表情图片
        //        self.toolbar.showEmotionButton = YES;
    } else { // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        _textView.inputView = self.kerboard;
//        [[IQKeyboardManager sharedManager] setEnable:YES];
        // 不显示表情图片
        //        self.toolbar.showEmotionButton = NO;
    }
    
    // 更换完毕完毕
    self.changingKeyboard = NO;
    
    [self keyboardDisAppear];
    [self keyboardAppear];
//    [self performSelector:@selector(keyboardAppear) withObject:nil afterDelay:0.25];
    
    //    [_textView becomeFirstResponder];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 打开键盘
//        [_textView becomeFirstResponder];
//    });
}

/**
 *  当表情选中的时候调用
 *
 *  @param note 里面包含了选中的表情
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    [_textView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:_textView];
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [_textView deleteBackward];
}
#pragma mark -
-(void)keyboardDisAppear
{
    [_textView resignFirstResponder];
}
-(void)keyboardAppear
{
    [_textView becomeFirstResponder];
}


#pragma mark - 
//
-(void)loadData
{
    //    LOADING;
    //    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    //    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    //    NSLog(@"%@", url);
    //    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
    //        if (isFinish) {
    //            NSLog(@"%@", load.dataDict);
    //            [self.dataArray removeAllObjects];
    NSArray * array = [USER objectForKey:@"myPetsDataArray"];
    for (NSDictionary * dict in array) {
        if (![[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
            continue;
        }
        UserPetListModel * model = [[UserPetListModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        [self.dataArray addObject:model];
        [model release];
        NSLog(@"ssssss%ld",self.dataArray.count);
    }
    if (self.aids == nil) {
        self.aids = [USER objectForKey:@"lastPublishAid"];
        if (self.aids == nil) {
            self.aids = [[self.dataArray lastObject] aid];
            self.name = [[self.dataArray lastObject] name];
        } else {
        NSLog(@"%@",self.aids);
        for (int i=0; i < self.dataArray.count; i++) {
            NSLog(@"self.dataArray.count:%ld",self.dataArray.count);
            if([[self.dataArray[i] aid] isEqualToString:self.aids]){
                self.name = [self.dataArray[i] name];
                NSLog(@"aaaaaaaa%@",self.name);
                [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
            }
        }}
    }
    //如果有aid
    if (self.publishType != 0) {//5.6号，！改为!=
        for (int i=0; i<self.dataArray.count; i++) {
//            if (<#condition#>) {
//                <#statements#>
//            }
            if ([[self.dataArray[i] aid] isEqualToString:[USER objectForKey:@"lastPublishAid"]]) {
                if (self.publishType == 1) {
                    self.aids = [NSMutableString stringWithString:self.aid];
                    
                } else {
                self.aids = [NSMutableString stringWithString:[self.dataArray[i] aid]];
                self.name = [self.dataArray[i] name];
                }
                [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
                break;
            }else if(i == self.dataArray.count-1){
                //5.6号，0改为i 已下5行
                if (self.aid != nil) {
//                NSLog(@"%@",[self.dataArray[i] aid]);
                    self.aids = [NSMutableString stringWithString:self.aid];
                    NSLog(@"%@",self.name);
                } else {
                    self.aids = [NSMutableString stringWithString:[self.dataArray[0] aid]];
                    self.name = [self.dataArray[0] name];
                }
//                self.name = [self.dataArray[i] name];
//                NSLog(@"%@",self.name);

                [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
            }
        }
        //                if ([[USER objectForKey:@"lastPublishAid"] intValue]) {
        //
        //                }
    }
    //            ENDLOADING;
    //        }else{
    //            LOADFAILED;
    //        }
    //    }];
    //    [request release];
}
//- (void)createIQ
//{
//    //Enabling keyboard manager
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:20];
//    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create UIToolbar for keyboard.
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
//    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
//    //Resign textField if touched outside of UITextField/UITextView.
//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
//}
-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    //    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.jpg"]];
    //    NSLog(@"%@", filePath);
    //    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    //    NSLog(@"%@", data);
    //    UIImage * image = [UIImage imageWithData:data];
    
    //    bgImageView.image = [self.oriImage applyBlurWithRadius:20 tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
    //    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    //    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    //    [self.view addSubview:tempView];
}
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-15, 200, 20) Font:17 Text:@"发布照片"];
    if (self.publishType == 1) {
        titleLabel.text = @"挣口粮";
    }else if(self.publishType >=2){
        MenuModel * model = [self.menuDataDict objectForKey:[NSString stringWithFormat:@"%d", self.publishType]];
        titleLabel.text = model.subject;
    }
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-62-10, 29, 62, 24) ImageName:@"exchange_cateBtn.png" Target:self Action:@selector(rightButtonClick) Title:@"美化"];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton.showsTouchWhenHighlighted = YES;
    [navView addSubview:rightButton];
}

-(void)backBtnClick
{
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)makeUI
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    sv.contentSize = CGSizeMake(320, 568);
    [self.view addSubview:sv];
    //    UIImageView * bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@""];
    //    [self.view addSubview:bgImageView];
    
    //    UIButton * leftButton = [MyControl createButtonWithFrame:CGRectMake(15, 25, 25, 25) ImageName:@"7-7.png" Target:self Action:@selector(leftButtonClick) Title:nil];
    //    [navView addSubview:leftButton];
    //
    //    UIButton * rightButton = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-25-15, 25, 25, 25) ImageName:@"30-1.png" Target:self Action:@selector(rightButtonClick) Title:nil];
    //    [bgImageView addSubview:rightButton];
    
    bigImageView = [MyControl createImageViewWithFrame:CGRectMake(10, 5, self.view.frame.size.width-20, 230) ImageName:@""];
    //    bigImageView.image = [UIImage imageNamed:@"cat2.jpg"];
    bigImageView.image = self.oriImage;
    float Width = self.oriImage.size.width;
    float Height = self.oriImage.size.height;
    //    if (Width>300) {
    //        float w = 300/Width;
    //        Width *= w;
    //        Height *= w;
    //    }
    //    if (Height>230) {
    if(Width != 0){
        float h = (self.view.frame.size.width-20)/Width;
        //        Width *= h;
        Height *= h;
    }else{
        Height = 200;
    }
    
    //    }
    bigImageView.frame = CGRectMake((self.view.frame.size.width-300)/2, bigImageView.frame.origin.y, self.view.frame.size.width-20, Height);
    bigImageView.layer.cornerRadius = 5;
    bigImageView.layer.masksToBounds = YES;
    [sv addSubview:bigImageView];
    
    /***********#话题#  @用户  发布到************/
    int width = (self.view.frame.size.width-20-7.5*2)/3;
    float space = 7.5;
    
    topic = [MyControl createButtonWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(topicClick) Title:[NSString stringWithFormat:@"#%@#", [USER objectForKey:@"topic"]]];
    if(self.publishType || self.isFromMasselection){
        topic.userInteractionEnabled = NO;
    }
    topic.titleLabel.font = [UIFont systemFontOfSize:13];
    topic.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    topic.layer.cornerRadius = 3;
    topic.layer.masksToBounds = YES;
    topic.showsTouchWhenHighlighted = YES;
    [sv addSubview:topic];
    
    users = [MyControl createButtonWithFrame:CGRectMake(topic.frame.origin.x+topic.frame.size.width+space, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(usersClick) Title:@"点击@小伙伴"];
    //    users.userInteractionEnabled = NO;
    //    if ([[USER objectForKey:@"atUsers"] count] == 0) {
    //        [users setTitle:@"点击@用户" forState:UIControlStateNormal];
    //    }else{
    //        [users setTitle:[NSString stringWithFormat:@"@豆豆 等%d个用户", [[[USER objectForKey:@"atUsers"] count] intValue]] forState:UIControlStateNormal];
    //    }
    users.titleLabel.font = [UIFont systemFontOfSize:13];
    users.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    users.layer.cornerRadius = 3;
    users.layer.masksToBounds = YES;
    users.showsTouchWhenHighlighted = YES;
    [sv addSubview:users];
    
    publishTo = [MyControl createButtonWithFrame:CGRectMake(users.frame.origin.x+users.frame.size.width+space, bigImageView.frame.origin.y+bigImageView.frame.size.height+4, width, 30) ImageName:@"" Target:self Action:@selector(publishToClick) Title:[NSString stringWithFormat:@"发布到%@", [USER objectForKey:@"a_name"]]];
    if ([self.name isKindOfClass:[NSString class]] && self.name.length) {
        [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
    }
//    if (self.aids == nil) {
//        self.aids = [USER objectForKey:@"lastPublishAid"];
//        NSArray * array = [USER objectForKey:@"myPetsDataArray"];
//        for (NSDictionary * dict in array) {
////            if (![[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
////                continue;
////            }
//            UserPetListModel * model = [[UserPetListModel alloc] init];
//            [model setValuesForKeysWithDictionary:dict];
//            [self.nameArray addObject:model];
//            [model release];
//            NSLog(@"self.dataArray.count:%ld",self.dataArray.count);
//        }
//        NSLog(@"self.dataArray.count....:%ld",self.dataArray.count);
//
//        for (int i=0; i < self.dataArray.count; i++) {
//            NSLog(@"self.dataArray.count:%ld",self.dataArray.count);
//            if([[self.nameArray[i] aid] isEqualToString:self.aids]){
//                self.name = [self.nameArray[i] name];
//                [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", self.name] forState:UIControlStateNormal];
//            }
//        }
//    }
    if(self.publishType != 0){
        publishTo.userInteractionEnabled = NO;
    }
    publishTo.titleLabel.font = [UIFont systemFontOfSize:13];
    publishTo.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    publishTo.layer.cornerRadius = 3;
    publishTo.layer.masksToBounds = YES;
    publishTo.showsTouchWhenHighlighted = YES;
    [sv addSubview:publishTo];
    /***********************************/
    //    _textView = [MyControl createTextFieldWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5, 300, 80) placeholder:@"为您爱宠的靓照写个描述吧~" passWord:NO leftImageView:nil rightImageView:nil Font:17];
    textBgView = [MyControl createViewWithFrame:CGRectMake(10, bigImageView.frame.origin.y+bigImageView.frame.size.height+5+33, 300, 80)];
    
    tHeight = textBgView.frame.origin.y+textBgView.frame.size.height;
    
    //将大小赋值给全局变量
    rect = textBgView.frame;
    [sv addSubview:textBgView];
    
    UIView *alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, textBgView.frame.size.width, textBgView.frame.size.height)];
    alphaView.backgroundColor = [UIColor whiteColor];
    alphaView.alpha = 0.6;
    alphaView.layer.cornerRadius = 5;
    alphaView.layer.masksToBounds = YES;
    [textBgView addSubview:alphaView];
    
    limitLabel = [MyControl createLabelWithFrame:CGRectMake(textBgView.frame.size.width-15-80, textBgView.frame.size.height-25-30, 80, 30) Font:25 Text:@"40"];
    limitLabel.textAlignment = NSTextAlignmentRight;
    //    [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1]
    limitLabel.textColor = [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    [textBgView addSubview:limitLabel];
    
    _textView = [[HMEmotionTextView alloc] initWithFrame:CGRectMake(0, 0, 300, 80)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    if ([[USER objectForKey:@"isFromActivity"] intValue] == 1) {
        _textView.text = [USER objectForKey:@"Topic"];
        limitLabel.text = [NSString stringWithFormat:@"%ld", 40 - [[ControllerManager changToAttributedText:_textView.realText] length]];
        [USER setObject:@"0" forKey:@"isFromActivity"];
    }else{
        _textView.placehoder = @"为您爱宠的靓照写个描述吧~";
    }
    //
    
    _textView.font = [UIFont systemFontOfSize:17];
    
    _textView.delegate = self;
    _textView.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
//    _textView.alpha = 0.4;
//    _textView.backgroundColor = [UIColor whiteColor];
    _textView.returnKeyType = UIReturnKeyDone;
    //    _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [textBgView addSubview:_textView];
    //    if (self.tempDes.length != 0) {
    //        _textView.text = self.tempDes;
    _textView.textColor = [UIColor blackColor];
    //    }
    
    
    //534 110
    publishButton = [MyControl createButtonWithFrame:CGRectMake(10, textBgView.frame.origin.y+textBgView.frame.size.height+5, self.view.frame.size.width-20, (self.view.frame.size.width-20)*110/534) ImageName:@"public_longBtnBg.png" Target:self Action:@selector(publishButtonClick:) Title:@"发布"];
    publishButton.alpha = 0.8;
    publishButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    //    publishButton.backgroundColor = ORANGE;
    //    publishButton.layer.cornerRadius = 5;
    //    publishButton.layer.masksToBounds = YES;
    [sv addSubview:publishButton];
    
    /************************************/
    UIImageView * bgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(10, publishButton.frame.origin.y+publishButton.frame.size.height+5, 300, 45) ImageName:nil];
    //    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    /*******************/
    sv.contentSize = CGSizeMake(self.view.frame.size.width, bgImageView2.frame.origin.y+bgImageView2.frame.size.height+20);
    /*******************/
    bgImageView2.image = [[UIImage imageNamed:@"30-2-2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    [sv addSubview:bgImageView2];
    
    sina = [MyControl createButtonWithFrame:CGRectMake(20+5, 5+5, 25, 25) ImageName:@"publish_unSelected.png" Target:self Action:@selector(sinaClick) Title:nil];
    [bgImageView2 addSubview:sina];
    [sina setBackgroundImage:[UIImage imageNamed:@"publish_selected.png"] forState:UIControlStateSelected];
    
    sinaLabel = [MyControl createLabelWithFrame:CGRectMake(sina.frame.origin.x+sina.frame.size.width+7, 10, 80, 25) Font:15 Text:@"新浪微博"];
    sinaLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:sinaLabel];
    
    if ([[USER objectForKey:@"sina"] intValue] == 1) {
        sina.selected = YES;
        sinaLabel.textColor = BGCOLOR;
    }else{
        sina.selected = NO;
    }
    /*============================*/
    UIImageView * line = [MyControl createImageViewWithFrame:CGRectMake(300/2, 0, 2, bgImageView2.frame.size.height) ImageName:@"30-2.png"];
    [bgImageView2 addSubview:line];
    
    weChat = [MyControl createButtonWithFrame:CGRectMake(170+5, 5+5, 25, 25) ImageName:@"publish_unSelected.png" Target:self Action:@selector(weChatClick) Title:nil];
    [bgImageView2 addSubview:weChat];
    [weChat setBackgroundImage:[UIImage imageNamed:@"publish_selected.png"] forState:UIControlStateSelected];
    
    weChatLabel = [MyControl createLabelWithFrame:CGRectMake(weChat.frame.origin.x+weChat.frame.size.width+7, 10, 80, 25) Font:15 Text:@"微信朋友圈"];
    weChatLabel.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1];
    [bgImageView2 addSubview:weChatLabel];
    
    if ([[USER objectForKey:@"weChat"] intValue] == 1) {
        weChat.selected = YES;
        weChatLabel.textColor = BGCOLOR;
    }else{
        weChat.selected = NO;
    }
    
    [self.view bringSubviewToFront:navView];
}
#pragma mark - #话题点击事件
-(void)topicClick
{
    NSLog(@"进入#话题页");
    TopicViewController * vc = [[TopicViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)usersClick
{
    NSLog(@"进入@用户页");
    AtUsersViewController * vc = [[AtUsersViewController alloc] init];
    vc.sendNameAndIds = ^(NSString * name, NSString * idsString){
        if (name != nil && name.length != 0) {
            [users setTitle:name forState:UIControlStateNormal];
            self.usr_ids = idsString;
        }else{
            
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)publishToClick
{
    PublishToViewController * vc = [[PublishToViewController alloc] init];
    vc.aid = self.aids;
    vc.selectedArray = ^(NSArray * array, NSArray * nameArray){
        NSLog(@"===%@===", array);
        //5.6
        if (array.count != 0) {
            [publishTo setTitle:[NSString stringWithFormat:@"发布到%@", nameArray[0]] forState:UIControlStateNormal];
            self.aids = nil;
            self.aids = array[0];
            NSLog(@"%@", self.aids);
        }
    };
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}

-(void)shareEvent
{
    if (self.publishType == 1) {
        [MobClick event:@"food_share_suc"];
    }else{
        NSArray * menuList = [USER objectForKey:@"MenuList"];
        if (menuList.count <2) {
            [MobClick event:@"food_share_suc"];
        }else{
            //匹配
            for(int i=1;i<menuList.count;i++){
                if ([menuList[i] integerValue] == self.publishType) {
                    if (i == 1) {
                        [MobClick event:@"topic1_share_suc"];
                    }else if(i == 2){
                        [MobClick event:@"topic2_share_suc"];
                    }
                }else if(i == menuList.count-1){
                    [MobClick event:@"food_share_suc"];
                }
            }
        }
    }
    
}
#pragma mark -
-(void)publishButtonClick:(UIButton *)button
{
    
    if ([ControllerManager changToAttributedText:_textView.realText].length > 40) {
        StartLoading;
        [MyControl loadingFailedWithContent:@"最多输入40个字哦亲~" afterDelay:0.5];
        return;
    }
    button.userInteractionEnabled = NO;
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",_textView.realText);
    
    [self postData:self.oriImage];
}
#pragma mark - 准备同步分享
-(void)synShare
{
    s = [[USER objectForKey:@"sina"] intValue];
    w = [[USER objectForKey:@"weChat"] intValue];
    __block PublishViewController * blockSelf = self;
    
    if (s == 0 && w == 0) {
        shareSuc = YES;
        if (publishSuc) {
            [UIView animateWithDuration:0 delay:0.2 options:0 animations:^{
                
                [blockSelf dismissViewControllerAnimated:NO completion:^{
                    if (blockSelf.isFromMasselection) {
                        blockSelf.showMassAlert(blockSelf.img_id, blockSelf.starId, blockSelf.aid, blockSelf.name, blockSelf.MasselctionName, blockSelf.oriImage);
                    }else{
                        blockSelf.showFrontImage(blockSelf.img_id, blockSelf.publishType, blockSelf.aid, blockSelf.name);
                    }
                }];
            } completion:nil];
        }
    }else if (s == 1 && w == 0) {
        publishButton.userInteractionEnabled = NO;
        
        NSString * str = nil;
        if ([_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"] || _textView.realText.length == 0) {
            if (self.publishType) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }else{
            str = _textView.realText;
        }
        
        NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, self.img_id];
        
        NSString * topStr = [[topic.titleLabel.text componentsSeparatedByString:@"#"] objectAtIndex:1];
        if(![topStr isEqualToString:@"点击添加话题"]){
            str = [NSString stringWithFormat:@"%@ #%@# %@", str, topStr, last];
            NSLog(@"%@",topStr);
        }else{
            str = [NSString stringWithFormat:@"%@%@", str, last];
        }
        
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        
    }else if(s == 0 && w == 1){
        publishButton.userInteractionEnabled = NO;
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, self.img_id];
        NSString * str = nil;
        if ([_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"] || _textView.realText.length == 0) {
            if (self.publishType) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }else{
            str = _textView.realText;
        }
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            NSLog(@"weChat-response:%@", response);
            blockSelf->shareSuc = YES;
            if (blockSelf->publishSuc) {
                [UIView animateWithDuration:0 delay:0.2 options:0 animations:^{
                    //分享
                    [blockSelf shareEvent];
                    
                    [blockSelf dismissViewControllerAnimated:NO completion:^(){
                        if (blockSelf.isFromMasselection) {
                            blockSelf.showMassAlert(blockSelf.img_id, blockSelf.starId, blockSelf.aid, blockSelf.name, blockSelf.MasselctionName, blockSelf.oriImage);
                        }else{
                            blockSelf.showFrontImage(blockSelf.img_id, blockSelf.publishType, blockSelf.aid, blockSelf.name);
                        }
                    }];
                } completion:nil];
            }
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                //                [self postData:self.oriImage];
            }
        }];
        
    }else if(s == 1 && w == 1){
        publishButton.userInteractionEnabled = NO;
        
        isDouble = YES;
        
        NSString * str = nil;
        if ([_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"] || _textView.realText.length == 0) {
            if (self.publishType) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }else{
            str = _textView.realText;
        }
        
        NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, self.img_id];
        
        NSString * topStr = [[topic.titleLabel.text componentsSeparatedByString:@"#"] objectAtIndex:1];
        if(![topStr isEqualToString:@"点击添加话题"]){
            str = [NSString stringWithFormat:@"%@ #%@# %@", str, topStr, last];
        }else{
            str = [NSString stringWithFormat:@"%@%@", str, last];
        }
        
        BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
        NSLog(@"%d", oauth);
        if (oauth) {
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
                //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
            }];
        }else{
            [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:bigImageView.image socialUIDelegate:self];
            //设置分享内容和回调对象
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        }
        
    }
}

#pragma mark -

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    publishButton.userInteractionEnabled = YES;
    
    __block PublishViewController * blockSelf = self;
    
    NSLog(@"%@", response);
    if (!isDouble) {
        shareSuc = YES;
        if (publishSuc) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
        }
        
        publishButton.userInteractionEnabled = YES;
    }else{
        publishButton.userInteractionEnabled = YES;
        //分享微信
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, self.img_id];
        NSString * str = nil;
        if ([_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"] || _textView.realText.length == 0) {
            if (self.publishType) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }else{
            str = _textView.realText;
        }
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            blockSelf->shareSuc = YES;
            if (blockSelf->publishSuc) {
                [UIView animateWithDuration:0 delay:0.2 options:0 animations:^{
                    //分享
                    [blockSelf shareEvent];
                    
                    
                    [blockSelf dismissViewControllerAnimated:NO completion:^(){
                        if (blockSelf.isFromMasselection) {
                            blockSelf.showMassAlert(blockSelf.img_id, blockSelf.starId, blockSelf.aid, blockSelf.name, blockSelf.MasselctionName, blockSelf.oriImage);
                        }else{
                            blockSelf.showFrontImage(blockSelf.img_id, blockSelf.publishType, blockSelf.aid, blockSelf.name);
                        }
                    }];
                } completion:nil];
            }
            
            NSLog(@"weChat-response:%@", response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
}

-(void)dismiss
{
    //分享
    [self shareEvent];
    __block PublishViewController *blockSelf = self;
    [self dismissViewControllerAnimated:NO completion:^(){
        if (blockSelf.isFromMasselection) {
            blockSelf.showMassAlert(blockSelf.img_id, blockSelf.starId, blockSelf.aid, blockSelf.name, blockSelf.MasselctionName, blockSelf.oriImage);
        }else{
            blockSelf.showFrontImage(blockSelf.img_id, blockSelf.publishType, blockSelf.aid, blockSelf.name);
        }
    }];
}

#pragma mark - 新浪、微信点击事件
-(void)sinaClick
{
    sina.selected = !sina.selected;
    if (sina.selected) {
        [USER setObject:@"1" forKey:@"sina"];
        sinaLabel.textColor = BGCOLOR;
    }else{
        [USER setObject:@"0" forKey:@"sina"];
        sinaLabel.textColor = [UIColor blackColor];
    }
    
}
-(void)weChatClick
{
    weChat.selected = !weChat.selected;
    if (weChat.selected) {
        [USER setObject:@"1" forKey:@"weChat"];
        weChatLabel.textColor = BGCOLOR;
    }else{
        [USER setObject:@"0" forKey:@"weChat"];
        weChatLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - textFieldDelegate
-(void)textViewDidChange:(HMEmotionTextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    
    if([ControllerManager changToAttributedText:_textView.realText].length > 40){
        limitLabel.textColor = [UIColor redColor];
    }else{
        limitLabel.textColor = [UIColor colorWithRed:200/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    }
    //    NSLog(@"%d",)
    limitLabel.text = [NSString stringWithFormat:@"%ld", 40 - [ControllerManager changToAttributedText:_textView.realText].length];
    //    NSLog(@"%d", _textView.text.length);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    NSLog(@"%@", text);
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    [[IQKeyboardManager sharedManager] setEnable:YES];
    sv.scrollEnabled = NO;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
//    [[IQKeyboardManager sharedManager] setEnable:NO];
    sv.scrollEnabled = YES;
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    isInPublish = YES;
    if ([_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        _textView.text = @"";
    }
    _textView.textColor = [UIColor blackColor];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    isInPublish = NO;
    if (_textView.realText.length == 0) {
        _textView.placehoder = @"为您爱宠的靓照写个描述吧~";
        _textView.textColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1];
    }
    [_textView resignFirstResponder];
}
//-(void)test
//{
//    NSLog(@"+++++++++%f--%f", self.view.frame.origin.y, self.view.frame.size.height);
//    NSLog(@"---------%f--%f--%f", sv.frame.origin.y, sv.frame.size.height, sv.contentOffset.y);
//    sv.contentOffset = CGPointMake(0, 0);
//}
#pragma mark -
-(void)rightButtonClick
{
    NSLog(@"编辑");
    _textView.placehoder = @"为您爱宠的靓照写个描述吧~";
    //    if (_textView != nil && ![_textView.text isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
    //        self.tempDes = _textView.text;
    //    }else{
    //        self.tempDes = @"";
    //    }
    [self lauchEditorWithImage:self.oriImage];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -ASI

-(void)postData:(UIImage *)image
{
    //    [MyControl startLoadingWithStatus:@"发布中..."];
    LOADING;
    //    [USER objectForKey:@"aid"]
    NSLog(@"aid：%@", self.aids);
//    if (self.aids == nil) {
//        self.aids = [USER objectForKey:@"lastPublishAid"];
//        self.name = @"";
//    }
    NSString * code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aids];
    [USER setObject:self.aids forKey:@"lastPublishAid"];
    //网络上传
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETIMAGEAPI, self.aids, [MyMD5 md5:code], [ControllerManager getSID]];
    //    if (self.aid != nil) {
    //        code = [NSString stringWithFormat:@"aid=%@dog&cat", self.aid];
    //        url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", PETIMAGEAPI, self.aid, [MyMD5 md5:code], [ControllerManager getSID]];
    //    }
    NSLog(@"postUrl:%@", url);
    _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 30.0;
    
    //    float p = 1.0;
    //    image.
    
    //将图片处理到2000以下再返回data数据
    NSData * data = [MyControl scaleToSize:image];
    /*计算处理到2000以下图片的尺寸是多少，将尺寸加到图片名称中，方便瀑布流使用*/
    float W = image.size.width;
    float H = image.size.height;
    float p = 0;
    if (W>=H && image.size.width>2000) {
        p = 2000/W;
        W *= p;
        H *= p;
    }else if(H>W && image.size.height>2000){
        if (H/W <3) {
            p = 2000/H;
            W *= p;
            H *= p;
        }
    }
    [_request setPostValue:[NSString stringWithFormat:@"%d", self.publishType] forKey:@"is_food"];
    
    NSTimeInterval  timeInterval = [[NSDate date] timeIntervalSince1970];
    [_request setData:data withFileName:[NSString stringWithFormat:@"%.0f%@%ld%@_%d&%d.png", timeInterval, @"@", data.length, @"@", (int)W, (int)H] andContentType:@"image/jpg" forKey:@"image"];
    //    [_request setPostValue:data forKey:@"image"];
    //图片
    if (![_textView.realText isEqualToString:@"为您爱宠的靓照写个描述吧~"]) {
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%@",_textView.realText);
        [_request setPostValue:_textView.realText forKey:@"comment"];
    }else{
        [_request setPostValue:@"" forKey:@"comment"];
    }
    //
    [_request setPostValue:@"" forKey:@"topic_id"];
    NSLog(@"topic:%@", [USER objectForKey:@"topic"]);
    if ([[USER objectForKey:@"topic"] isEqualToString:@"点击添加话题"]) {
        [_request setPostValue:@"" forKey:@"topic_name"];
    }else{
        [_request setPostValue:[USER objectForKey:@"topic"] forKey:@"topic_name"];
    }
    /************/
    if ([users.titleLabel.text isEqualToString:@"点击@小伙伴"]) {
        [_request setPostValue:@"" forKey:@"relates"];
    }else{
        NSLog(@"%@", users.titleLabel.text);
        [_request setPostValue:users.titleLabel.text forKey:@"relates"];
    }
    
    if (self.isFromMasselection) {
        [_request setPostValue:self.starId forKey:@"star_id"];
    }
    //    NSLog(@"%@", _textView.text);
    _request.delegate = self;
    [_request startAsynchronous];
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    [USER setObject:@"1" forKey:@"needRefresh"];
    NSLog(@"success");
    //    StartLoading;
    
    NSLog(@"响应：%@", [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]] && [[[dict objectForKey:@"data"] objectForKey:@"image"] isKindOfClass:[NSDictionary class]]){
        self.img_id = [[[dict objectForKey:@"data"] objectForKey:@"image"] objectForKey:@"img_id"];
    }
    
    if ([[dict objectForKey:@"state"] intValue] == 1) {
        LOADFAILED;
        //        [MMProgressHUD dismissWithError:[dict objectForKey:@"errorMessage"] afterDelay:1];
        NSLog(@"errorMessage:%@", [dict objectForKey:@"errorMessage"]);
        publishButton.userInteractionEnabled = YES;
    }else if([[dict objectForKey:@"state"] intValue] == 2){
        [self login];
    }else{
        int exp = [[USER objectForKey:@"exp"] intValue];
        [USER setObject:[[dict objectForKey:@"data"] objectForKey:@"exp"] forKey:@"exp"];
        int index = [[USER objectForKey:@"exp"] intValue]-exp;
        if (index > 0) {
            
        }
        ENDLOADING;
        //        [MyControl loadingSuccessWithContent:@"发布成功" afterDelay:0.5f];
        
        publishSuc = YES;
        
        [MobClick event:@"photo"];
        
        if (self.publishType == 1) {
            [MobClick event:@"food_suc"];
        }else{
            NSArray * menuList = [USER objectForKey:@"MenuList"];
            if (menuList.count <2) {
                [MobClick event:@"food_suc"];
            }else{
                //匹配
                for(int i=1;i<menuList.count;i++){
                    if ([menuList[i] integerValue] == self.publishType) {
                        if (i == 1) {
                            [MobClick event:@"topic1_suc"];
                        }else if(i == 2){
                            [MobClick event:@"topic2_suc"];
                        }
                    }else if(i == menuList.count-1){
                        [MobClick event:@"food_suc"];
                    }
                }
            }
        }
        
        [self synShare];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    LOADFAILED;
    publishButton.userInteractionEnabled = YES;
    
}
#pragma mark - login
-(void)login
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat",  UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
            
            ENDLOADING;
            //            [self publishButtonClick:publishButton];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = (UIImageOrientation)[representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

#pragma mark - Status Bar Style

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Helper Methods

- (BOOL) hasValidAPIKey
{
    if ([kAFAviaryAPIKey isEqualToString:@"<YOUR-API-KEY>"] || [kAFAviarySecret isEqualToString:@"<YOUR-SECRET>"]) {
        [[[UIAlertView alloc] initWithTitle:@"Oops!"
                                    message:@"You forgot to add your API key and secret!"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}

#pragma mark -图片编辑
#pragma mark =================================
#pragma mark - Photo Editor Launch Methods

//********************自己方法******************
-(void)lauchEditorWithImage:(UIImage *)image
{
    UIImage * editingResImage = image;
    UIImage * highResImage = image;
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}
#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block PublishViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            //保存编辑完的照片
            //            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.oriImage = image;
    bigImageView.image = image;
    for (UIView * view in sv.subviews) {
        [view removeFromSuperview];
    }
    [self makeUI];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [_textView becomeFirstResponder];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //    [_textView becomeFirstResponder];
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set API Key and Secret
    [AFPhotoEditorController setAPIKey:kAFAviaryAPIKey secret:kAFAviarySecret];
    
    // Set Tool Order
    NSArray * toolOrder = @[kAFEffects, kAFFocus, kAFFrames, kAFStickers, kAFEnhance, kAFOrientation, kAFCrop, kAFAdjustments, kAFSplash, kAFDraw, kAFText, kAFRedeye, kAFWhiten, kAFBlemish, kAFMeme];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}

@end
