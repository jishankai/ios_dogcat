//
//  Alert_2ButtonView2.m
//  MyPetty
//
//  Created by miaocuilin on 14/12/11.
//  Copyright (c) 2014年 AidiGame. All rights reserved.
//

#import "Alert_2ButtonView2.h"

@implementation Alert_2ButtonView2
-(void)makeUI
{
    //黑 %60  白 %80
    UIView * alphaView = [MyControl createViewWithFrame:[UIScreen mainScreen].bounds];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:alphaView];
    
    UIView * bgView = [MyControl createViewWithFrame:CGRectMake(18, ([UIScreen mainScreen].bounds.size.height-230)/2.0, [UIScreen mainScreen].bounds.size.width-36, 230)];
    [self addSubview:bgView];
    
    UIView * whiteBg = [MyControl createViewWithFrame:CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height)];
    whiteBg.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    whiteBg.layer.cornerRadius = 10;
    whiteBg.layer.masksToBounds = YES;
    [bgView addSubview:whiteBg];
    
    UIButton * closeBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-36, 0, 36, 36) ImageName:@"various_close.png" Target:self Action:@selector(closeBtnClick) Title:nil];
    [bgView addSubview:closeBtn];
    
    UILabel * label1 = [MyControl createLabelWithFrame:CGRectMake(10, closeBtn.frame.origin.y+closeBtn.frame.size.height+10, bgView.frame.size.width-20, 20) Font:16 Text:nil];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label1];
    
    UILabel * label2 = [MyControl createLabelWithFrame:CGRectMake(20, label1.frame.origin.y+label1.frame.size.height+5, bgView.frame.size.width-40, 20) Font:16 Text:nil];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
    [bgView addSubview:label2];
    
    UIImageView * goldImage = [MyControl createImageViewWithFrame:CGRectMake(bgView.frame.size.width/2-30-5, label2.frame.origin.y+label2.frame.size.height+10, 30, 30) ImageName:@"gold.png"];
    [bgView addSubview:goldImage];
    
    UILabel * costLabel = [MyControl createLabelWithFrame:CGRectMake(bgView.frame.size.width/2+5, goldImage.frame.origin.y+5, bgView.frame.size.width/2, 20) Font:17 Text:[NSString stringWithFormat:@"%d", [self.rewardNum intValue]-[[USER objectForKey:@"food"] intValue]]];
    costLabel.textColor = ORANGE;
    [bgView addSubview:costLabel];
    
    selectImage = [MyControl createImageViewWithFrame:CGRectMake(bgView.frame.size.width/2-70, goldImage.frame.origin.y+goldImage.frame.size.height+15, 15, 15) ImageName:@"atUsers_unSelected.png"];
    [bgView addSubview:selectImage];
    
    UIButton * selectBtn = [MyControl createButtonWithFrame:CGRectMake(selectImage.frame.origin.x-5, selectImage.frame.origin.y-5, 25, 25) ImageName:@"" Target:self Action:@selector(selectBtnClick:) Title:nil];
    [bgView addSubview:selectBtn];
    
    UILabel * selectLabel = [MyControl createLabelWithFrame:CGRectMake(selectImage.frame.origin.x+selectImage.frame.size.width+5, selectImage.frame.origin.y-2.5, bgView.frame.size.width/2+50, 20) Font:15 Text:@"以后不用提醒我了"];
    selectLabel.textColor = ORANGE;
    [bgView addSubview:selectLabel];
    
    UIButton * cancelBtn = [MyControl createButtonWithFrame:CGRectMake(8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_grayBtn.png" Target:self Action:@selector(cancelClick) Title:@"再想想"];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:cancelBtn];
    
    UIButton * confirmBtn = [MyControl createButtonWithFrame:CGRectMake(bgView.frame.size.width-276/2*0.9-8, 346/2, 276/2*0.9, 93/2.0*0.9) ImageName:@"various_orangeBtn.png" Target:self Action:@selector(confirmClick) Title:@"没问题"];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:confirmBtn];
    NSLog(@"%d",self.type);

    if(self.type == 1){
        label1.text = [NSString stringWithFormat:@"本次打赏%@份口粮", self.rewardNum];
        label2.text = @"需要花费您：";
        
    }else if(self.type == 2){
//        NSLog(@"%d",self.subType);
        if(self.subType == 1){
            label1.hidden = YES;
            label2.text = @"本次捧星需要花费您：";
            costLabel.text = self.rewardNum;
        }else if(self.subType == 2){
            label1.hidden = YES;
            label2.text = @"本次购物需要花费您：";
            costLabel.text = self.rewardNum;
        }else if(self.subType == 3){
            label1.hidden = YES;
            label2.text = @"本次推荐需要花费您：";
            costLabel.text = self.rewardNum;
        }else{
            //FIXME: 推荐本应由其类型判断，单词处不是
            //5.20 默认当需要三十金币时，是推荐的提示
            if ([self.rewardNum isEqualToString:@"30"]) {
                NSLog(@"self.subType:%d",self.subType);
                label2.text = @"本次投票需要花费您：";
                costLabel.text = self.rewardNum;
            } else {
                //5.20 一份口粮一份金币，所以只有1，10，100，1000
                label1.text = [NSString stringWithFormat:@"本次打赏%@份口粮", self.rewardNum];
                label2.text = @"需要花费您：";
            }
        }
        
        
        selectImage.hidden = YES;
        selectBtn.hidden = YES;
//        selectLabel.hidden = YES;
        CGRect rect = selectLabel.frame;
        rect.origin.x = 0;
        rect.size.width = bgView.frame.size.width;
        selectLabel.frame = rect;
        selectLabel.text = @"先去充值吧~";
        selectLabel.textAlignment = NSTextAlignmentCenter;
        
        [confirmBtn setTitle:@"去充值" forState:UIControlStateNormal];
//        NSLog(@"ccccccccccccc");
        ////////////////////////////// 由应用版本控制
        if([[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
            selectLabel.text = @"先在应用挣钱吧~";
            cancelBtn.hidden = YES;
            CGRect rect2 = confirmBtn.frame;
            rect2.origin.x = (bgView.frame.size.width-rect2.size.width)/2.0;
            confirmBtn.frame = rect2;
            [confirmBtn setTitle:@"好吧" forState:UIControlStateNormal];
        }
        
    }else if(self.type == 3){
        label1.text = @"支付";
        label1.textAlignment = NSTextAlignmentLeft;
        
        UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+40, 100, 20) Font:16 Text:@"兑换"];
        label3.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
        [bgView addSubview:label3];
        
        selectImage.hidden = YES;
        selectLabel.hidden = YES;
        
        CGRect rect = goldImage.frame;
        rect.origin.y = label1.frame.origin.y-4;
        goldImage.frame = rect;
        
        CGRect rect2 = costLabel.frame;
        rect2.origin.y = label1.frame.origin.y;
        costLabel.frame = rect2;
        
    
        goldImage.image = [UIImage imageNamed:@"exchange_orangeFood.png"];
        
        costLabel.text = self.foodCost;
        NSString * str = [NSString stringWithFormat:@"%@", self.productName];
        label2.text = str;
        label2.font = [UIFont systemFontOfSize:15];
        label2.textAlignment = NSTextAlignmentLeft;
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(bgView.frame.size.width-130, 100) lineBreakMode:1];
        label2.frame = CGRectMake(100, label3.frame.origin.y, bgView.frame.size.width-130, size.height);
    }else if(self.type == 4){
        //退出圈子
//        @"亲爱的，真的忍心不捧了吗？", @"你舍得放弃陪伴你的TA么？", @"真的要这么无情么？"
        label1.text = @"亲爱的，真的忍心不捧了吗？";
        label2.text = @"你舍得放弃陪伴你的TA么？";
        
        CGRect rect = label1.frame;
        rect.origin.y += 20;
        label1.frame = rect;
        
        CGRect rect2 = label2.frame;
        rect2.origin.y += 20;
        label2.frame = rect2;
        
        goldImage.hidden = YES;
        selectImage.hidden = YES;
        selectBtn.hidden = YES;
        selectLabel.hidden = YES;
        costLabel.hidden = YES;
        
        UILabel * label3 = [MyControl createLabelWithFrame:CGRectMake(20, label2.frame.origin.y+label2.frame.size.height+5, bgView.frame.size.width-40, 20) Font:16 Text:@"真的要这么无情么？"];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
        [bgView addSubview:label3];
        
        [confirmBtn setTitle:@"额，是的" forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"various_orangeBtn.png"] forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[UIImage imageNamed:@"various_grayBtn.png"] forState:UIControlStateNormal];
    }else if (self.type == 5){
        CGRect rect = label1.frame;
        rect.origin.y += 20;
        rect.size.height = 40;
        label1.frame = rect;
        
        CGRect rect2 = label2.frame;
        rect2.origin.y += 40;
        label2.frame = rect2;
        
        label1.text = [NSString stringWithFormat:@"别着急~%@还没有周边呢。", self.pet_name];
        
        label2.text = @"不如先……";
        
        [cancelBtn setTitle:@"助TA集粉" forState:UIControlStateNormal];
        [confirmBtn setTitle:@"给TA送礼" forState:UIControlStateNormal];
        
        selectImage.hidden = YES;
        selectBtn.hidden = YES;
        selectLabel.hidden = YES;
        goldImage.hidden = YES;
        costLabel.hidden = YES;
    }else if(self.type == 6){
        UILabel *titleLabel = [MyControl createLabelWithFrame:CGRectMake(0, 60, bgView.frame.size.width, 20) Font:16 Text:@"本次投票需要花费您："];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:114/255.0 green:72/255.0 blue:43/255.0 alpha:1];
        [bgView addSubview:titleLabel];
        
        CGRect rect = goldImage.frame;
        rect.origin.y = titleLabel.frame.origin.y+30;
        goldImage.frame = rect;
    
        
        costLabel.text = self.voteCost;
        costLabel.frame = CGRectMake(goldImage.frame.origin.x+goldImage.frame.size.width+10, goldImage.frame.origin.y+5, bgView.frame.size.width/2, 20);
        costLabel.textColor = [ControllerManager colorWithHexString:@"7a7a7a"];
        costLabel.font = [UIFont systemFontOfSize:16];
        
        cancelBtn.hidden = YES;
        [confirmBtn setTitle:@"好的！" forState:UIControlStateNormal];
        CGRect confirmRect = confirmBtn.frame;
        confirmRect.origin.x = (bgView.frame.size.width-confirmRect.size.width)/2.0;
        confirmBtn.frame = confirmRect;
        
    }else if(self.type == 7){
        label1.text = @"先去创建你的宠物吧!";
        [cancelBtn setTitle:@"稍等等" forState:UIControlStateNormal];
        [confirmBtn setTitle:@"这就去~" forState:UIControlStateNormal];
        [MyControl setOriginY:label1.frame.origin.y+50 WithView:label1];
        
        selectImage.hidden = YES;
        selectLabel.hidden = YES;
        costLabel.hidden = YES;
        goldImage.hidden = YES;
    }
    
//    if ([[USER objectForKey:@"showCostAlert"] intValue]) {
//        selectImage.hidden = YES;
//        selectBtn.hidden = YES;
//        selectLabel.hidden = YES;
//    }
}
-(void)closeBtnClick
{
    [self removeFromSuperview];
}
-(void)cancelClick
{
    if(self.type == 5){
        //助TA集粉
        self.zbBlock(1);
    }
    [self removeFromSuperview];
}
-(void)confirmClick
{
    if(self.type == 1){
        //打赏
        self.reward();
    }else if (self.type == 2){
        //block跳转充值
        if(![[USER objectForKey:@"confVersion"] isEqualToString:[USER objectForKey:@"versionKey"]]){
            self.jumpCharge();
        }
    }else if(self.type == 3){
        //block确认兑换
        self.exchange();
    }else if(self.type == 4){
        //退出圈子
        self.quit();
    }else if(self.type == 5){
        //送礼
        self.zbBlock(2);
    }else if(self.type == 6){
        self.confirmClickBlock();
    }else if(self.type == 7){
        self.createMyPetBlock();
    }
    [self removeFromSuperview];
}
-(void)selectBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        selectImage.image = [UIImage imageNamed:@"atUsers_selected.png"];
        if(self.type == 1){
            [USER setObject:@"0" forKey:@"showCostAlert"];
        }else if(self.type == 6){
            [USER setObject:@"1" forKey:@"notShowVoteCostAlert"];
        }
        
    }else{
        selectImage.image = [UIImage imageNamed:@"atUsers_unSelected.png"];
        if(self.type == 1){
            [USER setObject:@"1" forKey:@"showCostAlert"];
        }else if(self.type == 6){
            [USER setObject:@"0" forKey:@"notShowVoteCostAlert"];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
