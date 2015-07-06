//
//  GoRecommendViewController.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestModel.h"

@interface GoRecommendViewController : UIViewController

@property(nonatomic,strong)NSString *starId;
@property(nonatomic,strong)NSString *starName;
//票数剩余
@property(nonatomic,strong)NSString *voteLeft;
@property(nonatomic,strong)NSString *voteCost;
//插在第一个，从新卡片或者瀑布流跳进来时需要传
@property(nonatomic,strong)NewestModel *insertModel;
@end
