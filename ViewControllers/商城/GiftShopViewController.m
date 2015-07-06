//
//  GiftShopViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-28.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "GiftShopViewController.h"
#import "UserBagViewController.h"
#import "GiftShopModel.h"
@interface GiftShopViewController ()
{
    NSInteger typeSelectedIndex;
    NSInteger priceSelectedIndex;
}
@property (nonatomic,retain)NSMutableArray *goodGiftDataArray;
@property (nonatomic,retain)NSMutableArray *badGiftDataArray;
@property (nonatomic,retain)NSMutableArray *giftDataArray;

@property (nonatomic,retain)NSMutableArray *goodLowToHighDataArray;
@property (nonatomic,retain)NSMutableArray *goodHighToLowDataArray;
@property (nonatomic,retain)NSMutableArray *badLowToHighDataArray;
@property (nonatomic,retain)NSMutableArray *badHighToLowDataArray;
@end

@implementation GiftShopViewController

//-(void)dealloc
//{
//    [super dealloc];
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cateArray = [NSMutableArray arrayWithObjects:@"全部", @"爱心礼物", @"捣乱礼物", nil];
    self.cateArray2 = [NSMutableArray arrayWithObjects:@"喵喵专用", @"汪汪专用", nil];
    self.orderArray = [NSMutableArray arrayWithObjects:@"由高到低", @"由低到高", nil];
    self.totalGoodsDataArray = [NSMutableArray arrayWithCapacity:0];
    self.priceHighToLowArray = [NSMutableArray arrayWithCapacity:0];
    self.priceLowToHighArray = [NSMutableArray arrayWithCapacity:0];
    self.goodLowToHighDataArray = [NSMutableArray arrayWithCapacity:0];
    self.goodHighToLowDataArray = [NSMutableArray arrayWithCapacity:0];
    self.badLowToHighDataArray = [NSMutableArray arrayWithCapacity:0];
    self.badHighToLowDataArray = [NSMutableArray arrayWithCapacity:0];
    typeSelectedIndex = 0;
    priceSelectedIndex = 1;
    
    [self addGiftShopData];
    [self createBg];
    [self createFakeNavigation];
    [self createHeader];
//    [self createScrollView2];
    [self createScrollView];
    [self createBottom];

//    [self loadData];
    
    
//    [self buyGiftItemsAPI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([USER objectForKey:@"noViewGift"] == nil || [[USER objectForKey:@"noViewGift"] length] == 0 || [[USER objectForKey:@"noViewGift"] intValue] == 0) {
        greenBall.hidden = YES;
    }else{
        giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
        greenBall.hidden = NO;
    }
}

#pragma mark -
- (void)buyGiftItemsAPI:(NSInteger)tag
{
    GiftsModel *model = self.giftDataArray[tag];
    
    if([model.price intValue] > [[USER objectForKey:@"gold"] intValue]){
        //余额不足
        if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
            //审核
            [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来购物吧~"];
        }else{
            [ControllerManager addAlertWith:self Cost:[model.price intValue] SubType:2];
        }
        return;
    }
    
    
    NSString *item = model.gift_id;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"item_id=%@&num=1dog&cat",item]];
    NSString *buyItemsString = [NSString stringWithFormat:@"%@%@&num=1&sig=%@&SID=%@",BUYSHOPGIFTAPI,item,sig,[ControllerManager getSID]];
//    NSLog(@"购买商品api:%@",buyItemsString);
    
    __block GiftShopViewController * blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:buyItemsString Block:^(BOOL isFinish, httpDownloadBlock *load) {
//        NSLog(@"购买商品结果：%@",load.dataDict);
        if (isFinish) {
            NSString * level = [NSString stringWithFormat:@"%d", ([item intValue]/100)%10];
            NSString * name = item;
            [MobClick event:@"buy_gift" attributes:@{@"level":level, @"name":name}];
            
            [USER setObject:[NSString stringWithFormat:@"%@",[[load.dataDict objectForKey:@"data"] objectForKey:@"user_gold"]] forKey:@"gold"];
            blockSelf->BottomGold.text = [USER objectForKey:@"gold"];
            int noViewGiftNumber = [[USER objectForKey:@"noViewGift"] intValue];
            [USER setObject:[NSString stringWithFormat:@"%d",noViewGiftNumber+1] forKey:@"noViewGift"];
            blockSelf->giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
            if ([blockSelf->giftNum.text isEqualToString:@""]) {
                blockSelf->greenBall.hidden = YES;
            }else{
                blockSelf->greenBall.hidden = NO;
            }
            
            [MyControl popAlertWithView:blockSelf.view Msg:[NSString stringWithFormat:@"大人，您购买的 %@，小的已经给您送到储物箱了", model.name]];
//            PopupView * pop = [[PopupView alloc] init];
//            [pop modifyUIWithSize:blockSelf.view.frame.size msg:[NSString stringWithFormat:@"大人，您购买的 %@，小的已经给您送到储物箱了", model.name]];
//            [blockSelf.view addSubview:pop];
//            [pop release];
//            
//            __block PopupView * blockPop = pop;
//            [UIView animateWithDuration:0.2 animations:^{
//                blockPop.bgView.alpha = 1;
//            } completion:^(BOOL finished) {
//                [UIView animateKeyframesWithDuration:0.2 delay:2 options:0 animations:^{
//                    blockPop.bgView.alpha = 0;
//                } completion:^(BOOL finished) {
//                    [blockPop removeFromSuperview];
//                }];
//            }];
//            [ControllerManager HUDText:[NSString stringWithFormat:@"大人，您购买的 %@，小的已经给您送到储物箱了", model.name] showView:self.view yOffset:0];
        }
    }];
    [request release];
}
- (void)addGiftShopData
{
    self.goodGiftDataArray =[NSMutableArray arrayWithCapacity:0];
    self.badGiftDataArray = [NSMutableArray arrayWithCapacity:0];
    self.giftDataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dict = [ControllerManager returnTotalGiftDict];
    NSMutableArray *allKeys = [NSMutableArray arrayWithArray:[dict allKeys]];
    //排序 gift_id从小到大
    for (int i=0; i<allKeys.count; i++) {
        for (int j=0; j<allKeys.count-1-i; j++) {
            if ([allKeys[j] intValue]>[allKeys[j+1] intValue]) {
                NSString * giftId1 = allKeys[j];
                NSString * giftId2 = allKeys[j+1];
                allKeys[j] = giftId2;
                allKeys[j+1] = giftId1;
            }
        }
    }
    
    for (NSString *giftId in allKeys) {
        GiftsModel *model = [ControllerManager returnGiftsModelWithGiftId:giftId];
        [self.giftDataArray addObject:model];
        [self.totalGoodsDataArray addObject:model];
//        NSLog(@"%@gift_id@",model.gift_id);
        if ([model.gift_id integerValue] < 2000) {
            [self.goodGiftDataArray addObject:model];
        }else{
            [self.badGiftDataArray addObject:model];
        }
    }
//    NSLog(@"%ld",    self.goodGiftDataArray.count);
//    NSLog(@"%@",    [self.goodGiftDataArray[16] gift_id]);
//
//    NSLog(@"%ld",    self.badGiftDataArray.count);
    
    //排序 price 从小到大
    self.priceLowToHighArray = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
    for (int i=0; i<self.priceLowToHighArray.count; i++) {
        for (int j=0; j<self.priceLowToHighArray.count-1-i; j++) {
            if ([[self.priceLowToHighArray[j] price] intValue]>[[self.priceLowToHighArray[j+1] price] intValue]) {
                GiftsModel * model1 = self.priceLowToHighArray[j];
                GiftsModel * model2 = self.priceLowToHighArray[j+1];
                self.priceLowToHighArray[j] = model2;
                self.priceLowToHighArray[j+1] = model1;
            }
        }
    }
    
    for (GiftsModel *model in self.priceLowToHighArray) {
        if ([model.gift_id integerValue] < 2000) {
            [self.goodLowToHighDataArray addObject:model];
        }else{
            [self.badLowToHighDataArray addObject:model];
        }
    }
    
    //排序 price 从大到小
    self.priceHighToLowArray = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
    for (int i=0; i<self.priceHighToLowArray.count; i++) {
        for (int j=0; j<self.priceHighToLowArray.count-1-i; j++) {
            if ([[self.priceHighToLowArray[j] price] intValue]<[[self.priceHighToLowArray[j+1] price] intValue]) {
                GiftsModel * model1 = self.priceHighToLowArray[j];
                GiftsModel * model2 = self.priceHighToLowArray[j+1];
                self.priceHighToLowArray[j] = model2;
                self.priceHighToLowArray[j+1] = model1;
            }
        }
    }
    
    for (GiftsModel *model in self.priceHighToLowArray) {
        if ([model.gift_id integerValue] < 2000) {
            [self.goodHighToLowDataArray addObject:model];
        }else{
            [self.badHighToLowDataArray addObject:model];
        }
    }
    
    self.showArray = self.totalGoodsDataArray;
//    NSLog(@"%ld",self.showArray.count);
    
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopGift" ofType:@"plist"];
//    NSMutableDictionary *DictData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSArray *level0 = [[DictData objectForKey:@"good"] objectForKey:@"level0"];
//    NSArray *level1 =[[DictData objectForKey:@"good"] objectForKey:@"level1"];
//    NSArray *level2 =[[DictData objectForKey:@"good"] objectForKey:@"level2"];
//    NSArray *level3 =[[DictData objectForKey:@"good"] objectForKey:@"level3"];
//    [self addData:level0 isGood:YES];
//    [self addData:level1 isGood:YES];
//    [self addData:level2 isGood:YES];
//    [self addData:level3 isGood:YES];
//    
//    NSArray *level4 =[[DictData objectForKey:@"bad"] objectForKey:@"level0"];
////    NSArray *level5 =[[DictData objectForKey:@"bad"] objectForKey:@"level1"];
////    NSArray *level6 =[[DictData objectForKey:@"bad"] objectForKey:@"level2"];
//    [self addData:level4 isGood:NO];
////    [self addData:level5 isGood:NO];
////    [self addData:level6 isGood:NO];
//    
////    NSLog(@"data:%@",DictData);
//    [self.totalGoodsDataArray addObjectsFromArray:self.goodGiftDataArray];
//    [self.totalGoodsDataArray addObjectsFromArray:self.badGiftDataArray];
////    self.totalGoodsDataArray = [NSMutableArray arrayWithArray:[ControllerManager returnAllGiftsArray]];
//    self.showArray = self.totalGoodsDataArray;
//
//    NSMutableArray * temp1 = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
//    NSMutableArray * temp2 = [NSMutableArray arrayWithArray:self.totalGoodsDataArray];
//    //从高到低
//    for (int i=0; i<temp1.count; i++) {
//        for (int j=0; j<temp1.count-1-i; j++) {
//            if ([[temp1[j] price] intValue]<[[temp1[j+1] price] intValue]) {
//                GiftShopModel * model1 = temp1[j];
//                GiftShopModel * model2 = temp1[j+1];
//                temp1[j] = model2;
//                temp1[j+1] = model1;
//            }
//        }
//    }
//    self.priceHighToLowArray = [NSMutableArray arrayWithArray:temp1];
//    //从低到高
//    for (int i=0; i<temp2.count; i++) {
//        for (int j=0; j<temp2.count-1-i; j++) {
//            if ([[temp2[j] price] intValue]>[[temp2[j+1] price] intValue]) {
//                GiftShopModel * model1 = temp2[j];
//                GiftShopModel * model2 = temp2[j+1];
//                temp2[j] = model2;
//                temp2[j+1] = model1;
//            }
//        }
//    }
//    self.priceLowToHighArray = [NSMutableArray arrayWithArray:temp2];
}
//- (void)addData:(NSArray *)array isGood:(BOOL)good
//{
//    for (NSDictionary *dict in array) {
//        GiftShopModel *model = [[GiftShopModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
//        if (good) {
//            [self.goodGiftDataArray addObject:model];
//        }else{
//            [self.badGiftDataArray addObject:model];
//        }
//        [self.giftDataArray addObject:model];
//        [model release];
//    }
//}
//- (void)loadData
//{
//    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"code=dog&cat"]];
//    NSString *itemsString = [NSString stringWithFormat:@"%@&sig=%@&SID=%@",SHOPITEMSAPI,sig,[ControllerManager getSID]];
//    NSLog(@"itemsString:%@",itemsString);
//}
/****************/

-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
//    self.bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
//    [self.view addSubview:self.bgImageView];
//    //    self.bgImageView.backgroundColor = [UIColor redColor];
////    NSString * docDir = DOCDIR;
//    NSString * filePath = BLURBG;
//    NSLog(@"%@", filePath);
//    NSData * data = [NSData dataWithContentsOfFile:filePath];
//    //    NSLog(@"%@", data);
//    UIImage * image = [UIImage imageWithData:data];
//    self.bgImageView.image = image;
//    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
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
    
    backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick:) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UIButton * titleBtn = [MyControl createButtonWithFrame:CGRectMake(60, 64-20-12-5, 200, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"礼物商城"];
    [titleBtn setTitle:@"现实礼物" forState:UIControlStateSelected];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:titleBtn];
    
//    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake(60, 64-20-12, 200, 20) Font:17 Text:@"虚拟礼物"];
//    titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    [navView addSubview:titleLabel];
    
    UIImageView * giftImageView = [MyControl createImageViewWithFrame:CGRectMake(320-31, 30, 51*0.4, 55*0.4) ImageName:@"tool4.png"];
    [navView addSubview:giftImageView];
    
    greenBall = [MyControl createImageViewWithFrame:CGRectMake(13, -5, 15, 15) ImageName:@"greenBall.png"];
    [giftImageView addSubview:greenBall];
    
    giftNum = [MyControl createLabelWithFrame:CGRectMake(-5, 0, 25, 15) Font:9 Text:nil];
//    giftNum.text = [NSString stringWithFormat:@"%@",[USER objectForKey:@"noViewGift"]];
    giftNum.font = [UIFont boldSystemFontOfSize:9];
    giftNum.textAlignment = NSTextAlignmentCenter;
    [greenBall addSubview:giftNum];
    
    UIButton * giftBagBtn = [MyControl createButtonWithFrame:CGRectMake(320-41, 24, 51*0.6, 55*0.6) ImageName:@"" Target:self Action:@selector(giftBagBtnClick) Title:nil];
//    giftBagBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    giftBagBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:giftBagBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
-(void)titleBtnClick:(UIButton *)btn
{
    return;
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        sv2.hidden = NO;
        sv.hidden = YES;
        sv2.contentOffset = CGPointMake(0, 0);
    }else{
        sv.hidden = NO;
        sv2.hidden = YES;
        sv.contentOffset = CGPointMake(0, 0);
    }
}
-(void)backBtnClick:(UIButton *)button
{
    if (self.isQuick) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [USER setObject:@"" forKey:@"noViewGift"];
        [self dismissViewControllerAnimated:YES completion:nil];
//        button.selected = !button.selected;
//        JDSideMenu * menu = [ControllerManager shareJDSideMenu];
//        if (button.selected) {
//            [menu showMenuAnimated:YES];
//            alphaBtn.hidden = NO;
//            [UIView animateWithDuration:0.25 animations:^{
//                alphaBtn.alpha = 0.5;
//            }];
//        }else{
//            [menu hideMenuAnimated:YES];
//            [UIView animateWithDuration:0.25 animations:^{
//                alphaBtn.alpha = 0;
//            } completion:^(BOOL finished) {
//                alphaBtn.hidden = YES;
//            }];
//        }
    }
}
-(void)giftBagBtnClick
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    NSLog(@"跳转到我的背包");
//    UserInfoViewController * vc = [[UserInfoViewController alloc] init];
//    vc.offset = 320*3;
//    [self presentViewController:vc animated:YES completion:nil];
//    [vc release];
    [USER setObject:@"" forKey:@"noViewGift"];
    UserBagViewController *userBagVC = [[UserBagViewController alloc] init];
    [self presentViewController:userBagVC animated:YES completion:^{
        [userBagVC release];
    }];
}
-(void)createHeader
{
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    headerBgView.backgroundColor = ORANGE;
    headerBgView.alpha = 0.2;
    [headerView addSubview:headerBgView];
    
    cateBtn = [MyControl createButtonWithFrame:CGRectMake(35, 5, 90, 25) ImageName:@"" Target:self Action:@selector(cateBtnClick) Title:@"全部"];
    cateBtn.layer.cornerRadius = 5;
    cateBtn.layer.masksToBounds = YES;
    cateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    cateBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:cateBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(76, 9, 10, 8) ImageName:@"5-2.png"];
    [cateBtn addSubview:triangle1];
    
    orderBtn = [MyControl createButtonWithFrame:CGRectMake(196, 5, 90, 25) ImageName:@"" Target:self Action:@selector(orderBtnClick) Title:@"价格"];
    orderBtn.layer.cornerRadius = 5;
    orderBtn.layer.masksToBounds = YES;
    orderBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    orderBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:orderBtn];
    
    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(76, 9, 10, 8) ImageName:@"5-2.png"];
    [orderBtn addSubview:triangle2];
}

-(void)cateBtnClick{
    NSLog(@"cate");
    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:cateBtn :&f :self.cateArray];
        [dropDown setDefaultCellType];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
        isCateShow = YES;
    }else{
        [dropDown hideDropDown:cateBtn];
        isCateShow = NO;
        [self rel];
    }
}
-(void)orderBtnClick{
    NSLog(@"order");
    if (dropDown2 == nil) {
        CGFloat f = 120;
        dropDown2 = [[NIDropDown alloc] showDropDown:orderBtn :&f :self.orderArray];
        [dropDown2 setDefaultCellType];
        dropDown2.delegate = self;
        if (!isCateShow) {
            headerView.frame = CGRectMake(0, 64, 320, 35+120);
        }
        isOrderShow = YES;
    }else{
        isOrderShow = NO;
        [dropDown2 hideDropDown:orderBtn];
        [self rel2];
    }

}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        isCateShow = NO;
        [self rel];
    }else{
        isOrderShow = NO;
        [self rel2];
    }
    
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
//    NSLog(@"%d--%@", Line, Words);
    if (sender == dropDown) {
        [sv removeFromSuperview];
        typeSelectedIndex = Line;
        
        if (Line == 0) {
//            self.showArray = self.totalGoodsDataArray;
//            self.giftDataArray = self.totalGoodsDataArray;
            if (priceSelectedIndex == 0) {
                self.showArray = self.priceHighToLowArray;
            }else{
                self.showArray = self.priceLowToHighArray;
            }
        }else if(Line == 1){
//            self.showArray = self.goodGiftDataArray;
//            self.giftDataArray = self.goodGiftDataArray;
            if (priceSelectedIndex == 0) {
                self.showArray = self.goodHighToLowDataArray;
            }else{
                self.showArray = self.goodLowToHighDataArray;
            }
        }else if(Line == 2){
//            self.showArray = self.badGiftDataArray;
//            self.giftDataArray = self.badGiftDataArray;
            if (priceSelectedIndex == 0) {
                self.showArray = self.badHighToLowDataArray;
            }else{
                self.showArray = self.badLowToHighDataArray;
            }
        }
        [self createScrollView];
    }else{
        [sv removeFromSuperview];
        priceSelectedIndex = Line;
        
        if (Line == 0) {
            if (typeSelectedIndex == 0) {
                self.showArray = self.priceHighToLowArray;
            }else if(typeSelectedIndex == 1){
                self.showArray = self.goodHighToLowDataArray;
            }else{
                self.showArray = self.badHighToLowDataArray;
            }
//            self.showArray = self.priceHighToLowArray;
        }else{
            if (typeSelectedIndex == 0) {
                self.showArray = self.priceLowToHighArray;
            }else if(typeSelectedIndex == 1){
                self.showArray = self.goodLowToHighDataArray;
            }else{
                self.showArray = self.badLowToHighDataArray;
            }
//            self.showArray = self.priceLowToHighArray;
        }
        [self createScrollView];
    }
//    int temp = 0;
//    for (int i=1; i< self.goodGiftDataArray.count; i++) {
//        GiftShopModel *model = self.goodGiftDataArray[i];
//        temp = [model.price intValue];
//        if (model) {
//            <#statements#>
//        }
//    }
//    [self.goodGiftDataArray exchangeObjectAtIndex:<#(NSUInteger)#> withObjectAtIndex:<#(NSUInteger)#>]
}
-(void)rel
{
    if (isOrderShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+120);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    if (isCateShow) {
        headerView.frame = CGRectMake(0, 64, 320, 35+200);
    }else{
        headerView.frame = CGRectMake(0, 64, 320, 35);
    }
    [dropDown2 release];
    dropDown2 = nil;
}

#pragma mark - createUI
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+35, 320, self.view.frame.size.height-40-64-35)];
    //    sv.contentSize = CGSizeMake(320, 64+35+15+(30/3)*100);
    [self.view addSubview:sv];
    
    [self.view bringSubviewToFront:navView];
    [self.view bringSubviewToFront:headerView];
    int index = (int)self.showArray.count;
    if (index%2) {
        sv.contentSize = CGSizeMake(self.view.frame.size.width, 15+(index/2+1)*160);
    }else{
        sv.contentSize = CGSizeMake(self.view.frame.size.width, 15+(index/2)*160);
    }
    //5.28
//    GiftsModel *model = [ControllerManager returnGiftsModelWithGiftId];

//    GiftsModel *imageModel
    NSDictionary *imageDict = [ControllerManager returnTotalGiftDict];
    NSMutableArray *arrayGiftId = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *arrayDetailImage = [NSMutableArray arrayWithCapacity:1];
//    [arrayGiftId setValuesForKeysWithDictionary:imageDict];
    [arrayGiftId addObjectsFromArray:[imageDict allKeys]];
    [arrayDetailImage addObjectsFromArray:[imageDict allValues]];
//    NSLog(@"index:%d",index);
    
    /***************************/
    for(int i=0; i<index; i+=2){
        //白色背景
        UIImageView * giftBgImageView = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-500/2)/2.0, (i/2)*160+10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView];
        
        UIImageView * giftBgImageView2 = [MyControl createImageViewWithFrame:CGRectMake(giftBgImageView.frame.origin.x+274/2, (i/2)*160+10, 222/2, 190/2) ImageName:@"giftAlert_giftBg.png"];
        [sv addSubview:giftBgImageView2];
//        if ((i+2)%4 == 0) {
//            giftBgImageView.frame = CGRectMake(25+i/4*300, 10+310/2, 222/2, 190/2);
//            giftBgImageView2.frame = CGRectMake(324/2+i/4*300, 10+310/2, 222/2, 190/2);
//        }
        
        //礼物图片
        UIImageView * giftImageView = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView addSubview:giftImageView];
        
        UIImageView * giftImageView2 = [MyControl createImageViewWithFrame:CGRectMake((111-98)/2.0, (95-93)/2.0, 98, 83) ImageName:@""];
        [giftBgImageView2 addSubview:giftImageView2];
        
        
        //木板
        UIImageView * wood = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-546/2)/2.0, giftBgImageView.frame.origin.y+190/2, 546/2, 17/2.0) ImageName:@"giftAlert_wood.png"];
        [sv addSubview:wood];
        
        //
        UIImageView * hang_tag = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+4, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag];
        
        UIImageView * hang_tag2 = [MyControl createImageViewWithFrame:CGRectMake(wood.frame.origin.x+wood.frame.size.width-4-246/2, wood.frame.origin.y-1, 246/2, 106/2) ImageName:@""];
        [sv addSubview:hang_tag2];
        
        //礼物名称
        UILabel * productLabel = [MyControl createLabelWithFrame:CGRectMake(10, 18, 80, 15) Font:12 Text:nil];
        productLabel.font = [UIFont boldSystemFontOfSize:12];
        productLabel.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        [hang_tag addSubview:productLabel];
        
        UILabel * productLabel2 = [MyControl createLabelWithFrame:CGRectMake(10, 18, 80, 15) Font:12 Text:nil];
        productLabel2.font = [UIFont boldSystemFontOfSize:12];
        productLabel2.textColor = [ControllerManager colorWithHexString:@"5F5E5E"];
        [hang_tag2 addSubview:productLabel2];
        
        //人气
        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(90, 20, 30, 15) Font:12 Text:@"人气"];
        rq.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag addSubview:rq];
        
        UILabel * rq2 = [MyControl createLabelWithFrame:CGRectMake(90, 20, 30, 15) Font:12 Text:@"人气"];
        rq2.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag2 addSubview:rq2];
        
        //人气值
        UILabel * rqz = [MyControl createLabelWithFrame:CGRectMake(80, 35, 42, 15) Font:12 Text:@"+100"];
        rqz.textAlignment = NSTextAlignmentCenter;
        rqz.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag addSubview:rqz];
        
        UILabel * rqz2 = [MyControl createLabelWithFrame:CGRectMake(80, 35, 42, 15) Font:12 Text:@"+100"];
        rqz2.textAlignment = NSTextAlignmentCenter;
        rqz2.font = [UIFont boldSystemFontOfSize:12];
        [hang_tag2 addSubview:rqz2];
        //金币图标及价格
        UIImageView * gold = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"gold.png"];
        [hang_tag addSubview:gold];
        
        UILabel * price = [MyControl createLabelWithFrame:CGRectMake(33, 34, 40, 17) Font:15 Text:nil];
        price.font = [UIFont boldSystemFontOfSize:13];
        price.textColor = BGCOLOR;
        [hang_tag addSubview:price];
        
        UIImageView * gold2 = [MyControl createImageViewWithFrame:CGRectMake(10, 35, 15, 15) ImageName:@"gold.png"];
        [hang_tag2 addSubview:gold2];
        
        UILabel * price2 = [MyControl createLabelWithFrame:CGRectMake(33, 34, 40, 17) Font:15 Text:@""];
        price2.font = [UIFont boldSystemFontOfSize:13];
        price2.textColor = BGCOLOR;
        [hang_tag2 addSubview:price2];
        
        //
        CGRect rect = giftBgImageView.frame;
        CGRect rect2 = giftBgImageView2.frame;
        UIButton * sendGiftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
        sendGiftBtn.tag = 1000+i;
        [giftBgImageView addSubview:sendGiftBtn];
        
        UIButton * sendGiftBtn2 = [MyControl createButtonWithFrame:CGRectMake(0, 0, rect2.size.width, rect2.size.height) ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
        sendGiftBtn2.tag = 1000+i+1;
        [giftBgImageView2 addSubview:sendGiftBtn2];
        /*******************i*********************/
//        NSLog(@"showArray%@", self.showArray[i]);
        if ([[self.showArray[i] gift_id] intValue]>2000) {
            hang_tag.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
        }else{
            hang_tag.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
        }
        //5.28
//        giftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.showArray[i] gift_id]]];
        
        NSString *url = [self.showArray[i] detail_image];
//        NSLog(@"gift_url:%@", url);
//        NSMutableData *data = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        giftImageView.image = [UIImage imageWithData:data];
        [giftImageView setImageWithURL:[NSURL URLWithString:url]];
//        NSLog(@"imageNamed%@//%d", [self.showArray[i] detail_image],i);
        
        productLabel.text = [self.showArray[i] name];
        rqz.text = [self.showArray[i] add_rq];
        price.text = [self.showArray[i] price];
        
        /*******************i+1*********************/
        
        if ([[self.showArray[i+1] gift_id] intValue]>2000) {
            hang_tag2.image = [UIImage imageNamed:@"giftAlert_badBg.png"];
        }else{
            hang_tag2.image = [UIImage imageNamed:@"giftAlert_goodBg.png"];
        }
        //5.28
        NSString *url2 = [self.showArray[i+1] detail_image];
//        NSLog(@"gift_url:%@", url2);
//        NSMutableData *data2 = [NSMutableData dataWithContentsOfURL:[NSURL URLWithString:url2]];
//        giftImageView2.image = [UIImage imageWithData:data2];
        [giftImageView2 setImageWithURL:[NSURL URLWithString:url2]];

//        giftImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.showArray[i+1] gift_id]]];
//        NSLog(@"imageNamed:%@",giftImageView2.image);
        productLabel2.text = [self.showArray[i+1] name];
        rqz2.text = [self.showArray[i+1] add_rq];
        price2.text = [self.showArray[i+1] price];
        
//        CGRect rect = CGRectMake(20+i%3*100, 64+35+15+i/3*100, 85, 90);
//        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"product_bg.png"];
//        if ([[self.showArray[i] gift_id] intValue]>=2000) {
//            imageView.image = [UIImage imageNamed:@"trick_bg.png"];
//        }
//        [sv addSubview:imageView];
//        
////        UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
////        [imageView addSubview:triangle];
//        
//        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(0, 3, 20, 9) Font:7 Text:@"人气"];
//        rq.font = [UIFont boldSystemFontOfSize:7];
//        rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
//        [imageView addSubview:rq];
//        
//        UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(0, 10, 25, 8) Font:9 Text:@"+150"];
//        rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
//        rqNum.textAlignment = NSTextAlignmentCenter;
//        //            rqNum.backgroundColor = [UIColor redColor];
//        [imageView addSubview:rqNum];
//        
//        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(0, 5, 85, 15) Font:11 Text:@"汪汪项圈"];
//        giftName.textColor = [UIColor grayColor];
//        giftName.textAlignment = NSTextAlignmentCenter;
//        [imageView addSubview:giftName];
//        
//        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(5, 20, 75, 50) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
//        [imageView addSubview:giftPic];
//        
//        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(20, 90-14-5, 15, 15) ImageName:@"gold.png"];
//        [imageView addSubview:gift];
//        
//        UILabel * giftPrice = [MyControl createLabelWithFrame:CGRectMake(42, 90-19, 40, 15) Font:13 Text:[NSString stringWithFormat:@"%d", i*50+50]];
//        giftPrice.textColor = BGCOLOR;
//        [imageView addSubview:giftPrice];
//        
//        //新品，推荐，热卖标注
//        UIImageView * label = [MyControl createImageViewWithFrame:CGRectMake(62, -6, 73/2, 46/2) ImageName:@"right_corner.png"];
//        [imageView addSubview:label];
//        label.hidden = YES;
//        
//        UILabel * labelLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 73/2, 46/2) Font:12 Text:nil];
//        labelLabel.textAlignment = NSTextAlignmentCenter;
//        [label addSubview:labelLabel];
//        
//        if (i == 0) {
//            label.hidden = NO;
//            labelLabel.text = @"新品";
//        }else if (i == 2) {
//            label.hidden = NO;
//            labelLabel.text = @"热卖";
//        }else if (i == 3) {
//            label.hidden = NO;
//            labelLabel.text = @"特卖";
//        }
//        
//        UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick:) Title:nil];
//        [sv addSubview:button];
//        button.tag = 1000+i;
//        
//        //更换礼物图片
//        GiftShopModel *model = self.showArray[i];
//        if ([model.add_rq rangeOfString:@"-"].location == NSNotFound) {
//            rqNum.text = [NSString stringWithFormat:@"+%@",model.add_rq];
//        }else{
//            rqNum.text = [NSString stringWithFormat:@"%@",model.add_rq];
//        }
//        giftPrice.text = model.price;
//        giftPic.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",model.gift_id]];
//        giftName.text=model.name;
        
    }
    
    [self.view bringSubviewToFront:alphaBtn];
}

//-(void)createScrollView2
//{
//    
//    /************现实礼物******************/
//    sv2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-40)];
//    sv2.contentSize = CGSizeMake(320, 64+35+15+(30/2)*185);
//    [self.view addSubview:sv2];
//    sv2.hidden = YES;
//    
//    [self.view bringSubviewToFront:navView];
//    [self.view bringSubviewToFront:headerView];
//    
//    for(int i=0;i<3*10;i++){
//        CGRect rect = CGRectMake(10+i%2*155, 64+35+15+i/2*185, 138, 170);
//        UIImageView * imageView = [MyControl createImageViewWithFrame:rect ImageName:@"giftBg.png"];
//        [sv2 addSubview:imageView];
//        
//        UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 32, 32) ImageName:@"gift_triangle.png"];
//        [imageView addSubview:triangle];
//        
//        UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(-3, 1, 20, 9) Font:8 Text:@"人气"];
//        rq.font = [UIFont boldSystemFontOfSize:8];
//        rq.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
//        [triangle addSubview:rq];
//        
//        UILabel * rqNum = [MyControl createLabelWithFrame:CGRectMake(-1, 8, 25, 10) Font:9 Text:@"+150"];
//        rqNum.transform = CGAffineTransformMakeRotation(-45.0*M_PI/180.0);
//        rqNum.textAlignment = NSTextAlignmentCenter;
//        //            rqNum.backgroundColor = [UIColor redColor];
//        [triangle addSubview:rqNum];
//        
//        UIImageView * giftPic = [MyControl createImageViewWithFrame:CGRectMake(33, 10, 70, 90) ImageName:[NSString stringWithFormat:@"bother%d_2.png", arc4random()%6+1]];
//        [imageView addSubview:giftPic];
//        
//        NSString * str = @"伟嘉 宠物猫粮 幼猫 海洋鱼味1.2kg";
//        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(108, 100) lineBreakMode:1];
//        UILabel * giftName = [MyControl createLabelWithFrame:CGRectMake(15, 105, 138-30, size.height) Font:12 Text:str];
//        giftName.textColor = [UIColor grayColor];
////        giftName.textAlignment = NSTextAlignmentCenter;
//        [imageView addSubview:giftName];
//        
//        UIImageView * gift = [MyControl createImageViewWithFrame:CGRectMake(43, 150, 15, 15) ImageName:@"gold.png"];
//        [imageView addSubview:gift];
//        
//        UILabel * giftNum = [MyControl createLabelWithFrame:CGRectMake(65, 170-20, 40, 15) Font:13 Text:[NSString stringWithFormat:@"%d", i*100+2000]];
//        giftNum.textColor = BGCOLOR;
//        [imageView addSubview:giftNum];
//        
//        //新品，推荐，热卖标注
//        UIImageView * label = [MyControl createImageViewWithFrame:CGRectMake(110, -6, 73/2, 46/2) ImageName:@"right_corner.png"];
//        [imageView addSubview:label];
//        label.hidden = YES;
//        
//        UILabel * labelLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, 73/2, 46/2) Font:12 Text:nil];
//        labelLabel.textAlignment = NSTextAlignmentCenter;
//        [label addSubview:labelLabel];
//        
////        if (i == 0) {
////            label.hidden = NO;
////            labelLabel.text = @"新品";
////        }else if (i == 2) {
////            label.hidden = NO;
////            labelLabel.text = @"热卖";
////        }else if (i == 3) {
////            label.hidden = NO;
////            labelLabel.text = @"特卖";
////        }
//        
//        UIButton * button = [MyControl createButtonWithFrame:rect ImageName:@"" Target:self Action:@selector(buttonClick2:) Title:nil];
//        [sv2 addSubview:button];
//        button.tag = 2000+i;
//    }
//}
-(void)buttonClick:(UIButton *)btn
{
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    NSLog(@"点击了虚拟礼物第%ld个", btn.tag-1000+1);
    [self buyGiftItemsAPI:btn.tag -1000];
}
-(void)buttonClick2:(UIButton *)btn
{
    NSLog(@"点击了现实礼物第%ld个", btn.tag-2000+1);
}
#pragma mark - createBottom
-(void)createBottom
{
    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-40, 320, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel * MyGold = [MyControl createLabelWithFrame:CGRectMake(10, 10, 100, 20) Font:15 Text:@"我的金币："];
    MyGold.textColor = [UIColor blackColor];
    [view addSubview:MyGold];
    
    CGSize size = [MyGold.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    
    BottomGold = [MyControl createLabelWithFrame:CGRectMake(MyGold.frame.origin.x+size.width, 10, 100, 20) Font:15 Text:[USER objectForKey:@"gold"]];
    BottomGold.textColor = BGCOLOR;
    [view addSubview:BottomGold];
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        BottomGold.text = @"500";
    }
    
    UIButton * moreGold = [MyControl createButtonWithFrame:CGRectMake(220, (40-25)/2.0, 90, 25) ImageName:@"" Target:self Action:@selector(moreGoldClick) Title:@"更多金币"];
    moreGold.titleLabel.font = [UIFont systemFontOfSize:15];
    moreGold.backgroundColor = BGCOLOR;
    moreGold.layer.cornerRadius = 5;
    moreGold.layer.masksToBounds = YES;
    moreGold.showsTouchWhenHighlighted = YES;
    moreGold.hidden = YES;
    [view addSubview:moreGold];
}
-(void)moreGoldClick
{
    NSLog(@"金币充值");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
