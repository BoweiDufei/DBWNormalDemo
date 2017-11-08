// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Resize.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
// Private helper methods
@interface UIImage ()
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
@end

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage;
    if ([self respondsToSelector:@selector(scale)] && [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    } else {
        croppedImage = [UIImage imageWithCGImage:imageRef];
    }
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    return croppedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}
#pragma mark -合成成一张图
- (UIImage *)imageWithGlImage:(UIImage *)image2
{
    CGFloat s = 0;
    if(image2.size.width > self.size.width)
    {
        s = image2.size.width / self.size.width;
        UIGraphicsBeginImageContext(image2.size);
        [image2 drawInRect:CGRectMake(0, 0, image2.size.width,image2.size.height)];
        [self drawInRect:CGRectMake(0, 0, self.size.width * s,self.size.height * s)];
    }
    else
    {
        s = self.size.width / image2.size.width;
        UIGraphicsBeginImageContext(self.size);
        [image2 drawInRect:CGRectMake(0, 0, image2.size.width  * s,image2.size.height  * s)];
        [self drawInRect:CGRectMake(0, 0, self.size.width,self.size.height)];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  转换图片大小
 *  Create by liuxinyan on 15/11/28
 *  @param Newsize 新的大小
 *
 *  @return 新的大小的UIImage
 */
- (UIImage *)TransformtoSize:(CGSize)newsize{
    
    
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(newsize, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(newsize);
    }
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect;
    if ([self respondsToSelector:@selector(scale)])
        newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale));
    else
        newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage;
    if ([self respondsToSelector:@selector(scale)] && [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    } else {
        newImage = [UIImage imageWithCGImage:newImageRef];
    }
    
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}
- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
/**
 *  UIView 转换为 UIImage
 *
 *  @param imageWithView UIView
 *
 *  @return UIImage
 */
+(UIImage*)imageWithView:(UIView*)view{
    
    UIGraphicsBeginImageContext(view.bounds.size);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
/**
 *  获取视频封面，本地视频，网络视频都可以用
 *
 *  @param videoURL <#videoURL description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMake(1, 1000); //CMTimeMakeWithSeconds(2.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
    
    return thumbImg;
    
}
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
+(UIImage *)getImgforName:(NSString *) name{
    if (name.length==0) {
        return nil;
    }else{
        float width=44;
        UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        UILabel *namefrist=[[UILabel alloc]initWithFrame:headview.bounds];
        namefrist.textAlignment=NSTextAlignmentCenter;
        namefrist.font=[UIFont systemFontOfSize:20];
        if ([name length]>2) {
            namefrist.text=[name substringFromIndex:[name length]-2];
        }else{
            namefrist.text=name;
        }
        
        [headview addSubview:namefrist];
        return [UIImage imageWithView:headview];;
    }
    
}
+(UIImage *)convertViewwithArr:(NSMutableArray *)headArr{
    float width=44;
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    headview.backgroundColor=[UIColor colorWithRed:235 green:235 blue:235 alpha:1];
    switch (headArr.count) {
        case 0:{
            
        }break;
        case 1:{
            UIImageView *img=[headArr firstObject];
            img.frame= headview.bounds;
            [headview addSubview:img];
        }
            break;
        case 2:{
            float em= width/headArr.count;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            img.frame= CGRectMake(0, em/2, em, em);
            img1.frame=CGRectMake(em, em/2, em, em);
            [headview addSubview:img];
            [headview addSubview:img1];
        }
            break;
        case 3:{
            float em= width/2;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            img.frame= CGRectMake(0, em, em, em);
            img1.frame= CGRectMake(em, em, em, em);
            img2.frame= CGRectMake(em/2, 0, em, em);
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
        }
            break;
        case 4:{
            float em= width/2;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            img.frame= CGRectMake(0, em, em, em);
            img1.frame= CGRectMake(em, em, em, em);
            img2.frame= CGRectMake(0, 0, em, em);
            img3.frame= CGRectMake(em, 0, em, em);
            
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
        }
            break;
        case 5:{
            float em= width/3;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            UIImageView *img4=headArr[4];
            img.frame= CGRectMake(0, em/2+em, em, em);
            img1.frame= CGRectMake(em, em/2+em, em, em);
            img2.frame= CGRectMake(2*em, em/2+em, em, em);
            img3.frame= CGRectMake(em/2, em/2, em, em);
            img4.frame= CGRectMake(em/2+em, em/2, em, em);
            
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
            [headview addSubview:img4];
            
        }
            break;
        case 6:{
            float em= width/3;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            UIImageView *img4=headArr[4];
            UIImageView *img5=headArr[5];
            img.frame= CGRectMake(0, em/2+em, em, em);
            img1.frame= CGRectMake(em, em/2+em, em, em);
            img2.frame= CGRectMake(2*em, em/2+em, em, em);
            img3.frame= CGRectMake(0, em/2, em, em);
            img4.frame= CGRectMake(em, em/2, em, em);
            img5.frame= CGRectMake(2*em, em/2, em, em);
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
            [headview addSubview:img4];
            [headview addSubview:img5];
        }
            break;
        case 7:{
            float em= width/3;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            UIImageView *img4=headArr[4];
            UIImageView *img5=headArr[5];
            UIImageView *img6=headArr[6];
            img.frame= CGRectMake(0, em, em, em);
            img1.frame= CGRectMake(em, em, em, em);
            img2.frame= CGRectMake(2*em, em, em, em);
            img3.frame= CGRectMake(0, 2*em, em, em);
            img4.frame= CGRectMake(em, 2*em, em, em);
            img5.frame= CGRectMake(2*em, 2*em, em, em);
            img6.frame= CGRectMake(em, 0, em, em);
            
            
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
            [headview addSubview:img4];
            [headview addSubview:img5];
            [headview addSubview:img6];
        }
            break;
        case 8:{
            float em= width/3;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            UIImageView *img4=headArr[4];
            UIImageView *img5=headArr[5];
            UIImageView *img6=headArr[6];
            UIImageView *img7=headArr[7];
            
            img.frame= CGRectMake(0, em, em, em);
            img1.frame= CGRectMake(em, em, em, em);
            img2.frame= CGRectMake(2*em, em, em, em);
            img3.frame= CGRectMake(0, 2*em, em, em);
            img4.frame= CGRectMake(em, 2*em, em, em);
            img5.frame= CGRectMake(2*em, 2*em, em, em);
            img6.frame= CGRectMake(em/2, 0, em, em);
            img7.frame= CGRectMake(em/2+em, 0, em, em);
            
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
            [headview addSubview:img4];
            [headview addSubview:img5];
            [headview addSubview:img6];
            [headview addSubview:img7];
        }
            break;
        default:{
            float em= width/3;
            UIImageView *img=[headArr firstObject];
            UIImageView *img1=headArr[1];
            UIImageView *img2=headArr[2];
            UIImageView *img3=headArr[3];
            UIImageView *img4=headArr[4];
            UIImageView *img5=headArr[5];
            UIImageView *img6=headArr[6];
            UIImageView *img7=headArr[7];
            UIImageView *img8=headArr[8];
            
            img.frame= CGRectMake(0, em, em, em);
            img1.frame= CGRectMake(em, em, em, em);
            img2.frame= CGRectMake(2*em, em, em, em);
            img3.frame= CGRectMake(0, 2*em, em, em);
            img4.frame= CGRectMake(em, 2*em, em, em);
            img5.frame= CGRectMake(2*em, 2*em, em, em);
            img6.frame= CGRectMake(0, 0, em, em);
            img7.frame= CGRectMake(em, 0, em, em);
            img8.frame= CGRectMake(2*em, 0, em, em);
            
            
            [headview addSubview:img];
            [headview addSubview:img1];
            [headview addSubview:img2];
            [headview addSubview:img3];
            [headview addSubview:img4];
            [headview addSubview:img5];
            [headview addSubview:img6];
            [headview addSubview:img7];
            [headview addSubview:img8];
        }
            break;
            
    }
    return [UIImage imageWithView:headview];
}
- (UIImage*)grayscaletype:(int)type{
    CGImageRef imageRef = self.CGImage;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    
    UInt8 *buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8 *tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            UInt8 brightness;
            switch (type) {
                case 1:
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    *(tmp + 0) = brightness;
                    *(tmp + 1) = brightness;
                    *(tmp + 2) = brightness;
                    break;
                case 2:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green * 0.7;
                    *(tmp + 2) = blue * 0.4;
                    break;
                case 3:
                    *(tmp + 0) = 255 - red;
                    *(tmp + 1) = 255 - green;
                    *(tmp + 2) = 255 - blue;
                    break;
                default:
                    *(tmp + 0) = red;
                    *(tmp + 1) = green;
                    *(tmp + 2) = blue;
                    break;
            }
        }
    }
    
    
    CFDataRef effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    UIImage *effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    return effectedImage;
}

@end
