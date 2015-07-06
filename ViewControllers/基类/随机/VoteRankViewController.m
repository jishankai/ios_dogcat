//
//  VoteRankViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/15.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "VoteRankViewController.h"
#import "PopularityCell.h"
#import "PetVotesViewController.h"
#import "NewestModel.h"
#import "GoRecommendViewController.h"
//#import "MasselectionStarModel.h"

@interface VoteRankViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
}
@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)NSMutableArray *rankDataArray;
//@property (nonatomic,strong) NSMutableArray *starsArray;
@end

@implementation VoteRankViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ControllerManager hideTabBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ControllerManager showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.rankDataArray = [NSMutableArray arrayWithCapacity:0];
//    self.starsArray = [NSMutableArray arrayWithCapacity:0];
    [self createFakeNavigation];
    [self createHeader];
    [self createTableView];
    
    [self loadData];
}
-(void)loadData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"star_id=%@dog&cat", self.starId]];
    NSString *url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", VOTERANKAPI, self.starId, sig, [ControllerManager getSID]];
//    LOADING;
    __block VoteRankViewController *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [blockSelf.tv headerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]] && array.count) {
                [blockSelf.rankDataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    NewestModel *model = [[NewestModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [blockSelf.rankDataArray addObject:model];
                }
                
                page = 1;
                [self.tv reloadData];
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ld&star_id=%@dog&cat", page, self.starId]];
    NSString *url = [NSString stringWithFormat:@"%@%ld&star_id=%@&sig=%@&SID=%@", VOTERANKAPI2, page, self.starId, sig, [ControllerManager getSID]];
//    LOADING;
    __block VoteRankViewController *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [blockSelf.tv footerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]] && array.count) {
//                [blockSelf.rankDataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    NewestModel *model = [[NewestModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [blockSelf.rankDataArray addObject:model];
                }
                
                page++;
                [self.tv reloadData];
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

#pragma mark -
-(void)createFakeNavigation
{
    UIImageView *blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurImage];
    
    UIView *navView = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    //    navView.backgroundColor = [UIColor redColor];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIImageView * backImageView = [MyControl createImageViewWithFrame:CGRectMake(17, 32, 10, 17) ImageName:@"leftArrow.png"];
    [navView addSubview:backImageView];
    
    UIButton * backBtn = [MyControl createButtonWithFrame:CGRectMake(10, 22, 60, 40) ImageName:@"" Target:self Action:@selector(backBtnClick) Title:nil];
    backBtn.showsTouchWhenHighlighted = YES;
    [navView addSubview:backBtn];
    
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0, 32, 100, 20) Font:17 Text:@"最热萌星"];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
//    UIButton *findMeBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-45, 24, 40, 35) ImageName:@"" Target:self Action:@selector(findMeBtnClick) Title:nil];
//    //    giftBagBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    findMeBtn.showsTouchWhenHighlighted = YES;
//    [navView addSubview:findMeBtn];
    
}
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)findMeBtnClick
//{
//    
//}
#pragma mark - 创建顶栏
-(void)createHeader
{
    UIView * header2Bg = [MyControl createViewWithFrame:CGRectMake(0, 64, WIDTH, 35)];
    [self.view addSubview:header2Bg];
    
    UIView * alphaView2 = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 35)];
    alphaView2.backgroundColor = [ControllerManager colorWithHexString:@"c1bfbd"];
    alphaView2.alpha = 0.8;
    [header2Bg addSubview:alphaView2];
    
    UILabel * nickName = [MyControl createLabelWithFrame:CGRectMake(15, 7.5, 100, 20) Font:15 Text:@"昵称"];
    [header2Bg addSubview:nickName];
    
    UILabel * rq = [MyControl createLabelWithFrame:CGRectMake(195, 7.5, 60, 20) Font:15 Text:@"得票数"];
    [header2Bg addSubview:rq];
    
    UILabel * rank = [MyControl createLabelWithFrame:CGRectMake(275, 7.5, 60, 20) Font:15 Text:@"排名"];
    [header2Bg addSubview:rank];
}

#pragma mark - 创建tableView
-(void)createTableView
{
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, self.view.frame.size.width, self.view.frame.size.height-(64+35)) style:UITableViewStylePlain];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tv];
    [self.tv addHeaderWithTarget:self action:@selector(loadData)];
    [self.tv addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.tv registerNib:[UINib nibWithNibName:@"PopularityCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PopularityCell"];
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"PopularityCell";
    
    PopularityCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NewestModel *model = [self.rankDataArray objectAtIndex:indexPath.row];
    cell.isFromVoteRank = YES;
    [cell configUIWithName:model.name rq:model.stars rank:(int)indexPath.row+1 upOrDown:0 shouldLarge:NO];
    [MyControl setImageForImageView:cell.headImageView Tx:model.tx isPet:YES isRound:YES];
    cell.rqNum.text = model.stars;
    
    __block VoteRankViewController *blockSelf = self;
    cell.cellClick = ^(NSInteger index){
        PetVotesViewController *petVote = [[PetVotesViewController alloc] init];
        petVote.tx = model.tx;
        petVote.aid = model.aid;
        petVote.name = model.name;
        petVote.star_id = blockSelf.starId;
        petVote.starName = blockSelf.starName;
        petVote.end_time = blockSelf.end_time;
        [ControllerManager addViewController:petVote To:blockSelf];
        //5.5
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *titles = [userDefaultes stringForKey:@"titleString"];
        NSLog(@"%@",titles);
        petVote.voteBlock = ^(NSString *img_id, NSString *name, NSString *url, NSString *stars){
            GoRecommendViewController *recommend = [[GoRecommendViewController alloc] init];
            //5.5
            recommend.starId = blockSelf.starId;
            recommend.starName = titles;
            //model.name;
            recommend.voteLeft = [USER objectForKey:@"voteLeft"];
            recommend.voteCost = [USER objectForKey:@"votePrice"];
            NewestModel *model = [[NewestModel alloc] init];
            model.img_id = img_id;
            model.name = name;
            model.url = url;
            model.stars = stars;
            
            recommend.insertModel = model;
            [blockSelf.navigationController pushViewController:recommend animated:YES];
        };
    };
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
@end
