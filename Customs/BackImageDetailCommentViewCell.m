//
//  BackImageDetailCommentViewCell.m
//  MyPetty
//
//  Created by miaocuilin on 14/11/23.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "BackImageDetailCommentViewCell.h"

@implementation BackImageDetailCommentViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}

-(void)makeUI
{
    headImageView = [MyControl createImageViewWithFrame:CGRectMake(6, 11.5, 30, 30) ImageName:@"defaultPetHead.png"];
    headImageView.layer.cornerRadius = 15;
    headImageView.layer.masksToBounds = YES;
    [self addSubview:headImageView];
    
    name = [MyControl createLabelWithFrame:CGRectMake(45, 10, 220, 15) Font:12 Text:nil];
    name.textColor = ORANGE;
    [self addSubview:name];
    
    float Width = [UIScreen mainScreen].bounds.size.width-13*2-10*2;
    
    desLabel = [[HMEmotionTextView alloc] initWithFrame:CGRectMake(40, 30, Width-40-10-35, 25)];
    
//    desLabel.scrollEnabled = NO;//是否可以拖动
    desLabel.userInteractionEnabled = NO;
    desLabel.textContainerInset = UIEdgeInsetsZero;
//    desLabel.textAlignment = NSTextAlignmentLeft;
    desLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    desLabel.textColor = [ControllerManager colorWithHexString:@"3d3d3d"];
    [self addSubview:desLabel];
    [desLabel release];
    
    
    time = [MyControl createLabelWithFrame:CGRectMake(Width-155, 10, 150, 15) Font:11 Text:nil];
    time.textColor = [ControllerManager colorWithHexString:@"7b7878"];
    time.textAlignment = NSTextAlignmentRight;
    [self addSubview:time];
    
    line = [MyControl createViewWithFrame:CGRectMake(40, 53-1, Width-40, 1)];
    line.backgroundColor = [ControllerManager colorWithHexString:@"dddddd"];
    [self addSubview:line];
    
    reportBtn = [MyControl createButtonWithFrame:CGRectMake(Width-5-25, 28, 18*31/26.0, 18) ImageName:@"grayAlert.png" Target:self Action:@selector(report) Title:nil];
    [self addSubview:reportBtn];
}
-(void)report
{
    NSLog(@"report");
    self.reportBlock();
}
-(void)configUIWithName:(NSString *)nameStr Cmt:(NSString *)cmt Time:(NSString *)timeStr CellHeight:(CGFloat)cellHeight textSize:(CGSize)textSize Tx:(NSString *)tx isTest:(BOOL)isTest
{
    if (!isTest) {
        reportBtn.hidden = YES;
    }else{
        reportBtn.hidden = NO;
    }
    
    if (![tx isEqualToString:@"0"]) {
        [MyControl setImageForImageView:headImageView Tx:tx isPet:NO isRound:YES];
//        [headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", USERTXURL, tx]] placeholderImage:[UIImage imageNamed:@"defaultUserHead.png"]];
    }else{
        headImageView.image = [UIImage imageNamed:@"defaultUserHead.png"];
    }
    
    
    CGRect lineRect = line.frame;
    lineRect.origin.y = cellHeight-1;
    line.frame = lineRect;
    
//    NSLog(@"%f", self.frame.size.height);
    //发言者
    NSString * name1 = nil;
    //被回复者
    NSString * name2 = nil;
    NSString * combineStr = nil;
    NSLog(@"%@", nameStr);
    if ([nameStr rangeOfString:@"&"].location == NSNotFound) {
        combineStr = nameStr;
    }else{
        name1 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:0];
        name2 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1];
        if ([name2 rangeOfString:@"@"].location != NSNotFound) {
            name2 = [[name2 componentsSeparatedByString:@"@"] objectAtIndex:1];
        }
//        if ([nameStr rangeOfString:@"@"].location == NSNotFound) {
//            name2 = [[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1];
//        }else{
//            //1099&阿汤叔&阿汤叔@1100p  应该是1099p回复阿汤哥
//            name2 = [[[[nameStr componentsSeparatedByString:@"&"] objectAtIndex:1] componentsSeparatedByString:@"@"] objectAtIndex:1];
//        }
//        [NSString stringWithFormat:@"%@ 回复 %@", name1, name2]
        combineStr = name1;
    }
    
    NSMutableAttributedString * mutableStr = [[NSMutableAttributedString alloc] initWithString:combineStr];
    
    [mutableStr addAttribute:NSForegroundColorAttributeName value:ORANGE range:NSMakeRange(0, combineStr.length)];
//    if ([nameStr rangeOfString:@"&"].location != NSNotFound) {
//        [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(name1.length+1, 2)];
//    }
    name.attributedText = mutableStr;
    [mutableStr release];
    
    
//    desLabel.text = cmt;
//    
//    CGRect desRect = desLabel.frame;
//    if (textSize.height>15) {
//        
//        desRect.size.height = textSize.height;
//    }else{
//        desRect.size.height = 15;
//    }
//    desLabel.frame = desRect;
    //1,评论
    //显示的内容
    if(name2 != nil){
        NSString *strings = [NSString stringWithFormat:@"回复 %@：%@", name2, cmt];
        //    cmt = [NSString stringWithFormat:@"回复 %@:%@", name2, cmt];
        NSMutableAttributedString * cmtStr = [[NSMutableAttributedString alloc] initWithString:strings];
        [cmtStr addAttribute:NSForegroundColorAttributeName value:ORANGE range:NSMakeRange(3, name2.length+1)];
        desLabel.attributedText =[self changAttributedText:cmtStr];
        [cmtStr release];
    } else {
        NSMutableAttributedString * cmtStr = [[NSMutableAttributedString alloc] initWithString:cmt];
        desLabel.attributedText =[self changAttributedText :cmtStr];
        [cmtStr release];
    }
    desLabel.font = [UIFont systemFontOfSize:12];
    

    time.text = [MyControl timeFromTimeStamp:timeStr];
}
#pragma mark - 匹配图片
- (NSAttributedString *)changAttributedText:(NSMutableAttributedString *)str{
    //创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = str;
    //[[NSMutableAttributedString alloc] initWithString:str];
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    NSString *string = str.string;
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, str.length)];
    //
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [string substringWithRange:range];
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"/EmotionIcons/lxh/lxh-info.plist" ofType:nil];
//        NSLog(@"%@",plist);
        NSArray *face = [[NSArray alloc] initWithContentsOfFile:plist];
        for (int i = 0; i < face.count; i ++)
        {
            if ([face[i][@"chs"] isEqualToString:subStr])
            {
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face[i][@"png"]];
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                //                UIImage *acv = [UIImage];
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                [textAttachment release];
            }
        }
    }
    //从后往前替换
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    return attributeString;
}


@end
