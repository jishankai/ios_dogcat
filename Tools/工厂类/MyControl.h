//
//  MyControl.h
//  test_demo
//
//  Created by Apple on 13-3-6.
//  Copyright (c) 2013年 Apple. All rights reserved.
//
//使用此类，在工程pch文件里面加入该头文件，即可在工程内任意地方进行创建
//此类设计模式为最简单的工厂模式
//UI，mycontrol
//网络  httpdownload
//数据库  SQL


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyControl : NSObject
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)createViewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;

#pragma mark --判断导航的高度64or44
+(float)isIOS7;

+(UIAlertView *)createAlertViewWithTitle:(NSString *)title;

+(UIAlertView *)createAlertViewWithTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles;

+(NSString *)timeFromTimeStamp:(NSString *)timeStamp;
+(NSString *)timeStringFromStamp:(NSString *)timeStamp;
+(NSString *)leftTimeFromStamp:(NSString *)timeStamp;

#pragma mark - 屏幕截图
+(UIImage *)imageWithView:(UIView *)view;
+(void)saveScreenshotsWithImage:(UIImage *)image;

#pragma mark - 截图图片一部分
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

#pragma mark - 传入一个旧image和所需要的宽高，返回一个符合宽高比的image
+(UIImage *)returnImageWithImage:(UIImage *)oldImage Width:(float)width Height:(float)height;

//传入月数，返回年龄string
+(NSString *)returnAgeStringWithCountOfMonth:(NSString *)countOfMonth;

+(void)startLoadingWithStatus:(NSString *)status;
+(void)loadingSuccessWithContent:(NSString *)content afterDelay:(float)delay;
+(void)loadingFailedWithContent:(NSString *)content afterDelay:(float)delay;

//字典转data
+(NSData *)returnDataWithDictionary:(NSDictionary *)dict;
//data转字典
+(NSDictionary *)returnDictionaryWithData:(NSData *)data;
//路径文件转dictonary
+(NSDictionary *)returnDictionaryWithDataPath:(NSString *)path;

//NSArray转data
+(NSData *)returnDataWithArray:(NSArray *)array;
//路径文件转NSArray
+(NSArray *)returnArrayWithData:(NSData *)data;

//传进NSURL返回图片的宽高字典
+(NSDictionary *)imageSizeFrom:(NSURL *)imageUrl;

//限制图片大小
+(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;
+(NSData *)scaleToSize:(UIImage *)sourceImage;

+(NSData *)scaleImage:(UIImage *)sourceImage WithSize:(CGSize)TargetSize;



+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

+ (UIImage *)image: (UIImage *) image fitInSize: (CGSize) viewsize;
+(UIImage *)returnSquareImageWithImage:(UIImage *)image;

+(void)popAlertWithView:(UIView *)keyView Msg:(NSString *)msg;

//为URL添加不备份标签
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//抖动动画
+(void)animateIncorrectPassword:(UIView *)view;

//修正图片旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage;

+(void)setImageForBtn:(UIButton *)btn Tx:(NSString *)tx isPet:(BOOL)isPet;
+(void)setImageForImageView:(UIImageView *)imageView Tx:(NSString *)tx isPet:(BOOL)isPet;
+(void)setImageForBtn:(UIButton *)btn Tx:(NSString *)tx isPet:(BOOL)isPet isRound:(BOOL)isRound;
+(void)setImageForImageView:(UIImageView *)imageView Tx:(NSString *)tx isPet:(BOOL)isPet isRound:(BOOL)isRound;

//图片压缩
+(NSData*)compressImage:(UIImage*)image;

+(NSInteger)returnUnreadMessageCount;

//清除sdwebimage图片缓存
+(void)clearMemory;

//图片缩略图
+(void)thumbnailWithImage:(UIImage *)OriImage ImageView:(UIImageView *)imageView TargetLength:(float)length;


//+(void)updatePetsData;

+(NSURL *)returnClipThumbImageURLwithName:(NSString *)name Width:(NSInteger)w Height:(NSInteger)h;

+(NSURL *)returnThumbImageURLwithName:(NSString *)name Width:(NSInteger)w Height:(NSInteger)h;
+(NSURL *)returnThumbUserTxURLwithName:(NSString *)name Width:(NSInteger)w Height:(NSInteger)h;
+(NSURL *)returnThumbPetTxURLwithName:(NSString *)name Width:(NSInteger)w Height:(NSInteger)h;

#pragma mark -
+(void)setOriginX:(CGFloat)originX WithView:(UIView *)view;
+(void)setOriginY:(CGFloat)originY WithView:(UIView *)view;
+(void)setWidth:(CGFloat)width WithView:(UIView *)view;
+(void)setHeight:(CGFloat)height WithView:(UIView *)view;

+(CGFloat)returnOriginAndHeightWithView:(UIView *)view;
+(CGFloat)returnOriginAndWidthWithView:(UIView *)view;

+(void)setVerticalSpace:(CGFloat)space FromView:(UIView *)fromView ToView:(UIView *)toView;
+(void)setHorizonSpace:(CGFloat)space FromView:(UIView *)fromView ToView:(UIView *)toView;

+(BOOL)isShouldRegist:(UIViewController *)controller;


+(CGSize)returnSizeAboutString:(NSString *)str FontSize:(CGFloat)font DefaultSize:(CGSize)defaultSize;

//+(CGSize)returnImageSizeWithUrl:(NSString *)url;
@end
