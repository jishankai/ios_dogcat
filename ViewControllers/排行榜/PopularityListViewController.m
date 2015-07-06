//
//  PopularityListViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "PopularityListViewController.h"
#define YELLOW [UIColor colorWithRed:250/255.0 green:230/255.0 blue:180/255.0 alpha:1]
#import "PopularityCell.h"
#import "popularityListModel.h"
@interface PopularityListViewController ()

@property (nonatomic,assign)NSInteger category;
@end

@implementation PopularityListViewController

//-(void)dealloc
//{
//    [super dealloc];
//}


- (NSInteger)category
{
    if (!_category) {
        _category = 0;
    }
    return _category;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[USER objectForKey:@"isSuccess"] intValue] && isLoaded) {
        if (!showMyRank) {
            [self loadData];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isLoaded = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick event:@"rank"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.catArray = [NSMutableArray arrayWithCapacity:0];
    self.dogArray = [NSMutableArray arrayWithCapacity:0];
    self.otherArray = [NSMutableArray arrayWithCapacity:0];
    self.totalArray = [NSMutableArray arrayWithCapacity:0];
    self.rankDataArray = [NSMutableArray arrayWithCapacity:0];
    self.limitRankDataArray = [NSMutableArray arrayWithCapacity:0];
    self.aidsArray = [NSMutableArray arrayWithCapacity:0];
    self.myCountryArray = [NSMutableArray arrayWithCapacity:0];
    
    self.titleArray = [NSMutableArray arrayWithObjects:@"总人气榜",@"昨日人气", @"上周人气", @"上月人气",  nil];
    self.myCountryRankArray = [NSMutableArray arrayWithCapacity:0];
    self.selectedWords = @"所有";
    self.totalArray = [NSMutableArray arrayWithObjects:@"所有", @"喵", @"汪", @"其他", nil];
//    [self getListData];
    [self createBg];
    [self createTableView];
    [self createHeader2];
    [self createHeader];
    [self createFakeNavigation];
    
//    [self createArrow];
//    [self findMeBtnClick];
    self.category = 1;
    
    [self loadData];
    
    [tv registerNib:[UINib nibWithNibName:@"PopularityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PopularityCell"];
}
- (void)loadData
{
    LOADING;
    NSString *rankSig = [MyMD5 md5:[NSString stringWithFormat:@"category=%lddog&cat",self.category]];
    NSString *rank = [NSString stringWithFormat:@"%@%ld&sig=%@&SID=%@",POPULARRANKAPI,self.category,rankSig,[ControllerManager getSID]];
    NSLog(@"rank:%@",rank);
    
    __block PopularityListViewController * blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:rank Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
//            NSLog(@"人气排行数据：%@",load.dataDict);
//            arrow.hidden = NO;
            [blockSelf.rankDataArray removeAllObjects];
            [blockSelf.limitRankDataArray removeAllObjects];
            if (![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                
                [MyControl loadingFailedWithContent:@"数据异常" afterDelay:0.7];
                [blockSelf->tv reloadData];
                return;
            }
            NSArray *array = [load.dataDict objectForKey:@"data"];
            NSLog(@"%ld", array.count);
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dict = array[i];
                popularityListModel *model = [[popularityListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [blockSelf.rankDataArray addObject:model];
                [model release];
            }
            
//            NSLog(@"%@--%d", blockSelf.selectedWords, blockSelf->selectLine);
            if ([blockSelf.selectedWords isEqualToString:@"所有"]) {
                [blockSelf.limitRankDataArray addObjectsFromArray:blockSelf.rankDataArray];
            }else{
                for (int i=0; i<blockSelf.rankDataArray.count; i++) {
                    popularityListModel * model = blockSelf.rankDataArray[i];
                    
                    if([[model type] intValue]/100 == blockSelf->selectLine){
                        [blockSelf.limitRankDataArray addObject:blockSelf.rankDataArray[i]];
                    }
//                    if ([[ControllerManager returnCateNameWithType:[model type]] isEqualToString:self.selectedWords]) {
//                        
//                    }
                }
            }
            
//            [self createTableView];
            if ([[USER objectForKey:@"isSuccess"] intValue]) {
                [blockSelf loadUserPetsInfo];
//                ENDLOADING;
            }else{
                [blockSelf->tv reloadData];
                if(blockSelf.isFromPetMain && blockSelf.targetAid != nil){
                    for (int i=0; i<blockSelf.limitRankDataArray.count; i++) {
                        if ([[blockSelf.limitRankDataArray[i] aid] isEqualToString:blockSelf.targetAid]) {
                            blockSelf->tv.contentOffset = CGPointMake(0, i*50);
                            break;
                        }
                    }
                }
                ENDLOADING;
            }
            
//            [tv2 reloadData];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadUserPetsInfo
{
    NSString * code = [NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
    NSLog(@"%@", url);
    __block PopularityListViewController * blockSelf = self;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
//            NSLog(@"--%@", load.dataDict);
            [blockSelf.aidsArray removeAllObjects];
            [blockSelf.myCountryArray removeAllObjects];
            
            blockSelf.myCountryRankArray = [load.dataDict objectForKey:@"data"];
            for (int i=0; i<blockSelf.myCountryRankArray.count; i++) {
                [blockSelf.aidsArray addObject:[blockSelf.myCountryRankArray[i] objectForKey:@"aid"]];
            }
            //筛选出我的国家在数组中的位置
//            if ([self.selectedWords isEqualToString:@"所有种族"]) {
                for (int i=0; i<blockSelf.limitRankDataArray.count; i++) {
                    for (int j=0; j<blockSelf.aidsArray.count; j++) {
                        if ([[blockSelf.limitRankDataArray[i] aid] isEqualToString:blockSelf.aidsArray[j]]) {
                            [blockSelf.myCountryArray addObject:[NSString stringWithFormat:@"%d", i+1]];
                            break;
                        }
                    }
                    
                }
//            }else{
//                
//            }
            
//            NSLog(@"-----self.myCountryArray:%@", self.myCountryArray);
            blockSelf->count = 0;
            /***************逻辑判断*****************/
//            if (self.view.frame.size.height == 480) {
//                //iPhone4s  3名，7名
//                isiPhone4s = YES;
//                
//                if (self.rankDataArray.count>=6) {
//                    //寻找是否有我
//                    for (int i=0; i<self.myCountryArray.count; i++) {
//                        if ([self.myCountryArray[i] intValue]<=3+2) {
//                            //记录我的第一名
//                            markLineNum = [self.myCountryArray[i] intValue]-1;
//                            [self showEntireList];
//                            break;
//                        }else{
//                            markLineNum = [self.myCountryArray[i] intValue]-1;
//                            [self findMeBtnClick];
//                            break;
//                        }
//                    }
//                }else{
//                    [self showEntireList];
//                }
//            }else{
//                //iPhone5s  5名，9名
//                if (self.rankDataArray.count>=8) {
//                    //寻找是否有我
//                    for (int i=0; i<self.myCountryArray.count; i++) {
//                        if ([self.myCountryArray[i] intValue]<=5+2) {
//                            //记录我的第一名
//                            markLineNum = [self.myCountryArray[i] intValue]-1;
//                            [self showEntireList];
//                            break;
//                        }else{
//                            markLineNum = [self.myCountryArray[i] intValue]-1;
//                            [self findMeBtnClick];
//                            break;
//                        }
//                    }
//                }else{
//                    [self showEntireList];
//                }
//            }
            ENDLOADING;
            if (blockSelf.isFromPetMain) {
                if(blockSelf.targetAid != nil){
                    for (int i=0; i<blockSelf.limitRankDataArray.count; i++) {
                        if ([[blockSelf.limitRankDataArray[i] aid] isEqualToString:blockSelf.targetAid]) {
                            blockSelf->tv.contentOffset = CGPointMake(0, i*50);
                            [blockSelf->tv reloadData];
                            break;
                        }else if(i == blockSelf.limitRankDataArray.count-1){
//                            [self findMeBtnClick];
                            [blockSelf->tv reloadData];
                        }
                    }
                }
            }else{
//                [self findMeBtnClick];
                [blockSelf->tv reloadData];
            }
            
//            [tv reloadData];
        }else{
            LOADFAILED;
        }
    }];
    [request release];
}

-(void)getListData
{
    NSDictionary * oriDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CateNameList" ofType:@"plist"]];
    //将数据存到数组中
    NSDictionary * dict1 = [oriDict objectForKey:@"1"];
    NSDictionary * dict2 = [oriDict objectForKey:@"2"];
//    NSDictionary * dict3 = [oriDict objectForKey:@"3"];
    
    [self.totalArray addObject:@"所有"];
    
    if ([[USER objectForKey:@"planet"] intValue] == 2) {
        for (int i=0; i<[dict2 count]; i++) {
            NSString * str = [dict2 objectForKey:[NSString stringWithFormat:@"%d", 200+i+1]];
            [self.dogArray addObject:str];
            [self.totalArray addObject:str];
        }
    }else{
        for (int i=0; i<[dict1 count]; i++) {
            NSString * str = [dict1 objectForKey:[NSString stringWithFormat:@"%d", 100+i+1]];
            [self.catArray addObject:str];
            [self.totalArray addObject:str];
        }
    }

}
-(void)createBg
{
    UIImageView * imageView = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:imageView];
}
#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35+35, self.view.frame.size.width, self.view.frame.size.height-(64+35+35)) style:UITableViewStylePlain];

    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    [tv release];
    
    [tv registerNib:[UINib nibWithNibName:@"PopularityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PopularityCell"];
}
#pragma mark - 创建arrow
-(void)createArrow
{
    arrow = [MyControl createButtonWithFrame:CGRectMake(150, self.view.frame.size.height-50*4+13.5, 20, 34) ImageName:@"list_moreArrow.png" Target:self Action:@selector(showEntireList) Title:nil];
    arrow.hidden = YES;
    [self.view addSubview:arrow];
//    arrow = [MyControl createImageViewWithFrame:CGRectMake(150, self.view.frame.size.height-50*4+13.5, 20, 34) ImageName:@"list_moreArrow.png"];
//    [self.view addSubview:arrow];
}
-(void)showEntireList
{
    tv.scrollEnabled = YES;
    arrow.alpha = 0;
    arrow.hidden = YES;
//    findMeBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//        tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
    }];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.limitRankDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"PopularityCell";

    PopularityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    popularityListModel *model = [self.limitRankDataArray objectAtIndex:indexPath.row];
    [cell configUIWithName:model.name rq:model.t_rq rank:(int)indexPath.row+1 upOrDown:indexPath.row%2 shouldLarge:NO];
    
    __block PopularityListViewController * blockSelf = self;
    cell.cellClick = ^(NSInteger num){
        NSLog(@"跳转到第%ld个国家", num);
        PetMainViewController *petInfoVC = [[PetMainViewController alloc] init];
        petInfoVC.aid = model.aid;
        [blockSelf presentViewController:petInfoVC animated:YES completion:nil];
        [petInfoVC release];
    };
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    
//    tableView == tv2 && indexPath.row == myCurrentCountNum-1
    
//    if (indexPath.row == myCurrentCountNum-1) {
//        cell.backgroundColor = [ControllerManager colorWithHexString:@"f9f9f9"];
//        [cell configUIWithName:model.name rq:model.t_rq rank:indexPath.row+1 upOrDown:model.change shouldLarge:YES];
//    }else{
//        [cell configUIWithName:model.name rq:model.t_rq rank:indexPath.row+1 upOrDown:model.change shouldLarge:NO];
//    }
    
//    tableView == tv && markLineNum == indexPath.row && isShow == NO
    if (indexPath.row == myCurrentCountNum-1) {
        [cell configUIWithName:model.name rq:model.t_rq rank:(int)indexPath.row+1 upOrDown:model.vary shouldLarge:YES];
        cell.backgroundColor = [ControllerManager colorWithHexString:@"f9f9f9"];
    }else{
        [cell configUIWithName:model.name rq:model.t_rq rank:(int)indexPath.row+1 upOrDown:model.vary shouldLarge:NO];
    }

    [MyControl setImageForImageView:cell.headImageView Tx:model.tx isPet:YES isRound:YES];

//    NSLog(@"titleBtn.currentTitle:%@",titleBtn.currentTitle);
    if ([titleBtn.currentTitle isEqualToString:@"总人气榜"]) {
        cell.rqNum.text = model.t_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"昨日人气"]){
        cell.rqNum.text = model.d_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"上周人气"]){
        cell.rqNum.text = model.w_rq;
//        NSLog(@"%@", model.w_rq);
    }else{
        cell.rqNum.text = model.m_rq;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
//        NSLog(@"%d----%d", self.rankDataArray.count, self.limitRankDataArray.count);
//        arrow.alpha = 0;
//        arrow.hidden = YES;
//        findMeBtn.userInteractionEnabled = NO;
//
//        [UIView animateWithDuration:0.3 animations:^{
//            tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//            tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
//        }];
//        
    }
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView == tv) {
//        NSLog(@"endDecelerating");
//        findMeBtn.userInteractionEnabled = YES;
//    }
//}
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView == tv) {
//        NSLog(@"endDragging");
//        findMeBtn.userInteractionEnabled = YES;
//    }
//}

#pragma mark - 创建导航
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
//    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
//    UILabel * titleBgLabel = [MyControl createLabelWithFrame:CGRectMake(100, 64-39, 120, 30) Font:17 Text:@"喵星"];
//    if ([[USER objectForKey:@"planet"] intValue] == 2) {
//        titleBgLabel.text = @"汪星";
//    }
//    titleBgLabel.font = [UIFont boldSystemFontOfSize:17];
////    titleBgLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
//    [navView addSubview:titleBgLabel];
    
//    titleBtn = [MyControl createButtonWithFrame:CGRectMake(130, 64-38, 90, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"人气日榜"];
//    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//    titleBtn.showsTouchWhenHighlighted = YES;
//    titleBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.6];
//    [titleBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:230/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
//    [navView addSubview:titleBtn];
    /*****************************/
    
    titleBtn = [MyControl createButtonWithFrame:CGRectMake(130-10, 64-38, 90, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"昨日人气"];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navView addSubview:titleBtn];

    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(82, 12, 10, 8) ImageName:@"5-3.png"];
    [titleBtn addSubview:triangle2];
    /*****************************/
    UIImageView * findMe = [MyControl createImageViewWithFrame:CGRectMake(320-35, 30, 43/2, 47/2) ImageName:@"findMe.png"];
    [navView addSubview:findMe];
    
    findMeBtn = [MyControl createButtonWithFrame:CGRectMake(320-45, 24, 40, 35) ImageName:@"" Target:self Action:@selector(findMeBtnClick) Title:nil];
//    giftBagBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    findMeBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:findMeBtn];
    
    UIView * line0 = [MyControl createViewWithFrame:CGRectMake(0, 63, 320, 1)];
    line0.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.1];
    [navView addSubview:line0];
}
#pragma mark - 导航点击事件
-(void)titleBtnClick:(UIButton *)btn
{
    if (dropDown2 == nil) {
        CGFloat f = 200;
        dropDown2 = [[NIDropDown alloc] showDropDown:titleBtn :&f :self.titleArray];
    
        [dropDown2 setCellTextColor:[UIColor whiteColor] Font:[UIFont boldSystemFontOfSize:15] BgColor:[UIColor colorWithRed:252/255.0 green:120/255.0 blue:85/255.0 alpha:0.6] lineColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.6]];
        dropDown2.delegate = self;
        CGRect rect = navView.frame;
        rect.size.height = 64+160;
        navView.frame = rect;

        //当drop2打开时关闭drop1
        [dropDown hideDropDown:raceBtn];
        [self rel];
    }else{
        [dropDown2 hideDropDown:titleBtn];

        [self rel2];
    }
}
-(void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)findMeBtnClick
{
    NSLog(@"findMe");
    if (![[USER objectForKey:@"isSuccess"] intValue]) {
        ShowAlertView;
        return;
    }
    
    if (self.limitRankDataArray.count == 0) {
        NSLog(@"没有数据");
        return;
    }
    if (self.myCountryArray.count == 0) {
        NSLog(@"排行榜中没有您的萌星");
        [MyControl popAlertWithView:self.view Msg:@"排行榜中没有您的萌星"];
        return;
    }
    /***************逻辑判断*****************/
//    for (int i=0; i<self.myCountryArray.count; i++) {
//        if (!isShow) {
//            if ([self.myCountryArray[i] intValue] > markLineNum) {
//                if (self.view.frame.size.height == 480) {
//                    //iPhone4s 7名
//                    if () {
//                        
//                    }
//                }
//            }else if(i == self.myCountryArray.count-1){
//                
//            }
//        }else{
//            
//        }
//    }
    
//    if (isiPhone4s) {
//        //iPhone4s  3名，7名
//        if (self.rankDataArray.count>=7) {
//            //寻找是否有我
//            for (int i=0; i<self.myCountryArray.count; i++) {
//                if ([self.myCountryArray[i] intValue]<3+2) {
//                    markLineNum = [self.myCountryArray[i] intValue]-1;
//                    [self showEntireList];
//                    break;
//                }else{
//                    [self findMeBtnClick];
//                    break;
//                }
//            }
//        }else{
//            
//        }
//    }else{
//        //iPhone5s  5名，9名
//        if (self.rankDataArray.count>=9) {
//            //寻找是否有我
//            for (int i=0; i<self.myCountryArray.count; i++) {
//                if ([self.myCountryArray[i] intValue]<=3) {
//                    break;
//                }else{
//                    [self findMeBtnClick];
//                    break;
//                }
//            }
//        }else{
//            
//        }
//    }
//    if (isiPhone4s) {
//        if (isShow) {
//            for (int i=0; i<self.myCountryArray.count; i++) {
//                if ([self.myCountryArray[i] intValue]>markLineNum+1) {
//                    markLineNum = [self.myCountryArray[i] intValue];
//                }else if(i == self.myCountryArray.count-1){
//                    //到最后也没有找到我自己国家的下一名，循环到我的第一个国家，判断底层偏移量，判断我的这一个国家是不是在界面的3+2个后，如果在--》跳到这一个；如果不在--》将上层隐藏，跳到底层的下一个。
//                    //如何循环到下一个，而且不影响上边判断从markLineNum的下一个开始。
//                    float offset = tv.contentOffset.y;
//                    //offset/50为当前显示的第一个排行名次-1
//                    if (offset/50 + 5 > [self.myCountryArray[0] intValue]) {
//
//                    }
//                }
//            }
//        }else{
//            //没显示上一层
//        
//        }
//    }else{
//        if (isShow) {
//            
//        }else{
//            
//        }
//    }
    
    
    showMyRank = 1;
    /******************************/
    
    if (self.myCountryArray.count) {
        if (count == self.myCountryArray.count) {
            count = 0;
        }
        myCurrentCountNum = [self.myCountryArray[count++] intValue];
        
        NSLog(@"myCurrentCountNum:%d", myCurrentCountNum);
        [tv reloadData];
//        tv2.contentOffset = CGPointMake(0, myCurrentCountNum*50-50*2);
//        
//        [tv2 reloadData];
    }
    
    
//    arrow.hidden = NO;
//    tv.scrollEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
//        arrow.alpha = 1;
        tv.contentOffset = CGPointMake(0, (myCurrentCountNum-1)*50);
//        if (self.view.frame.size.height == 480) {
//            tv.frame = CGRectMake(0, 0, 320, 64+35+35+50*3);
//        }else{
//            tv.frame = CGRectMake(0, 0, 320, 64+35+35+50*5);
//        }
        
//        tv2.frame = CGRectMake(0, self.view.frame.size.height-50*3, 320, 50*3);
    }];
    
    //控制tv的偏移量为50的整数倍
//    for (int i=0; i<100; i++) {
//        if (tv.contentOffset.y>i*50 && tv.contentOffset.y<(i+1)*50) {
////            [UIView animateWithDuration:0.3 animations:^{
//                tv.contentOffset = CGPointMake(0, (i+1)*50);
//            findMeBtn.userInteractionEnabled = YES;
////            }];
//            break;
//        }
//    }
}
#pragma mark - 创建顶栏1
-(void)createHeader
{
    headerView = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:headerView];
    
    UIView * headerBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    headerBgView.backgroundColor = ORANGE;
    headerBgView.alpha = 0.2;
    [headerView addSubview:headerBgView];
    
    raceBtn = [MyControl createButtonWithFrame:CGRectMake(15, 5, 115-20, 25) ImageName:@"" Target:self Action:@selector(raceBtnClick) Title:@"所有"];
    raceBtn.layer.cornerRadius = 5;
    raceBtn.layer.masksToBounds = YES;
    raceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    raceBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:168/255.0 blue:146/255.0 alpha:0.6];
    [headerView addSubview:raceBtn];
    //小三角
    UIImageView * triangle1 = [MyControl createImageViewWithFrame:CGRectMake(102-20, 9, 10, 8) ImageName:@"5-2.png"];
    [raceBtn addSubview:triangle1];
}
#pragma mark - 创建顶栏2
-(void)createHeader2
{
    UIView * header2Bg = [MyControl createViewWithFrame:CGRectMake(0, 64+35, 320, 35)];
    [self.view addSubview:header2Bg];
    
    UIView * alphaView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    alphaView2.backgroundColor = [ControllerManager colorWithHexString:@"c1bfbd"];
    alphaView2.alpha = 0.8;
    [header2Bg addSubview:alphaView2];
    
    UILabel * nickName = [MyControl createLabelWithFrame:CGRectMake(15, 7.5, 100, 20) Font:15 Text:@"昵称"];
    [header2Bg addSubview:nickName];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(195, 7.5, 60, 20) Font:15 Text:@"人气值"];
    [header2Bg addSubview:rq];
    
    UILabel * rank = [MyControl createLabelWithFrame:CGRectMake(275, 7.5, 60, 20) Font:15 Text:@"排名"];
    [header2Bg addSubview:rank];
}
-(void)raceBtnClick
{
    NSLog(@"race");
    
    if (dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc] showDropDown:raceBtn :&f :self.totalArray];
        [dropDown setDefaultCellType];
        dropDown.delegate = self;
        headerView.frame = CGRectMake(0, 64, 320, 35+160);
//        headerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }else{
        [dropDown hideDropDown:raceBtn];
        [self rel];
    }
}
#pragma mark -
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    if (sender == dropDown) {
        [self rel];
    }else{
        [self rel2];
    }
//    NSLog(@"%@",titleBtn.currentTitle);
  
//    [self loadData];
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"line:%d--words:%@", Line, Words);
    
    if (sender == dropDown) {
        //打开所有排行
//        [self showEntireList];
        self.selectedWords = Words;
        selectLine = Line;
        
        [self.limitRankDataArray removeAllObjects];
        if ([Words isEqualToString:@"所有"]) {
            [self.limitRankDataArray addObjectsFromArray:self.rankDataArray];
        }else{
            if([Words isEqualToString:@"喵"]){
                for (int i=0; i<self.rankDataArray.count; i++) {
                    popularityListModel * model = self.rankDataArray[i];
                    if ([model.type intValue]/100 == 1) {
                        [self.limitRankDataArray addObject:self.rankDataArray[i]];
                    }
                }
            }else if([Words isEqualToString:@"汪"]){
                for (int i=0; i<self.rankDataArray.count; i++) {
                    popularityListModel * model = self.rankDataArray[i];
                    if ([model.type intValue]/100 == 2) {
                        [self.limitRankDataArray addObject:self.rankDataArray[i]];
                    }
                }
            }else if([Words isEqualToString:@"其他"]){
                for (int i=0; i<self.rankDataArray.count; i++) {
                    popularityListModel * model = self.rankDataArray[i];
                    if ([model.type intValue]/100 == 3) {
                        [self.limitRankDataArray addObject:self.rankDataArray[i]];
                    }
                }
            }
            
        }
        count = 0;
        myCurrentCountNum = 0;
        [self searchMe];
        [tv reloadData];
    }else if(sender == dropDown2){
        for (int i =0; i<self.titleArray.count; i++) {
            if ([titleBtn.currentTitle isEqualToString:self.titleArray[i]]) {
                self.category = i;
                break;
            }
        }
//        [raceBtn setTitle:@"所有种族" forState:UIControlStateNormal];
        [self loadData];
    }
}
-(void)searchMe
{
    //从limitRankDataArray中挑出符合条件的我的联萌的排名
    [self.aidsArray removeAllObjects];
    [self.myCountryArray removeAllObjects];
    for (int i=0; i<self.myCountryRankArray.count; i++) {
        [self.aidsArray addObject:[self.myCountryRankArray[i] objectForKey:@"aid"]];
    }
    //筛选出我的国家在数组中的位置
    for (int i=0; i<self.limitRankDataArray.count; i++) {
        for (int j=0; j<self.aidsArray.count; j++) {
            if ([[self.limitRankDataArray[i] aid] isEqualToString:self.aidsArray[j]]) {
                [self.myCountryArray addObject:[NSString stringWithFormat:@"%d", i+1]];
                break;
            }
        }
    }
    NSLog(@"-----self.myCountryArray:%@", self.myCountryArray);
}
-(void)rel
{

    headerView.frame = CGRectMake(0, 64, 320, 35);
    [dropDown release];
    dropDown = nil;
}
-(void)rel2
{
    navView.frame = CGRectMake(0, 0, 320, 64);
    [dropDown2 release];
    dropDown2 = nil;
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
