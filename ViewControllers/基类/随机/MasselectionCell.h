//
//  MasselectionCell.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/14.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//
//  此cell是海选的大Cell，其中还会包含一个collectionView

#import <UIKit/UIKit.h>
#import "MasselectionStarModel.h"

@interface MasselectionCell : UICollectionViewCell

@property(nonatomic,strong)void (^joinBlock)();
@property(nonatomic,strong)void (^GoRecomBlock)();
@property(nonatomic,strong)void (^checkAllAnimalsBlock)();
@property(nonatomic,strong)void (^headerBlock)(NSInteger);
@property(nonatomic,strong)void (^bannerBlock)();
@property(nonatomic,strong)void (^imageClickBlock)(NSInteger);
-(void)modifyUI:(MasselectionStarModel *)model;
@end
