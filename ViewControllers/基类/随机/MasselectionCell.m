//
//  MasselectionCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/14.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MasselectionCell.h"
#import "MassCollectionCell.h"
#import "MassHeaderView.h"
#import "MasselectionImagesModel.h"

//static NSString * cellID = @"MasselectionCell";
//static NSString * headerViewID = @"Mass_electionHeaderView";

@interface MasselectionCell() <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
//    NSInteger page;
}
@property(nonatomic,strong)UIButton *bannerBtn;
@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)MasselectionStarModel *model;
@property(nonatomic,strong)UILabel *countLabel;
@property(nonatomic,strong)UIButton *joinBtn;
@property(nonatomic,strong)UIButton *recomBtn;

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)UIView *headView;
@end

@implementation MasselectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self makeUI];
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

-(void)makeUI
{
    self.bannerBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, 175) ImageName:@"" Target:self Action:@selector(bannerClick) Title:nil];
    [self.contentView addSubview:self.bannerBtn];
    
    self.headView = [MyControl createViewWithFrame:CGRectMake(0, self.bannerBtn.frame.size.height, WIDTH, 50)];
    self.headView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.contentView addSubview:self.headView];
    
    //    128/64
    CGFloat btnW = 60.0;
    CGFloat btnH = 30.0;
    self.joinBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-10-btnW, (self.headView.frame.size.height-btnH)/2.0, btnW, btnH) ImageName:@"bt_participate.png" Target:self Action:@selector(joinClick) Title:nil];
    [self.headView addSubview:self.joinBtn];
    
    self.recomBtn = [MyControl createButtonWithFrame:CGRectMake(WIDTH-10*2-btnW*2, (self.headView.frame.size.height-btnH)/2.0, btnW, btnH) ImageName:@"bt_recommend.png" Target:self Action:@selector(recomClick) Title:nil];
    [self.headView addSubview:self.recomBtn];
    
    self.countLabel = [MyControl createLabelWithFrame:CGRectMake(10, 0, self.recomBtn.frame.origin.x-10, self.headView.frame.size.height) Font:13 Text:nil];
    self.countLabel.textColor = [UIColor blackColor];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"您今天还剩3个推荐名额"];
    [attStr setAttributes:@{NSForegroundColorAttributeName:ORANGE, NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(5, 1)];
    self.countLabel.attributedText = attStr;
    [self.headView addSubview:self.countLabel];

    [self createCollection];
}
-(void)bannerClick
{
    self.bannerBlock();
}
-(void)joinClick
{
    self.joinBlock();
}
-(void)recomClick
{
    self.GoRecomBlock();

}
#pragma mark -
-(void)loadData
{
    NSString *sig = [MyMD5 md5:[NSString stringWithFormat:@"page=0&star_id=%@dog&cat", self.model.star_id]];
    //http://release4pet.imengstar.com/index.php?r=star/popularApi&sig=fe9af31120938d3e48e2af8107036779&page=0&star_id=3
    //http://release4pet.imengstar.com/index.php?r=star/popularApi&page=0&star_id=3&sig=fe9af31120938d3e48e2af8107036779&SID=40gj91v6oo7vcf127o7ri6g0n1
    //http://release4pet.imengstar.com/index.php?r=star/popularApi&page=1&star_id=3&sig=68a5c4ca86ce3bd22e99fe658559be7e&SID=40gj91v6oo7vcf127o7ri6g0n1
    NSString *url = [NSString stringWithFormat:@"%@%d&star_id=%@&sig=%@&SID=%@", MASSPOPULARAPI, 0, self.model.star_id, sig, [ControllerManager getSID]];
    NSLog(@"loadData:%@",url);

    __block MasselectionCell *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [blockSelf.collection headerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            NSLog(@"loadDataarray:%@",[load.dataDict objectForKey:@"data"]);

            if([array isKindOfClass:[NSArray class]] && array.count){
                [blockSelf.imageArray removeAllObjects];
                for (NSDictionary *imageDict in array) {
                    MasselectionImagesModel *imageModel = [[MasselectionImagesModel alloc] init];
                    [imageModel setValuesForKeysWithDictionary:imageDict];
                    [blockSelf.imageArray addObject:imageModel];
                }
                blockSelf.model.imagesArray = [NSArray arrayWithArray:blockSelf.imageArray];
                blockSelf.model.page = 1;
                [blockSelf.collection reloadData];
            }
        }else{
            LOADFAILED;
        }
    }];
}
-(void)loadMoreData
{
//    [self loadData];
    NSString *sig = nil;
//    if (self.model.page == 0) {
//        sig = [MyMD5 md5:[NSString stringWithFormat:@"page=0&star_id=%@dog&cat", self.model.star_id]];
//    } else {
    sig = [MyMD5 md5:[NSString stringWithFormat:@"page=%ld&star_id=%@dog&cat", self.model.page, self.model.star_id]];
//    }
    NSString *url = [NSString stringWithFormat:@"%@%ld&star_id=%@&sig=%@&SID=%@", MASSPOPULARAPI, self.model.page, self.model.star_id, sig, [ControllerManager getSID]];
    NSLog(@"loadMoreData:%@",url);
    __block MasselectionCell *blockSelf = self;
    httpDownloadBlock *request = [[httpDownloadBlock alloc] initWithUrlStr:url Block:^(BOOL isFinish, httpDownloadBlock *load) {
        [blockSelf.collection footerEndRefreshing];
        if (isFinish) {
            NSArray *array = [load.dataDict objectForKey:@"data"];
            NSLog(@"arrayloadMoreData%@",[load.dataDict objectForKey:@"data"]);
            if([array isKindOfClass:[NSArray class]] && array.count){
//                [blockSelf.imageArray removeAllObjects];
                blockSelf.imageArray = [NSMutableArray arrayWithArray:blockSelf.model.imagesArray];
                for (NSDictionary *imageDict in array) {
                    MasselectionImagesModel *imageModel = [[MasselectionImagesModel alloc] init];
                    [imageModel setValuesForKeysWithDictionary:imageDict];
                    [blockSelf.imageArray addObject:imageModel];
                }
                
                blockSelf.model.imagesArray = [NSArray arrayWithArray:blockSelf.imageArray];
                blockSelf.model.page++;
                [blockSelf.collection reloadData];
            }
        }else{
            LOADFAILED;
        }
    }];
}
#pragma mark -
-(void)createCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = (WIDTH-10-10-5-5)/3.0;
    //    CGFloat w = WIDTH/3.0;
    layout.itemSize = CGSizeMake(w, w);
    //    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    //这里的sectionInset设置的是整段的边框缩进
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 22, 10);
    //【注意】这里需要先设置header的高度，否则默认为0显示不出
    layout.headerReferenceSize = CGSizeMake(WIDTH, 110);
    
    CGFloat oriY = 175+50;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, oriY, WIDTH, HEIGHT-oriY-25) collectionViewLayout:layout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collection];
    [self.collection addHeaderWithTarget:self action:@selector(loadData)];
    [self.collection addFooterWithTarget:self action:@selector(loadMoreData)];
    
    
    [self.collection registerClass:[MassCollectionCell class] forCellWithReuseIdentifier:@"MassCollectionCell"];
    [self.collection registerClass:[MassHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MassHeaderView"];
}
#pragma mark -

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.imagesArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MassCollectionCell" forIndexPath:indexPath];
    MasselectionImagesModel *model = self.model.imagesArray[indexPath.row];
    [cell modifyUI:model];
    return cell;
}
//#warning 这里一定要添加UICollectionViewDelegateFlowLayout代理才可以
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if(kind == UICollectionElementKindSectionHeader){
        MassHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MassHeaderView" forIndexPath:indexPath];
        header.end_time = self.model.end_time;
        [header modifyUI:self.model.animalsArray];
        
        
        __weak MasselectionCell *weakSelf = self;
        header.headClickBlock = ^(NSInteger i){
            //点击了第i个头像
//            NSLog(@"%d", i);
            weakSelf.headerBlock(i);
        };
        
        header.checkAllBlock = ^(){
            weakSelf.checkAllAnimalsBlock();
        };
        return header;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.row:%ld", indexPath.row);
    self.imageClickBlock(indexPath.row);
}


#pragma mark -
-(void)modifyUI:(MasselectionStarModel *)model
{
    self.model = model;
    if (model.page == 0) {
        //当page为0时，将偏移置为0.
        self.collection.contentOffset = CGPointMake(0, 0);
    }
    
    if([model.end_time intValue] <= [[NSDate date] timeIntervalSince1970]){
        //过期
        [MyControl setWidth:WIDTH WithView:self.countLabel];
        self.countLabel.text = @"活动结束啦~看看下边的热门照片吧~";
        self.recomBtn.hidden = YES;
        self.joinBtn.hidden = YES;
    }else{
        [MyControl setWidth:WIDTH-10*2-64*2-10 WithView:self.countLabel];
        
        NSString *str = [NSString stringWithFormat:@"您今天还剩%@个推荐名额", model.votes];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr setAttributes:@{NSForegroundColorAttributeName:ORANGE, NSFontAttributeName:[UIFont systemFontOfSize:25]} range:NSMakeRange(5, 1)];
        self.countLabel.attributedText = attStr;
        
        self.recomBtn.hidden = NO;
        self.joinBtn.hidden = NO;
    }
    
    __block MasselectionCell *blockSelf = self;
    [self.bannerBtn setImageWithURL:[NSURL URLWithString:model.banner] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            //更新页面高度
            CGFloat targetW = WIDTH;
            CGFloat targetH = targetW*image.size.height/image.size.width;
            blockSelf.bannerBtn.frame = CGRectMake(0, 0, targetW, targetH);
            [MyControl setOriginY:targetH WithView:blockSelf.headView];
            CGFloat oriY = targetH+blockSelf.headView.frame.size.height;
            blockSelf.collection.frame = CGRectMake(0, oriY, WIDTH, HEIGHT-oriY-25);
        }
    }];
    
    
    [self.collection reloadData];
}
@end
