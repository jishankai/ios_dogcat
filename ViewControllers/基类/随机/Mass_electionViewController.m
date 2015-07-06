//
//  Mass_electionViewController.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "Mass_electionViewController.h"

#import "GoRecommendViewController.h"
#import "MasselectionStarModel.h"
#import "MasselectionHotStarModel.h"
#import "MasselectionImagesModel.h"
#import "MasselectionCell.h"
#import "VoteRankViewController.h"
#import "PetVotesViewController.h"
#import "PublishViewController.h"
#import "Alert_BegFoodViewController.h"
#import "WalkAndTeaseViewController.h"
#import "FrontImageDetailViewController.h"

static NSString * cellID = @"MasselectionCell";
//static NSString * headerViewID = @"Mass_electionHeaderView";
@interface Mass_electionViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    //每一票多少金币
    NSInteger voteCost;
    
    BOOL isConf;
    UIImageView *guide;
}
@property(nonatomic,strong)UICollectionView *collection;
//@property(nonatomic,strong)PicturePlayView *playView;
@property(nonatomic,strong)NSMutableArray *starsArray;
@property(nonatomic,strong)NSMutableArray *hotPetsArray;
@property(nonatomic,strong)NSMutableArray *imagesArray;
@property(nonatomic,strong)UIActionSheet *sheet;
@end

@implementation Mass_electionViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    if (![[USER objectForKey:@"guide_masselection"] intValue]) {
        [self createGuide];
        [USER setObject:@"1" forKey:@"guide_masselection"];
    }
}

-(void)createGuide
{
//    [UIScreen mainScreen].bounds
    guide = [MyControl createImageViewWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) ImageName:@"guide_masselection.png"];
    if(self.view.frame.size.height <= 480){
        [MyControl setHeight:568 WithView:guide];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [guide addGestureRecognizer:tap];
    
    FirstTabBarViewController * tabBar = (FirstTabBarViewController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    [tabBar.view addSubview:guide];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hotPetsArray = [NSMutableArray arrayWithCapacity:0];
    self.starsArray = [NSMutableArray arrayWithCapacity:0];
    self.imagesArray = [NSMutableArray arrayWithCapacity:0];
    
    NSLog(@"/////////////////////////////");
    
//    [self createImages];
//    [self createMenuView];
    [self createCollection];
    
}
#pragma mark -
-(void)loadData
{
//    LOADING;
    
    __block Mass_electionViewController *blockSelf = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", MASSELECTIONAPI, [ControllerManager getSID]];
    NSLog(@"url:%@", url);
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        if (isFinish) {
            if ([[load.dataDict objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                if ([[load.dataDict objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]) {
                    blockSelf->isConf = YES;
                    NSLog(@"%@",[load.dataDict objectForKey:@"confVersion"]);
                }
                
                NSDictionary *dict = [load.dataDict objectForKey:@"data"];
                
                NSLog(@"oooooooooo%@",dict);
                NSArray *starArray = [dict objectForKey:@"stars"];
                
                [self.starsArray removeAllObjects];
                for (NSDictionary *starDict in starArray) {
                    MasselectionStarModel *starModel = [[MasselectionStarModel alloc] init];
                    [starModel setValuesForKeysWithDictionary:starDict];
                    starModel.des = [starDict objectForKey:@"description"];
                    /*
                     考虑到界面复用和collection嵌套问题，特在starModel中添加一个page字段，NSInteger类型，用于记录每一个活动滑动到多少page，以免混乱。
                     page初始化为0
                     */
                    //上拉加载，应该是从下一页开始，如果初始页为零那么此处应改为1.
                    starModel.page = 1;
                    //
                    [self.hotPetsArray removeAllObjects];
                    NSArray *animalArray = [starDict objectForKey:@"animals"];
                    for (NSDictionary *animalDict in animalArray) {
                        MasselectionHotStarModel *hotModel = [[MasselectionHotStarModel alloc] init];
                        [hotModel setValuesForKeysWithDictionary:animalDict];
                        [self.hotPetsArray addObject:hotModel];
                    }
                    starModel.animalsArray = [NSArray arrayWithArray:self.hotPetsArray];
                    
                    //
                    [self.imagesArray removeAllObjects];
                    NSArray *imagesArray = [starDict objectForKey:@"images"];
                    NSLog(@"imagesArray:%@",[load.dataDict objectForKey:@"data"]);
                    for (NSDictionary *imageDict in imagesArray) {
                        MasselectionImagesModel *imageModel = [[MasselectionImagesModel alloc] init];
                        [imageModel setValuesForKeysWithDictionary:imageDict];
                        [self.imagesArray addObject:imageModel];
                    }
                    starModel.imagesArray = [NSArray arrayWithArray:self.imagesArray];
                    
                    //
                    [self.starsArray addObject:starModel];
                }
                //
                if (self.starsArray.count) {
                    MasselectionStarModel *starModel = self.starsArray[0];
                    //更新本地剩余票数及票价
                    [USER setObject:[NSString stringWithFormat:@"%@", starModel.votes] forKey:@"voteLeft"];
                    [USER setObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"vote_price"]] forKey:@"votePrice"];
                }
                //没票多少金币
                blockSelf->voteCost = [[dict objectForKey:@"vote_price"] intValue];
                
                [blockSelf.collection reloadData];
            }
//            ENDLOADING;
        }else{
            LOADFAILED;
        }
    }];
}

#pragma mark -
-(void)createCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(WIDTH, HEIGHT-25);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    
    CGFloat spe = [UIScreen mainScreen].bounds.size.width/5.0;
    CGFloat bottomHeight = spe*99/128-10;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-bottomHeight) collectionViewLayout:layout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.pagingEnabled = YES;
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collection];
    //
    [self.collection registerClass:[MasselectionCell class] forCellWithReuseIdentifier:cellID];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.starsArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MasselectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    MasselectionStarModel *model = self.starsArray[indexPath.row];
    [cell modifyUI:model];
    //缓存
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *titleString = model.name;
    [userDefaults setObject:titleString forKey:@"titleString"];
    [userDefaults synchronize];
//    NSLog(@"%@",model.name);
    
    __weak Mass_electionViewController *blockSelf = self;
    //参赛
    cell.joinBlock = ^(){
        [blockSelf joinClick:indexPath.row];
    };
    //去推荐
    cell.GoRecomBlock = ^(){
        GoRecommendViewController *recommend = [[GoRecommendViewController alloc] init];
        recommend.starId = model.star_id;
        recommend.starName = model.name;
        recommend.voteLeft = model.votes;
        recommend.voteCost = [NSString stringWithFormat:@"%ld", voteCost];
        [blockSelf.navigationController pushViewController:recommend animated:YES];
    };
    cell.checkAllAnimalsBlock = ^(){
        VoteRankViewController *vote = [[VoteRankViewController alloc] init];
        vote.starId = model.star_id;
        vote.starName = model.name;
        vote.end_time = model.end_time;
        [blockSelf.navigationController pushViewController:vote animated:YES];
    };
    cell.headerBlock = ^(NSInteger i){
        NSLog(@"点击了第%ld个活动的第%ld个头像", indexPath.row, i);
        PetVotesViewController *petVote = [[PetVotesViewController alloc] init];
        petVote.tx = [model.animalsArray[i] tx];
        petVote.aid = [model.animalsArray[i] aid];
        petVote.name = [model.animalsArray[i] name];
        petVote.star_id = model.star_id;
        petVote.starName = model.name;
        petVote.end_time = model.end_time;
        [ControllerManager addTabBarViewController:petVote];
        petVote.voteBlock = ^(NSString *img_id, NSString *name, NSString *url, NSString *stars){
            GoRecommendViewController *recommend = [[GoRecommendViewController alloc] init];
            
            recommend.starId = model.star_id;
            recommend.starName = model.name;
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
    cell.bannerBlock = ^(){
        //跳转
//        if (isConf) {
//            return;
//        }
        WalkAndTeaseViewController * vc = [[WalkAndTeaseViewController alloc] init];
        vc.isFromMass = YES;
        vc.URL = model.url;
        vc.share_title = model.title;
        vc.share_des = model.des;
        vc.icon = model.icon;
        [blockSelf presentViewController:vc animated:YES completion:nil];
    };
    cell.imageClickBlock = ^(NSInteger index){
        MasselectionImagesModel *imageModel = model.imagesArray[index];
        
        //判断是不是过期
        NSInteger nowTime = [[NSDate date] timeIntervalSince1970];
        if (nowTime>=[model.end_time intValue]) {
            //过期  照片详情
            FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
            vc.img_id = imageModel.img_id;
            vc.isFromRandom = YES;
            CGFloat width = (WIDTH-10-10-5-5)/3.0*2;
            vc.imageURL = [MyControl returnClipThumbImageURLwithName:model.url Width:width Height:width];
            vc.imageCmt = @"";
            [ControllerManager addTabBarViewController:vc];
        }else{            
            GoRecommendViewController *recommend = [[GoRecommendViewController alloc] init];
            recommend.starId = model.star_id;
            recommend.starName = model.name;
            recommend.voteLeft = model.votes;
            recommend.voteCost = [NSString stringWithFormat:@"%ld", voteCost];
            NewestModel *model = [[NewestModel alloc] init];
            model.img_id = imageModel.img_id;
            model.name = imageModel.name;
            model.url = imageModel.url;
            model.stars = imageModel.stars;
            
            recommend.insertModel = model;
            [blockSelf.navigationController pushViewController:recommend animated:YES];
        }
    };
    return cell;
}

#pragma mark -
-(void)joinClick:(NSInteger)index
{
//    MasselectionStarModel *model = self.starsArray[index];
    ShouldShowRegist;
    
    //判断有没有自己创建的宠物
    BOOL hasMine = NO;
    NSArray *array = [USER objectForKey:@"myPetsDataArray"];
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"master_id"] isEqualToString:[USER objectForKey:@"usr_id"]]) {
            hasMine = YES;
            break;
        }
    }
    if (hasMine) {
        [self cameraClick];
    }else{
        //提示没有自己的宠物
        Alert_2ButtonView2 *twoBtnView = [[Alert_2ButtonView2 alloc] initWithFrame:[UIScreen mainScreen].bounds];
        twoBtnView.type = 7;
        [twoBtnView makeUI];
        [self.view addSubview:twoBtnView];
        
        __block Mass_electionViewController *blockSelf = self;
        twoBtnView.createMyPetBlock = ^(){
            //创建宠物
            RegisterViewController * vc = [[RegisterViewController alloc] init];
            vc.isOldUser = YES;
            [blockSelf presentViewController:vc animated:YES completion:nil];
        };
    }
}

-(void)cameraClick
{
    if (self.sheet == nil) {
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        }
        else {
            
            self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        
        self.sheet.tag = 255;
        
    }
    [self.sheet showInView:self.view];
}
#pragma mark - 相机
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        //        [USER setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"buttonIndex"];
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                    
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    //                    isCamara = YES;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    //                    isCamara = NO;
                    break;
                case 2:
                    // 取消
                    return;
            }
        }
        else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                //                isCamara = NO;
            } else {
                return;
            }
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - UIImagePicker Delegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"%ld", image.imageOrientation);
    image = [MyControl fixOrientation:image];
    
    __block Mass_electionViewController * blockSelf = self;
    
    [self dismissViewControllerAnimated:NO completion:^{
        //Publish
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        PublishViewController * vc = [[PublishViewController alloc] init];
        
        vc.isFromMasselection = YES;
        
//        NSDictionary * dict = blockSelf.petsDataArray[blockSelf.currentSelectedIndex];
//        UserPetListModel * model = [[UserPetListModel alloc] init];
//        [model setValuesForKeysWithDictionary:dict];
        NSInteger index = blockSelf.collection.contentOffset.x/blockSelf.collection.frame.size.width;
        MasselectionStarModel *model = self.starsArray[index];
        
        vc.oriImage = image;
        vc.MasselctionName = model.name;
        vc.starId = model.star_id;

        //img_id star_id aid name massName UIImage*
        vc.showMassAlert = ^(NSString *img_id, NSString *star_id, NSString *aid, NSString *name, NSString *massName, UIImage*oriImage){
            __block Alert_BegFoodViewController * begFood = [[Alert_BegFoodViewController alloc] init];
            //            begFood.imgId = img_id;
            begFood.isFromMasselection = YES;
            begFood.name = name;
            begFood.massName = massName;
            begFood.oriImage = oriImage;
            begFood.img_id = img_id;
            [ControllerManager addTabBarViewController:begFood];
            
            [blockSelf dismissViewControllerAnimated:NO completion:nil];
        };
        [blockSelf presentViewController:vc animated:YES completion:nil];
    }];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
