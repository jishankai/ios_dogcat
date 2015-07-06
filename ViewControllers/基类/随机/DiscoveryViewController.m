//
//  DiscoveryViewController.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "DiscoveryViewController.h"
#define WORDCOLOR [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1]
#define BROWNCOLOR [UIColor colorWithRed:247/255.0 green:192/255.0 blue:152/255.0 alpha:1]
#import "SearchResultModel.h"
#import "UserInfoModel.h"
#import "PetSearchCell.h"
#import "PopularityListViewController.h"
#import "DemoViewController.h"
#import "ArticleViewController.h"
#import "DiscoverPictureViewController.h"

@interface DiscoveryViewController ()
{
    DiscoverPictureViewController * vc;
    ArticleViewController *article;
}

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)UISegmentedControl *seg;
@end

@implementation DiscoveryViewController

-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide_discover.png"];
    float a = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    float b = 320/480.0;
    if(a == b){
        guide.frame = CGRectMake(0, 0, self.view.frame.size.width, 568);
    }
    UITapGestureRecognizer * guideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guideTap:)];
    [guide addGestureRecognizer:guideTap];
    
    //    FirstTabBarViewController * tabBar = [ControllerManager shareTabBar];
    [[UIApplication sharedApplication].keyWindow addSubview:guide];
    [guideTap release];
}
-(void)guideTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.2 animations:^{
        guide.alpha = 0;
    }completion:^(BOOL finished) {
        guide.hidden = YES;
        [guide removeFromSuperview];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!isLoaded) {
        if (![[USER objectForKey:@"guide_discover"] intValue]) {
            [USER setObject:@"1" forKey:@"guide_discover"];
            [self createGuide];
        }
    }
}

-(void)refresh
{
    if(sc.selectedSegmentIndex == 0){
        if (isLoaded) {
            [vc refreshTop];
        }
    }else{
        if (isListLoaded) {
            //萌事刷新
            [article headerRefresh];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    isLoaded = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideSearch];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    self.searchUserArray = [NSMutableArray arrayWithCapacity:0];
    
    UIImageView * blurBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurBg];
    
    [self createHeader];
    [self createScrollView];
    [self createWaterFlow];
    [self createTableView];
    [self createSearchView];
    
//    [self createNewTableView];
}


-(void)createNewTableView
{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-44) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.separatorStyle = 0;
    [sv addSubview:self.table];
    
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    self.seg = [[UISegmentedControl alloc] initWithItems:@[@"精选", @"最新", @"关注"]];
    self.seg.frame = CGRectMake(WIDTH/4.0, 7, WIDTH/2.0, 30);
    self.seg.tintColor = [UIColor clearColor];
    [self.seg setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [self.seg setTitleTextAttributes:@{NSForegroundColorAttributeName:ORANGE} forState:UIControlStateSelected];
    [self.seg setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal | UIControlStateSelected];
    self.seg.selectedSegmentIndex = 0;
    [view addSubview:self.seg];
    
    
    self.table.tableHeaderView = view;
}

-(void)createHeader
{
//    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    
    alphaBgBtn = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(hideSearch) Title:nil];
    alphaBgBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    alphaBgBtn.alpha = 0;
    alphaBgBtn.hidden = YES;
    [self.view addSubview:alphaBgBtn];
    
    navView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.view addSubview:navView];
    
    UIView * alphaView = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 64)];
    alphaView.alpha = 0.2;
    alphaView.backgroundColor = ORANGE;
    [navView addSubview:alphaView];
    
    UIButton * listBtn = [MyControl createButtonWithFrame:CGRectMake(5, 28, 27, 27) ImageName:@"discover_list.png" Target:self Action:@selector(jumpRQ) Title:nil];
    [navView addSubview:listBtn];
    
    sc = [[UISegmentedControl alloc] initWithItems:@[@"萌图", @"萌事"]];
    sc.frame = CGRectMake(40, 28, self.view.frame.size.width-40*2, 28);
    sc.layer.cornerRadius = 5;
    sc.layer.masksToBounds = YES;
    sc.backgroundColor = [UIColor clearColor];
//    sc.alpha = 0.7;
    sc.tintColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:51/255.0 alpha:0.4];
    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [sc setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    [sc addTarget:self action:@selector(segmentClick) forControlEvents:UIControlEventValueChanged];
    sc.selectedSegmentIndex = 0;
    [navView addSubview:sc];
    
    UIImageView * search = [MyControl createImageViewWithFrame:CGRectMake(self.view.frame.size.width-10-15, 34, 15, 15) ImageName:@"main_search.png"];
    [navView addSubview:search];
    
    UIButton * searchBtn = [MyControl createButtonWithFrame:CGRectMake(self.view.frame.size.width-30, 28, 30, 28) ImageName:@"" Target:self Action:@selector(searchBtnClick) Title:nil];
    searchBtn.showsTouchWhenHighlighted = YES;
    //    topBtn.backgroundColor = [UIColor greenColor];
    [navView addSubview:searchBtn];
}
-(void)hideSearch
{
    sc.userInteractionEnabled = YES;
    tf.text = nil;
    vc.view.hidden = NO;
    vc2.view.hidden = NO;
    tv.hidden = YES;
    [tf resignFirstResponder];
    
    [self hideDrop];
    //        sc.hidden = NO;
    searchBg.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        alphaBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        alphaBgBtn.hidden = YES;
    }];
}

-(void)jumpRQ
{
    PopularityListViewController * rq = [[PopularityListViewController alloc] init];
    [self presentViewController:rq animated:YES completion:nil];
    [rq release];
}
-(void)createScrollView
{
    sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sv.delegate = self;
    sv.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
    
    [self.view bringSubviewToFront:alphaBgBtn];
    [self.view bringSubviewToFront:navView];
}
-(void)createWaterFlow
{
    vc = [[DiscoverPictureViewController alloc] init];
    [self addChildViewController:vc];
    [vc.view setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
//    vc.reloadRandom = ^(){
//        if([ControllerManager getIsSuccess]){
//            [self getNewMessage];
//        }
//    };
    [sv addSubview:vc.view];
}
-(void)createRecommend
{
    article = [[ArticleViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:article];
    nc.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:nc];
    [sv addSubview:nc.view];
    [nc didMoveToParentViewController:self];
    
//    vc2 = [[PetRecommendViewController alloc] init];
//    [self addChildViewController:vc2];
//    [vc2.view setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [sv addSubview:vc2.view];
//    [self.view bringSubviewToFront:navView];
}
-(void)searchBtnClick
{
    [tf becomeFirstResponder];
    searchBg.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        alphaBgBtn.hidden = NO;
        alphaBgBtn.alpha = 1;
    }];
}
-(void)segmentClick
{
    NSLog(@"%ld", sc.selectedSegmentIndex);
    if(sc.selectedSegmentIndex == 1){
        if (!isListLoaded) {
            isListLoaded = YES;
            [self createRecommend];
        }
        [ControllerManager showTabBar];
    }
    [UIView animateWithDuration:0.3 animations:^{
        sv.contentOffset = CGPointMake(self.view.frame.size.width*sc.selectedSegmentIndex, 0);
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (sv.contentOffset.x > self.view.frame.size.width/2.0) {
        //显示自定义tabbar
        [ControllerManager showTabBar];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    sc.selectedSegmentIndex = sv.contentOffset.x/self.view.frame.size.width;
    if (sv.contentOffset.x == self.view.frame.size.width) {
        if (!isListLoaded) {
            isListLoaded = YES;
            [self createRecommend];
        }
    }
}
#pragma mark -
-(void)loadMoreUser
{
    //    if(!isSearchUser){
    //        [tv footerEndRefreshing];
    //        return;
    //    }
//    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ddog&cat", page]];
    NSString * url = [NSString stringWithFormat:@"%@%@&page=%d&sig=%@&SID=%@", SEARCHUSERAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], page, sig,[ControllerManager getSID]];
    NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            //NSLog(@"%@", load.dataDict);
            
            NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (array.count == 0) {
                [tv footerEndRefreshing];
                LoadingSuccess;
                return;
            }
            for (NSDictionary *dict in array) {
                UserInfoModel *model = [[UserInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.searchUserArray addObject:model];
                [model release];
            }
            [tv footerEndRefreshing];
//            LoadingSuccess;
            [tv reloadData];
            page++;
            
        }else{
            [tv footerEndRefreshing];
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)loadMorePets
{
//    StartLoading;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", self.lastAid]];
    NSString * url = [NSString stringWithFormat:@"%@&aid=%@&name=%@&sig=%@&SID=%@", SEARCHAPI, self.lastAid, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
    //            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            //           NSLog(@"%@", load.dataDict);
            
            
            NSArray * array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
            if (array.count == 0) {
//                LoadingSuccess;
                [tv footerEndRefreshing];
                return;
            }
            for (NSDictionary *dict in array) {
                SearchResultModel *model = [[SearchResultModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.searchArray addObject:model];
                [model release];
            }
            self.lastAid = [self.searchArray[self.searchArray.count-1] aid];
//            LoadingSuccess;
            [tv footerEndRefreshing];
            [tv reloadData];
            
            vc.view.hidden = YES;
            vc2.view.hidden = YES;
            
        }else{
            [tv footerEndRefreshing];
            LOADFAILED;
        }
    }];
    [request release];
}
-(void)createTableView
{
//    blurImageView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) ImageName:@"blurBg.jpg"];
//    [self.view insertSubview:blurImageView belowSubview:navView];
//    blurImageView.hidden = YES;
    CGFloat spe = [UIScreen mainScreen].bounds.size.width/5.0;
    CGFloat bottomHeight = spe*99/128-10;
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+35, self.view.frame.size.width, self.view.frame.size.height-64-35-bottomHeight) style:UITableViewStylePlain];
    tv.dataSource = self;
    tv.delegate = self;
    tv.separatorStyle = 0;
    tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tv];
    tv.hidden = YES;
    
    
    [self.view bringSubviewToFront:navView];
//    [blurImageView addSubview:tv];
//    [tv release];
    [tv addFooterWithCallback:^{
        [self loadMorePets];
    }];
    
//    UIView * view = [MyControl createViewWithFrame:CGRectMake(0, 0, tv.frame.size.width, 35)];
//    tv.tableHeaderView = view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%d", self.searchArray.count);
    if (isSearchUser) {
        return self.searchUserArray.count;
    }else{
        return self.searchArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ID";
    PetSearchCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PetSearchCell" owner:self options:nil] objectAtIndex:0];
    }
    if (!isSearchUser) {
        SearchResultModel * model = self.searchArray[indexPath.row];
        [cell configUI:model];
    }else{
        UserInfoModel * model = self.searchUserArray[indexPath.row];
        [cell configUI2:model];
    }
    
    
    cell.selectionStyle = 0;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.table) {
//        return 44.0;
//    }else{
//        return 0.1;
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d", indexPath.row);
    [self hideDrop];
    
    if (isSearchUser) {
        __block UserCardViewController * card = [[UserCardViewController alloc] init];
        card.usr_id = [self.searchUserArray[indexPath.row] usr_id];
        [ControllerManager addTabBarViewController:card];
//        [[UIApplication sharedApplication].keyWindow addSubview:card.view];
        card.close = ^(){
            [ControllerManager deleTabBarViewController:card];
//            [card.view removeFromSuperview];
        };
        [card release];
//        UserInfoViewController * uvc = [[UserInfoViewController alloc] init];
//        uvc.usr_id = [self.searchUserArray[indexPath.row] usr_id];
//        [self presentViewController:uvc animated:YES completion:nil];
//        [uvc release];
    }else{
        PetMainViewController * pvc = [[PetMainViewController alloc] init];
        pvc.aid = [self.searchArray[indexPath.row] aid];
        [self presentViewController:pvc animated:YES completion:nil];
        [pvc release];
    }
    
}

#pragma mark - 
-(void)createSearchView
{
    //532/2  58/2  226 215 215
    searchBg = [MyControl createViewWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 58/2+10)];
    searchBg.hidden = YES;
//    searchBg.clipsToBounds = YES;
//    searchBg.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:searchBg];
    
    UIButton * searchBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, searchBg.frame.size.width, searchBg.frame.size.height+89) ImageName:@"" Target:self Action:@selector(hideSearch) Title:nil];
//    searchBgBtn.backgroundColor = [UIColor redColor];
    [searchBg addSubview:searchBgBtn];
    
    UIView * brownView = [MyControl createViewWithFrame:CGRectMake(10, 5, 532/2, 58/2)];
    brownView.backgroundColor = BROWNCOLOR;
    brownView.alpha = 0.8;
    brownView.layer.cornerRadius = 13;
    brownView.layer.masksToBounds = YES;
    [searchBg addSubview:brownView];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSearch)];
//    [searchBg addGestureRecognizer:tap];
//    [tap release];
    
    typeBtn = [MyControl createButtonWithFrame:CGRectMake(10+5, 4.5+5, 144/2, 20) ImageName:@"" Target:self Action:@selector(typeBtnClick:) Title:@"萌 星"];
    [typeBtn setTitleColor:WORDCOLOR forState:UIControlStateNormal];
    typeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [searchBg addSubview:typeBtn];
    
    UIImageView * triangle = [MyControl createImageViewWithFrame:CGRectMake(typeBtn.frame.origin.x+typeBtn.frame.size.width-7, typeBtn.frame.origin.y+typeBtn.frame.size.height-7, 7, 7) ImageName:@"main_search_triangle.png"];
    [searchBg addSubview:triangle];
    
    tf = [MyControl createTextFieldWithFrame:CGRectMake(typeBtn.frame.origin.x+typeBtn.frame.size.width+5, typeBtn.frame.origin.y, brownView.frame.size.width-15-typeBtn.frame.size.width, 20) placeholder:@"搜索" passWord:NO leftImageView:nil rightImageView:nil Font:13];
    tf.borderStyle = 0;
    tf.autocapitalizationType = 0;
    tf.autocorrectionType = 0;
    tf.delegate = self;
    tf.returnKeyType = UIReturnKeySearch;
    //    tf.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [searchBg addSubview:tf];
    
    UIView * view = [MyControl createViewWithFrame:CGRectMake(brownView.frame.origin.x+brownView.frame.size.width+3, brownView.frame.origin.y, 40-6, 29)];
    view.layer.cornerRadius = 7;
    view.layer.masksToBounds = YES;
    view.backgroundColor = BROWNCOLOR;
    view.alpha = 0.8;
    [searchBg addSubview:view];
    
    cancel = [MyControl createButtonWithFrame:CGRectMake(brownView.frame.origin.x+brownView.frame.size.width, brownView.frame.origin.y, 40, 29) ImageName:@"" Target:self Action:@selector(cancelClick:) Title:@"取消"];
    [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBg addSubview:cancel];
    
}
-(void)cancelClick:(UIButton *)btn
{
    //隐藏searchBg
    if ([btn.titleLabel.text isEqualToString:@"搜索"]) {
        //请求搜索API
        [MobClick event:@"search"];
        [self textFieldShouldReturn:tf];
    }else{
        [self hideSearch];
//        self.sv.scrollEnabled = YES;
////        blurImageView.hidden = YES;
//        sc.userInteractionEnabled = YES;
//        tf.text = nil;
//        vc.view.hidden = NO;
//        vc2.view.hidden = NO;
//        tv.hidden = YES;
//        [tf resignFirstResponder];
////        sc.hidden = NO;
//        searchBg.hidden = YES;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //string是最新输入的文字，textField的长度及字符要落后一个操作。
    if (![string isEqualToString:@""]) {
        [cancel setTitle:@"搜索" forState:UIControlStateNormal];
    }else if(textField.text.length == 1){
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
    }
    if ([cancel.titleLabel.text isEqualToString:@"搜索"]) {
        if ([string isEqualToString:@""]) {
            //退格
            NSLog(@"%ld--%ld", textField.text.length, self.tfString.length);
            if (self.tfString.length>=textField.text.length-1) {
                self.tfString = [self.tfString substringToIndex:textField.text.length-1];
            }
        }else{
            self.tfString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }
        
    }else{
        self.tfString = nil;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf resignFirstResponder];
    [self hideDrop];
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    if (self.tfString != nil) {
        //开始搜索
        NSLog(@"搜索");
        if ([typeBtn.titleLabel.text isEqualToString:@"萌 星"]) {
            //搜索宠物
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
            NSString * url = [NSString stringWithFormat:@"%@&name=%@&sig=%@&SID=%@", SEARCHAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
            //            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if(isFinish){
                    NSLog(@"%@", load.dataDict);
                    [self.searchArray removeAllObjects];
                    
                    NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    if (array.count == 0) {
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"查无此宠"];
                        ENDLOADING;
                        return;
                    }
                    for (NSDictionary *dict in array) {
                        SearchResultModel *model = [[SearchResultModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.searchArray addObject:model];
                        [model release];
                    }
                    self.lastAid = [self.searchArray[array.count-1] aid];
                    ENDLOADING;
                    [tv reloadData];
                    
//                    self.sv.scrollEnabled = NO;
//                    blurImageView.hidden = NO;
                    sc.userInteractionEnabled = NO;
                    vc.view.hidden = YES;
                    vc2.view.hidden = YES;
                    tv.hidden = NO;
//                    else if (segmentClickIndex == 2){
//                        vc3.view.hidden = YES;
//                    }
                    
                }else{
                    LOADFAILED;
                }
            }];
            [request release];
        }else{
            //搜索经纪人
            LOADING;
            NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"dog&cat"]];
            NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SEARCHUSERAPI, [tf.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], sig,[ControllerManager getSID]];
            NSLog(@"%@--%@--%@", tf.text, self.tfString, url);
            httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
                if(isFinish){
                    //                    NSLog(@"%@", load.dataDict);
                    [self.searchUserArray removeAllObjects];
                    page = 0;
                    
                    NSArray *array = [[load.dataDict objectForKey:@"data"] objectAtIndex:0];
                    if (array.count == 0) {
                        [MyControl popAlertWithView:[UIApplication sharedApplication].keyWindow Msg:@"查无此人"];
                        ENDLOADING;
                        return;
                    }
                    for (NSDictionary *dict in array) {
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        [model setValuesForKeysWithDictionary:dict];
                        [self.searchUserArray addObject:model];
                        [model release];
                    }
                    ENDLOADING;
                    [tv reloadData];
                    page++;
                    
//                    self.sv.scrollEnabled = NO;
//                    blurImageView.hidden = NO;
                    sc.userInteractionEnabled = NO;
                    vc.view.hidden = YES;
                    vc2.view.hidden = YES;
                    tv.hidden = NO;
                    
                }else{
                    LOADFAILED;
                }
            }];
            [request release];
        }
    }
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    self.tfString = nil;
    return YES;
}
-(void)typeBtnClick:(UIButton *)btn
{
    if (dropDown == nil) {
        
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc] showDropDown:btn :&f :[NSArray arrayWithObjects:@"萌 星", @"经纪人", nil]];
        //        NSLog(@"%@", self.totalArray);
        [dropDown setCellTextColor:WORDCOLOR Font:[UIFont systemFontOfSize:13] BgColor:BROWNCOLOR lineColor:[UIColor brownColor]];
        dropDown.alpha = 0.9;
        
        CGRect rect = searchBg.frame;
        rect.size.height += 89;
        searchBg.frame = rect;
        
        dropDown.delegate = self;
    }else{
        [dropDown hideDropDown:btn];
        [self rel];
    }
}
-(void)hideDrop
{
    if (dropDown != nil) {
        [dropDown hideDropDown:typeBtn];
        [self rel];
    }
}

#pragma mark - niDrop代理
-(void)niDropDownDelegateMethod:(NIDropDown *)sender
{
    [self rel];
}
-(void)didSelected:(NIDropDown *)sender Line:(int)Line Words:(NSString *)Words
{
    NSLog(@"%d--%@", Line, Words);
    if (Line == 0) {
        isSearchUser = NO;
        [tv addFooterWithCallback:^{
            [self loadMoreUser];
        }];
    }else{
        isSearchUser = YES;
        [tv addFooterWithCallback:^{
            [self loadMorePets];
        }];
    }
}
-(void)rel
{
    CGRect rect = searchBg.frame;
    rect.size.height -= 89;
    searchBg.frame = rect;
    [dropDown release];
    dropDown = nil;
}

- (void)didReceiveMemoryWarning {
    //清除缓存图片
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearMemory];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
