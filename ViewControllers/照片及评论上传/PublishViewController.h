//
//  PublishViewController.h
//  MyPetty
//
//  Created by Aidi on 14-7-1.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIFormDataRequest.h"


@interface PublishViewController : UIViewController
{
    ASIFormDataRequest * _request;
    UIImageView * bgImageView;
    UIImageView * bigImageView;
    
    UIView * textBgView;
    UIView * navView;
    UIScrollView * sv;
    UILabel * sinaLabel;
    UILabel * weChatLabel;
    
    UIButton * topic;
    UIButton * users;
    UIButton * publishTo;
    
    UIButton * publishButton;
    
    //用于限制键盘change的通知
    BOOL isInPublish;
    
    //s=sina  w=weChat
    int s;
    int w;
    
    BOOL publishSuc;
    BOOL shareSuc;
    
    //判断是否是新浪微信都分享，用来判断新浪分享完成代理该走哪个处理
    BOOL isDouble;
}
@property (nonatomic,copy)NSString * tempDes;
//@property (nonatomic,retain)UIImageView * bgImageView;
@property (nonatomic)BOOL isBeg;
@property (nonatomic,retain)UIImage * oriImage;
//@property (nonatomic,retain)AFPhotoEditorController * af;
@property (nonatomic,copy)NSString * usr_ids;

//别的界面传过来的
@property (nonatomic,copy)NSString * aid;
@property (nonatomic,copy)NSString * name;

//要发布到的宠物的aid
@property (nonatomic,copy)NSMutableString * aids;

@property(nonatomic,retain)NSMutableArray * dataArray;

@property(nonatomic,copy)void (^showFrontImage)(NSString *, NSInteger, NSString *, NSString *);
//img_id star_id aid name massName UIImage*
@property(nonatomic,copy)void (^showMassAlert)(NSString *, NSString *, NSString *, NSString *, NSString *, UIImage *);
@property (nonatomic,copy)NSString * img_id;

@property (nonatomic) int publishType;

//判断是否为活动照片
@property (nonatomic)BOOL isFromMasselection;
@property (nonatomic,strong)NSString *MasselctionName;
@property (nonatomic,strong)NSString *starId;
@end
