//
//  GoRecommendCollectionCell.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestModel.h"

@interface GoRecommendCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *image;
-(void)modifyUI:(NewestModel *)model;
@end
