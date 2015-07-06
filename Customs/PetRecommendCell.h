//
//  PetRecommendCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/3.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "PetRecomModel.h"
@interface PetRecommendCell : UITableViewCell <iCarouselDataSource,iCarouselDelegate>
{
    iCarousel * carousel;
    int imageCount;
    
    UIButton * headBtn;
    UIImageView * sex;
    UILabel * nameLabel;
    
    UILabel * ownerLabel;
    UIImageView * ownerHead;
    
//    UIButton * pBtn;
    UIButton * jumpPetBtn;
    UIButton * jumpUserBtn;
    
    UILabel * memberNum;
    UILabel * percent;
}
@property(nonatomic,copy)NSString * aid;

@property(nonatomic,retain)UIButton * pBtn;
@property(nonatomic,copy)void (^pBtnClick)(NSInteger,NSString *);
@property(nonatomic,copy)void (^imageClick)(NSInteger);
@property(nonatomic,copy)void (^jumpPetClick)(NSString *);
@property(nonatomic,copy)void (^jumpUserClick)();

@property(nonatomic,retain)NSArray * imagesArray;
-(void)configUI:(PetRecomModel *)model;
@end
