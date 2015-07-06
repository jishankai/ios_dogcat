//
//  MassWatchCell.h
//  MyPetty
//
//  Created by zhangjr on 14-8-20.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@interface MassWatchCell : UITableViewCell
{
    UIButton *talkButton;
}
@property(nonatomic,strong)UIButton *headButton;
@property(nonatomic,strong)UIImageView *giftView;
@property(nonatomic,strong)UIImageView *sexView;
@property(nonatomic,strong)UILabel *watcherName;
@property(nonatomic,strong)UILabel *ProvinceAndCity;
@property(nonatomic,strong)NSString *Province;
@property(nonatomic,strong)NSString *city;

//
@property(nonatomic)BOOL isMi;
@property(nonatomic,copy)NSString * txType;
@property(nonatomic,copy)NSString * usr_id;
@property(nonatomic,copy)void (^jumpToUserInfo)(UIImage *, NSString *);
@property(nonatomic,copy)void (^cellClick)(NSInteger);
@property (nonatomic,assign)NSInteger num;
-(void)configUI:(UserInfoModel *)model isLiker:(BOOL)isLiker;
@end
