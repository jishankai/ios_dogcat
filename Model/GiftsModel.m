//
//  GiftsModel.m
//  MyPetty
//
//  Created by miaocuilin on 15/4/20.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "GiftsModel.h"

@implementation GiftsModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.add_rq forKey:@"add_rq"];
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.detail_image forKey:@"detail_image"];
    [aCoder encodeObject:self.effect_des forKey:@"effect_des"];
    [aCoder encodeObject:self.gift_id forKey:@"gift_id"];
    [aCoder encodeObject:self.is_real forKey:@"is_real"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.ratio forKey:@"ratio"];
    [aCoder encodeObject:self.sale_status forKey:@"sale_status"];
    [aCoder encodeObject:self.update_time forKey:@"update_time"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.add_rq = [aDecoder decodeObjectForKey:@"add_rq"];
        self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
        self.detail_image = [aDecoder decodeObjectForKey:@"detail_image"];
        self.effect_des = [aDecoder decodeObjectForKey:@"effect_des"];
        self.gift_id = [aDecoder decodeObjectForKey:@"gift_id"];
        self.is_real = [aDecoder decodeObjectForKey:@"is_real"];
        self.level = [aDecoder decodeObjectForKey:@"level"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.ratio = [aDecoder decodeObjectForKey:@"ratio"];
        self.sale_status = [aDecoder decodeObjectForKey:@"sale_status"];
        self.update_time = [aDecoder decodeObjectForKey:@"update_time"];
    }
    return self;
}
@end
