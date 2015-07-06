//
//  MassHeaderView.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/26.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "MassHeaderView.h"
#import "MasselectionHotStarModel.h"
#import "HyperlinksButton.h"

@interface MassHeaderView ()

@property(nonatomic,strong)UILabel *label;
@end

@implementation MassHeaderView

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
    self.label = [MyControl createLabelWithFrame:CGRectMake(10, 5, 100, 15) Font:12 Text:@"最热萌星"];
    self.label.textColor = [UIColor lightGrayColor];
    [self addSubview:self.label];
    
    NSString *str = @"查看全部";
    CGSize size = [str boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    HyperlinksButton *hyper = [[HyperlinksButton alloc] initWithFrame:CGRectMake(WIDTH-10-size.width, 5, size.width, 15)];
    [hyper setTitle:str forState:UIControlStateNormal];
    [hyper setTitleColor:[ControllerManager colorWithHexString:@"FF6666"] forState:UIControlStateNormal];
    hyper.titleLabel.font = [UIFont systemFontOfSize:13];
    [hyper setColor:[ControllerManager colorWithHexString:@"FF6666"]];
    [hyper addTarget:self action:@selector(checkAllAnimals) forControlEvents:UIControlEventTouchUpInside];
    hyper.showsTouchWhenHighlighted = YES;
    [self addSubview:hyper];

    
    
    //for   头像宽高35  计算起始大小和间距
//    NSArray *array = @[@"啦啦啦", @"啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦啦", @"啦啦啦啦"];
    CGFloat w = 35.0;
    CGFloat count = 6;
    CGFloat sideSpe = 20.0;
    CGFloat spe = (WIDTH-sideSpe*2-count*w)/(count-1);
    for (NSInteger i=0; i<count; i++) {
        UIButton *head = [MyControl createButtonWithFrame:CGRectMake(sideSpe+i*(spe+w), self.label.frame.origin.y+self.label.frame.size.height+5, w, w) ImageName:@"" Target:self Action:@selector(headClick:) Title:nil];
        head.tag = 100+i;
        [self addSubview:head];
        
        UILabel *nameLabel = [MyControl createLabelWithFrame:CGRectMake(head.frame.origin.x-5, head.frame.origin.y+w, w+10, 12) Font:10 Text:nil];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        nameLabel.adjustsFontSizeToFitWidth = NO;
        nameLabel.tag = 200+i;
        [self addSubview:nameLabel];
    }
    
    UIView *line = [MyControl createViewWithFrame:CGRectMake(0, 80, WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
    [self addSubview:line];
    
    UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(10, line.frame.origin.y+5, 100, 15) Font:12 Text:@"热门照片"];
    titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:titleLabel];
}
-(void)checkAllAnimals
{
    self.checkAllBlock();
}

-(void)headClick:(UIButton *)sender
{
    self.headClickBlock(sender.tag-100);
}

#pragma mark -
-(void)modifyUI:(NSArray *)animalsArray
{
    if([self.end_time intValue] <= [[NSDate date] timeIntervalSince1970]){
        //过期
        self.label.text = @"本期排名";
    }else{
        self.label.text = @"最热萌星";
    }
    
    for (int i=0; i<6; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        UILabel *label = (UILabel *)[self viewWithTag:200+i];
        
        if (i<animalsArray.count) {
            MasselectionHotStarModel *model = animalsArray[i];
            label.text = model.name;

            [MyControl setImageForBtn:btn Tx:model.tx isPet:YES isRound:YES];
            
            btn.hidden = NO;
            label.hidden = NO;
        }else{
            btn.hidden = YES;
            label.hidden = YES;
        }
        
    }
}
@end
