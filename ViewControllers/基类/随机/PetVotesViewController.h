//
//  PetVotesViewController.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/15.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//
//  此界面展示的是：具体某个宠物在活动中的得票情况，投票人的前3名及我贡献票数的情况

#import <UIKit/UIKit.h>

@interface PetVotesViewController : UIViewController
@property(nonatomic,strong)NSString *tx;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *aid;
@property(nonatomic,strong)NSString *star_id;
@property(nonatomic,strong)NSString *starName;
@property(nonatomic,strong)NSString *end_time;

@property(nonatomic,strong)void (^voteBlock)(NSString *, NSString *, NSString *, NSString *);
@end
