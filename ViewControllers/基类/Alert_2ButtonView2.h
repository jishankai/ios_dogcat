//
//  Alert_2ButtonView2.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert_2ButtonView2 : UIView
{
    UIImageView * selectImage;
}
@property(nonatomic,copy)NSString * rewardNum;
@property(nonatomic,copy)NSString * foodCost;
@property(nonatomic,copy)NSString * productName;
@property(nonatomic,copy)NSString * pet_name;

@property(nonatomic,copy)NSString * voteCost;
//1.打赏，有勾选的  2.提示去充值 3.提示是否确认兑换 4.退出圈子 5.宠物没周边提示  //6.推荐票数用完  7.没有创建的宠物
@property(nonatomic)int type;
//1.本次捧星  2.本次购物  3.
@property(nonatomic)int subType;

@property(nonatomic,copy)void (^reward)();
@property(nonatomic,copy)void (^jumpCharge)();
@property(nonatomic,copy)void (^exchange)();
@property(nonatomic,copy)void (^quit)();
//@property(nonatomic,copy)void (^exchangeRecommend)();
//去创建宠物
@property(nonatomic,copy)void (^createMyPetBlock)();

@property(nonatomic,copy)void (^confirmClickBlock)();

//1.助TA集粉  2.送礼
@property(nonatomic,copy)void (^zbBlock)(int);
-(void)makeUI;
@end
