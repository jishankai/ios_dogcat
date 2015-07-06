//
//  FoodViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/2.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodCell.h"
#import "BegFoodListModel.h"
#import "Alert_2ButtonView2.h"
#import "ChargeViewController.h"
#import "UserCardViewController.h"
#import "PetMainViewController.h"
#import "MsgViewController.h"
#import "MenuModel.h"

@interface FoodViewController ()
{
    UIImageView *guide;
}
@end

@implementation FoodViewController

-(void)viewWillAppear:(BOOL)animated
{
    if (![[USER objectForKey:@"guide_food"] intValue]) {
        [self createGuide];
        [USER setObject:@"1" forKey:@"guide_food"];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
//    isLoaded = YES;
    [super viewDidAppear:animated];
    if ([[USER objectForKey:@"hasRemoteNotification"] intValue]) {
        [USER setObject:@"0" forKey:@"hasRemoteNotification"];
        MsgViewController * vc = [[MsgViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        [vc release];
        [nc release];
    }
}
-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide2.png"];
    if(self.view.frame.size.height <= 480){
        [MyControl setHeight:568 WithView:guide];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [guide addGestureRecognizer:tap];
    
    FirstTabBarViewController * tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabBar.view addSubview:guide];
    [tap release];
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
        [guide removeFromSuperview];
    }];
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createFakeNavigation];
    
    [self createReward];
    
    [self createTableView];
//    [self createBottom];
    [self loadData];
    
//    isLoaded = YES;
}

-(void)loadData
{
    if (isLoading) {
        NSLog(@"拒绝访问");
        return;
    }
    isLoading = YES;
    page = 0;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", BEGFOODAPI, page, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    
    __block FoodViewController * blockSelf = self;
    
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"%@", load.dataDict);
            if (![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]] || [[[load.dataDict objectForKey:@"data"] objectAtIndex:0] count] == 0) {
//                ENDLOADING;
                blockSelf->isLoading = NO;
                return;
            }
            
            [blockSelf.dataArray removeAllObjects];
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            for (NSDictionary * dict in array) {
                BegFoodListModel * model = [[BegFoodListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.dataArray addObject:model];
                [model release];
            }
            
            blockSelf->page++;
            [blockSelf->tv reloadData];

            [UIView animateWithDuration:0.2 animations:^{
                blockSelf->tv.contentOffset = CGPointMake(0, 0);
            }];
            
            //刷新赏按钮
            [blockSelf scrollViewDidEndDecelerating:blockSelf->tv];
            [blockSelf refreshHeader:0];
            blockSelf->isLoading = NO;
//            ENDLOADING;
        }else{
            blockSelf->isLoading = NO;
            LOADFAILED;
            NSLog(@"========myStar========");
        }
    }];
    [request release];
}

-(void)loadMoreData
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%d&sig=%@&SID=%@", BEGFOODAPI, page, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    __block FoodViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if (![[[load.dataDict objectForKey:@"data"] objectAtIndex:0] isKindOfClass:[NSArray class]]) {
//                ENDLOADING;
                return;
            }
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (!array.count) {
                return;
            }
            for (NSDictionary * dict in array) {
                BegFoodListModel * model = [[BegFoodListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArray addObject:model];
                [model release];
            }
            blockSelf->page++;
            [blockSelf->tv reloadData];
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)createFakeNavigation
{
    UIImageView * image = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:image];
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    petHeadBtn = [MyControl createButtonWithFrame:CGRectMake(25, 20, 38, 38) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    petHeadBtn.layer.cornerRadius = 19;
    petHeadBtn.layer.masksToBounds = YES;
    [navView addSubview:petHeadBtn];
    
    sex = [MyControl createImageViewWithFrame:CGRectMake(70, petHeadBtn.frame.origin.y+5, 13, 13) ImageName:@"man.png"];
    sex.hidden = YES;
    [navView addSubview:sex];
    
    petName = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x+15, petHeadBtn.frame.origin.y+5, 200, 15) Font:13 Text:@"我是大萌星"];
    [navView addSubview:petName];
    
    petType = [MyControl createLabelWithFrame:CGRectMake(sex.frame.origin.x, 40, 100, 15) Font:11 Text:@"我为自己带粮"];
    [navView addSubview:petType];
    
    userHeadImage = [MyControl createImageViewWithFrame:CGRectMake(navView.frame.size.width-20-13, 77/2, 20, 20) ImageName:@"defaultUserHead.png"];
    userHeadImage.layer.cornerRadius = 10;
    userHeadImage.layer.masksToBounds = YES;
    [navView addSubview:userHeadImage];
    
    userName = [MyControl createLabelWithFrame:CGRectMake(userHeadImage.frame.origin.x-155, userHeadImage.frame.origin.y+2.5, 150, 15) Font:11 Text:nil];
    userName.textAlignment = NSTextAlignmentRight;
    [navView addSubview:userName];
    
    jumpUserBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-100, userHeadImage.frame.origin.y, 100, 20) ImageName:@"" Target:self Action:@selector(jumpUserClick) Title:nil];
    [navView addSubview:jumpUserBtn];
}
-(void)createReward
{
    //587  98
    rewardBg = [MyControl createImageViewWithFrame:CGRectMake((self.view.frame.size.width-498/2)/2.0, self.view.frame.size.height-50-103/2-20, 498/2, 103/2) ImageName:@"food_rewardBg.png"];
    [self.view addSubview:rewardBg];
    
    //
    UIImageView * food = [MyControl createImageViewWithFrame:CGRectMake(30, (rewardBg.frame.size.height-25)/2.0, 25, 25) ImageName:@"exchange_whiteFood.png"];
    [rewardBg addSubview:food];
    
    rewardNum = [MyControl createLabelWithFrame:CGRectMake(75, 0, 47, rewardBg.frame.size.height) Font:17 Text:@"1"];
    rewardNum.font = [UIFont boldSystemFontOfSize:17];
    rewardNum.textAlignment = NSTextAlignmentCenter;
    [rewardBg addSubview:rewardNum];
    
    
    UIImageView * arrow = [MyControl createImageViewWithFrame:CGRectMake(125, (rewardBg.frame.size.height-31/2)/2.0, 18/2, 31/2) ImageName:@"rightArrow.png"];
    [rewardBg addSubview:arrow];
    
    
    
    //10 100 1000
    selectView = [MyControl createViewWithFrame:CGRectMake(rewardBg.frame.origin.x+45, rewardBg.frame.origin.y-105, 113, 105)];
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    
    UIImageView * selectBg = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 113, 100) ImageName:@""];
    selectBg.image = [[UIImage imageNamed:@"food_selectBg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    [selectView addSubview:selectBg];
    
    UIImageView * selectTri = [MyControl createImageViewWithFrame:CGRectMake((113-19/2.0)/2.0, 100, 19/2.0, 5) ImageName:@"food_selectBg_tri.png"];
    [selectView addSubview:selectTri];
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    for (int i=0; i<numArray.count; i++) {
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) Font:17 Text:[NSString stringWithFormat:@"   %@", numArray[i]]];
        label.tag = 200+i;
        [selectBg addSubview:label];
        
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(0, 25*i, selectBg.frame.size.width, 25) ImageName:@"" Target:self Action:@selector(numBtnClick:) Title:nil];
        [selectBg addSubview:button];
        button.tag = 100+i;
        if (i == 3) {
            label.backgroundColor = ORANGE;
        }
    }
    
    //
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    selectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [rewardBg addSubview:selectBtn];
    
//    UIButton * rewardBtn = [MyControl createButtonWithFrame:CGRectMake(rewardBg.frame.size.width/2.0, 0, rewardBg.frame.size.width/2.0, rewardBg.frame.size.height) ImageName:@"" Target:self Action:@selector(rewardBtnClick:) Title:@""];
//    rewardBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [rewardBg addSubview:rewardBtn];
    
    heartBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2) ImageName:@"food_heart.png" Target:self Action:@selector(rewardBtnClick:) Title:nil];
    [heartBtn addTarget:self action:@selector(heartTouchDown) forControlEvents:UIControlEventTouchDown];
    [heartBtn addTarget:self action:@selector(heartUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:heartBtn];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
}
-(void)heartTouchDown
{
    [timer2 invalidate];
    timer2 = nil;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        heartBtn.frame = rect;
    }];
}
-(void)heartUpOutside
{
    [UIView animateWithDuration:0.2 animations:^{
        heartBtn.frame = CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
    } completion:^(BOOL finished) {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
}
-(void)heartAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        heartBtn.frame = rect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            heartBtn.frame = CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
        }];
    }];
}
//-(void)heartClick:(UIButton *)btn
//{
//    NSLog(@"click");
//    
//}
#pragma mark -
-(void)createTableView
{
//    -25, 70+25, rewardBg.frame.origin.y-70-10, self.view.frame.size.width
    tv = [[UITableView alloc] initWithFrame:CGRectMake(20, 70-18, rewardBg.frame.origin.y-70-10, self.view.frame.size.width) style:UITableViewStylePlain];
    NSLog(@"%f--%f", self.view.frame.size.width/self.view.frame.size.height, 320/480.0);
    float a = self.view.frame.size.width/self.view.frame.size.height;
    float b = 320/480.0;
    if (a != b) {
        tv.frame = CGRectMake(-25, 70+25, rewardBg.frame.origin.y-70-10, self.view.frame.size.width);
    }
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    tv.transform = CGAffineTransformMakeRotation(-M_PI/2);
    tv.showsVerticalScrollIndicator = NO;
    tv.separatorStyle = 0;
    tv.pagingEnabled = YES;
    tv.backgroundColor = [UIColor clearColor];
    
    [self.view bringSubviewToFront:selectView];
    
//    addLabel = [MyControl createLabelWithFrame:CGRectZero Font:15 Text:nil];
//    addLabel.textColor = ORANGE;
//    addLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:addLabel];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    FoodCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[FoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
    }
    BegFoodListModel * model = self.dataArray[indexPath.row];
    
    cell.bigClick = ^(NSURL *url){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.imageURL = url;
        [ControllerManager addTabBarViewController:vc];
        [vc release];
    };
    
    if (addAnimationSwitch) {
        [cell addAnimation:[rewardNum.text intValue]];
        addAnimationSwitch = NO;
    }
    
    //有可能泄露
    [cell modifyUI:model];
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width;
}
#pragma mark -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tv && self.dataArray.count) {
        if (tv.contentOffset.y == (self.dataArray.count-1)*self.view.frame.size.width) {
            [self loadMoreData];
        }
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tv && self.dataArray.count) {
        int a = tv.contentOffset.y/self.view.frame.size.width;
        [self refreshHeader:a];
        
        //更换赏按钮
        BegFoodListModel * model = self.dataArray[a];
        NSInteger is_food = [model.is_food integerValue];
        if (is_food == 1) {
            [heartBtn setBackgroundImage:[UIImage imageNamed:@"food_heart.png"] forState:UIControlStateNormal];
        }else{
            NSDictionary * totalMenuDict = [MyControl returnDictionaryWithData:[USER objectForKey:@"MenuData"]];
            
            if (totalMenuDict.count == 0) {
                [heartBtn setBackgroundImage:[UIImage imageNamed:@"food_heart.png"] forState:UIControlStateNormal];
            }else{
                if ([[totalMenuDict objectForKey:model.is_food] isKindOfClass:[MenuModel class]]) {
                    //有数据
                    MenuModel * tempModel = [totalMenuDict objectForKey:model.is_food];
                    [heartBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MENUURL, tempModel.pic]] forState:UIControlStateNormal];
                }else{
                    //没数据
                    [heartBtn setBackgroundImage:[UIImage imageNamed:@"food_heart.png"] forState:UIControlStateNormal];
                }
            }
            
        }
    }
}
-(void)refreshHeader:(int)a
{
    //更新顶栏数据
    BegFoodListModel * model = self.dataArray[a];

    [MyControl setImageForBtn:petHeadBtn Tx:model.tx isPet:YES isRound:YES];

    sex.hidden = NO;
    if ([model.gender intValue] == 1) {
        sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        sex.image = [UIImage imageNamed:@"woman.png"];
    }
    petName.text = model.name;
    petType.text = [ControllerManager returnCateNameWithType:model.type];
    userName.text = [NSString stringWithFormat:@"%@", model.u_name];
    
    [MyControl setImageForImageView:userHeadImage Tx:model.u_tx isPet:NO isRound:YES];
}

#pragma mark -
-(void)numBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        selectView.alpha = 0;
    } completion:^(BOOL finished) {
        selectView.hidden = YES;
    }];
    NSLog(@"%ld", btn.tag);
    for (int i=0; i<4; i++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:200+i];
        label.backgroundColor = [UIColor clearColor];
    }
    UILabel * label = (UILabel *)[self.view viewWithTag:100+btn.tag];
    label.backgroundColor = ORANGE;
    
    NSArray * numArray = @[@"1000", @"100", @"10", @"1"];
    rewardNum.text = numArray[btn.tag-100];
}
-(void)selectBtnClick:(UIButton *)btn
{
    if (selectView.hidden) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.hidden = NO;
            selectView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            selectView.alpha = 0;
        } completion:^(BOOL finished) {
            selectView.hidden = YES;
        }];
    }
    
}

-(void)rewardBtnClick:(UIButton *)btn
{
    [UIView animateWithDuration:0.2 animations:^{
        heartBtn.frame = CGRectMake(self.view.frame.size.width-90, rewardBg.frame.origin.y-2, 126/2, 115/2);
    } completion:^(BOOL finished) {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    if ([rewardNum.text intValue]>[[USER objectForKey:@"gold"] intValue]+[[USER objectForKey:@"food"] intValue]) {
        Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view2.type = 2;
        view2.rewardNum = rewardNum.text;
        [view2 makeUI];
        view2.jumpCharge = ^(){
            Alert_oneBtnView * oneView = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            oneView.type = 4;
            [oneView makeUI];
            oneView.jumpTB = ^(){
                ChargeViewController * charge = [[ChargeViewController alloc] init];
                [self presentViewController:charge animated:YES completion:nil];
                [charge release];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:oneView];
            [oneView release];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:view2];
        [view2 release];
        return;
    }
    
    if([[USER objectForKey:@"showCostAlert"] intValue] && [rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]){
        Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view2.type = 1;
        view2.reward = ^(){
            [self reward];
        };
        view2.rewardNum = rewardNum.text;
        [view2 makeUI];
        [[UIApplication sharedApplication].keyWindow addSubview:view2];
        [view2 release];
        return;
    }
    
    [self reward];
    
}
-(void)reward
{
    int a = tv.contentOffset.y/self.view.frame.size.width;
    if(!self.dataArray.count){
        return;
    }
//    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@&n=%@dog&cat", [self.dataArray[a] img_id], rewardNum.text]];
    NSString * url = [NSString stringWithFormat:@"%@%@&n=%@&sig=%@&SID=%@", REWARDFOODAPI, [self.dataArray[a] img_id], rewardNum.text, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            if([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                if ([rewardNum.text intValue]>[[USER objectForKey:@"food"] intValue]) {
                    [USER setObject:@"0" forKey:@"food"];
                }else{
                    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"food"] intValue]-[rewardNum.text intValue]] forKey:@"food"];
                }
                
                [USER setObject:[NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"gold"]] forKey:@"gold"];
                BegFoodListModel * model = self.dataArray[a];
                model.food = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"food"]];
//                [MyControl popAlertWithView:self.view Msg:[NSString stringWithFormat:@"打赏成功，萌星 %@ 感谢您的爱心！", [self.dataArray[a] name]]];
                addAnimationSwitch = YES;
                [tv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:a inSection:0]] withRowAnimation:0];
                
                
            }
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)headBtnClick
{
    //跳转宠物主页
    PetMainViewController * vc = [[PetMainViewController alloc] init];
//    NSLog(@"%d", [vc retainCount]);
    int a = tv.contentOffset.y/self.view.frame.size.width;
    vc.aid = [self.dataArray[a] aid];
    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
-(void)jumpUserClick
{
    __block UserCardViewController * vc = [[UserCardViewController alloc] init];
    int a = tv.contentOffset.y/self.view.frame.size.width;
    vc.usr_id = [self.dataArray[a] usr_id];
//    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    [ControllerManager addTabBarViewController:vc];
    vc.close = ^(){
//        [vc.view removeFromSuperview];
        [ControllerManager deleTabBarViewController:vc];
    };
//    [self presentViewController:vc animated:YES completion:nil];
    [vc release];
}
//-(void)createBottom
//{
//    UIView * bottomBg = [MyControl createViewWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
//    [self.view addSubview:bottomBg];
//
//    NSArray * selectedArray = @[@"food_myStar_selected", @"food_beg_selected", @"food_discovery_selected", @"food_center_selected"];
//    NSArray * unSelectedArray = @[@"food_myStar_unSelected", @"food_beg_unSelected", @"food_discovery_unSelected", @"food_center_unSelected"];
//    for (int i=0; i<selectedArray.count; i++) {
//        UIImageView * halfBall = [MyControl createImageViewWithFrame:CGRectMake(i*(self.view.frame.size.width/4.0), bottomBg.frame.size.height-28, self.view.frame.size.width/4.0, 28) ImageName:@"food_bottom_halfBall.png"];
//        [bottomBg addSubview:halfBall];
//
//        UIButton * ballBtn = [MyControl createButtonWithFrame:CGRectMake(halfBall.frame.origin.x+halfBall.frame.size.width/2.0-42.5/2.0, bottomBg.frame.size.height-halfBall.frame.size.height-85/4.0, 85/2.0, 85/2.0) ImageName:unSelectedArray[i] Target:self Action:@selector(ballBtnClick:) Title:nil];
//        ballBtn.tag = 100+i;
//
//        [ballBtn setBackgroundImage:[UIImage imageNamed:selectedArray[i]] forState:UIControlStateSelected];
//        [bottomBg addSubview:ballBtn];
//        if (i == 1) {
//            ballBtn.selected = YES;
//        }
//    }
//}

//-(void)ballBtnClick:(UIButton *)btn
//{
//    for (int i=0; i<4; i++) {
//        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
//        button.selected = NO;
//    }
//    btn.selected = YES;
//    
//    [self ballAnimation:btn];
//    
//    if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }else if(btn.tag-100){
//        
//    }
//}
//
////气泡动画
//-(void)ballAnimation:(UIView *)view
//{
//    CGRect rect = view.frame;
//    [UIView animateWithDuration:0.1 animations:^{
//        view.frame = CGRectMake(rect.origin.x-rect.size.width*0.1, rect.origin.y, rect.size.width*1.2, rect.size.height);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            view.frame = rect;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                view.frame = CGRectMake(rect.origin.x, rect.origin.y-rect.size.height*0.1, rect.size.width, rect.size.height*1.2);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.1 animations:^{
//                    view.frame = rect;
//                }];
//            }];
//        }];
//    }];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
