//
//  PetVotesModel.h
//  MyPetty
//
//  Created by miaocuilin on 15/4/16.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PetVotesModel : NSObject
@property(nonatomic,strong)NSNumber *my_votes;
@property(nonatomic,strong)NSNumber *total_votes;

//gender img_id stars url
@property(nonatomic,strong)NSDictionary *infoDict;
@property(nonatomic,strong)NSArray *rankArray;
@end
