//
//  DefaultPetCell.h
//  MyPetty
//
//  Created by miaocuilin on 14-8-30.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPetListModel.h"
@interface DefaultPetCell : UITableViewCell
{
    NSInteger rowNum;
}
@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UIImageView *crownImage;
@property (retain, nonatomic) IBOutlet UIImageView *sexImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *cateAndAge;
@property (retain, nonatomic) IBOutlet UIButton *defaultBtn;
@property (copy, nonatomic)void (^defaultBtnClick)(NSInteger,NSString *);
@property (nonatomic,copy)NSString * master_id;
//-(void)configUIWithSex:(int)sex Name:(NSString *)name Cate:(NSString *)cate Age:(NSString *)age Default:(BOOL)isDefault row:(int)row;
-(void)configUIWithModel:(UserPetListModel *)model Default:(BOOL)isDefault Row:(NSInteger)row;
@end
