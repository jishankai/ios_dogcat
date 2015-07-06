//
//  BegFoodListModel.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/5.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BegFoodListModel.h"

@implementation BegFoodListModel


-(void)dealloc
{
    [super dealloc];
//    [_aid release];   //避免多次点击tabbar赏粮崩溃
    [_cmt release];
    [_create_time release];
    [_food release];
    [_gender release];
    [_img_id release];
    [_url release];
    [_name release];
    [_tx release];
    [_type release];
    [_u_name release];
    [_u_tx release];
    [_usr_id release];
    [_is_food release];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    NSLog(@"undefinedKey:%@",key);
}
@end
