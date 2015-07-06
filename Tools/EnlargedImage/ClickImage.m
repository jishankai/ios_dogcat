//
//  ClickImage.m
//  TableView
//
//  Created by LYZ on 14-1-13.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "ClickImage.h"

CGRect goBackRect; //返回的位置大小
float goBackDuration; //返回的时间
UIScrollView * goBackgroundView; // 返回到的view
UIImageView* goBackImageView; //
UIImageView* goBackFakeImageView; //
UIViewController* goBackViewController; //
UIActionSheet *sheet; //

@implementation ClickImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //fakeImage = [[UIImage alloc]init];
    }
    return self;
}
- (void)canClickIt:(BOOL)click {
    if (click==YES) {
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIt:)];
        [touch setNumberOfTapsRequired:1];
        self.userInteractionEnabled = YES;
        _duration = 0.3;
        [self addGestureRecognizer:touch];
    }
}
//
- (void)tapIt:(UIGestureRecognizer*)sender {
    [self showImage:(UIImageView*)sender.view];
}
// 显示放大的图片（只有图片）
- (void)showImage:(UIImageView *)defaultImageView{
    goBackDuration = _duration;
    UIImage *image = defaultImageView.image;
    window = [UIApplication sharedApplication].keyWindow;
    //5.20 将UIView改为ScrollView，使放大图片能够滑动
    goBackgroundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    // 5.20 ScrollView代理
    goBackgroundView.delegate = self;
    //
    defaultRect = [defaultImageView convertRect:defaultImageView.bounds toView:window];//关键代码，坐标系转换
    goBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:defaultRect];
    imageView.image = image;
    imageView.tag = 1;
    UIImageView *fakeImageView = [[UIImageView alloc]initWithFrame:defaultRect];
    //5.20 设置ScrollView内容大小
    goBackgroundView.contentSize = imageView.size;    //CGSizeMake(320, 460*10);
//    goBackgroundView.contentSize = defaultFrame.size;
//    NSLog(@"%f",imageView.size.height);
    [goBackgroundView addSubview:fakeImageView];
    [goBackgroundView addSubview:imageView];
    [window addSubview:goBackgroundView];
    if (clickViewController!=nil) {
        //截图
        if (!snapView) {
            snapView = clickViewController.view;
        }
            if(&UIGraphicsBeginImageContextWithOptions != NULL)
            {
                UIGraphicsBeginImageContextWithOptions(snapView.frame.size, NO, 0.0);
            } else {
                UIGraphicsBeginImageContext(snapView.frame.size);
            }
            [snapView.layer renderInContext:UIGraphicsGetCurrentContext()];
            fakeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        
        fakeImageView.image = fakeImage;
        [UIView animateWithDuration:_duration animations:^{
            imageView.alpha = 0;
            imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            fakeImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:(_duration/2) animations:^{
                goBackImageView = imageView;
                goBackFakeImageView = fakeImageView;
                goBackRect = defaultRect;
                
            } completion:^(BOOL finished) {
                goBackgroundView.alpha = 0;
                for (UIView* next = [self superview]; next; next = next.superview) {
                    UIResponder *nextResponder = [next nextResponder];
                    if ([nextResponder isKindOfClass:[UIViewController class]]) {
                        [((UIViewController*)nextResponder) presentViewController:clickViewController animated:NO completion:^{
                            ;
                        }];//可更改为UINavigation推入
                    }
                }
                goBackViewController = clickViewController;
            }];
        }];
    } else {
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        [goBackgroundView addGestureRecognizer:tap];
//        [tap release];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage)];
        [goBackgroundView addGestureRecognizer:longPress];
        sheet = [[UIActionSheet alloc] initWithTitle:@"保存到相册" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        
        defaultImageView.alpha = 0;
        // 5.20 放大时图的显示位置
        [UIView animateWithDuration:_duration animations:^{
            if (imageView.frame.size.height <= [UIScreen mainScreen].bounds.size.height) {
                imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            } else {
                imageView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
                // 5.20 高度误差，重新确定scrollview内容高度
                goBackgroundView.contentSize = imageView.frame.size;
//                NSLog(@"%f",image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            }
            
            goBackgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.93];
            
        } completion:^(BOOL finished) {
        }];
    }
}
+ (void)dismissClickView {
    UIView *snapView = goBackViewController.view;
    if(&UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(snapView.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(snapView.frame.size);
    }
    [snapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    goBackFakeImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    goBackgroundView.alpha = 1;
    [goBackViewController dismissViewControllerAnimated:NO completion:^{
        ;
    }];
    [UIView animateWithDuration:goBackDuration animations:^{
        goBackImageView.alpha = 1;
        goBackImageView.frame = goBackRect;
        goBackFakeImageView.frame = goBackRect;
    } completion:^(BOOL finished) {
        goBackViewController = nil;
        [goBackgroundView removeFromSuperview];
    }];
}
- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:_duration animations:^{
        imageView.frame = defaultRect;
        goBackgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [goBackgroundView removeFromSuperview];
    }];
}


- (void)setClickToViewController:(UIViewController*)cViewController {
    clickViewController = cViewController;
}
#pragma mark - 保存到相册
- (void)saveImage
{
    [sheet showInView:window];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageView * imageView = (UIImageView *)[window viewWithTag:1];
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
//    NSString *message = @"呵呵";
    if (!error) {
//        message = @"成功保存到相册";
        UIAlertView *alert = [MyControl createAlertViewWithTitle:@"已保存至相册"];
        
    }else{
        UIAlertView *alert = [MyControl createAlertViewWithTitle:@"保存失败"];
//        message = [error description];
    }
//    NSLog(@"message is %@",message);
}

@end

@implementation UIImageView (Click)
@dynamic canClick;

CGRect defaultFrame;
id dImageView;
- (void)canClickIt:(BOOL)click {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIt:)];
    [tap setNumberOfTapsRequired:1];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)tapIt:(UIGestureRecognizer*)sender {
    [UIImageView showImage:(UIImageView*)sender.view];
}
+ (void)showImage:(UIImageView *)defaultImageView{
    UIImage *image = defaultImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    defaultFrame = [defaultImageView convertRect:defaultImageView.bounds toView:window];//关键代码，坐标系转换
    backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    backgroundView.alpha = 0;
    dImageView = defaultImageView;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:defaultFrame];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.5 animations:^{
        defaultImageView.alpha = 0;
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = defaultFrame;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        ((UIImageView*)dImageView).alpha = 1;
        [backgroundView removeFromSuperview];
    }];
}

@end

