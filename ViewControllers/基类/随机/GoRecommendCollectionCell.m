//
//  GoRecommendCollectionCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/27.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "GoRecommendCollectionCell.h"

@interface GoRecommendCollectionCell ()

@end

@implementation GoRecommendCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    CGFloat height = HEIGHT-76-20-64-5-20;
    UIView *bgView = [MyControl createViewWithFrame:CGRectMake(0, 0, WIDTH-20, height)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    self.image = [MyControl createImageViewWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-10-30) ImageName:@""];
    [self addSubview:self.image];
}

-(void)modifyUI:(NewestModel *)model
{
    CGFloat targetW = self.frame.size.width-20;
    CGFloat targetH = self.frame.size.height-10-30;
    
    NSArray *array = [model.url componentsSeparatedByString:@"_"];
    NSString *string = array[array.count-1];
    NSArray *array2 = [string componentsSeparatedByString:@"&"];
    
    float imageW = [array2[0] floatValue];
    float imageH = [array2[1] floatValue];
    
    float realWidth = 0;
    float realHeight = 0;
//    int margin = 5;
    if (imageW/imageH > targetW/targetH) {
        //过宽
        realHeight = targetW*imageH/imageW;
        realWidth = targetW;
        
        self.image.frame = CGRectMake(10, (targetH-realHeight)/2.0, realWidth, realHeight);
    }else{
        //过高
        realWidth = targetH*imageW/imageH;
        realHeight = targetH;
        
        self.image.frame = CGRectMake(10+(targetW-realWidth)/2.0, 10, realWidth, realHeight);
    }
    
    NSURL *url = [MyControl returnThumbImageURLwithName:model.url Width:realWidth Height:realHeight];
    [self.image setImageWithURL:url];
}
@end
