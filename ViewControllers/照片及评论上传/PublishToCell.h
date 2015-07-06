//
//  PublishToCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/12/8.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPetListModel.h"

@interface PublishToCell : UITableViewCell
{
    NSInteger a;
}
@property (retain, nonatomic) IBOutlet UIImageView *headImage;
@property (retain, nonatomic) IBOutlet UIImageView *crown;
@property (retain, nonatomic) IBOutlet UIImageView *sex;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *cateAndAge;
@property (retain, nonatomic) UIButton *selectBtn;

@property (copy,nonatomic)void (^selectBlock)(NSInteger);
//@property (copy,nonatomic)void (^unSelectBlock)(int);

-(void)configUI:(UserPetListModel *)model Index:(NSInteger)index BtnSelected:(BOOL)select;
@end
