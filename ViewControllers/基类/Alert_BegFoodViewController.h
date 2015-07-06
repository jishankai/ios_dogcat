//
//  Alert_BegFoodViewController.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Alert_BegFoodViewController : UIViewController
{
    UILabel * deadLine;
    UIView * bgView;
    UIImageView * bigImage;
}
@property(nonatomic,retain)NSDictionary * dict;
@property(nonatomic,copy)NSString * name;

@property(nonatomic)NSInteger is_food;

@property(nonatomic)BOOL isFromMasselection;
@property(nonatomic,copy)NSString * img_id;
@property(nonatomic,copy)NSString * massName;
@property(nonatomic,copy)UIImage * oriImage;
@end
