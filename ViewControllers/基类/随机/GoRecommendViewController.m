//
//  GoRecommendViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "GoRecommendViewController.h"
#import "GoRecommendCollectionCell.h"


static NSString *cellID = @"GoRecommendCollectionCell.h";

@interface GoRecommendViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UMSocialUIDelegate>
{
    UIView *navView;
    // 推荐次数
    NSInteger count;
    // 旧的sid
    NSString *_oldSidStr;
    //
    BOOL isMoreCreated;
    NSInteger page;
    UIImageView *guide;
}

@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)UILabel *voteNumLabel;
@property(nonatomic,strong)UIButton *menuBgBtn;
@property(nonatomic,strong)UIView *moreView;
@property(nonatomic,strong)NSMutableArray *newestArray;
@property(nonatomic,strong)UIButton *heartBtn;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation GoRecommendViewController

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"dddd");
    [super viewWillAppear:animated];
    [ControllerManager hideTabBar];
    if (![[USER objectForKey:@"guide_handpick_recom"] intValue]) {
        [self createGuide];
        [USER setObject:@"1" forKey:@"guide_handpick_recom"];
    }
}
-(void)createGuide
{
    guide = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"guide_handpick_recom.png"];
    if(self.view.frame.size.height <= 480){
        [MyControl setOriginY:self.view.frame.size.height-568 WithView:guide];
        [MyControl setHeight:568 WithView:guide];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [guide addGestureRecognizer:tap];
    
//    FirstTabBarViewController * tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [self.view addSubview:guide];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ControllerManager showTabBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.newestArray = [NSMutableArray arrayWithCapacity:0];
//    // 推荐次数
//    count = [self.voteLeft intValue];
    // 旧的sid
    _oldSidStr = [ControllerManager getSID];
    
    [self createBgView];
    [self createFakeNavigation];
    [self createBottom];
    [self loadData];
}
-(void)loadData
{
    LOADING;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"star_id=%@dog&cat", self.starId]];
    NSString *url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", VOTELISTAPI, self.starId, sig, [ControllerManager getSID]];
    
    __weak GoRecommendViewController *weakSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [load.dataDict objectForKey:@"data"];
                [weakSelf.newestArray removeAllObjects];
                
                if(weakSelf.insertModel != nil){
                    [weakSelf.newestArray addObject:weakSelf.insertModel];
                }
                for (NSDictionary *dict in array) {
                    NewestModel *model = [[NewestModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    //和insertModel排重
                    if(weakSelf.insertModel != nil && [weakSelf.insertModel.img_id isEqualToString:model.img_id]){
                        continue;
                    }
                    [weakSelf.newestArray addObject:model];
                }
                
                page = 1;
                //
                [weakSelf.collection reloadData];
                [weakSelf scrollViewDidEndDecelerating:weakSelf.collection];
            }
            
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreData
{
//    LOADING;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ld&star_id=%@dog&cat", page, self.starId]];
    NSString *url = [NSString stringWithFormat:@"%@%ld&star_id=%@&sig=%@&SID=%@", VOTELISTAPI2, page, self.starId, sig, [ControllerManager getSID]];
    
    __weak GoRecommendViewController *weakSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [load.dataDict objectForKey:@"data"];
                for (NSDictionary *dict in array) {
                    NewestModel *model = [[NewestModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    if(weakSelf.insertModel != nil && [weakSelf.insertModel.img_id isEqualToString:model.img_id]){
                        continue;
                    }
                    [weakSelf.newestArray addObject:model];
                }
                
                page++;
                //
                [weakSelf.collection reloadData];
//                [weakSelf scrollViewDidEndDecelerating:weakSelf.collection];
            }
            
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

#pragma mark -
-(void)createBgView
{
    UIImageView * blurBg = [MyControl createImageViewWithFrame:[UIScreen mainScreen].bounds ImageName:@"blurBg.jpg"];
    [self.view addSubview:blurBg];
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
    //title
    UILabel * titleLabel = [MyControl createLabelWithFrame:CGRectMake((self.view.frame.size.width-100)/2.0-50, 32, 200, 20) Font:17 Text:self.starName];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    
    UIImageView * shareImageView = [MyControl createImageViewWithFrame:CGRectMake(WIDTH-25-15, 64-27-7, 25, 25) ImageName:@"star_share.png"];
    [navView addSubview:shareImageView];
    
    CGRect rect = shareImageView.frame;
    UIButton * share = [MyControl createButtonWithFrame:CGRectMake(rect.origin.x-10, rect.origin.y-5, rect.size.width+20, rect.size.height+10) ImageName:@"" Target:self Action:@selector(shareClick) Title:nil];
    share.showsTouchWhenHighlighted = YES;
    [navView addSubview:share];
    
}

-(void)shareClick
{
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
-(void)backBtnClick
{
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
-(void)createBottom
{
    //180  153
//    CGFloat h = size.width*0.8*150/172.0;
    
    //白色透明底 40%
    CGFloat alphaHeight = 50.0+13;
    UIView *alphaView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT-30-alphaHeight, WIDTH, alphaHeight)];
    alphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [self.view addSubview:alphaView];
    
    //已获得
    self.voteNumLabel = [MyControl createLabelWithFrame:CGRectMake(20, alphaView.frame.origin.y, alphaView.frame.size.width-20, alphaHeight) Font:15 Text:nil];
    self.voteNumLabel.textColor = [ControllerManager colorWithHexString:@"663333"];
    [self.view addSubview:self.voteNumLabel];
    
    self.heartBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-90-19, HEIGHT-76-20-13, 90, 76) ImageName:@"bt_heart.png" Target:self Action:@selector(heartBtnClick) Title:nil];
    [self.heartBtn addTarget:self action:@selector(heartTouchDown) forControlEvents:UIControlEventTouchDown];
    [self.heartBtn addTarget:self action:@selector(heartUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.heartBtn];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    
    
    [self createCollectionWithHeight:self.heartBtn.frame.origin.y-64];
}
-(void)createAddVoteView
{
    UILabel *label = [MyControl createLabelWithFrame:CGRectMake(50, self.voteNumLabel.frame.origin.y, 30, 15) Font:17 Text:@"+ 1"];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [ControllerManager colorWithHexString:@"663333"];
    [self.view addSubview:label];
    
    NSInteger index = self.collection.contentOffset.x/WIDTH;
    NewestModel *model = self.newestArray[index];
    
    //动画
    __block GoRecommendViewController *blockSelf = self;
    [UIView animateWithDuration:1.2 animations:^{
        label.frame = CGRectMake(50, self.voteNumLabel.frame.origin.y-30, 30, 20);
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        //更新票数
        NSString *voteCount = [NSString stringWithFormat:@"%d", [model.stars intValue]+1];
        model.stars = voteCount;
        [blockSelf updateVoteNum];
    }];
}

#pragma mark -
-(void)heartTouchDown
{
    [self.timer invalidate];
    self.timer = nil;
    
    __block GoRecommendViewController *blockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = blockSelf.heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        blockSelf.heartBtn.frame = rect;
    }];
}
-(void)heartUpOutside
{
    __block GoRecommendViewController *blockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        blockSelf.heartBtn.frame = CGRectMake(WIDTH-90-19, HEIGHT-76-20-13, 90, 76);
    } completion:^(BOOL finished) {
        blockSelf.timer = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
}
-(void)heartAnimation
{
    __block GoRecommendViewController *blockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = blockSelf.heartBtn.frame;
        rect.origin.x -= 7;
        rect.origin.y -= 7;
        rect.size.width += 14;
        rect.size.height += 14;
        blockSelf.heartBtn.frame = rect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            blockSelf.heartBtn.frame = CGRectMake(WIDTH-90-19, HEIGHT-76-20-13, 90, 76);
        }];
    }];
}

-(void)heartBtnClick
{
    //记录sid，判断是否是同一个，如果是投票次数累计；不是则从新赋值为三
    if ([_oldSidStr isEqualToString:[ControllerManager getSID]]) {
        // 推荐次数
        count = [self.voteLeft intValue];
    } else {
        count = 3;
    }
    
    
    ShouldShowRegist;
    
    NSInteger index = self.collection.contentOffset.x/WIDTH;
    NewestModel *model = self.newestArray[index];
    
    __block GoRecommendViewController *blockSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        blockSelf.heartBtn.frame = CGRectMake(WIDTH-90-19, HEIGHT-76-20-13, 90, 76);
    } completion:^(BOOL finished) {
        blockSelf.timer = [NSTimer scheduledTimerWithTimeInterval:2.4 target:self selector:@selector(heartAnimation) userInfo:nil repeats:YES];
    }];
    
    if (count == 0) {
        //先判断金币够不够
        if([[USER objectForKey:@"gold"] intValue]<[self.voteCost intValue]){
            //金币不足
            //5.8 去充值
            Alert_2ButtonView2 * view2 = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            view2.type = 2;
            view2.rewardNum = self.voteCost;
            // 6.3
//            [ControllerManager addAlertWith:self Cost:[self.voteCost intValue] SubType:3];
            [view2 makeUI];
            view2.jumpCharge = ^(){
                Alert_oneBtnView * oneView = [[Alert_oneBtnView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                oneView.type = 4;
                [oneView makeUI];
                oneView.jumpTB = ^(){
                    ChargeViewController * charge = [[ChargeViewController alloc] init];
                    [self presentViewController:charge animated:YES completion:nil];
//                    [charge release];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:oneView];
//                [oneView release];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:view2];
//            [view2 release];
            return;
//            Alert_2ButtonView2 *alert = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            alert.type = 2;
//            alert.subType = 3;
//            alert.rewardNum = self.voteCost;
//            [alert makeUI];
//            [self.view addSubview:alert];
//            return;
        }
        if(![[USER objectForKey:@"notShowVoteCostAlert"] intValue]){
            
            Alert_2ButtonView2 *alert = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alert.type = 6;
            alert.voteCost = self.voteCost;
            [alert makeUI];
            [self.view addSubview:alert];
            alert.confirmClickBlock = ^(){
                NSLog(@"赠送推荐票");
                [blockSelf voteWithImgId:model.img_id Free:NO];
            };
        }else{
            //直接赠送
            [self voteWithImgId:model.img_id Free:NO];
        }
        
    }else{
        //直接赠送
        [self voteWithImgId:model.img_id Free:YES];
    }
}
#pragma mark - 推荐投票
-(void)voteWithImgId:(NSString *)imgId Free:(BOOL)isFree
{
    LOADING;
    __block GoRecommendViewController *blockSelf = self;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"img_id=%@dog&cat", imgId]];
    NSString *url = [NSString stringWithFormat:@"%@%@&sig=%@&SID=%@", VOTEAPI, imgId, sig, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            if ([[[load.dataDict objectForKey:@"data"] objectForKey:@"isSuccess"] intValue]) {
                //成功
                if(isFree){
                    blockSelf->count--;
                    [USER setObject:[NSString stringWithFormat:@"%ld", blockSelf->count] forKey:@"voteLeft"];
                }else{
                    NSString *gold = [NSString stringWithFormat:@"%d", [[USER objectForKey:@"gold"] intValue]-[blockSelf.voteCost intValue]];
                    [USER setObject:gold forKey:@"gold"];
                }
                
                [blockSelf createAddVoteView];
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}


#pragma mark -
-(void)createCollectionWithHeight:(CGFloat)height
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //itemSize和sectionInset配合可以设置cell的大小和偏移位置
    layout.itemSize = CGSizeMake(WIDTH-20, height-5-20);
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    layout.minimumInteritemSpacing = 20;
    layout.minimumLineSpacing = 20;
    /*
     以上结构为：itemSize定cell的宽高，sectionInset设置这个列表的section的上左下右的缩进，这里左右各缩进10，miniMumLineSpacing设置cell之间的最小间距，右边的10+左边的10=20像素。
     */
    
    
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+5, WIDTH, height-5-20) collectionViewLayout:layout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor clearColor];
    self.collection.pagingEnabled = YES;
    self.collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collection];
    
    [self.collection registerClass:[GoRecommendCollectionCell class] forCellWithReuseIdentifier:cellID];
}

#pragma mark -
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newestArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoRecommendCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    NewestModel *model = self.newestArray[indexPath.row];
    [cell modifyUI:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewestModel *model = self.newestArray[indexPath.row];
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.img_id = model.img_id;
    vc.isFromGoRecommend = YES;
//    vc.isFromRandom = YES;
//    vc.imageURL = [MyControl returnThumbImageURLwithName:model.url Width:[UIScreen mainScreen].bounds.size.width Height:0];
//    vc.imageCmt = @"";
    [ControllerManager addViewController:vc To:self];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateVoteNum];
    if(self.newestArray.count>1 && scrollView.contentOffset.x == (self.newestArray.count-1)*WIDTH){
        NSLog(@"加载更多~");
        [self loadMoreData];
    }
}
-(void)updateVoteNum
{
    //刷新票数
    NSInteger index = self.collection.contentOffset.x/WIDTH;
    NewestModel *model = self.newestArray[index];
    
    NSString *str = [NSString stringWithFormat:@"已得%@票", model.stars];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(2, model.stars.length)];
    self.voteNumLabel.attributedText = attStr;
}

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
    self.moreView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT, WIDTH, 120)];
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
#pragma mark -share
-(void)shareClick:(UIButton *)btn
{
    [self cancelBtnClick];
    NSInteger index = btn.tag;
    [MobClick event:@"photo_share"];
    
    NSInteger x = self.collection.contentOffset.x/WIDTH;
    NewestModel *model = self.newestArray[x];
    
    GoRecommendCollectionCell *cell = (GoRecommendCollectionCell *)[self.collection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0]];
    UIImageView *bigImageView = cell.image;
    
    if (index == 400) {
        NSLog(@"微信");
        //强制分享图片
        //        [self.imageDict objectForKey:@"cmt"]
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, model.img_id];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，快来给我投票啦~", model.name];
        NSString *str = [NSString stringWithFormat:@"这是大萌星%@在%@活动里的萌照，你们也来支持个~", model.name, self.starName];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
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
        
        NSString * str = [NSString stringWithFormat:@"这是大萌星%@在%@活动里的萌照，你们也来支持个~", model.name, self.starName];
//        [NSString stringWithFormat:@"我是%@，快来给我投票啦~", model.name]
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = str;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:bigImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
                [MyControl popAlertWithView:self.view Msg:@"分享成功"];
            }else{
                [MyControl popAlertWithView:self.view Msg:@"分享失败"];
            }
        }];
    }else if(index == 402){
        NSLog(@"微博");
        NSString * str = [NSString stringWithFormat:@"这是大萌星%@在#%@#活动里的萌照，你们也来支持个~", model.name, self.starName];
        NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, model.img_id];
        str = [NSString stringWithFormat:@"%@%@", str, last];
        
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
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSLog(@"分享成功！");
        [MyControl popAlertWithView:self.view Msg:@"分享成功"];
    }else{
        NSLog(@"失败原因：%@", response);
        
        [MyControl popAlertWithView:self.view Msg:@"分享失败"];
    }
}

@end
