
//

#import <UIKit/UIKit.h>

#pragma mark - Funtion Method (宏 方法)
#ifndef __OPTIMIZE__
#define NSLog_d(FORMAT,...) NSLog(@"%@[%d行]:%@",[[[NSString stringWithFormat:@"%s",__FILE__] componentsSeparatedByString:@"/"] lastObject], __LINE__,[NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define NSLog_d(...) {}
#endif
//
//// 颜色(RGB)
//#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kWindowHeight  [[UIScreen mainScreen] bounds].size.height
#define kWindowWidth  [[UIScreen mainScreen] bounds].size.width
#define headportraitimage [UIImage imageNamed:@"placeimage"]
#define kMainTableViewBackColor RGBCOLOR(244,245,246)

#define kMainTextLabelDefaultColor RGBCOLOR(80,80,80)
#define kMainBorderColor RGBCOLOR(224,224,224)
//枚举
#define BTFont(_size_) [UIFont fontWithName:@"FZLanTingHei-L-GBK" size:_size_]
typedef enum{
    DBWToolBarButtonTypeCamera,
    DBWToolBarButtonTypePictures,
    DBWToolBarButtonTypeMenu,
    DBWToolBarButtonTypeFace,
}DBWToolBarButtonType;
/**
 上传类型
 */
typedef enum {
    /**
     *  头像
     */
    fileTypephoto = 1,
    /**
     *  图片
     */
    fileTypeimage,
    /**
     *  评论
     */
    fileTypecomment
}fileType;

typedef enum {
    /**
     *  图片
     */
    fileImage = 1,
    /**
     *  其他
     */
    fileOther
}filesTypeStr;
//*******************封装一个view，排列图片为三行三**************************//
#pragma mark - 封装一个view
@interface BackView : UIView
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//二维码制作
//taskStype转换成中文
+(NSString *)changeTaskStypeToChinese:(NSString *)stype;
//中文转换成taskStype
+(NSString *)changeChineseToTaskStype:(NSString *)Chinese;
//优先级转换成中文
+(NSString *)changeChineseToProity:(NSString *)Chinese;
+(NSString *)changeProityToChinese:(NSString *)Proity;
+(NSString *)appendingStringFromArry:(NSArray *)arry;
+(NSString *)appendingBlankFromArry:(NSArray *)arry;
-(void)addImage:(UIImage *)image;
//监听键盘上下
+(void)keyboardUp:(UIView *)keyView note:(NSNotification *)note;
//汉字转换拼音
+ (NSString *)transformToPinyin:(NSString *)text;
//URL编码
+ (NSString *)URLEncodedString:(NSString *)url;
//普通MD5加密
+(NSString*)md5:(NSString *)code;
//UTF16MD5加密
+ (NSString *)md5ForUTF16:(NSString *)code;
//view左右摆动
+ (void)shakeHorizontally:(UIView *)taget;
//view左右饭庄
+ (void)flipWithDurationDirection:(NSInteger)direction tagetView:(UIView *)taget;
//计算缓存数据大小
+ (float ) folderSizeAtPath:(NSString*) folderPath;
//把UIImageView切成圆形
-(UIImageView *)clipToCircleFrom:(UIImageView *)origonImageView;
+(void)animationTranscationMethod;
@end
#pragma mark - 网络发送封装
#import <AFNetworking/AFNetworking.h>
//*******************网络发送封装AFN*************************************//
/**
 *  网络发送封装AFN
 */
typedef void(^success)(NSDictionary *dict);
typedef void(^failue)(NSError *error);
@interface DBWSendNetTool : NSObject
+(NSString *)UrlstringByDic:(NSDictionary *)params;
+ (void)downFileWithUrl:(NSString *)url andVideoPath:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock  success:(void (^)(NSURL * json))success fail:(void (^)(NSError* err))fail;
+ (NSURLSessionDataTask *)JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
//+ (void)JSONDataSynchronousWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
/**
 *  POST jsonData
 *
 *  @param url     <#url description#>
 *  @param dict    <#dict description#>
 *  @param success <#success description#>
 *  @param fail    <#fail description#>
 */
+ (void)postJSONDataWithUrl:(NSString *)url Data:(id)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
+ (void)postJSONWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
+ (void)DBW_JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
+ (void)Activity_JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
+ (void)DBW_JSONDataWithFirstGetDataFromLocation:(BOOL)fromLoacationBool Url:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail;
/**
 *  上传图片
 *
 *  @param url        上传地址
 *  @param image      上传图片
 *  @param completion 成功后返回
 *  @param errorBlock 失败后返回
 *
 *  @return return value description
 */
+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                                       image:(UIImage *)image
                                    fileName:(NSString *) fileName
                                        Data:(NSMutableDictionary *)dict
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock;

+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                             andLoacationUrl:(NSString *)DocumentLocationUrl
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock;
#pragma mark - 应用上传
/**
 *  【应用】图片上传
 *
 *  @param url        上传地址
 *  @param image      图片
 *  @param fileName   图片名称
 *  @param completion <#completion description#>
 *  @param errorBlock <#errorBlock description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                                       image:(UIImage *)image
                                    fileName:(NSString *) fileName
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock;


+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                                   imageData:(NSData *)imagedata
                                    fileName:(NSString *) fileName
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock;
/**
 *  【应用】文件上传
 *
 *  @param url                 上传地址
 *  @param DocumentLocationUrl 文件位置
 *  @param completion          <#completion description#>
 *  @param errorBlock          <#errorBlock description#>
 *
 *  @return <#return value description#>
 */
+ (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)url
                            andLoacationUrl:(NSString *)DocumentLocationUrl
                                 completion:(void (^)(id json))completion
                                 errorBlock:(void (^)(NSError* err))errorBlock;
@end
#pragma mark - 快速创建一个button和nav右上角图片
//*******************快速创建一个button和nav右上角图片*************************************//
@interface DBWMyButton : NSObject

+ (UIButton *)createNormalButton:(id)target frame:(CGRect)rect btnTitle:(NSString *)title act:(SEL)act normaleImage:(NSString *)normaleImage hightImage:(NSString *)hightImageName;
//初始化右上角图片
+ (UIButton *)initNavigationLRitem:(id)target  act:(SEL)act normaleImage:(NSString *)normaleImage hightImage:(NSString *)hightImageName;

@end

#pragma mark - 封装字符串长高
//*******************封装字符串长高*************************************//
@interface StringWidthAndHeightMethod : NSObject

+(NSString *)getCurrentDate;
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

@end
#pragma mark - 快速得到沙盒地址
//*******************快速得到沙盒地址*************************************//
@interface GetDownAddress : NSObject
+ (NSString *)getDocumentAddress:(NSString *)Str;
+ (NSString *)getCacheAddress:(NSString *)Str;
@end

#pragma mark - 键盘收回的方法
//*******************键盘收回的方法*************************************//
//@interface UIViewController (DismissKeyboard)
//-(void)setupForDismissKeyboard;
//@end

#pragma mark - 拖拽气泡方法
//*******************拖拽气泡方法*************************************//
@interface UnReadBubbleView : UIView
//气泡上显示数字的label
//the label on the bubble
@property (nonatomic,strong)UILabel *bubbleLabel;
//气泡的直径
//bubble's diameter
@property (nonatomic,assign)CGFloat bubbleWidth;

//气泡粘性系数，越大可以拉得越长
//viscosity of the bubble,the bigger you set,the longer you drag
@property (nonatomic,assign)CGFloat viscosity;

@property (nonatomic,assign)CGFloat breakViscosity;

//气泡颜色
//bubble's color
@property (nonatomic,strong)UIColor *bubbleColor;

//GameCenter动画 default NO
//if you want show GameCenter Animation you can set it yes default NO
@property (nonatomic,assign)BOOL showGameCenterAnimation;
//允许拖拽手势 default yes
//allow PanGestureRecognizer default yes
@property (nonatomic,assign)BOOL allowPan;
-(void)start;
+(UnReadBubbleView *)creatAunReadButtonView;
@end


#pragma mark - 控制字符串的长度
//*******************控制字符串的长度*************************************//
@interface DBWMyString : NSObject
+ (NSString *)getSubStringBySize:(NSString *)textStr andSize:(int)Strsize;

@end


//*******************判断是否是第一次登录**************************//
#pragma mark - 判断是否是第一次登录
@interface DBWFirstLogin : NSObject
+(BOOL)firstLogin;
+(void)saveCurrentVersion;

+(BOOL)firstLoginWithControllerString:(NSString *)controllerSting;
+(void)saveCurrentVersionWithControllerString:(NSString *)controllerSting;
@end

//*******************简单的封装**************************//
#pragma mark - 简单的封装
//如果要将一个自定义对象保存到文件中，必须实现nscoding协议
@interface DBW_MyPackages : NSObject
//图片压缩到指定大小
+ (UIImage*)dealImage:(UIImage *)source ByScalingAndCroppingForSize:(CGSize)targetSize;
/**计算label行间距,注意label.text一定有值*/
+(CGFloat)labelLinePaddingWithText:(UILabel *)label andPaddingHeigh:(CGFloat)padding;
//判断星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//运行时runtime
+(void)runTimeByInstrance:(id)weakVC;
//版本对比，是否高于7.0系统
+(BOOL)higherThanSeven;
//转化图片大小
+ (UIImage *)TransformOriganImage:(UIImage *)currentImage toSize:(CGSize)newsize;
//手机号验证
+ (BOOL)valiMobile:(NSString *)mobile;
//邮箱验证
+ (BOOL)valiEmail:(NSString *)email;
/**
 *  数字验证
 *
 *  @param number number description
 *
 *  @return YES:NO
 */
+ (BOOL)valiNumber:(NSString *)number;
+ (BOOL)valifloat:(NSString *)floatstr;
+(BOOL)MyselfTotalStr:(NSString *)totalStr ContainsSubString:(NSString *)sub;
+(UIColor *)dbwFirstFontColor;
+(UIColor *)dbwSecondFontColor;
//计算label 宽高
+(CGSize)sizeWithText:(UILabel *)lable maxSize:(CGSize)maxSize;
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;
//计算label 特定字体的宽高
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize andSpecialFont:(CGFloat)FontSize;

+(CGSize)defaultSizeWithText:(NSString *)text;

+(CGSize)sizeWithFont:(UIFont *)textFont andMaxSize:(CGSize)maxSize andText:(NSString *)text;

//返回两个frame的最大Y值
+(CGFloat)getMaxYBetweenOneFrame:(CGRect)oneFrame andTwoFrame:(CGRect)twoFrame;

//获得documentPahts
+(NSString *) getDoucumentPaths:(NSString *)filePath;
//获得cachesPahts
+(NSString *) getCachesPaths:(NSString *)filePath;

+(BOOL)saveObjectOf:(id)object toFile:(NSString *)path;

//创建一个button
+(UIButton *)getDefaultButton:(id)target action:(SEL)action andTitleName:(NSString *)titlename normal_image:(NSString *)normal_name highlighted_image:(NSString *)highlighted_name background_image:(NSString *)background_image titlefont:(CGFloat)font titlepadding:(CGFloat)padding;

//从XIB中创建一个自定义cell
+(UITableViewCell *)cellWithTableView:(UITableView *)tableView andIdenty:(NSString *)identifier NibNamed:(NSString *)nibName;
//创建一个可重用的headerAndfooterView,在viewForHeaderInSection中调用
+(UITableViewHeaderFooterView *)headerFooterViewWithTableView:(UITableView *)tableView andIdenty:(NSString *)identifier NibNamed:(NSString *)nibName;
//得到一个纯颜色的图片
+(UIImage *)imageWithColor:(UIColor *)color;
//得到一个随机颜色
+(UIColor *)getRandomColoralpha:(CGFloat)alpha;
//把一个图片包装成40*40大小的barbuttonItem
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action andSize:(CGFloat)imageW;
//汉子转拼音
+(NSString *)ChineseCharacterChangToSpell:(NSString *)ChineseCharacter;
//数据库－－－存
//路径
+(BOOL)shareFMDBwithPath:(NSString *)fmdbpath;
+(BOOL)addStatus:(NSDictionary *)dict ByStr:(NSString *)destionStr andUserId:(NSString *)userId;
+(void)addstatusFromArry:(NSArray *)dictArry ByStr:(NSString *)destionStr andUserId:(NSString *)userId;
//数据库－－-取
+(NSDictionary *)getDictionFromSqliteByStr:(NSString *)destionStr andUserId:(NSString *)userId;
//将一字符串按照固定长度截取，并返回一个数组
+(NSMutableArray *)compentStrByLength:(NSInteger)lengthNumber andOrignString:(NSString *)orignStr;
@end


@interface UIBarButtonItem (Extension)

+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

@end

@interface UIImage (Exness)
-(UIImage *)dbw_getCicleImage;
+(UIImage *)dbwresizeImage:(NSString *)imageName;
+ (UIImage *)resizeImage:(NSString *)imageName;
/**
 *  裁剪图片
 */
- (UIImage *)dbw_clipImageInRect:(CGRect)rect;
-(UIImage*) circleImageWithParam:(CGFloat) inset;
/**
 *  裁剪图片
 */
+ (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius;
@end
@interface NSString (Exness)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end

//*******************简单的封装**************************//
#pragma mark - 字符串中是否含有中文
//如果要将一个自定义对象保存到文件中，必须实现nscoding协议
@interface ChineseInclude : NSObject
+ (BOOL)isIncludeChineseInString:(NSString*)str;
@end


//*******************简单的封装**************************//
#pragma mark - 其他封装
//如果要将一个自定义对象保存到文件中，必须实现nscoding协议
@interface OtherEasyFuncation : NSObject
//富文本处理
+(NSMutableAttributedString *)attributeString:(NSString *)fromStr andColor:(UIColor *)fromColor andAppendString:(NSString *)rightString andColor:(UIColor *)rightColor;
+(UIView *)CRMBuildBlankImageView;

+(UIWebView *)openTelephoneWithNumber:(NSString *)phoneNumberStr;
+ (UIColor *) colorWithHexString: (NSString *)color;//16进制颜色转换
+(NSMutableDictionary *)getCurrentWifiInformation;
+(void)shapeWithMask;
+(void)rotateToUpright;
+(void)rotateToLeft;
+ (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text;
+(UIActivityIndicatorView *)showflowinView:(UIView *)bodyView;
+(void)hiddenFlowerInview:(UIView *)view;
//显示加载（菊花）
+(void)shwoFlowerOnview:(UIView *)view;
+(void)hiddenFlowerOnview:(UIView *)view;
//计算page方法  arry:当前数组  onceNo:一次请求返回文件数量一般是10
+(NSInteger)getPageFromeArry:(NSMutableArray *)arry andOnceFileNo:(NSInteger)onceNo;
//计算文件夹文件大小总和
+(NSInteger)cachesFileSizeWithPath:(NSString *)path;
+ (NSString *)getCurrentDateWithString;
/*
 *时间格式转换
 */
+(NSString *)getCutypetimeFromStr:(NSString *)datetime withFormat:(NSString *)format;
+(NSString *)getCutypetimeFromDate:(NSDate *)datetime withFormat:(NSString *)format;
//压缩图片
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;
+(BOOL)adjustIfRunYear:(int)year;
//scrollview上下滑动，navigationbar变色值
+(CGFloat)getNavigationBarAlphWithScrollViewOffset:(CGFloat)offset;
//添加消失donghua
+(CATransition *)getFadeAnimation;
+(BOOL)isBlank:(id)string;
/**查看是否是空字符串或者<NULL>格式*/
+(BOOL) isBlankString:(NSString *)string;
//返回空字符或字符
+(NSString *)RetBlankString:(NSString *)string;
+(UIImage *)imageFromView:(UIView *)snapView;
+(NSInteger)getMaxRownumberWithTotalElements:(NSInteger)totalNmber andEveryRowcount:(NSInteger)everyNumber;
+(void)buildBankImgWithTabelView:(UITableView *)tableView andAdjustWithArry:(NSMutableArray *)arry andImgs:(NSString *)imgs andShowWords:(NSString *)words andTBHeight:(CGFloat)tbHeigth;
+(UIView *)buildImgviewWithStr:(NSString *)imgs andShowWords:(NSString *)words andTBHeight:(CGFloat)tbHeigth;
+(void)buildBankImgWithTabelView:(UITableView *)tableView andAdjustWithArry:(NSMutableArray *)arry;
+(void)buildBankImgWithCollectionView:(UICollectionView *)collectionView andAdjustWithArry:(NSMutableArray *)arry;
+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2;//合并图片
+(UIImage *)getProgressImageWithRect:(CGRect)imgRect andStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor;//渐进色图片
+(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle;//3d旋转view
@end

#pragma mark - UIViewController的扩展方法，判断bool值是否为真，如果是执行第一个方法，不是的话执行第二个方法
@interface UIViewController(DBWExtession)
-(void)ifBool:(BOOL)flag performFirstAct:(SEL)firstAct orPerformSecondAct:(SEL)secondAct;
@end

@interface NSString(DBWExtession)
- (NSString *)removeHTML2;
- (NSString *)removeHTML;
/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原
 */
- (NSString *)base64DecodedString;

-(NSDictionary *)changeJsonUrlToDictionary;
@end

#pragma mark - 语音方法
//*******************动画*************************************//
@interface DBWSpeakMethod : NSObject
+(void)startSpeakWithText:(NSString *)text;
+(void)stopSpeaking;
@end

typedef void(^CancelBlcok)(NSString * text);
typedef void(^SuccessBlcok)(NSString * text);
typedef void(^CompleteBLock)(id obj);
typedef void(^Complete2BLock)(id obj,id obj2);
@interface DBWAlertView : NSObject
+(instancetype)alertView;
-(void)createAlertViewStyle:(UIAlertViewStyle )stype andTitle:(NSString *)title andMessage:(NSString *)message andcancelButton:(NSString *)cancelStr andotherButton:(NSString *)otherStr andCancelBlcok:(CancelBlcok)cancel andSureBlock:(SuccessBlcok)sureBlock;
-(void)createAlertViewStyle:(UIAlertViewStyle )stype andTitle:(NSString *)title andCancelBlcok:(CancelBlcok)cancel andSureBlock:(SuccessBlcok)sureBlock;

@end
