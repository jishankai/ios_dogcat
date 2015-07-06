//
//  MassHeaderView.h
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol MassHeaderDelegate <NSObject>
//
//-(void)checkAllBlock
//
//@end

@interface MassHeaderView : UICollectionReusableView
@property(strong,nonatomic)void (^headClickBlock)(NSInteger);

@property(strong,nonatomic)void (^checkAllBlock)();

@property(nonatomic,strong)NSString *end_time;
-(void)modifyUI:(NSArray *)animalsArray;
@end
