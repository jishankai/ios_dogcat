//
//  FaceKeyboard.h
//  MyPetty
//
//  Created by 曹凯 on 15/4/10.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#ifndef MyPetty_FaceKeyboard_h
#define MyPetty_FaceKeyboard_h

#import "UIImage+Extension.h"
#import "UIView+Extension.h"
//    #import "UIBarButtonItem+Extension.h"

#ifdef DEBUG // 调试状态, 打开LOG功能
#define HMLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define HMLog(...)
#endif

// 是否为iOS7
//#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)


// 屏幕尺寸
#define HMScreenW [UIScreen mainScreen].bounds.size.width

/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 4
// 表情的最大列数
#define HMEmotionMaxCols 6
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 通知
// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"


#endif
