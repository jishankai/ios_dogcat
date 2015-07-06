//
//  FrontImageDetailViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/21.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

#import "HMEmotionTextView.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"

@interface FrontImageDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextViewDelegate>
{
    UIView * bgView;
    UIScrollView * sv;
    UIScrollView * sv2;
    UIImageView * bottomBgView;
    
    UIView * imageBgView;
    UIView * imageBgView2;
    //
    ClickImage * bigImageView;
    HMEmotionTextView * desLabel;
    UILabel * topicLabel;
    UILabel * timeLabel;
    
    UIButton * headBtn;
    UIImageView * sex;
    UILabel * petName;
    UILabel * petType;
    UILabel * userName;
    UIImageView * userTx;
    UIImageView * triangle;
    
    UITableView * tv;
    UITableView * desTv;
    
    UISwipeGestureRecognizer * swipeLeft;
    UISwipeGestureRecognizer * swipeRight;
    
    UISwipeGestureRecognizer * swipeLeft2;
    UISwipeGestureRecognizer * swipeRight2;
    //是否在第二页
    BOOL isBackSide;
    
    
    BOOL isTest;
    
    //
    BOOL isCommentCreated;
    //评论
    UIButton * bgButton;
    UIView * commentBgView;
    HMEmotionTextView * commentTextField;
    //表情button点击状态
    BOOL isClick;
    
    //判断是否在当前控制器，来限制键盘变化通知
    BOOL isInThisController;
    
    
    //背面点击按钮index
    int triangleIndex;
    
    BOOL isReply;
    int replyRow;
    
    //评论及回复框的起始Y值
    float originalY;
    
    //4项是否都加载过数据了
    BOOL isLoaded[4];
    
    BOOL isBackLoaded;
    
    BOOL isLoad;
    UIImageView * guide;
    
    //图片不存在
    BOOL imageNotExist;
    
    UIButton * menuBgBtn;
    UIView * moreView;
    BOOL isMoreCreated;
    
    //判断当前图片是否是求口粮图片并且未过时
    NSInteger is_food;
}
//4、表情button
@property(nonatomic, retain)UIButton *emoticonButton;
//5、表情键盘
@property (nonatomic, retain) HMEmotionKeyboard *kerboard;
//6.是否正在切换键盘
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;

@property(nonatomic,retain)NSDictionary * picDict;
@property(nonatomic,retain)NSDictionary * imageDict;

@property(nonatomic,retain)NSDictionary * petDict;

@property(nonatomic,copy)NSString * img_id;

//@property (nonatomic)BOOL is_follow;

//评论解析数组
@property (nonatomic,retain)NSMutableArray * usrIdArray;
@property (nonatomic,retain)NSMutableArray * nameArray;
@property (nonatomic,retain)NSMutableArray * bodyArray;
@property (nonatomic,retain)NSMutableArray * createTimeArray;

@property (nonatomic,retain)NSMutableArray * cmtTxArray;
//
@property (nonatomic,retain)NSMutableArray * likerTxArray;
@property (nonatomic,retain)NSMutableArray * senderTxArray;
@property (nonatomic,retain)NSMutableArray * likerIdArray;
@property (nonatomic,retain)NSMutableArray * senderIdArray;

@property (nonatomic,retain)NSMutableArray * likersArray;
@property (nonatomic,retain)NSMutableArray * sendersArray;
@property (nonatomic,retain)NSMutableArray * commentersArray;
@property (nonatomic,retain)NSMutableArray * sharersArray;

@property (nonatomic)BOOL isFromRandom;

@property (nonatomic,copy)NSURL * imageURL;
@property (nonatomic,copy)NSString * imageCmt;
//显示背面第几列 1,2,3,4
@property (nonatomic)NSInteger showBackIndex;
//如果来自GoRecommend在退出详情时不显示tabBar
@property (nonatomic)BOOL isFromGoRecommend;
@end
