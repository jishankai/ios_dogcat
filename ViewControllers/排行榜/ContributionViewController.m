//
//  ContributionViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-29.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "ContributionViewController.h"
#define YELLOW [UIColor colorWithRed:250/255.0 green:230/255.0 blue:180/255.0 alpha:1]
#import "PopularityCell.h"
#import "popularityListModel.h"
#import "UserInfoViewController.h"

@interface ContributionViewController ()
@property (nonatomic)NSInteger category;
@end

@implementation ContributionViewController

- (NSInteger)category
{
    if (!_category) {
        _category = 0;
    }
    return _category;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = [NSMutableArray arrayWithObjects:@"总贡献榜",@"贡献日榜", @"贡献周榜", @"贡献月榜", nil];
//    self.myCountryRankArray = [NSMutableArray arrayWithObjects:@"10", @"38", @"66", @"88", nil];
    self.contributionDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.usr_idsArray = [NSMutableArray arrayWithCapacity:0];
//    self.myCountryArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createBg];
    [self createTableView];
    [self createHeader2];
    [self createFakeNavigation];
    
    [self createArrow];
    
    [self findMeBtnClick];
    [self loadData];
}
- (void)loadData
{
    NSString *contributionSig  =[MyMD5 md5:[NSString stringWithFormat:@"aid=%@&category=%ddog&cat",[USER objectForKey:@"aid"],self.category]];
    NSString *contribution = [NSString stringWithFormat:@"%@%@&category=%d&sig=%@&SID=%@",CONTRIBUTIONAPI,[USER objectForKey:@"aid"],self.category,contributionSig,[ControllerManager getSID]];
    NSLog(@"国家贡献排行榜API:%@",contribution);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:contribution Block:^(BOOL isFinish, httpDownloadBlock *load) {
        NSLog(@"国家贡献排行榜数据：%@",load.dataDict);
        if (isFinish) {
            [self.contributionDataArray removeAllObjects];
            NSArray *array = [load.dataDict objectForKey:@"data"];
            for (int i=0; i< array.count; i++) {
                NSDictionary *dict = array[i];
                popularityListModel *model = [[popularityListModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.contributionDataArray addObject:model];
                if ([model.usr_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
                    myRanking = i+1;
                }
                [model release];
            }
//            [self loadUserPetsInfo];
            [tv reloadData];
            [tv2 reloadData];
        }
    }];
    [request release];
    
}
//-(void)loadUserPetsInfo
//{
//    NSString * code = [NSString stringWithFormat:@"usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]];
//    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", USERPETLISTAPI, [USER objectForKey:@"usr_id"], [MyMD5 md5:code], [ControllerManager getSID]];
//    NSLog(@"%@", url);
//    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
//        if (isFinish) {
//            NSLog(@"--%@", load.dataDict);
//            [self.usr_idsArray removeAllObjects];
//            [self.myCountryArray removeAllObjects];
//            
//            NSArray * array = [load.dataDict objectForKey:@"data"];
//            for (int i=0; i<array.count; i++) {
//                [self.usr_idsArray addObject:[array[i] objectForKey:@"usr_id"]];
//            }
//            NSLog(@"%@--%@", self.contributionDataArray, self.aidsArray);
//            //筛选出我的国家在数组中的位置
//            for (int i=0; i<self.contributionDataArray.count; i++) {
//                NSLog(@"aid:%@", [self.contributionDataArray[i] aid]);
//                for (int j=0; j<self.aidsArray.count; j++) {
//                    if ([[self.contributionDataArray[i] aid] isEqualToString:self.aidsArray[j]]) {
//                        [self.myCountryArray addObject:[NSString stringWithFormat:@"%d", i+1]];
//                        break;
//                    }
//                }
//                
//            }
//            NSLog(@"-----%@", self.myCountryArray);
//            count = 0;
//            [self findMeBtnClick];
//            LoadingSuccess;
//        }else{
//            LoadingFailed;
//        }
//    }];
//    [request release];
//}

-(void)createBg
{
    bgImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:@""];
    [self.view addSubview:bgImageView];
    //    self.bgImageView.backgroundColor = [UIColor redColor];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"blurBg.png"]];
    NSLog(@"%@", filePath);
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    //    NSLog(@"%@", data);
    UIImage * image = [UIImage imageWithData:data];
    bgImageView.image = image;
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    tempView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.75];
    [self.view addSubview:tempView];
}
#pragma mark - 创建tableView
-(void)createTableView
{
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 64+35+50*5) style:UITableViewStylePlain];
    if (self.view.frame.size.height == 480) {
        tv.frame = CGRectMake(0, 0, 320, 64+35+50*3);
    }
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = 0;
    tv.scrollEnabled = NO;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    
    UIView * tempView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64+35)];
    tv.tableHeaderView = tempView;
    
    tv2 = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50*3, 320, 50*3) style:UITableViewStylePlain];
    tv2.delegate = self;
    tv2.dataSource = self;
    tv2.separatorStyle = 0;
    tv2.showsVerticalScrollIndicator = NO;
    tv2.scrollEnabled = NO;
    tv2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv2];
}
#pragma mark - 创建arrow
-(void)createArrow
{
   arrow = [MyControl createButtonWithFrame:CGRectMake(150, self.view.frame.size.height-50*4+13.5, 20, 34) ImageName:@"list_moreArrow.png" Target:self Action:@selector(showEntireList) Title:nil];
    [self.view addSubview:arrow];
}
-(void)showEntireList
{
    tv.scrollEnabled = YES;
    arrow.alpha = 0;
    arrow.hidden = YES;
    //    findMeBtn.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
        tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
    }];
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contributionDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PopularityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PopularityCell" owner:self options:nil] objectAtIndex:0];
    }
    popularityListModel *model = self.contributionDataArray[indexPath.row];
    cell.cellClick = ^(int num){
        NSLog(@"跳转到第%d个国家", num);
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.usr_id = model.usr_id;
        [self presentViewController:userInfoVC animated:YES completion:nil];
        [userInfoVC release];
    };
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    if (tableView == tv2 && indexPath.row == myRanking-1) {
        cell.backgroundColor = [ControllerManager colorWithHexString:@"f9f9f9"];
        [cell configUIWithName:model.name rq:model.t_contri rank:indexPath.row+1 upOrDown:model.change shouldLarge:YES];
    }else{
        [cell configUIWithName:model.name rq:model.t_contri rank:indexPath.row+1 upOrDown:model.change shouldLarge:NO];
    }
    
    if ([model.tx isEqualToString:@""]) {
        cell.headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    }else{
        NSString *headImagePath = [DOCDIR stringByAppendingString:model.tx];
        UIImage *image = [UIImage imageWithContentsOfFile:headImagePath];
        if (image) {
            cell.headImageView.image = image;
        }else{
            httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@",USERTXURL,model.tx] Block:^(BOOL isFinish, httpDownloadBlock *load) {
                NSLog(@"load.image:%@",load.dataImage);
                if (isFinish) {
                    if (load.dataImage == NULL) {
                        cell.headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
                    }else{
                        cell.headImageView.image =load.dataImage;
                    }
                }
            }];
            [request release];
        }
    }
    
    if ([titleBtn.currentTitle isEqualToString:@"总人气榜"]) {
        cell.rqNum.text = model.t_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"人气日榜"]){
        cell.rqNum.text = model.d_rq;
    }else if ([titleBtn.currentTitle isEqualToString:@"人气周榜"]){
        cell.rqNum.text = model.w_rq;
    }else{
        cell.rqNum.text = model.m_rq;
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
//        arrow.alpha = 0;
//        arrow.hidden = YES;
        findMeBtn.userInteractionEnabled = NO;
        
//        [UIView animateWithDuration:0.3 animations:^{
//            tv.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
//            tv2.frame = CGRectMake(0, self.view.frame.size.height, 320, 0);
//        }];
//        
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tv) {
        NSLog(@"endDecelerating");
        findMeBtn.userInteractionEnabled = YES;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == tv) {
        NSLog(@"endDragging");
        findMeBtn.userInteractionEnabled = YES;
    }
}


#pragma mark - 创建导航
-(void)createFakeNavigation
{
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    //    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.85;
    alphaView.backgroundColor = BGCOLOR;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 25, 40, 30) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    //    backBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [navView addSubview:backBtn];
    
    UILabel * titleBgLabel = [MyControl createLabelWithFrame:CGRectMake(100, 64-39, 120, 30) Font:17 Text:@"国家"];
    titleBgLabel.font = [UIFont boldSystemFontOfSize:17];
    //    titleBgLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    [navView addSubview:titleBgLabel];

    /*****************************/
    
    titleBtn = [MyControl createButtonWithFrame:CGRectMake(130, 64-38, 90, 30) ImageName:@"" Target:self Action:@selector(titleBtnClick:) Title:@"总贡献榜"];
    titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [titleBtn setTitleColor:YELLOW forState:UIControlStateNormal];
    [navView addSubview:titleBtn];
    
    //小三角
    UIImageView * triangle2 = [MyControl createImageViewWithFrame:CGRectMake(82, 12, 10, 8) ImageName:@"5-3.png"];
    [titleBtn addSubview:triangle2];
    /*****************************/
    UIImageView * findMe = [MyControl createImageViewWithFrame:CGRectMake(320-35, 30, 43/2, 47/2) ImageName:@"findMe.png"];
    [navView addSubview:findMe];
    
    findMeBtn = [MyControl createButtonWithFrame:CGRectMake(320-41, 24, 51*0.6, 55*0.6) ImageName:@"" Target:self Action:@selector(findMeBtnClick) Title:nil];
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
        
        [dropDown2 setCellTextColor:YELLOW Font:[UIFont boldSystemFontOfSize:15] BgColor:[UIColor colorWithRed:252/255.0 green:120/255.0 blue:85/255.0 alpha:0.6] lineColor:[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.6]];
        dropDown2.delegate = self;
        CGRect rect = navView.frame;
        rect.size.height = 64+160;
        navView.frame = rect;
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
//    if (self.myCountryArray.count) {
//        if (count == self.myCountryArray.count) {
//            count = 0;
//        }
//        myCurrentCountNum = [self.myCountryArray[count++] intValue];
        
//        NSLog(@"%d", myCurrentCountNum);
        tv2.contentOffset = CGPointMake(0, myRanking*50-50*2);
        
//        [tv2 reloadData];
//    }
    
    NSLog(@"findMe");
    arrow.hidden = NO;
    tv.scrollEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        arrow.alpha = 1;
        if (self.view.frame.size.height == 480) {
            tv.frame = CGRectMake(0, 0, 320, 64+35+50*3);
        }else{
            tv.frame = CGRectMake(0, 0, 320, 64+35+50*5);
        }
        tv2.frame = CGRectMake(0, self.view.frame.size.height-50*3, 320, 50*3);
    }];
    
    //控制tv的偏移量为50的整数倍
    for (int i=0; i<100; i++) {
        if (tv.contentOffset.y>i*50 && tv.contentOffset.y<(i+1)*50) {
//            [UIView animateWithDuration:0 animations:^{
                tv.contentOffset = CGPointMake(0, (i+1)*50);
//            } completion:^(BOOL finished) {
                findMeBtn.userInteractionEnabled = YES;
//            }];
            break;
        }
    }
}

#pragma mark - 创建顶栏2
-(void)createHeader2
{
    UIView * header2Bg = [MyControl createViewWithFrame:CGRectMake(0, 64, 320, 35)];
    [self.view addSubview:header2Bg];
    
    UIView * alphaView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 35)];
    alphaView2.backgroundColor = [ControllerManager colorWithHexString:@"c1bfbd"];
    alphaView2.alpha = 0.8;
    [header2Bg addSubview:alphaView2];
    
    UILabel * nickName = [MyControl createLabelWithFrame:CGRectMake(15, 7.5, 100, 20) Font:15 Text:@"昵称"];
    [header2Bg addSubview:nickName];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(195, 7.5, 60, 20) Font:15 Text:@"贡献值"];
    [header2Bg addSubview:rq];
    
    UILabel * rank = [MyControl createLabelWithFrame:CGRectMake(275, 7.5, 60, 20) Font:15 Text:@"排名"];
    [header2Bg addSubview:rank];
}

-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    [self rel2];
}
- (void) didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"words:%@--line:%d",Words,Line);
    self.category = Line;
    [self loadData];
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
