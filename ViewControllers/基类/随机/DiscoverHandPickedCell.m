//
//  DiscoverHandPickedCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/3.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "DiscoverHandPickedCell.h"

@interface DiscoverHandPickedCell ()
@property (retain, nonatomic) IBOutlet UIButton *headBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

//@property (retain, nonatomic) IBOutlet UIImageView *bigImage;

@property (retain, nonatomic) IBOutlet UILabel *topicAndDesLabel;
@property (retain, nonatomic) UITextView *desTextView;
@property (retain, nonatomic) IBOutlet UIView *toolsView;
@property (retain, nonatomic) IBOutlet UIView *likersView;

@property (retain, nonatomic) IBOutlet UIView *commentsView;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *firstCmtLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondCmtLabel;


@property (strong,nonatomic) NSString *comments;
@property (nonatomic,strong)NSMutableArray * usridArray;
@property (nonatomic,strong)NSMutableArray * nameArray;
@property (nonatomic,strong)NSMutableArray * bodyArray;
@property (nonatomic,strong)UILabel *likersCount;
@property (nonatomic,strong)UILabel *firstCmterName;
@property (nonatomic,strong)UILabel *secondCmterName;
@property (nonatomic,strong)UIImageView *addImageView;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UIButton *bigImageBtn;
@property (nonatomic,strong)UIView *bgWhiteView;

//点击之后跳转到详情页背面的点赞列表
@property (nonatomic,strong)UIButton *likeBtn;
@property (nonatomic,strong)UIButton *firstCmtBtn;
@property (nonatomic,strong)UIButton *secondCmtBtn;
@property (nonatomic,strong)UIButton *showAllCmtBtn;

@property (nonatomic,strong)RecommendModel *model;
@end
@implementation DiscoverHandPickedCell

- (void)awakeFromNib {
    // Initialization code
    self.usridArray = [NSMutableArray arrayWithCapacity:0];
    self.nameArray = [NSMutableArray arrayWithCapacity:0];
    self.bodyArray = [NSMutableArray arrayWithCapacity:0];
    
    self.desTextView = [[UITextView alloc] initWithFrame:self.topicAndDesLabel.frame];
    self.desTextView.textColor = [UIColor darkGrayColor];
    self.desTextView.textContainerInset = UIEdgeInsetsZero;
    self.desTextView.userInteractionEnabled = NO;
//    self.desTextView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [self addSubview:self.desTextView];
    
    self.topicAndDesLabel.numberOfLines = 0;
    self.topicAndDesLabel.lineBreakMode = NSLineBreakByCharWrapping;

    self.topicAndDesLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    CGRect rect = self.bigImage.frame;
//    rect.size.height = 150;
//    self.bigImage.frame = rect;
//    self.bigImage.hidden = YES;
    if(!self.isAttention){
//        self.timeLabel.hidden = YES;
        self.timeLabel.text = @"捧TA";
    }
    self.addImageView = [MyControl createImageViewWithFrame:CGRectMake(WIDTH-60, self.timeLabel.frame.origin.y, 20, 20) ImageName:@"plus.png"];
    [self.contentView addSubview:self.addImageView];
    
    self.addBtn = [MyControl createButtonWithFrame:CGRectMake(self.addImageView.frame.origin.x, self.addImageView.frame.origin.y, WIDTH-self.addImageView.frame.origin.x, 20) ImageName:@"" Target:self Action:@selector(addBtnClick:) Title:nil];
    [self.contentView addSubview:self.addBtn];
    
    
    //创建toolsView
    NSArray *array = @[@"page_like.png", @"page_comment.png", @"icon_gift.png", @"bt_more.png"];
    NSArray *textArray = @[@"赞Ta", @"评论", @"礼物", @""];
    CGFloat spe = (WIDTH-8*2)/4.0;
    for (int i=0; i<4; i++) {
        UIImageView *image = [MyControl createImageViewWithFrame:CGRectMake(8+spe*i, 0, 25, 25) ImageName:array[i]];
        [self.toolsView addSubview:image];
        image.tag = 4800+i;
        if (i == 3) {
            image.frame = CGRectMake(WIDTH-20-25, 0, 25, 25);
        }
        
        UILabel *label = [MyControl createLabelWithFrame:CGRectMake([MyControl returnOriginAndWidthWithView:image], 0, spe-25, 25) Font:12 Text:textArray[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        [self.toolsView addSubview:label];
        label.tag = 4900+i;
        
        UIButton *btn = [MyControl createButtonWithFrame:CGRectMake(8+spe*i, 0, spe, 25) ImageName:@"" Target:self Action:@selector(toolsBtnClick:) Title:nil];
//        btn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.toolsView addSubview:btn];
        btn.tag = 5000+i;
    }
    
    for (int i=0; i<7; i++) {
        UIImageView *image = [MyControl createImageViewWithFrame:CGRectMake(40+30*i, 0, 27, 27) ImageName:@""];
        image.tag = 5100+i;
        [self.likersView addSubview:image];
    }
    
    self.likersCount = [MyControl createLabelWithFrame:CGRectMake(40+30*7+10, 5, 35, 17) Font:10 Text:@"0"];
    self.likersCount.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.likersCount.layer.cornerRadius = 8;
    self.likersCount.layer.masksToBounds = YES;
    self.likersCount.textColor = [UIColor darkGrayColor];
    self.likersCount.textAlignment = NSTextAlignmentCenter;
    [self.likersView addSubview:self.likersCount];
    
    self.firstCmterName = [MyControl createLabelWithFrame:CGRectMake(39, 29, 10, 20) Font:11 Text:nil];
    self.firstCmterName.textColor = [ControllerManager colorWithHexString:@"FF6666"];
    [self.commentsView addSubview:self.firstCmterName];
    
    self.secondCmterName = [MyControl createLabelWithFrame:CGRectMake(39, 57, 10, 20) Font:11 Text:nil];
    self.secondCmterName.textColor = [ControllerManager colorWithHexString:@"FF6666"];
    [self.commentsView addSubview:self.secondCmterName];
    
    //
    self.bigImage.userInteractionEnabled = YES;
    self.bigImageBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, self.bigImage.frame.size.width, self.bigImage.frame.size.height) ImageName:@"" Target:self Action:@selector(bigImageBtnClick) Title:nil];
    [self.bigImage addSubview:self.bigImageBtn];
    
    //赞列表按钮
    self.likeBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, WIDTH, self.likersView.frame.size.height) ImageName:@"" Target:self Action:@selector(likeBtnClick) Title:nil];
    [self.likersView addSubview:self.likeBtn];
    //评论总数
    self.showAllCmtBtn = [MyControl createButtonWithFrame:CGRectMake(0, 3.5, self.commentsView.frame.size.width, 20) ImageName:@"" Target:self Action:@selector(showAllCmtBtnClick) Title:nil];
//    self.showAllCmtBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.commentsView addSubview:self.showAllCmtBtn];
    
    //评论1，2行按钮
    self.firstCmtBtn = [MyControl createButtonWithFrame:CGRectMake(0, 29, WIDTH, 20) ImageName:@"" Target:self Action:@selector(firstCmtBtnClick) Title:nil];
    [self.commentsView addSubview:self.firstCmtBtn];
    
    self.secondCmtBtn = [MyControl createButtonWithFrame:CGRectMake(0, 57, WIDTH, 20) ImageName:@"" Target:self Action:@selector(secondCmtBtnClick) Title:nil];
    [self.commentsView addSubview:self.secondCmtBtn];
    
    //白底
    self.bgWhiteView = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH, 0)];
    self.bgWhiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView insertSubview:self.bgWhiteView atIndex:0];
}
-(void)addBtnClick:(UIButton *)sender
{
    if (!sender.selected) {
        //捧
        self.pBlock();
    }
}
-(void)likeBtnClick
{
    //跳转照片详情并翻转，显示点赞列表
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.showBackIndex = 1;
    vc.img_id = self.model.img_id;
    vc.isFromRandom = YES;
    vc.imageURL = [MyControl returnThumbImageURLwithName:self.model.url Width:[UIScreen mainScreen].bounds.size.width*2 Height:0];
    vc.imageCmt = self.model.cmt;
    [ControllerManager addTabBarViewController:vc];
}
-(void)showAllCmtBtnClick
{
    //跳转照片详情并翻转，显示评论列表
    FrontImageDetailViewController * vc = [[FrontImageDetailViewController alloc] init];
    vc.showBackIndex = 3;
    vc.img_id = self.model.img_id;
    vc.isFromRandom = YES;
    vc.imageURL = [MyControl returnThumbImageURLwithName:self.model.url Width:[UIScreen mainScreen].bounds.size.width*2 Height:0];
    vc.imageCmt = self.model.cmt;
    [ControllerManager addTabBarViewController:vc];
}
-(void)firstCmtBtnClick
{
    //回复第一个人
//    if ([self.nameArray[0] isEqualToString:[USER objectForKey:@"name"]]) {
//        return;
//    }else{
        self.replyBlock(self.usridArray[0], self.nameArray[0]);
//    }
}
-(void)secondCmtBtnClick
{
    if (self.nameArray.count<2) {
        return;
    }
    //回复第二个人
//    if ([self.nameArray[1] isEqualToString:[USER objectForKey:@"name"]]) {
//        return;
//    }else{
        self.replyBlock(self.usridArray[1], self.nameArray[1]);
//    }
}

#pragma mark -
-(void)bigImageBtnClick
{
    self.bigImageBtnBlock();
}
-(void)modifyUI:(RecommendModel *)model
{
    self.model = model;
    
    self.topicAndDesLabel.hidden = YES;
    self.desTextView.hidden = NO;
    self.likersView.hidden = NO;
    self.commentsView.hidden = NO;
    self.topicAndDesLabel.text = nil;
    self.topicAndDesLabel.attributedText = nil;
    self.desTextView.text = nil;
    self.desTextView.attributedText = nil;
    
    [self.usridArray removeAllObjects];
    [self.nameArray removeAllObjects];
    [self.bodyArray removeAllObjects];
    self.firstCmterName.text = nil;
    self.firstCmtLabel.text = nil;
    self.secondCmterName.text = nil;
    self.secondCmtLabel.text = nil;
    UIImageView *zanImage = (UIImageView *)[self.toolsView viewWithTag:4800];
    zanImage.image = [UIImage imageNamed:@"page_like.png"];
    UILabel *zanLabel = (UILabel *)[self.toolsView viewWithTag:4900];
    zanLabel.text = @"赞Ta";
    self.addBtn.selected = NO;
    
    if (self.isAttention) {
        self.addBtn.hidden = YES;
        self.addImageView.hidden = YES;
        self.timeLabel.text = [MyControl timeFromTimeStamp:model.create_time];
    }else{
        self.addBtn.hidden = NO;
        self.addImageView.hidden = NO;
        
        NSArray *myPetArray = [USER objectForKey:@"myPetsDataArray"];
        if ([myPetArray isKindOfClass:[NSArray class]] && myPetArray.count) {
            for (NSDictionary * dict in myPetArray) {
                if ([[dict objectForKey:@"aid"] isEqualToString:model.aid]) {
                    self.addBtn.selected = YES;
                    break;
                }
            }
        }
        if (self.addBtn.selected) {
            self.addImageView.image = [UIImage imageNamed:@"icon_tick.png"];
            self.timeLabel.text = @"捧ing";
        }else{
            self.addImageView.image = [UIImage imageNamed:@"plus.png"];
            self.timeLabel.text = @"捧TA";
        }
    }
    
//    [MyControl setHeight:150 WithView:self.bigImage];
    [MyControl setImageForBtn:self.headBtn Tx:model.tx isPet:YES isRound:YES];
    self.nameLabel.text = model.name;
    NSURL *url = [MyControl returnThumbImageURLwithName:model.url Width:WIDTH*2 Height:0];
    [self.bigImage setImageWithURL:url];
    //取出长宽
    NSArray *array = [model.url componentsSeparatedByString:@"_"];
    NSString *wAndH = array[array.count-1];
    NSArray *array2 = [wAndH componentsSeparatedByString:@"&"];
    CGFloat w = [array2[0] floatValue];
    CGFloat h = [array2[1] floatValue];
    CGFloat targetH = WIDTH*h/w;
    //重新设置bigImage的高度
    [MyControl setHeight:targetH WithView:self.bigImage];
    self.bigImageBtn.frame = CGRectMake(0, 0, WIDTH, targetH);
    
    [MyControl setVerticalSpace:10 FromView:self.desTextView ToView:self.bigImage];
    /**********************************/
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    if ([model.topic_name isKindOfClass:[NSString class]] && model.topic_name.length > 0) {
        [mutableString appendFormat:@"#%@#", model.topic_name];
    }
    [mutableString appendString:model.cmt];
    
    
    if(mutableString.length){
//        WIDTH-8*2
//        CGSize topicAndCmtSize = [mutableString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.topicAndDesLabel.frame.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
        CGSize topicAndCmtSize = [mutableString boundingRectWithSize:CGSizeMake(self.desTextView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//        [mutableString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.topicAndDesLabel.frame.size.width, 1000) lineBreakMode:1];
        
        [MyControl setHeight:topicAndCmtSize.height WithView:self.desTextView];
//        NSLog(@"desTextView.frame::;%f--%f", self.desTextView.frame.origin.y, self.desTextView.frame.size.height);
        
        [MyControl setVerticalSpace:10 FromView:self.toolsView ToView:self.desTextView];
        if ([model.topic_name isKindOfClass:[NSString class]] && model.topic_name.length) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[ControllerManager changToAttributedText:mutableString]];
//            self.desTextView.textColor = [UIColor purpleColor];
            [attributedString setAttributes:@{NSForegroundColorAttributeName:[ControllerManager colorWithHexString:@"FF6666"]} range:NSMakeRange(0, model.topic_name.length+2)];
//            [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(model.topic_name.length+2, attributedString.length-(model.topic_name.length+2))];
            self.desTextView.attributedText = attributedString;
        }else{
            self.desTextView.attributedText = [ControllerManager changToAttributedText:mutableString];
        }
        self.desTextView.font = [UIFont systemFontOfSize:14];
    }else{
        [MyControl setHeight:0 WithView:self.desTextView];
        
        [MyControl setVerticalSpace:0 FromView:self.toolsView ToView:self.desTextView];
        self.desTextView.hidden = YES;
    }
    
    
    if ([model.likes intValue] > 0) {
        //是否已赞
        NSArray *zanArray = [model.likers componentsSeparatedByString:@","];
        for (NSString *usrid in zanArray) {
            if([usrid isEqualToString:[USER objectForKey:@"usr_id"]]){
//                UIImageView *zanImage = (UIImageView *)[self.likersView viewWithTag:4800];
                zanImage.image = [UIImage imageNamed:@"page_liked.png"];
//                UILabel *zanLabel = (UILabel *)[self.likersView viewWithTag:4900];
                zanLabel.text = @"已赞";
                break;
            }
        }
        
        
        [MyControl setVerticalSpace:15 FromView:self.likersView ToView:self.toolsView];
        //展示头像及调整点赞数label位置,为了避免复用问题先将7个头像置为空
        for (int i=0; i<7; i++) {
            UIImageView *image = (UIImageView *)[self.likersView viewWithTag:5100+i];
            image.image = nil;
        }

        for (int i=0; i<[model.likes intValue] && i < 7; i++) {
            UIImageView *image = (UIImageView *)[self.likersView viewWithTag:5100+i];
            [MyControl setImageForImageView:image Tx:model.likersTxArray[i] isPet:NO isRound:YES];
        }
        self.likersCount.text = model.likes;
        //5.8 点赞数
        if ([model.likes intValue] < 7) {
            [MyControl setOriginX:40+30*[model.likes intValue] WithView:self.likersCount];
        } else{
            [MyControl setOriginX:40+30*7 WithView:self.likersCount];
        }
        [MyControl setHeight:27 WithView:self.likersView];
//        [MyControl setHeight:27 WithView:self.likeBtn];
    }else{
        [MyControl setHeight:0 WithView:self.likersView];
        self.likersView.hidden = YES;
        [MyControl setVerticalSpace:0 FromView:self.likersView ToView:self.toolsView];
    }
    
    if ([model.comments isKindOfClass:[NSString class]] && model.comments.length > 0) {
        [MyControl setVerticalSpace:15 FromView:self.commentsView ToView:self.likersView];
        [self analyseComments:model.comments];
        self.commentsCountLabel.text = [NSString stringWithFormat:@"查看所有%ld条评论", self.nameArray.count];
        self.firstCmtLabel.attributedText = [ControllerManager changToAttributedText:self.bodyArray[0]];
        self.firstCmterName.text = self.nameArray[0];
        
        
        //改变cmterName的宽度
        CGSize size = [MyControl returnSizeAboutString:self.firstCmterName.text FontSize:11 DefaultSize:CGSizeMake(WIDTH, 20)];
        [MyControl setWidth:size.width WithView:self.firstCmterName];
        [MyControl setOriginX:self.firstCmterName.frame.origin.x+size.width+5 WithView:self.firstCmtLabel];
        [MyControl setWidth:self.commentsView.frame.size.width
         -self.firstCmtLabel.frame.origin.x WithView:self.firstCmtLabel];
        
        if (self.bodyArray.count>1) {
            self.secondCmtLabel.attributedText = [ControllerManager changToAttributedText:self.bodyArray[1]];
            self.secondCmterName.text = self.nameArray[1];
            
            CGSize size2 = [MyControl returnSizeAboutString:self.secondCmterName.text FontSize:11 DefaultSize:CGSizeMake(WIDTH, 20)];
            [MyControl setWidth:size2.width WithView:self.secondCmterName];
            [MyControl setOriginX:self.secondCmterName.frame.origin.x+size2.width+5 WithView:self.secondCmtLabel];
            [MyControl setWidth:self.commentsView.frame.size.width
             -self.secondCmtLabel.frame.origin.x WithView:self.secondCmtLabel];
        }
        [MyControl setHeight:75 WithView:self.commentsView];
    }else{
        self.commentsView.hidden = YES;
        [MyControl setHeight:0 WithView:self.commentsView];
        [MyControl setVerticalSpace:0 FromView:self.commentsView ToView:self.likersView];
    }
    
    [MyControl setHeight:self.commentsView.frame.origin.y+self.commentsView.frame.size.height+10 WithView:self.bgWhiteView];
}

-(void)toolsBtnClick:(UIButton *)sender
{
//    NSLog(@"sender.tag = %d", sender.tag);
    self.toolBlock(sender.tag-5000);
}
- (IBAction)headBtnClick:(UIButton *)sender {
    self.headBlock();
}


//解析评论
-(void)analyseComments:(NSString *)commentsString
{
//    if (!([[self.imageDict objectForKey:@"comments"] isKindOfClass:[NSNull class]] || [[self.imageDict objectForKey:@"comments"] length] == 0)) {
        NSArray * arr1 = [commentsString componentsSeparatedByString:@";usr"];
        
        //以前这里i从1开始，起初好像是为了实时回复
        for(int i=0;i<arr1.count;i++){
            if (i == 0 && [arr1[i] length] == 0) {
                continue;
            }
            //            NSLog(@"%@", arr1[i]);
            NSString * usrId = [[[[arr1[i] componentsSeparatedByString:@",name"] objectAtIndex:0] componentsSeparatedByString:@"_id:"] objectAtIndex:1];
            [self.usridArray addObject:usrId];
            //            [usrId release];
            
//            [self.cmtTxArray addObject:@"0"];
            //
            if ([arr1[i] rangeOfString:@"reply_id"].location == NSNotFound) {
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@"name:"] objectAtIndex:1];
                if ([name rangeOfString:@",tx"].location != NSNotFound) {
                    name = [[name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
                [self.nameArray addObject:name];
                //            [name release];
            }else{
                NSString * name = [[[[arr1[i] componentsSeparatedByString:@",reply_id"] objectAtIndex:0] componentsSeparatedByString:@",name:"] objectAtIndex:1];
                if ([name rangeOfString:@",tx"].location != NSNotFound) {
                    name = [[name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
                NSString * reply_name = [[[[arr1[i] componentsSeparatedByString:@",body"] objectAtIndex:0] componentsSeparatedByString:@",reply_name:"] objectAtIndex:1];
                if ([reply_name rangeOfString:@",tx"].location != NSNotFound) {
                    reply_name = [[reply_name componentsSeparatedByString:@",tx"] objectAtIndex:0];
                }
//                NSLog(@"%@", reply_name);
//                NSString * str = [NSString stringWithFormat:@"%@&%@", name, reply_name];
//                if ([reply_name rangeOfString:@"@"].location != NSNotFound) {
//                    reply_name = [[reply_name componentsSeparatedByString:@"@"] objectAtIndex:0];
//                }
                [self.nameArray addObject:name];
            }
            
            
            NSString * body = [[[[arr1[i] componentsSeparatedByString:@",create_time"] objectAtIndex:0] componentsSeparatedByString:@"body:"] objectAtIndex:1];
            [self.bodyArray addObject:body];
            //            [body release];
            
//            NSString * createTime = [[arr1[i] componentsSeparatedByString:@",create_time:"] objectAtIndex:1];
//            [self.createTimeArray addObject:createTime];
            //            [createTime release];
        }
        
//    }
//    NSLog(@"%@--%@", self.nameArray, self.bodyArray);
}

//- (void)dealloc {
//    [_bigImage release];
//    [_headBtn release];
//    [_topicAndDesLabel release];
//    [_likersView release];
//    [_likersView release];
//    [_commentsView release];
//    [super dealloc];
//}

@end
