//
//  MasselectionStarModel.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/14.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasselectionStarModel : NSObject

@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)NSString * banner;
@property(nonatomic,strong)NSString * name;
//活动id
@property(nonatomic,strong)NSString * star_id;
//免费票数
@property(nonatomic,strong)NSString * votes;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * icon;
@property(nonatomic,strong)NSString * des;
@property(nonatomic,strong)NSString * end_time;

@property(nonatomic,strong)NSArray *animalsArray;
@property(nonatomic,strong)NSArray *imagesArray;

@property(nonatomic)NSInteger page;
@end
