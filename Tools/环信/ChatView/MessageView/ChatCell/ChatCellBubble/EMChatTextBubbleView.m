/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <CoreText/CoreText.h>
#import "EMChatTextBubbleView.h"

NSString *const kRouterEventTextURLTapEventName = @"kRouterEventTextURLTapEventName";

@interface EMChatTextBubbleView ()
{
    NSDataDetector *_detector;
    NSArray *_urlMatches;
}

@end

@implementation EMChatTextBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.multipleTouchEnabled = NO;
        [self addSubview:_textLabel];
        
        _detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        NSLog(@"%@",self.model.content);
        retSize = [self.model.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                             NSFontAttributeName:[[self class] textLabelFont],
                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                             }
                                                   context:nil].size;
    }else{
        retSize = [self.model.content sizeWithFont:[[self class] textLabelFont] constrainedToSize:textBlockMinSize lineBreakMode:[[self class] textLabelLineBreakModel]];
    }
    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    _urlMatches = [_detector matchesInString:self.model.content options:0 range:NSMakeRange(0, self.model.content.length)];
//    // 为了避免表情显示不全，如果信息后不是“ ”,在信息后拼接空格@“ ”。
//    NSString *lastStr = [self.model.content substringFromIndex:self.model.content.length - 1];
    NSString *megStr = nil;
//    if ([lastStr isEqualToString:@" "]) {
        megStr = self.model.content;
//    } else {
//        megStr = [NSString stringWithFormat:@"%@%@", self.model.content, @" "];
//    }
//        NSLog(@"999999999999999%@00，%ld",megStr,megStr.length);
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:megStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[[self class] lineSpacing]];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [self.model.content length])];
    //显示自定义表情图片，替换显示
    [_textLabel setAttributedText:[self changAttributedText:attributedString]];
    [self highlightLinksWithIndex:NSNotFound];
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

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range
{
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [_textLabel.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in _urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    _textLabel.attributedText = attributedString;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point
{
    NSMutableAttributedString* optimizedAttributedText = [self.textLabel.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.textLabel.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.textLabel.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName])
        {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.textLabel.font range:NSMakeRange(0, [self.textLabel.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.textLabel.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
         
         if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
             [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
         }
         
         [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
         [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
     }];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = self.textLabel.frame;
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.textLabel.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.textLabel.numberOfLines > 0 ? MIN(self.textLabel.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    CGPoint point = [tap locationInView:_textLabel];
    CFIndex charIndex = [self characterIndexAtPoint:point];
    
    [self highlightLinksWithIndex:NSNotFound];
    
    for (NSTextCheckingResult *match in _urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:charIndex inRange:matchRange]) {
                
                [self routerEventWithName:kRouterEventTextURLTapEventName userInfo:@{KMESSAGEKEY:self.model, @"url":match.URL}];
                break;
            }
        }
    }
}

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        size = [object.content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{
                                                      NSFontAttributeName:[[self class] textLabelFont],
                                                      NSParagraphStyleAttributeName:paragraphStyle
                                                      }
                                            context:nil].size;
    }else{
        size = [object.content sizeWithFont:[self textLabelFont] constrainedToSize:textBlockMinSize lineBreakMode:[self textLabelLineBreakModel]];

    }
    return 2 * BUBBLE_VIEW_PADDING + size.height;
}

+(UIFont *)textLabelFont
{
    return [UIFont systemFontOfSize:LABEL_FONT_SIZE];
}

+(CGFloat)lineSpacing{
    return LABEL_LINESPACE;
}

+(NSLineBreakMode)textLabelLineBreakModel
{
    return NSLineBreakByCharWrapping;
}


@end
