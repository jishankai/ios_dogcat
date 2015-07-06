//
//  DiscoverPictureViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/2.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "DiscoverPictureViewController.h"
#import "RandomViewController.h"
#import "DiscoverHandPickedCell.h"
#import "RecommendModel.h"
#import "ChatViewController.h"
#import "PetMainViewController.h"
#import "SendGiftViewController.h"
#import "HMEmotionKeyboard.h"

static NSString *handpickCellID = @"DiscoverHandPickedCell";

@interface DiscoverPictureViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UMSocialUIDelegate,UITextViewDelegate>
{
    BOOL isWaterFlowCreated;
    BOOL isAttentionLoaded;
    BOOL isMoreCreated;
    NSInteger segSelectedIndex;
    NSInteger sheetIndex;
    BOOL isCommentCreated;
    CGFloat originalY;
    BOOL isInThisController;
    
    BOOL isReply;
    //3,表情button点击状态
    BOOL isClick;
    CGFloat lastOffSetY;
    CGFloat lastOffSetY1;

    CGFloat OldOffSetY;
    int a;
    int b;
    int c;
    
    BOOL isShow;
    
    BOOL isScroll;

}
//4,HMEmotionTextView
@property(nonatomic,strong)HMEmotionTextView *commentTextField;
//表情button
@property(nonatomic, strong)UIButton *emoticonButton;
//表情键盘
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
//是否正在切换键盘
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;


@property(nonatomic,strong)UITableView *tv;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic)CGFloat offsetY;
@property(nonatomic,strong)RandomViewController *random;
//@property(nonatomic,strong)UIActionSheet *sheet;

@property(nonatomic,strong)NSMutableArray *recommendDataArray;
@property(nonatomic,strong)NSMutableArray *attentionDataArray;
@property(nonatomic,strong)NSString *lastRecomImgid;
@property(nonatomic,strong)NSString *lastAttentionImgid;

//@property(nonatomic,strong)UITextField *commentTextField;
@property(nonatomic,strong)UIButton *bgButton;
@property(nonatomic,strong)UIView *commentBgView;

@property(nonatomic,strong)UIButton *menuBgBtn;
@property(nonatomic,strong)UIView *moreView;

@property(nonatomic,strong)NSString *reply_id;
@property(nonatomic,strong)NSString *reply_name;
@property(nonatomic,strong)NSString *reply_body;
@property(nonatomic,strong)NSString *reply_imgId;
@end

#define kShowTime 1.0
@implementation DiscoverPictureViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    lastOffSetY = -100;
    OldOffSetY = -self.view.size.height;
//    isShow = YES;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    
    self.recommendDataArray = [NSMutableArray arrayWithCapacity:0];
    self.attentionDataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self createTableView];
    [self createTop];
    
    [self loadHandpickData];
//    [self loadAttentionData];
}

#pragma mark -
-(void)refreshTop
{
    if (segSelectedIndex == 1) {
        [self.random headerRefresh];
    }else{
        [self.tv headerBeginRefreshing];
    }
    [self showTop];
}

#pragma mark -
-(void)loadHandpickData
{
//    LOADING;
    NSString *url = [NSString stringWithFormat:@"%@%@", RECOMMENDAPI, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [self.tv headerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && [array[0] isKindOfClass:[NSArray class]] && [array[0] count]){
                [self.recommendDataArray removeAllObjects];
                
                NSArray *tempArray = array[0];
                for (NSDictionary *dict in tempArray) {
                    RecommendModel *model = [[RecommendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    if([[dict objectForKey:@"likers_tx"] isKindOfClass:[NSArray class]]){
                        model.likersTxArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"likers_tx"]];
                    }
                    
                    [self.recommendDataArray addObject:model];
                }
                self.lastRecomImgid = [self.recommendDataArray[self.recommendDataArray.count-1] img_id];
                [self.tv reloadData];
                ENDLOADING;
            }
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreHandpickData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.lastRecomImgid]];
    NSString *url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", RECOMMENDAPI2, self.lastRecomImgid, sig, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        [self.tv footerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && [array[0] isKindOfClass:[NSArray class]] && [array[0] count]){
//                [self.recommendDataArray removeAllObjects];
                
                NSArray *tempArray = array[0];
                for (NSDictionary *dict in tempArray) {
                    RecommendModel *model = [[RecommendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    if([[dict objectForKey:@"likers_tx"] isKindOfClass:[NSArray class]]){
                        model.likersTxArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"likers_tx"]];
                    }
                    
                    [self.recommendDataArray addObject:model];
                }
                self.lastRecomImgid = [self.recommendDataArray[self.recommendDataArray.count-1] img_id];
                [self.tv reloadData];
                ENDLOADING;
            }
        }else{
            LOADFAILED;
        }
    }];
}

-(void)loadAttentionData
{
//    LOADING;
    NSString *url = [NSString stringWithFormat:@"%@%@", FAVORITEAPI, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv headerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && [array count]){
                [self.attentionDataArray removeAllObjects];
                
                for (NSDictionary *dict in array) {
                    RecommendModel *model = [[RecommendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    if([[dict objectForKey:@"likers_tx"] isKindOfClass:[NSArray class]]){
                        model.likersTxArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"likers_tx"]];
                    }
                    
                    [self.attentionDataArray addObject:model];
                }
                self.lastAttentionImgid = [self.attentionDataArray[self.attentionDataArray.count-1] img_id];
                NSLog(@"dddddddddd");
                [self.tv reloadData];
                ENDLOADING;
            }
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreAttentionData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", self.lastAttentionImgid]];
    NSString *url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", FAVORITEAPI2, self.lastAttentionImgid, sig, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [self.tv footerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && [array count]){
//                [self.attentionDataArray removeAllObjects];
                
                for (NSDictionary *dict in array) {
                    RecommendModel *model = [[RecommendModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    if([[dict objectForKey:@"likers_tx"] isKindOfClass:[NSArray class]]){
                        model.likersTxArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"likers_tx"]];
                    }
                    
                    [self.attentionDataArray addObject:model];
                }
                self.lastAttentionImgid = [self.attentionDataArray[self.attentionDataArray.count-1] img_id];
                [self.tv reloadData];
                ENDLOADING;
            }
        }else{
            LOADFAILED;
        }
    }];
}


-(void)createTableView
{
    UIImageView * blurImage = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurImage];
    
//    CGFloat spe = [UIScreen mainScreen].bounds.size.width/5.0;
//    CGFloat bottomHeight = spe*99/128-10;
    
    self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.separatorStyle = 0;
    self.tv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tv];
    
    UIView *view = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 32)];
    self.tv.tableHeaderView = view;
    
    [self.tv registerNib:[UINib nibWithNibName:handpickCellID bundle:[NSBundle mainBundle]] forCellReuseIdentifier:handpickCellID];
    
    [self.tv addHeaderWithTarget:self action:@selector(topRefresh)];
    [self.tv addFooterWithTarget:self action:@selector(bottomRefresh)];
}
-(void)topRefresh
{
    if (segSelectedIndex == 0) {
        [self loadHandpickData];
    }else{
        [self loadAttentionData];
    }
}
-(void)bottomRefresh
{
    if (segSelectedIndex == 0) {
        [self loadMoreHandpickData];
    }else{
        [self loadMoreAttentionData];
    }
}

-(void)createTop
{
    self.bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 32)];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:self.bgView];
    
//    UIView *alphaView = [MyControl createViewWithFrame:self.bgView.frame];
//    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
//    [self.bgView addSubview:alphaView];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"精选", @"最新", @"关注"]];
    segmentControl.frame = CGRectMake((WIDTH-180)/2.0, (self.bgView.frame.size.height-20)/2.0, 180, 20);
    segmentControl.tintColor = [UIColor clearColor];
    segmentControl.backgroundColor = [UIColor clearColor];
    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:ORANGE,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    [segmentControl addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    [self.bgView addSubview:segmentControl];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
    segSelectedIndex = seg.selectedSegmentIndex;
    switch (seg.selectedSegmentIndex) {
        case 0:
            [self hideWaterFlow];
            self.tv.hidden = NO;
            [self.tv reloadData];
            break;
        case 1:
            if (isWaterFlowCreated) {
                [self showWaterFlow];
            }else{
                [self createWaterFlow];
                isWaterFlowCreated = YES;
            }
            self.tv.hidden = YES;
            break;
        case 2:
            [self hideWaterFlow];
            self.tv.hidden = NO;
            if (!isAttentionLoaded) {
                [self loadAttentionData];
                isAttentionLoaded = YES;
                [self.tv reloadData];
            }else{
                [self.tv reloadData];
            }
            break;
        default:
            break;
    }
}
-(void)createWaterFlow
{
    self.random = [[RandomViewController alloc] init];
    self.random.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64);
    [ControllerManager addViewController:self.random To:self];
    
    [self.view bringSubviewToFront:self.bgView];
    
    __block DiscoverPictureViewController *blockSelf = self;
    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowTime * NSEC_PER_SEC));
    self.random.rollUp = ^(){
        [blockSelf isHidenView];
    };
    self.random.rollDown = ^(){
        
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [blockSelf isShowView];
//        });
    };
//    self.random.rollStop = ^(){
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [blockSelf isShowView];
//        });
//    };
}
-(void)showWaterFlow
{
    self.random.view.hidden = NO;
}
-(void)hideWaterFlow
{
    self.random.view.hidden = YES;
}

#pragma mark -
-(void)hideTop
{
    __block CGRect rect = self.bgView.frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        rect.origin.y = -rect.size.height;
        [MyControl setHeight:HEIGHT-64 WithView:self.tv];
        self.bgView.frame = rect;
    }];
}
-(void)showTop
{
    __block CGRect rect = self.bgView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        rect.origin.y = 0;
        self.bgView.frame = rect;
        
        [MyControl setHeight:HEIGHT-64 WithView:self.tv];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (segSelectedIndex == 0) {
        return self.recommendDataArray.count;
    }else{
        return self.attentionDataArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoverHandPickedCell *cell = [tableView dequeueReusableCellWithIdentifier:handpickCellID];
    cell.backgroundColor = [UIColor clearColor];
    
    RecommendModel *model = nil;
    if (segSelectedIndex == 2) {
        cell.isAttention = YES;
        model = self.attentionDataArray[indexPath.row];
    }else{
        cell.isAttention = NO;
        model = self.recommendDataArray[indexPath.row];
    }
    
    [cell modifyUI:model];
    __block DiscoverPictureViewController *blockSelf = self;
    cell.toolBlock = ^(NSInteger index){
        NSLog(@"第%ld行第%ld个按钮", indexPath.row, index);
        blockSelf->sheetIndex = indexPath.row;
        
        //判断是否注册
        if(index != 3){
            ShouldShowRegist;
        }
        //UISheetAction 发私信，保存图片，举报，取消
        if(index == 0){
            //点赞，点赞后将likes+1,likers+id,likers+tx
            [blockSelf zanWithIndex:indexPath];
        }else if(index == 1){
            //评论，这里在用户评论过后，将一段字符串添加到model.comments中的最前端
            blockSelf->isReply = NO;
            [blockSelf commentClick];
        }else if(index == 2){
            //礼物
            ShouldShowRegist;
            
            [blockSelf sendGift];
        }else if (index == 3) {
//            [blockSelf createSheet];
            if (!isMoreCreated) {
                //create more
                isMoreCreated = YES;
                [self createMore];
            }
            //show more
            self.menuBgBtn.hidden = NO;
            CGRect rect = self.moreView.frame;
            rect.origin.y -= rect.size.height;
            [UIView animateWithDuration:0.3 animations:^{
                self.moreView.frame = rect;
                self.menuBgBtn.alpha = 0.6;
            }];
        }
    };
    cell.headBlock = ^(){
        //跳转宠物主页
        PetMainViewController * vc = [[PetMainViewController alloc] init];
        vc.aid = model.aid;
        [self presentViewController:vc animated:YES completion:nil];
    };
    cell.pBlock = ^(){
        //pClick
        [blockSelf pClick:model];
    };
    cell.bigImageBtnBlock = ^(){
        FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
        vc.img_id = model.img_id;
        vc.isFromRandom = YES;
        vc.imageURL = [MyControl returnThumbImageURLwithName:model.url Width:[UIScreen mainScreen].bounds.size.width Height:0];
        vc.imageCmt = model.cmt;
        [ControllerManager addTabBarViewController:vc];
    };
    cell.replyBlock = ^(NSString *usrId, NSString *name){
        blockSelf->sheetIndex = indexPath.row;
        blockSelf->isReply = YES;
        
        blockSelf.reply_id = usrId;
        blockSelf.reply_name = name;
        blockSelf.reply_imgId = model.img_id;
        
        [blockSelf commentClick];
        
    };
    cell.selectionStyle = 0;
    cell.clipsToBounds = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (segSelectedIndex == 0) {
        RecommendModel *model = self.recommendDataArray[indexPath.row];
        //这10+的是空隙的高度
        return [self cellHeightWithModel:model]+10;
    }else if(segSelectedIndex == 2){
        RecommendModel *model = self.attentionDataArray[indexPath.row];
        return [self cellHeightWithModel:model]+10;
    }
    return 44;
}


-(CGFloat)cellHeightWithModel:(RecommendModel *)model
{
    //bigImage初始Y值45
    CGFloat cellHeight = 45.0;
    
    NSArray *array = [model.url componentsSeparatedByString:@"_"];
    NSString *wAndH = array[array.count-1];
    NSArray *array2 = [wAndH componentsSeparatedByString:@"&"];
    CGFloat w = [array2[0] floatValue];
    CGFloat h = [array2[1] floatValue];
    CGFloat targetH = WIDTH*h/w;
    //图片高度
    cellHeight += targetH;
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    if ([model.topic_name isKindOfClass:[NSString class]] && model.topic_name.length > 0) {
        [mutableString appendFormat:@"#%@#", model.topic_name];
    }
    [mutableString appendString:model.cmt];
    
    CGSize topicAndCmtSize = [mutableString boundingRectWithSize:CGSizeMake(WIDTH-8*2, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if (mutableString.length > 0) {
        //文字高度及间距
        cellHeight += (10+topicAndCmtSize.height);
    }
    
    //toolsView高度及间距
    cellHeight += (10+25);
    
    if ([model.likes intValue] > 0) {
        cellHeight += (15+27);
    }
    
    if ([model.comments isKindOfClass:[NSString class]] && model.comments.length > 0) {
        cellHeight += (15+75);
    }
    return cellHeight+10.0;
}
- (void)isShowView{
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowTime * 2 * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self showTop];
    [ControllerManager showTabBar];
        if (!self.random.view.hidden) {
            [self.random adjustRandomToNormal];
        }
//    });
}
- (void)isHidenView{
    [self hideTop];
    [ControllerManager hideTabBar];
    if (!self.random.view.hidden) {
        [self.random adjustRandomToBig];
    }
}

#pragma mark - scrollView代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.offsetY = scrollView.contentOffset.y;
//    NSLog(@"pppppppBegin%f",self.offsetY);

}
/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    lastOffSetY1 = scrollView.contentOffset.y;
//    
//    if (lastOffSetY >lastOffSetY1) {
//        NSLog(@"向上");
//    }else{
//         NSLog(@"向下");
//    }
//    
////    
////    NSLog(@"%f",scrollView.contentOffset.y);
////    if (OldOffSetY != -self.view.size.height) {
////        if (OldOffSetY > scrollView.contentOffset.y) {
////            NSLog(@"xiahua1112222");
////            isShow = NO;
////        }else {
////            NSLog(@"上画22211111");
////            isShow = YES;
////        }
////    }
//    OldOffSetY = scrollView.contentOffset.y;
//    NSLog(@"%f",OldOffSetY);
//
//    
}*/
//-(void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
//}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    //这里添加你的逻辑，比如，触发上拉加载更多
//    CGFloat end = self.tv.contentOffset.y;
//    if (end >self.offsetY) {
//        
//        [self isShowView];
//    }
//    NSLog(@"2211aaaaend%f",end);
//}
//拖动的手指抬起
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat endOffsetY = scrollView.contentOffset.y;
    lastOffSetY1 = endOffsetY;
//    NSLog(@"结束拖动%f--%f", self.offsetY, endOffsetY);
//    NSLog(@"kkkkkkkk抬起%f",endOffsetY);
    if (self.offsetY<endOffsetY) {
        //上滑
        [self isHidenView];

    }else{
        [self showTop];
        [ControllerManager showTabBar];
        if (!self.random.view.hidden) {
            [self.random adjustRandomToNormal];
        }
    }
}
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    NSLog(@"999999999999%d;;;;;;;;%d",self.tv.decelerating,isShow);
////    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kShowTime * 2 * NSEC_PER_SEC));
////    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////    [self isShowView];
//            [self scrollViewWithVelocity:velocity];
////    });
//
//}
//- (void)scrollViewWithVelocity:(CGPoint)velocity
//{
//    NSLog(@"%f",velocity.y);
//    if (velocity.y >= 2) {
//        
////        [self isShowView];
//                NSLog(@"-------");
//        
//    }else if (velocity.y <= -0.0001){
//        NSLog(@"========");
//    }else if (velocity.y == 0){
//        NSLog(@"ss++++");
//    }
//}

//当用户抬起手指而视图需要继续移动时，会收到通知。这个方法可以用来读取 contentOffset属性，从而判断出当用户抬起手指钱最后一次滚动到的位置，虽然这个位置并不会使滚动条的最终停止位置。
//-(void)scrollViewWillBeginDecelerate:(UIScrollView*)scrollView{
////    NSLog(@"结束拖动--%f", scrollView.contentOffset.y);
//}
#pragma mark -
-(void)createMore
{
    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    
    self.menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    self.menuBgBtn.backgroundColor = [UIColor blackColor];
    [tabBar.view addSubview:self.menuBgBtn];
    self.menuBgBtn.alpha = 0;
    self.menuBgBtn.hidden = YES;
    
    // 318*234
    self.moreView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT, WIDTH, 180)];
    self.moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [tabBar.view addSubview:self.moreView];
    
    //orange line
    UIView * orangeLine = [MyControl createViewWithFrame:CGRectMake(0, 0, 320, 4)];
    orangeLine.backgroundColor = [ControllerManager colorWithHexString:@"fc7b51"];
    [self.moreView addSubview:orangeLine];
    //label
    UILabel * shareLabel = [MyControl createLabelWithFrame:CGRectMake(15, 10, 80, 15) Font:13 Text:@"分享到"];
    shareLabel.textColor = [UIColor blackColor];
    [self.moreView addSubview:shareLabel];
    //3个按钮
    NSArray * arr = @[@"more_weixin.png", @"more_friend.png", @"more_sina.png"];
    NSArray * arr2 = @[@"微信好友", @"朋友圈", @"微博"];
    float spe = (self.view.frame.size.width-80-42*3)/2.0;
    for(int i=0;i<3;i++){
        UIButton * button = [MyControl createButtonWithFrame:CGRectMake(40+i*(spe+42), 33, 42, 42) ImageName:arr[i] Target:self Action:@selector(shareClick:) Title:nil];
        button.tag = 400+i;
        [self.moreView addSubview:button];
        
        CGRect rect = button.frame;
        UILabel * label = [MyControl createLabelWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y+rect.size.height+5, rect.size.width+20, 15) Font:12 Text:arr2[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        //        label.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.moreView addSubview:label];
    }
    
    UIView * grayLine1 = [MyControl createViewWithFrame:CGRectMake(0, 105, 320, 2)];
    grayLine1.backgroundColor = [ControllerManager colorWithHexString:@"e3e3e3"];
    [self.moreView addSubview:grayLine1];
    
//    128*32
    float spe2 = self.view.frame.size.width-20*2-128*2;
    UIButton * reportBtn = [MyControl createButtonWithFrame:CGRectMake(20, grayLine1.frame.origin.y+15, 128, 32) ImageName:@"more_report.png" Target:self Action:@selector(reportBtnClick) Title:nil];
    [self.moreView addSubview:reportBtn];

    
    UIButton * msgBtn = [MyControl createButtonWithFrame:CGRectMake(reportBtn.frame.origin.x+reportBtn.frame.size.width+spe2, grayLine1.frame.origin.y+15, 128, 32) ImageName:@"more_message.png" Target:self Action:@selector(msgBtnClick) Title:nil];
    [self.moreView addSubview:msgBtn];
}
-(void)cancelBtnClick
{
    NSLog(@"cancel");
    __block CGRect rect = self.moreView.frame;
    rect.origin.y += rect.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.moreView.frame = rect;
        self.menuBgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.menuBgBtn.hidden = YES;
    }];
}
#pragma mark -
-(void)reportBtnClick
{
    NSLog(@"举报");
    [self cancelBtnClick];
    [self reportImage];
}
-(void)msgBtnClick
{
    NSLog(@"私信");
    [self cancelBtnClick];
    
    ShouldShowRegist;
    
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    NSLog(@"发私信");
    ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:model.usr_id isGroup:NO];
    chatController.isFromCard = YES;
    chatController.nickName = [USER objectForKey:@"name"];
    chatController.tx = [USER objectForKey:@"tx"];
    chatController.other_nickName = model.u_name;
    chatController.other_tx = model.u_tx;
    [self presentViewController:chatController animated:YES completion:nil];
}

#pragma mark -gift
-(void)sendGift
{
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    SendGiftViewController * vc = [[SendGiftViewController alloc] init];
    vc.receiver_aid = model.aid;
    vc.receiver_name = model.name;
    vc.receiver_img_id = model.img_id;
    __weak SendGiftViewController *weakVC = vc;
    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    
    vc.hasSendGift = ^(NSString * itemId){
        NSLog(@"赠送礼物给默认宠物成功!");
        
        ResultOfBuyView * result = [[ResultOfBuyView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [UIView animateWithDuration:0.3 animations:^{
            result.alpha = 1;
        }];
        result.confirm = ^(){
            [weakVC closeGiftAction];
        };
        [result configUIWithName:model.name ItemId:itemId Tx:model.tx];
        [tabBar.view addSubview:result];
        
        
    };
    [ControllerManager addTabBarViewController:vc];
}
#pragma mark -share
-(void)shareClick:(UIButton *)btn
{
    NSInteger index = btn.tag;
    [MobClick event:@"photo_share"];
    
    DiscoverHandPickedCell *cell = (DiscoverHandPickedCell *)[self.tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sheetIndex inSection:0]];
    UIImageView *bigImageView = cell.bigImage;
    
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    //判断图片发布时间是否超过24小时
    BOOL isOvertime = [self isOver24Hour:model.create_time];
    
    if (index == 400) {
        NSLog(@"微信");
        //强制分享图片
        //        [self.imageDict objectForKey:@"cmt"]
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, model.img_id];
        
        NSString * str = nil;
        if([model.is_food intValue] && !isOvertime){
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"轻轻一点，免费赏粮！我的口粮全靠你啦~";
            if ([model.cmt length]) {
                str = model.cmt;
            }else{
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }
        }else{
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，你有没有爱上我？", model.name];
            if ([model.cmt length]) {
                str = model.cmt;
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
        }
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
                
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];

            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];

            }
            
        }];
    }else if(index == 401){
        NSLog(@"朋友圈");
        //强制分享图片
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, model.img_id];
        
        NSString * str = nil;
        if ([model.cmt length]) {
            str = model.cmt;
        }else{
            if ([model.is_food intValue] && !isOvertime) {
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
            
        }
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = str;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:nil image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [self loadShareAPI];
                
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];

            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
            
        }];
    }else if(index == 402){
        NSLog(@"微博");
        NSString * str = nil;
        if([model.is_food intValue] && !isOvertime){
            if ([model.cmt length]) {
                str = model.cmt;
            }else{
                str = @"看在我这么努力卖萌的份上快来宠宠我！免费送我点口粮好不好？";
            }
        }else{
            if ([model.cmt length]) {
                str = model.cmt;
            }else{
                str = @"这是我最新的美照哦~~打滚儿求表扬~~";
            }
        }
        
        NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, model.img_id];
        if([model.topic_name isKindOfClass:[NSString class]] && [model.topic_name length]){
            str = [NSString stringWithFormat:@"%@ #%@# %@", str, model.topic_name, last];
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

-(BOOL)isOver24Hour:(NSString *)createTime
{
    NSDate * date = [NSDate date];
    //当前时间戳
    NSString * stamp = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    //t为时间差
    //24小时为期限
    
    //当前时间戳-时间戳 < 24h 才返回NO,说明未超过24小时
    if ([stamp intValue]-[createTime intValue] < 24*60*60) {
        return NO;
    }else{
        return YES;
    }
}
#pragma mark -
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //    NSLog(@"%@", response);
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [self loadShareAPI];
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}

-(void)loadShareAPI
{
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    
    if ([model.is_food intValue] == 1) {
        [MobClick event:@"food_share_suc"];
    }else{
        NSArray * menuList = [USER objectForKey:@"MenuList"];
        if (menuList.count <2) {
            [MobClick event:@"food_share_suc"];
        }else{
            //匹配
            for(int i=1;i<menuList.count;i++){
                if ([menuList[i] integerValue] == [model.is_food intValue]) {
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
    
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", model.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", SHAREIMAGEAPI, model.img_id, sig, [ControllerManager getSID]];
    NSLog(@"shareUrl:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            if(![[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]){
                return;
            }
        }else{
            
        }
    }];
}

#pragma mark -
#pragma mark - 举报图片
-(void)reportImage
{
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    LOADING;
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", model.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", REPORTIMAGEAPI, model.img_id, sig, [ControllerManager getSID]];
    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            ENDLOADING;
            [MyControl popAlertWithView:self.view Msg:@"举报成功"];
        }else{
            LOADFAILED;
        }
    }];
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"已保存至相册" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];;
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];;
    }
}

#pragma mark -
-(void)zanWithIndex:(NSIndexPath *)indexPath
{
    RecommendModel *model = [self returnModelWithIndex:indexPath.row];
    
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", model.img_id]];
    NSString * url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", LIKEAPI, model.img_id, sig, [ControllerManager getSID]];
//    NSLog(@"likeURL:%@", url);
    
    LOADING;
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            NSLog(@"%@", load.dataDict);
            
            if (![[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] isKindOfClass:[NSNumber class]]) {
            }else{
                [MobClick event:@"like"];
//                btn.selected = YES;
                int a = [[[load.dataDict objectForKey:@"data"] objectForKey:@"gold"] intValue];
                if (a) {
                    [ControllerManager HUDImageIcon:@"gold.png" showView:self.view yOffset:0 Number:a];
                    [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+a] forKey:@"gold"];
                }

                //改变model中的likes likers likers_tx
                model.likes = [NSString stringWithFormat:@"%d", [model.likes intValue]+1];
                if([model.likers isKindOfClass:[NSString class]] && model.likers.length){
                    //已有人点过赞
                    model.likers = [NSString stringWithFormat:@"%@,%@", [USER objectForKey:@"usr_id"], model.likers];
                    if ([[USER objectForKey:@"tx"] isKindOfClass:[NSString class]]) {
                        [model.likersTxArray insertObject:[USER objectForKey:@"tx"] atIndex:0];
                    }else{
                        [model.likersTxArray insertObject:@"" atIndex:0];
                    }
                    
                }else{
                    //还没有人点赞
                    model.likers = [USER objectForKey:@"usr_id"];
                    if ([[USER objectForKey:@"tx"] isKindOfClass:[NSString class]]) {
                        model.likersTxArray = [NSMutableArray arrayWithObject:[USER objectForKey:@"tx"]];
                    }else{
                        [model.likersTxArray insertObject:@"" atIndex:0];
                        model.likersTxArray = [NSMutableArray arrayWithObject:@""];
                    }
                }
                
                [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            ENDLOADING;
        }else{
            ENDLOADING;
            NSLog(@"点赞失败");
        }
    }];
}

#pragma mark -
-(void)pClick:(RecommendModel *)model
{
    ShouldShowRegist;
    
    Alert_oneBtnView * oneBtn = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSArray *array = [USER objectForKey:@"myPetsDataArray"];
    if (array.count >= 10) {
        NSInteger cost = array.count*5;
        if (cost>100) {
            cost = 100;
        }
        if(cost>[[USER objectForKey:@"gold"] intValue]){
            //余额不足
            if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
                //审核
                [MyControl popAlertWithView:self.view Msg:@"钱包君告急！挣够金币再来捧萌星吧~"];
            }else{
                [ControllerManager addAlertWith:self Cost:cost SubType:1];
            }
            
            return;
        }
        oneBtn.type = 2;
        oneBtn.petsNum = array.count;
        [oneBtn makeUI];
        [[UIApplication sharedApplication].keyWindow addSubview:oneBtn];
    }else{
        oneBtn.type = 2;
        oneBtn.petsNum = array.count;
        [oneBtn makeUI];
        [[UIApplication sharedApplication].keyWindow addSubview:oneBtn];
    }
    oneBtn.jump = ^(){
        //                    [MyControl startLoadingWithStatus:@"加入中..."];
        LOADING;
        NSString *joinPetCricleSig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@dog&cat", model.aid]];
        NSString *joinPetCricleString = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", JOINPETCRICLEAPI,model.aid, joinPetCricleSig, [ControllerManager getSID]];
        NSLog(@"加入圈子:%@",joinPetCricleString);
        httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:joinPetCricleString Block:^(BOOL isFinish, httpDownloadBlock *load) {
            if (isFinish) {
                NSLog(@"加入成功数据：%@",load.dataDict);
                if ([[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"]) {
                    if (array.count>=10) {
                        NSInteger cost = array.count * 5;
                        if (cost>100) {
                            [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-100] forKey:@"gold"];
                        }else{
                            [USER setObject:[NSString stringWithFormat:@"%ld", [[USER objectForKey:@"gold"] intValue]-cost] forKey:@"gold"];
                        }
                        
                    }
                    
                }
                ENDLOADING;
                [self refreshMyPets];
                
                FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
                //捧Ta成功界面
                NoCloseAlert * noClose = [[NoCloseAlert alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                noClose.confirm = ^(){};
                [tabBar.view addSubview:noClose];
                NSString * percent = [NSString stringWithFormat:@"%@", [[load.dataDict objectForKey:@"data"] objectForKey:@"percent"]];
                [noClose configUIWithTx:model.tx Name:model.name Percent:percent];
                [UIView animateWithDuration:0.3 animations:^{
                    noClose.alpha = 1;
                }];
            }else{
                LOADFAILED;
                NSLog(@"加入国家失败");
            }
        }];
    };
}
-(void)refreshMyPets
{
    NSString * sig = [MyMD5 md5:[NSString stringWithFormat:@"is_simple=1&usr_id=%@dog&cat", [USER objectForKey:@"usr_id"]]];
    NSString * url = [NSString stringWithFormat:@"%@%d&usr_id=%@&sig=%@&SID=%@", USERPETLISTAPI, 1, [USER objectForKey:@"usr_id"], sig, [ControllerManager getSID]];
//    NSLog(@"%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if (isFinish) {
            //            NSLog(@"%@", load.dataDict);
            //获取用户所有宠物，将信息存到本地
            NSArray * array = [load.dataDict objectForKey:@"data"];
            if([array isKindOfClass:[NSArray class]] && array.count>0){
                [USER setObject:array forKey:@"myPetsDataArray"];
                [self.tv reloadData];
            }
        }else{
            LOADFAILED;
        }
    }];
}


#pragma mark - commentClick
-(void)commentClick
{
    ShouldShowRegist;
    
    isInThisController = YES;
//    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    
    if (isReply && [self.reply_id isEqualToString:[USER objectForKey:@"usr_id"]]) {
        [MyControl popAlertWithView:self.view Msg:@"不能回复自己哦"];
        return;
    }
    
    if (!isCommentCreated) {
        isCommentCreated = YES;
        [self createCommentUI];
    }
    
    if (isReply) {
        self.commentTextField.placehoder = [NSString stringWithFormat:@"回复%@", self.reply_name];
    }else{
        self.commentTextField.placehoder = @"写个评论呗";
    }
    

    self.bgButton.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgButton.alpha = 0.3;
        self.commentBgView.frame = CGRectMake(0, originalY, 320, 40);
    }];
    [self.commentTextField becomeFirstResponder];
}
-(void)createCommentUI
{
    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    
    self.bgButton = [MyControl createButtonWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) ImageName:nil Target:self Action:@selector(bgButtonClick) Title:nil];
    self.bgButton.backgroundColor = [UIColor blackColor];
    self.bgButton.alpha = 0.3;
    self.bgButton.hidden = YES;
    [tabBar.view addSubview:self.bgButton];
    
    self.commentBgView = [MyControl createViewWithFrame:CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40)];
    originalY = self.commentBgView.frame.origin.y;
    self.commentBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [tabBar.view addSubview:self.commentBgView];
    //评论输入框 self.commentTextField
    self.commentTextField = [[HMEmotionTextView alloc] initWithFrame:CGRectMake(45, 5, 220, 30)];
    self.commentTextField.font = [UIFont systemFontOfSize:15];
    self.commentTextField.attributedText = nil;
    self.commentTextField.placehoder= @"写个评论呗";
    self.commentTextField.layer.cornerRadius = 5;
    self.commentTextField.layer.masksToBounds = YES;
    self.commentTextField.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1].CGColor;
    self.commentTextField.layer.borderWidth = 1.5;
    self.commentTextField.delegate = self;
    //关闭自动更正及大写
    self.commentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.commentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.commentBgView addSubview:self.commentTextField];
    //    [commentTextView release];
    
    //3，增加键盘button
    self.emoticonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.emoticonButton.frame = CGRectMake(8, 7.5, 25, 25);
    //    [emoticonButton setTitle:@"图标" forState:UIControlStateNormal];
    [self.emoticonButton setBackgroundImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted@2x"] forState:UIControlStateNormal];
    [self.emoticonButton addTarget:self action:@selector(emoticonButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBgView addSubview:self.emoticonButton];
    
    // 键盘的frame(位置)即将改变, 就会发出UIKeyboardWillChangeFrameNotification
    // 键盘即将弹出, 就会发出UIKeyboardWillShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIButton * sendButton = [MyControl createButtonWithFrame:CGRectMake(260, 10, 55, 20) ImageName:@"" Target:self Action:@selector(sendButtonClick) Title:@"发送"];
    [sendButton setTitleColor:BGCOLOR forState:UIControlStateNormal];
    [self.commentBgView addSubview:sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

#pragma mark -
//4,
#pragma mark - ck
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
//4.10.图标点击方法
- (void)emoticonButtonClick{
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
    [self.commentTextField resignFirstResponder];
    [self openEmotion];
    
    
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
        //        self.toolbar.transform = CGAffineTransformIdentity;
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
        CGFloat keyboardH = keyboardF.size.height;
        //        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

#pragma mark - UITextViewDelegate
/**
 *  当用户开始拖拽scrollView时调用
 */
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

/**
 *  当textView的文字改变就会调用
 */
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}
#pragma mark - 打开表情
/**
 *  打开表情
 */
- (void)openEmotion
{
    [self kerboard];
    // 正在切换键盘
    self.changingKeyboard = YES;
    
    if (self.commentTextField.inputView) { // 当前显示的是自定义键盘，切换为系统自带的键盘
        self.commentTextField.inputView = nil;
        
        // 显示表情图片
        //        self.toolbar.showEmotionButton = YES;
    } else { // 当前显示的是系统自带的键盘，切换为自定义键盘
        // 如果临时更换了文本框的键盘，一定要重新打开键盘
        self.commentTextField.inputView = self.kerboard;
        
        // 不显示表情图片
        //        self.toolbar.showEmotionButton = NO;
    }
    
    // 关闭键盘
    [self.commentTextField resignFirstResponder];
    
    // 更换完毕完毕
    self.changingKeyboard = NO;
    
    //    [commentTextField becomeFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 打开键盘
        [self.commentTextField becomeFirstResponder];
    });
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
    [self.commentTextField appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.commentTextField];
}

/**
 *  当点击表情键盘上的删除按钮时调用
 */
- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.commentTextField deleteBackward];
}


#pragma mark -
-(void)sendButtonClick
{
    if(self.commentTextField.text == nil || self.commentTextField.text.length == 0){
        return;
    }
    
    RecommendModel *model = [self returnModelWithIndex:sheetIndex];
    
    //post数据  参数img_id 和 body
    NSString * url = [NSString stringWithFormat:@"%@%@", COMMENTAPI, [ControllerManager getSID]];
    NSLog(@"postUrl:%@", url);
    ASIFormDataRequest * _request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    _request.requestMethod = @"POST";
    _request.timeOutSeconds = 20;
    
    [_request setPostValue:self.commentTextField.realText forKey:@"body"];
    
    //
    if(isReply){
        [_request setPostValue:self.reply_imgId forKey:@"img_id"];
        [_request setPostValue:self.reply_id forKey:@"reply_id"];
        [_request setPostValue:[self.reply_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"reply_name"];
    }else{
        [_request setPostValue:model.img_id forKey:@"img_id"];
    }

    _request.delegate = self;
    [_request startAsynchronous];
    
    LOADING;
    [self bgButtonClick];
}

#pragma mark - ASI代理
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //    buttonRight.userInteractionEnabled = YES;
    ENDLOADING;
    
    NSLog(@"success");
    NSLog(@"request.responseData:%@",[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil]);
    //经验弹窗
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"%@", dict);
    if ([[dict objectForKey:@"state"] intValue] == 2) {
        //过期
        [self login];
    }else{
        if ([[dict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            int exp = [[USER objectForKey:@"exp"] intValue];
            int gold = [[[dict objectForKey:@"data"] objectForKey:@"gold"] intValue];
            int addExp = [[[dict objectForKey:@"data"] objectForKey:@"exp"] intValue];
            if (addExp>0) {
                [USER setObject:[NSString stringWithFormat:@"%d", exp+addExp] forKey:@"exp"];
                //                [ControllerManager HUDImageIcon:@"Star.png" showView:self.view.window yOffset:0 Number:addExp];
            }
            if (gold>0) {
                [USER setObject:[NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]+gold] forKey:@"gold"];
                [ControllerManager HUDImageIcon:@"gold.png" showView:self.view.window yOffset:0 Number:gold];
            }
        }
       
        [self.commentTextField resignFirstResponder];
        
        //添加评论
        NSLog(@"%@", [USER objectForKey:@"usr_id"]);
        NSMutableString *addString = [[NSMutableString alloc] initWithCapacity:0];
        [addString appendFormat:@"usr_id:%@,name:%@,body:%@,create_time:%.0f", [USER objectForKey:@"usr_id"], [USER objectForKey:@"name"], self.commentTextField.realText, [[NSDate date] timeIntervalSince1970]];
        RecommendModel *model = [self returnModelWithIndex:sheetIndex];
        
        if ([model.comments isKindOfClass:[NSString class]] && model.comments.length) {
            model.comments = [NSString stringWithFormat:@"%@;%@", addString, model.comments];
        }else{
            model.comments = addString;
        }
        self.commentTextField.placehoder = @"写个评论呗";
        self.commentTextField.attributedText = nil;
        self.commentTextField.text = nil;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.commentBgView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height-216-40, 320, 40);
            //评论清空
            self.commentTextField.placehoder = @"写个评论呗";
            self.commentTextField.attributedText = nil;
            self.commentTextField.text = nil;
            

//            self.commentTextField.placehoder = @"写个评论呗";
//            self.commentTextField.realText = @"";
        }];
//        self.bgButton.hidden = YES;
        [self bgButtonClick];
        
//        [self.tv reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sheetIndex inSection:0];
        [self.tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    ENDLOADING;
    [MyControl popAlertWithView:self.view Msg:@"评论失败"];
}
#pragma mark -
-(void)login
{
    LOADING;
    NSString * code = [NSString stringWithFormat:@"uid=%@dog&cat", UDID];
    NSString * url = [NSString stringWithFormat:@"%@&uid=%@&sig=%@", LOGINAPI, UDID, [MyMD5 md5:code]];
    NSLog(@"login-url:%@", url);
    httpDownloadBlock * request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock * load) {
        if(isFinish){
            NSLog(@"%@", load.dataDict);
            [ControllerManager setIsSuccess:[[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]];
            [ControllerManager setSID:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"]];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] forKey:@"isSuccess"];
            [USER setObject:[[load.dataDict objectForKey:@"data"] objectForKey:@"SID"] forKey:@"SID"];
            
            [self sendButtonClick];
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

#pragma mark - 键盘监听
-(void)keyboardWasChange:(NSNotification *)notification
{
    if (!isInThisController) {
        return;
    }

    float y = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    if (y == HEIGHT) {
        return;
    }
//    float height = 216.0;
    float height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (height<100) {
        height = 216.0;
    }
    NSString * str = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([str isEqualToString:@"zh-Hans"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.commentBgView.frame = CGRectMake(0, HEIGHT-height-self.commentBgView.frame.size.height, self.view.frame.size.width, self.commentBgView.frame.size.height);
            originalY = self.commentBgView.frame.origin.y;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.commentBgView.frame = CGRectMake(0, HEIGHT-height-self.commentBgView.frame.size.height, self.view.frame.size.width, self.commentBgView.frame.size.height);
            originalY = self.commentBgView.frame.origin.y;
        }];
    }
}
-(void)bgButtonClick
{
    isInThisController = NO;
    [self.commentTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.commentBgView.frame = CGRectMake(-self.view.frame.size.width, originalY, WIDTH, 40);
        self.bgButton.alpha = 0;
    } completion:^(BOOL finished) {
        self.bgButton.hidden = YES;
    }];
}



#pragma mark -
-(RecommendModel *)returnModelWithIndex:(NSInteger)index
{
    RecommendModel *model = nil;
    if (segSelectedIndex == 0) {
        model = self.recommendDataArray[index];
    }else{
        model = self.attentionDataArray[index];
    }
    return model;
}
@end
