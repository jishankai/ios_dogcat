//
//  HMEmotionPopView.h
//   
//
//  Created by apple on 14-7-17.
//  Copyright (c) 2014年  . All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMEmotionView;

@interface HMEmotionPopView : UIView
+ (instancetype)popView;

/**
 *  显示表情弹出控件
 *
 *  @param emotionView 从哪个表情上面弹出
 */
- (void)showFromEmotionView:(HMEmotionView *)fromEmotionView;
- (void)dismiss;
@end
