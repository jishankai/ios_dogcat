//
//  ArticleCell.m
//  MyPetty
//
//  Created by miaocuilin on 15/3/23.
//  Copyright (c) 2015年 AidiGame. All rights reserved.
//

#import "ArticleCell.h"

@interface ArticleCell ()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UIImageView *pic;

@end

@implementation ArticleCell

- (void)awakeFromNib {
    // Initialization code
    
    [self makeUI];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    CGFloat spe = 15.0f;
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spe, 20, [UIScreen mainScreen].bounds.size.width-spe*2, 20)];
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
//    self.titleLab.text = @"吉娃娃躲进主人行李箱 安检引发纽约纽约纽约纽约";
    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:self.titleLab];
    
    _detailLab = [MyControl createLabelWithFrame:CGRectMake(spe, 55, [UIScreen mainScreen].bounds.size.width*0.6, 60) Font:12 Text:nil];
    self.detailLab.textColor = [UIColor lightGrayColor];
    self.detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.detailLab.textAlignment = NSTextAlignmentNatural;
    self.detailLab.adjustsFontSizeToFitWidth = NO;
    self.detailLab.autoresizesSubviews = NO;
    [self.contentView addSubview:self.detailLab];
    
    _pic = [MyControl createImageViewWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-spe-64, 55, 64, 64) ImageName:@"defaultPetPic.jpg"];
    self.pic.contentMode = UIViewContentModeScaleAspectFill;
    self.pic.clipsToBounds = YES;
    [self.contentView addSubview:self.pic];
}
-(void)modifyUI:(ArticleModel *)model
{
    self.titleLab.text = model.title;
    self.detailLab.text = model.des;
    CGSize size = [MyControl returnSizeAboutString:self.detailLab.text FontSize:12 DefaultSize:CGSizeMake(self.detailLab.frame.size.width, 1000)];
    [MyControl setHeight:size.height WithView:self.detailLab];
    
    [self.pic setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"water_white.png"]];
}

@end
