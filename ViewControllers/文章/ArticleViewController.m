//
//  ArticleViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArticleViewController.h"
#import "ArticleCell.h"
#import "ArtivleDetailViewController.h"
#import "ArticleModel.h"
#import "ArticleWebViewController.h"

@interface ArticleViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSInteger page;
    BOOL isSelfCreated;
}
@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)NSMutableArray *articlesArray;
@property(nonatomic,strong)NSMutableArray *bannersArray;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *alphaBg;
@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.articlesArray = [NSMutableArray arrayWithCapacity:0];
    self.bannersArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createTableView];
    [self.tv registerClass:[ArticleCell class] forCellReuseIdentifier:@"ArticleCell"];
    [self loadArticlesData];
    
    isSelfCreated = YES;
}

-(void)headerRefresh
{
    [self.tv headerBeginRefreshing];
}

-(void)loadArticlesData
{
    if (!isSelfCreated) {
        LOADING;
    }
    __weak ArticleViewController *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:ARTICLESAPI Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv headerEndRefreshing];
        if (isFinish) {
            NSDictionary *dict = [load.dataDict objectForKey:@"data"];
            if ([[dict objectForKey:@"articles"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"articles"] count]) {
                page = 1;
                
                [blockSelf.articlesArray removeAllObjects];
                NSArray *array = [dict objectForKey:@"articles"];
                for (NSDictionary *dic in array) {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.des = [dic objectForKey:@"description"];
                    [blockSelf.articlesArray addObject:model];
                }
            }
            
            if([[dict objectForKey:@"banner"] isKindOfClass:[NSDictionary class]]){
                [blockSelf.bannersArray removeAllObjects];
                
                NSDictionary *dic = [dict objectForKey:@"banner"];
                ArticleModel *model = [[ArticleModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.des = [dic objectForKey:@"description"];
                [blockSelf.bannersArray addObject:model];
                
                [blockSelf.headerImageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"water_white.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    if (image) {
                        CGFloat w = [UIScreen mainScreen].bounds.size.width-30;
                        CGFloat h = w*image.size.height/image.size.width;
                        [MyControl setHeight:h+20 WithView:blockSelf.headerView];
                        [MyControl setHeight:h WithView:blockSelf.headerImageView];
                        CGFloat p = 60/330.0;
                        CGFloat alphaH = h*p;
                        blockSelf.alphaBg.frame = CGRectMake(0, h-alphaH, w, alphaH);
                        blockSelf.titleLabel.frame = blockSelf.alphaBg.frame;
                        blockSelf.tv.tableHeaderView = blockSelf.headerView;
                    }
                }];
                blockSelf.titleLabel.text = model.title;
            }
            
            
            [blockSelf.tv reloadData];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreArticles
{
//    LOADING;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%lddog&cat", page]];
    NSString *url = [NSString stringWithFormat:@"%@&page=%ld&sig=%@", ARTICLESAPI, page, sig];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv footerEndRefreshing];
        if (isFinish) {
            NSDictionary *dict = [load.dataDict objectForKey:@"data"];
            if ([[dict objectForKey:@"articles"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"articles"] count]) {
                page++;
                
                NSArray *array = [dict objectForKey:@"articles"];
                for (NSDictionary *dic in array) {
                    ArticleModel *model = [[ArticleModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    model.des = [dic objectForKey:@"description"];
                    [self.articlesArray addObject:model];
                }
            }else{
                [MyControl popAlertWithView:self.view Msg:@"木有更多啦~"];
            }
            
//            if([[dict objectForKey:@"banner"] isKindOfClass:[NSDictionary class]]){
//                [self.bannersArray removeAllObjects];
//                
//                NSDictionary *dic = [dict objectForKey:@"banner"];
//                ArticleModel *model = [[ArticleModel alloc] init];
//                [model setValuesForKeysWithDictionary:dic];
//                model.des = [dic objectForKey:@"description"];
//                [self.bannersArray addObject:model];
//                
//                [self.headerImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"water_white.png"]];
//                self.titleLabel.text = model.title;
//            }
            
            
            [self.tv reloadData];
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

-(UIView *)createHeaderView
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width-30;
    CGFloat h = w/3*2;
    self.headerView = [MyControl createViewWithFrame:CGRectMake(0, 0, w+30, h+20)];
    
    _headerImageView = [MyControl createImageViewWithFrame:CGRectMake(15, 20, w, h) ImageName:@""];
    [self.headerView addSubview:self.headerImageView];
//    self.headerImageView.clipsToBounds = YES;
//    self.headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headerImageView.backgroundColor = [UIColor whiteColor];
    
    CGFloat p = 60/330.0;
    CGFloat alphaH = h*p;
    self.alphaBg = [MyControl createViewWithFrame:CGRectMake(0, h-alphaH, w, alphaH)];
    self.alphaBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.headerImageView addSubview:self.alphaBg];
    
    self.titleLabel = [MyControl createLabelWithFrame:self.alphaBg.frame Font:20 Text:nil];
//    titleLabel.text = @"【星球日报·第一期】因为你是我的眼";
    self.titleLabel.numberOfLines = 1;
    [self.headerImageView addSubview:self.titleLabel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerBtnClick:)];
    [self.headerView addGestureRecognizer:tap];
//    UIButton *headerBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.headerImageView.frame.size.width+30, headerView.frame.size.height) ImageName:@"" Target:self Action:@selector(headerBtnClick) Title:nil];
//    [self.headerImageView addSubview:headerBtn];
    
    return self.headerView;
}
-(void)headerBtnClick:(UIGestureRecognizer *)tap
{
    //跳转详细页面，webView
    ArticleWebViewController *article = [[ArticleWebViewController alloc] init];
    article.model = self.bannersArray[0];
    [self presentViewController:article animated:YES completion:nil];
}

#pragma mark -
-(void)createTableView
{
    CGFloat spe = 64.0f;
    CGFloat spe2 = [UIScreen mainScreen].bounds.size.width/5.0;
    //    140 101
    //    128*94
    CGFloat bottomHeight = spe2*105/128;
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, spe, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-spe-bottomHeight+10) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
//    self.tv.separatorStyle = 0;
//    self.tv.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tv];
    
    
    self.tv.tableHeaderView = [self createHeaderView];
    
    //禁止带导航的界面里滑动控件自动缩进
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tv addHeaderWithTarget:self action:@selector(loadArticlesData)];
    [self.tv addFooterWithTarget:self action:@selector(loadMoreArticles)];
}

#pragma mark -delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articlesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ArticleCell";
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    ArticleModel *model = self.articlesArray[indexPath.row];
    [cell modifyUI:model];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转详细页
//    ArtivleDetailViewController *detail = [[ArtivleDetailViewController alloc] init];
    ArticleWebViewController *article = [[ArticleWebViewController alloc] init];
    article.model = self.articlesArray[indexPath.row];
    [self presentViewController:article animated:YES completion:nil];
//    [self.navigationController pushViewController:detail animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.0f;
}
@end
