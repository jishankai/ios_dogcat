//
//  PetVotesViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/15.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "PetVotesViewController.h"
#import "PetVotesModel.h"
#import "PetVotesRankModel.h"
#import "PetMainViewController.h"
#import "UserCardViewController.h"
#import "HyperlinksButton.h"
#import "GoRecommendViewController.h"
#import "NewestModel.h"

@interface PetVotesViewController () <UMSocialUIDelegate>
{
    BOOL isMoreCreated;
    //是否过期
    BOOL isEnd;
}
@property(nonatomic,strong)UIView *totalView;
@property(nonatomic,strong)UIView *whiteBgView;
@property(nonatomic,strong)UIButton *headBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexImageView;
@property(nonatomic,strong)UIView *heartBgView;
@property(nonatomic,strong)UILabel *totalVotesLabel;
@property(nonatomic,strong)UILabel *myVotesLabel;
@property(nonatomic,strong)UIView *brownBgView;
@property(nonatomic,strong)UIButton *shareBtn;

@property(nonatomic,strong)UILabel *noVoteLabel;
@property(nonatomic,strong)PetVotesModel *petVotesModel;

@property(nonatomic,strong)UIButton *menuBgBtn;
@property(nonatomic,strong)UIView *moreView;
@property(nonatomic,strong)HyperlinksButton *linkBtn;
@end

@implementation PetVotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断是不是过期
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime>=[self.end_time intValue]) {
        //过期
        isEnd = YES;
    }
    
    [self createUI];
//    [self createNoVote];
//    [self createList];
    [self loadData];
}
-(void)loadData
{
    LOADING;
    __block PetVotesViewController *blockSelf = self;
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"aid=%@&star_id=%@dog&cat", self.aid, self.star_id]];
    NSString *url = [NSString stringWithFormat:@"%@%@&star_id=%@&sig=%@&SID=%@", VOTECONTRIAPI, self.aid, self.star_id, sig, [ControllerManager getSID]];
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            NSDictionary *dataDict = [load.dataDict objectForKey:@"data"];
            if ([dataDict isKindOfClass:[NSDictionary class]]) {
                blockSelf.petVotesModel = [[PetVotesModel alloc] init];
                [blockSelf.petVotesModel setValuesForKeysWithDictionary:dataDict];
                blockSelf.petVotesModel.infoDict = [dataDict objectForKey:@"info"];
                NSArray *array = [dataDict objectForKey:@"rank"];
                if (array.count) {
                    //解析rank数组
                    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
                    for (NSDictionary *dict in array) {
                        NSString *usrId = [[dict allKeys] objectAtIndex:0];
                        NSString *tx = [[dict objectForKey:usrId] objectForKey:@"tx"];
                        NSNumber *votes = [[dict objectForKey:usrId] objectForKey:@"votes"];
                        PetVotesRankModel *model = [[PetVotesRankModel alloc] init];
                        model.usr_id = usrId;
                        model.tx = tx;
                        model.votes = votes;
                        [tempArray addObject:model];
                    }
                    blockSelf.petVotesModel.rankArray = [NSArray arrayWithArray:tempArray];
                }
                
                [blockSelf modifyUI];
                
            }
            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

-(void)modifyUI
{
    if (self.petVotesModel.rankArray.count>0) {
        [self createList];
    }else{
        [self createNoVote];
    }
    
    [MyControl setImageForBtn:self.headBtn Tx:self.tx isPet:YES isRound:YES];
    
    self.totalVotesLabel.text = [NSString stringWithFormat:@"%@", self.petVotesModel.total_votes];
    CGSize size = [MyControl returnSizeAboutString:self.totalVotesLabel.text FontSize:25 DefaultSize:CGSizeMake(self.totalView.frame.size.width, self.totalVotesLabel.frame.size.height)];
    //60+size.width
    CGFloat width = 60+size.width;
    [MyControl setOriginX:(self.totalView.frame.size.width-width)/2.0 WithView:self.heartBgView];
    [MyControl setWidth:width WithView:self.heartBgView];
    [MyControl setWidth:size.width WithView:self.totalVotesLabel];
    
    
    self.nameLabel.text = self.name;
    if ([[self.petVotesModel.infoDict objectForKey:@"gender"] intValue] == 1) {
        self.sexImageView.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"woman.png"];
    }
    CGSize size2 = [MyControl returnSizeAboutString:self.nameLabel.text FontSize:17 DefaultSize:CGSizeMake(self.totalView.frame.size.width, self.nameLabel.frame.size.height)];
    [MyControl setOriginX:(self.totalView.frame.size.width-size2.width)/2.0+size2.width+5 WithView:self.sexImageView];
    
    self.myVotesLabel.text = [NSString stringWithFormat:@"（您贡献了 %@票）", self.petVotesModel.my_votes];

    if (!isEnd) {
        //创建linkBtn
        CGSize voteLabelSize = [self.myVotesLabel.text boundingRectWithSize:CGSizeMake(self.myVotesLabel.frame.size.width, self.myVotesLabel.frame.size.height) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        CGFloat oriX = (self.totalView.frame.size.width-voteLabelSize.width)/2.0;
        self.linkBtn = [[HyperlinksButton alloc] initWithFrame:CGRectMake(oriX+voteLabelSize.width-5, self.myVotesLabel.frame.origin.y-5, 50, self.myVotesLabel.frame.size.height+10)];
        [self.linkBtn addTarget:self action:@selector(linkBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.linkBtn setTitle:@"去投票" forState:UIControlStateNormal];
        [self.linkBtn setColor:[UIColor colorWithRed:115/255.0 green:151/255.0 blue:187/255.0 alpha:1]];
        [self.linkBtn setTitleColor:[UIColor colorWithRed:115/255.0 green:151/255.0 blue:187/255.0 alpha:1] forState:UIControlStateNormal];
        self.linkBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        //    115  151  187
        [self.whiteBgView addSubview:self.linkBtn];
    }
}

-(void)linkBtnClick
{
    //跳转推荐列表
    NSDictionary *info = self.petVotesModel.infoDict;
    self.voteBlock([info objectForKey:@"img_id"], self.name, [info objectForKey:@"url"], [info objectForKey:@"stars"]);
    [self closeClick];
}
-(void)createUI
{
    //半透明按钮
    UIButton * alphaBtn = [MyControl createButtonWithFrame:[UIScreen mainScreen].bounds ImageName:@"" Target:self Action:@selector(closeClick) Title:nil];
    alphaBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:alphaBtn];
    
    //totalView 高出白底半个头像的高度
    self.totalView = [MyControl createViewWithFrame:CGRectMake(20, (HEIGHT-315)/2.0, WIDTH-40, 315)];
    [self.view addSubview:self.totalView];
    
    //圆角白底
    CGFloat headW = self.totalView.frame.size.width/3.5;
    //头像高度的一半
    CGFloat h = headW/2.0;
    self.whiteBgView = [MyControl createViewWithFrame:CGRectMake(0, h, self.totalView.frame.size.width, self.totalView.frame.size.height-h)];
    self.whiteBgView.backgroundColor = [UIColor whiteColor];
    self.whiteBgView.layer.cornerRadius = 7;
    self.whiteBgView.layer.masksToBounds = YES;
    [self.totalView addSubview:self.whiteBgView];
    
    self.headBtn = [MyControl createButtonWithFrame:CGRectMake((self.whiteBgView.frame.size.width-headW)/2.0, 0, headW, headW) ImageName:@"defaultPetHead.png" Target:self Action:@selector(headBtnClick) Title:nil];
    [self.totalView addSubview:self.headBtn];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(self.whiteBgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeClick) Title:nil];
    [self.whiteBgView addSubview:closeBtn];
    
    self.nameLabel = [MyControl createLabelWithFrame:CGRectMake(0, h+10, self.whiteBgView.frame.size.width, 20) Font:17 Text:nil];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [ControllerManager colorWithHexString:@"FF6666"];
    [self.whiteBgView addSubview:self.nameLabel];
    
    self.sexImageView = [MyControl createImageViewWithFrame:CGRectMake(self.whiteBgView.frame.size.width-60, self.nameLabel.frame.origin.y, 20, 20) ImageName:@""];
    [self.whiteBgView addSubview:self.sexImageView];
    
    
    self.heartBgView = [MyControl createViewWithFrame:CGRectMake(headW, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+10, 50+70, 40)];
    [self.whiteBgView addSubview:self.heartBgView];
    
    UIImageView *heart = [MyControl createImageViewWithFrame:CGRectMake(0, 0, 45, 39) ImageName:@"icon_heart2.png"];
    [self.heartBgView addSubview:heart];
    
    self.totalVotesLabel = [MyControl createLabelWithFrame:CGRectMake(60, 0, 60, 40) Font:25 Text:@""];
    self.totalVotesLabel.textColor = [ControllerManager colorWithHexString:@"FF6666"];
    [self.heartBgView addSubview:self.totalVotesLabel];
    
    self.myVotesLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, self.totalView.frame.size.width, 20) Font:13 Text:@"（您贡献了 0票）"];
    [MyControl setVerticalSpace:0 FromView:self.myVotesLabel ToView:self.heartBgView];
    self.myVotesLabel.textAlignment = NSTextAlignmentCenter;
    self.myVotesLabel.textColor = [ControllerManager colorWithHexString:@"CC9999"];
    [self.whiteBgView addSubview:self.myVotesLabel];
    
    self.brownBgView = [MyControl createViewWithFrame:CGRectMake(0, 0, self.totalView.frame.size.width, 50)];
    [MyControl setVerticalSpace:5 FromView:self.brownBgView ToView:self.myVotesLabel];
    self.brownBgView.backgroundColor = [UIColor colorWithRed:233/255.0 green:230/255.0 blue:220/255.0 alpha:1];
    [self.whiteBgView addSubview:self.brownBgView];
    
    //367 84
    CGFloat shareW = 183;
    CGFloat shareH = 42;
    self.shareBtn = [MyControl createButtonWithFrame:CGRectMake((self.totalView.frame.size.width-shareW)/2.0, 0, shareW, shareH) ImageName:@"star_askvotes.png" Target:self Action:@selector(shareBtnClick) Title:nil];
    [MyControl setVerticalSpace:15 FromView:self.shareBtn ToView:self.brownBgView];
    [self.whiteBgView addSubview:self.shareBtn];
}
-(void)createNoVote
{
    self.noVoteLabel = [MyControl createLabelWithFrame:CGRectMake(0, 0, self.totalView.frame.size.width, 50) Font:17 Text:@"还没人投票。。。"];
    self.noVoteLabel.textAlignment = NSTextAlignmentCenter;
    self.noVoteLabel.textColor = [ControllerManager colorWithHexString:@"CC9999"];
    [self.brownBgView addSubview:self.noVoteLabel];
    
    [self setOneLine];
}
-(void)createList
{
    int count = (int)self.petVotesModel.rankArray.count;
    NSArray *array = self.petVotesModel.rankArray;
    //36 60
    for (int i=0; i<count; i++) {
        PetVotesRankModel *model = array[i];
        
        UIImageView *rankImage = [MyControl createImageViewWithFrame:CGRectMake(40, 50*i+10, 18, 30) ImageName:[NSString stringWithFormat:@"star_%d.png", i+1]];
        [self.brownBgView addSubview:rankImage];
        
        UIButton *userHeadBtn = [MyControl createButtonWithFrame:CGRectMake(rankImage.frame.origin.x+50, rankImage.frame.origin.y, 30, 30) ImageName:@"defaultUserHead.png" Target:self Action:@selector(userHeadClick:) Title:nil];
        userHeadBtn.tag = 500+i;
        [self.brownBgView addSubview:userHeadBtn];
        [MyControl setImageForBtn:userHeadBtn Tx:model.tx isPet:NO isRound:YES];
        
        UILabel *contriLabel = [MyControl createLabelWithFrame:CGRectMake(userHeadBtn.frame.origin.x+60, userHeadBtn.frame.origin.y, 40, userHeadBtn.frame.size.height) Font:14 Text:@"贡献"];
        contriLabel.textColor = [ControllerManager colorWithHexString:@"CC9999"];
        [self.brownBgView addSubview:contriLabel];
        
        UILabel *contriNumLabel = [MyControl createLabelWithFrame:CGRectMake(contriLabel.frame.origin.x+60, contriLabel.frame.origin.y, 60, contriLabel.frame.size.height) Font:15 Text:nil];
        contriNumLabel.textColor = [ControllerManager colorWithHexString:@"FF6666"];
        [self.brownBgView addSubview:contriNumLabel];
        contriNumLabel.text = [NSString stringWithFormat:@"%@", model.votes];
    }
    
    //调整brown和shareBtn,white,total高度
    if(count>1){
        [MyControl setHeight:50*count WithView:self.brownBgView];
        [MyControl setVerticalSpace:15 FromView:self.shareBtn ToView:self.brownBgView];
        [MyControl setHeight:self.shareBtn.frame.origin.y+self.shareBtn.frame.size.height+20 WithView:self.whiteBgView];
        CGFloat halfHeadW = self.totalView.frame.size.width/3.5/2.0;
        [MyControl setHeight:self.whiteBgView.frame.size.height+halfHeadW WithView:self.totalView];
        [MyControl setOriginY:(HEIGHT-self.totalView.frame.size.height)/2.0 WithView:self.totalView];
    }else{
        [self setOneLine];
    }
}
-(void)setOneLine
{
    [MyControl setHeight:self.shareBtn.frame.origin.y+self.shareBtn.frame.size.height+20 WithView:self.whiteBgView];
    CGFloat halfHeadW = self.totalView.frame.size.width/3.5/2.0;
    [MyControl setHeight:self.whiteBgView.frame.size.height+halfHeadW WithView:self.totalView];
    [MyControl setOriginY:(HEIGHT-self.totalView.frame.size.height)/2.0 WithView:self.totalView];
}


#pragma mark - 点击事件
-(void)userHeadClick:(UIButton *)sender
{
    int a = (int)sender.tag-500;
    NSString *usrId = [self.petVotesModel.rankArray[a] usr_id];
    UserCardViewController *card = [[UserCardViewController alloc] init];
    card.usr_id = usrId;
    [ControllerManager addViewController:card To:self];
    __block UserCardViewController *blockCard = card;
    card.close = ^(){
        [ControllerManager deleTabBarViewController:blockCard];
    };
}
-(void)shareBtnClick
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
-(void)headBtnClick
{
    //进宠物详情
    PetMainViewController *pet = [[PetMainViewController alloc] init];
    pet.aid = self.aid;
    [self presentViewController:pet animated:YES completion:nil];
}
-(void)closeClick
{
    [ControllerManager deleTabBarViewController:self];
}

#pragma mark -
#pragma mark -
-(void)createMore
{
//    FirstTabBarViewController *tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    
    self.menuBgBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"" Target:self Action:@selector(cancelBtnClick) Title:nil];
    self.menuBgBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menuBgBtn];
    self.menuBgBtn.alpha = 0;
    self.menuBgBtn.hidden = YES;
    
    // 318*234
    self.moreView = [MyControl createViewWithFrame:CGRectMake(0, HEIGHT, WIDTH, 120)];
    self.moreView.backgroundColor = [ControllerManager colorWithHexString:@"efefef"];
    [self.view addSubview:self.moreView];
    
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
        button.tag = 4000+i;
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
    int index = (int)btn.tag;
//    [MobClick event:@"photo_share"];
    NSDictionary *info = self.petVotesModel.infoDict;

//
    //下载图片
    __block PetVotesViewController *blockSelf = self;
//    UIImageView *imageView = [MyControl createImageViewWithFrame:CGRectZero ImageName:@""];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMAGEURL, [info objectForKey:@"url"]]];
    NSURL *url = [MyControl returnThumbImageURLwithName:[info objectForKey:@"url"] Width:WIDTH Height:0];
    LOADING;
    SDWebImageDownloader *download = [SDWebImageDownloader sharedDownloader];
    [download downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        ENDLOADING;
        
        NSLog(@"download finish");
        [blockSelf cancelBtnClick];
        
        if (image) {
            if (index == 4000) {
                NSLog(@"微信");
                //强制分享图片
                //        [self.imageDict objectForKey:@"cmt"]
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
                
                
                
                NSString *str = nil;
                if (isEnd) {
                    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"活动结束，热度不减~来看看%@的参赛照片", blockSelf.name];
                    str = [NSString stringWithFormat:@"大萌星%@在%@活动里一共得到%@票哟，厉害吧~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }else{
                    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，快来给我投票啦~", blockSelf.name];
                    str = [NSString stringWithFormat:@"大萌星%@在%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }
                
                
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:image location:nil urlResource:nil presentedController:blockSelf completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享成功"];
                    }else{
                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享失败"];
                        
                    }
                }];
            }else if(index == 4001){
                NSLog(@"朋友圈");
                //强制分享图片
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
                
                
                NSString * str = nil;
                if (isEnd) {
                    str = [NSString stringWithFormat:@"大萌星%@在%@活动里一共得到%@票哟，厉害吧~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }else{
                    str = [NSString stringWithFormat:@"大萌星%@在%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }
                
                [UMSocialData defaultData].extConfig.wechatTimelineData.title = str;
                
                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:image location:nil urlResource:nil presentedController:blockSelf completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        NSLog(@"分享成功！");
                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享成功"];
                    }else{
                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享失败"];
                    }
                }];
            }else if(index == 4002){
                NSLog(@"微博");
                NSString * str = nil;
                if (isEnd) {
                    //5.7
                    str = [NSString stringWithFormat:@"大萌星%@在#%@#活动里一共得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }else{
                    str = [NSString stringWithFormat:@"大萌星%@在#%@#活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
                }
                
                NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
                str = [NSString stringWithFormat:@"%@%@", str, last];
                
                BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
                NSLog(@"%d", oauth);
                if (oauth) {
                    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                        [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:blockSelf];
                        //设置分享内容和回调对象
                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(blockSelf,[UMSocialControllerService defaultControllerService],YES);
                    }];
                }else{
                    [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:blockSelf];
                    //设置分享内容和回调对象
                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(blockSelf,[UMSocialControllerService defaultControllerService],YES);
                }
            }
        }else{
            NSLog(@"error:%@",error);
        }
    }];
    
//    return;
//    [imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
////        ENDLOADING;
//        [blockSelf cancelBtnClick];
//        if (image) {
//            if (index == 4000) {
//                NSLog(@"微信");
//                //强制分享图片
//                //        [self.imageDict objectForKey:@"cmt"]
//                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//                [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
//                
//                
//                
//                NSString *str = nil;
//                if (isEnd) {
//                    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"活动结束，热度不减~来看看%@的参赛照片", blockSelf.name];
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里一共得到%@票哟，厉害吧~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }else{
//                    [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"我是%@，快来给我投票啦~", blockSelf.name];
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }
//                
//                
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:str image:image location:nil urlResource:nil presentedController:blockSelf completion:^(UMSocialResponseEntity *response){
//                    if (response.responseCode == UMSResponseCodeSuccess) {
//                        NSLog(@"分享成功！");
//                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享成功"];
//                    }else{
//                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享失败"];
//                        
//                    }
//                }];
//            }else if(index == 4001){
//                NSLog(@"朋友圈");
//                //强制分享图片
//                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
//                [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
//                
//                
//                NSString * str = nil;
//                if (isEnd) {
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里一共得到%@票哟，厉害吧~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }else{
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }
//                
//                [UMSocialData defaultData].extConfig.wechatTimelineData.title = str;
//                
//                [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:str image:image location:nil urlResource:nil presentedController:blockSelf completion:^(UMSocialResponseEntity *response){
//                    if (response.responseCode == UMSResponseCodeSuccess) {
//                        NSLog(@"分享成功！");
//                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享成功"];
//                    }else{
//                        [MyControl popAlertWithView:blockSelf.view Msg:@"分享失败"];
//                    }
//                }];
//            }else if(index == 4002){
//                NSLog(@"微博");
//                NSString * str = nil;
//                if (isEnd) {
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }else{
//                    str = [NSString stringWithFormat:@"%@在宠物星球%@活动里已经得到%@票喽，你们也来支持个~", blockSelf.name, blockSelf.starName, blockSelf.petVotesModel.total_votes];
//                }
//                
//                NSString * last = [NSString stringWithFormat:@"%@%@ #我是大萌星#", WEBBEGFOODAPI, [info objectForKey:@"img_id"]];
//                str = [NSString stringWithFormat:@"%@%@", str, last];
//                
//                BOOL oauth = [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
//                NSLog(@"%d", oauth);
//                if (oauth) {
//                    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
//                        [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:blockSelf];
//                        //设置分享内容和回调对象
//                        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(blockSelf,[UMSocialControllerService defaultControllerService],YES);
//                    }];
//                }else{
//                    [[UMSocialControllerService defaultControllerService] setShareText:str shareImage:image socialUIDelegate:blockSelf];
//                    //设置分享内容和回调对象
//                    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(blockSelf,[UMSocialControllerService defaultControllerService],YES);
//                }
//            }
//        }else{
//            NSLog(@"error:%@",error);
//        }
//    }];
    
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
