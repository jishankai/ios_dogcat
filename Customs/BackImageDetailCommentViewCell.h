//
//  BackImageDetailCommentViewCell.h
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
@interface BackImageDetailCommentViewCell : UITableViewCell <UITextViewDelegate>
{
    UIImageView * headImageView;
    UILabel * name;
    
    HMEmotionTextView * desLabel;
    UILabel * time;
    
    UIView * line;
    UIButton * reportBtn;
}
@property (nonatomic,copy)void (^reportBlock)(void);

-(void)configUIWithName:(NSString *)nameStr Cmt:(NSString *)cmt Time:(NSString *)timeStr CellHeight:(CGFloat)cellHeight textSize:(CGSize)textSize Tx:(NSString *)tx isTest:(BOOL)isTest;
@end
