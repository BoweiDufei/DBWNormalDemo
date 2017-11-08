// UIImage+Resize.h
// 调整（扩展）
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>
@interface UIImage (Resize)
/**
 *  制作群头像
 *
 *  @param headArr UIimageView 数组
 *
 *  @return 群头像
 */
+(UIImage *)convertViewwithArr:(NSMutableArray *)headArr;
/**
 *  截取后两个字制作图片
 *
 *  @param name 字符串
 *
 *  @return 图片
 */
+(UIImage *)getImgforName:(NSString *) name;

/**
 获取视频缩略图

 @param videoURL 视频地址【本地/网络】

 @return 视频缩略图
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL ;
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
#pragma mark -合成成一张图
- (UIImage *)imageWithGlImage:(UIImage *)image2;
/**
 *  转换图片大小
 *  Create by liuxinyan on 15/11/28
 *  @param Newsize 新的大小
 *
 *  @return 新的大小的UIImage
 */
-(UIImage *)TransformtoSize:(CGSize)Newsize;
/**
 *  转通道填充
 *
 *  @param tintColor 填充颜色
 *
 *  @return 填充后的图片
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
/**
 *  UIView 转换为 UIImage
 *
 *  @param view 视图
 *  @return UIImage
 */
+(UIImage*)imageWithView:(UIView *)view;
//黑白图片
- (UIImage*)grayscaletype:(int)type;
@end
