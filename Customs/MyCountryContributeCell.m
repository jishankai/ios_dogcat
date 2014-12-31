//
//  MyCountryContributeCell.m
//  MyPetty
//
//  Created by miaocuilin on 14-8-26.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "MyCountryContributeCell.h"
#import "UserInfoViewController.h"
@implementation MyCountryContributeCell

- (void)awakeFromNib
{
    // Initialization code
    [self createUI];
}
-(void)createUI
{

    self.headBtn.layer.cornerRadius = self.headBtn.frame.size.height/2;
    self.headBtn.layer.masksToBounds = YES;
    self.headBtn.userInteractionEnabled = NO;
}
-(void)modifyWithBOOL:(BOOL)isThis lineNum:(int)num
{
    lineNum = num;
    self.circleBg.hidden = YES;
    
    if (isThis) {
        self.circleBg.hidden = NO;
    }
    //
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"defaultUserHead.png"] forState:UIControlStateNormal];
    self.headBtn.tag = 10000+num;
//    //
//    [NSString stringWithFormat:@"", [ControllerManager returnPositionWithRank:<#(NSString *)#>]]
//    NSString * str = @"祭司 — ";
//    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(60, 20) lineBreakMode:1];
//    self.positionLabel.text = str;
//    CGRect rect = self.positionLabel.frame;
//    rect.size.width = size.width;
//    self.positionLabel.frame = rect;
//    //
//    CGRect rect2 = self.sex.frame;
//    rect2.origin.x = rect.origin.x+size.width;
//    self.sex.frame = rect2;
//    //
//    CGRect rect3 = self.name.frame;
//    rect3.origin.x = rect2.origin.x+rect2.size.width;
//    self.name.frame = rect3;
//    self.name.text = @"Anna";
//    self.name.textColor = BGCOLOR;
    //
    self.location.text = @"北京市 | 朝阳区";
    self.location.textColor = [UIColor lightGrayColor];
    //
    self.contribution.text = @"60000";
    self.contribution.textColor = BGCOLOR;
    
    UIView * line = [MyControl createViewWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, self.contentView.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
}
-(void)configUI:(CountryMembersModel *)model
{
    //
    NSString * str = nil;
    if (lineNum == 0) {
        str = @"经纪人 — ";
    }else{
        str = [NSString stringWithFormat:@"%@ — ", [ControllerManager returnPositionWithRank:model.rank]];
    }
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:1];
    self.positionLabel.text = str;
    CGRect rect = self.positionLabel.frame;
    rect.size.width = size.width;
    self.positionLabel.frame = rect;
    //
    CGRect rect2 = self.sex.frame;
    rect2.origin.x = rect.origin.x+size.width;
    self.sex.frame = rect2;
    //
    CGRect rect3 = self.name.frame;
    rect3.origin.x = rect2.origin.x+rect2.size.width;
    self.name.frame = rect3;
    self.name.text = @"Anna";
    self.name.textColor = BGCOLOR;
//    NSLog(@"%@", model.usr_id)
    usr_id = model.usr_id;
    self.name.text = model.name;
    self.location.text =[ControllerManager returnProvinceAndCityWithCityNum:model.city];
    self.contribution.text = model.t_contri;
    if ([model.gender intValue]==1) {
        self.sex.image = [UIImage imageNamed:@"man.png"];
    }else{
        self.sex.image = [UIImage imageNamed:@"woman.png"];
    }
    
    [self.headBtn setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL,model.tx]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"]];

//    NSString * txUserFilePath = [DOCDIR stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
//    NSLog(@"本地用户头像路径：%@", txUserFilePath);
//    UIImage *User_image = [UIImage imageWithData:[NSData dataWithContentsOfFile:txUserFilePath]];
//    if (User_image) {
//        [self.headBtn setBackgroundImage:User_image forState:UIControlStateNormal];
//    }else{
    
//        [[httpDownloadBlock alloc] initWithUrlStr:[NSString stringWithFormat:@"%@%@", USERTXURL,model.tx] Block:^(BOOL isFinish, httpDownloadBlock * load) {
//            if (isFinish) {
////                NSLog(@"load.dataImage:%@",load.dataImage);
//                if (load.dataImage == NULL) {
//                    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"defaultUserHead.png"] forState:UIControlStateNormal];
//                }else{
//                    //本地目录，用于存放favorite下载的原图
//                    NSString * docDir = DOCDIR;
//                    NSString * txUserFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", model.tx]];
//                    //将下载的图片存放到本地
//                    [load.data writeToFile:txUserFilePath atomically:YES];
//                    [self.headBtn setBackgroundImage:load.dataImage forState:UIControlStateNormal];
//                }
//            }else{
//                NSLog(@"download failed");
//            }
//        }];
//    }
}
- (IBAction)headBtnClick:(id)sender {
    NSLog(@"点击头像--%d", self.headBtn.tag-10000);
    NSLog(@"usr_id:%@",usr_id);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headBtn release];
    [_positionLabel release];
    [_location release];
    [_contribution release];
    [_circleBg release];
    [_sex release];
    [_name release];
    [super dealloc];
}
@end
