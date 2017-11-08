

#import "DBW_Package.h"
#import <objc/runtime.h>
#import "UIImage+Resize.h"
#import "AppUtil.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <FMDB/FMDB.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface BackView()

@end
//自定义一个view，并且布局三列N行的图片
#pragma mark -自定义一个view，并且布局三列N行的图片
@implementation BackView
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(NSString *)changeTaskStypeToChinese:(NSString *)stype{
    if (stype == nil||[stype isEqualToString:@""]) {
        return @"";
    }
    NSInteger stype_new = [stype integerValue];
    switch (stype_new) {
        case 0:
            return @"检测任务";
            break;
        case 1:
            return @"设计";
            break;
        case 2:
            return @"开发";
            break;
        case 3:
            return @"测试";
            break;
        case 4:
            return @"研究";
            break;
        case 5:
            return @"讨论";
            break;
        case 6:
            return @"外出";
            break;
        case 7:
            return @"界面";
            break;
        case 8:
            return @"事务";
            break;
            
        default:
            return @"其他";
            break;
    }
    
    //import <coreImage>
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    [filter setDefaults];
//    
//    NSString *str = @"www.baidu.com";
//    NSData *dataStr = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:dataStr forKey:@"inputMessage"];
//    CIImage *dataImage = [filter outputImage];
//    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    tempImageView.image = [UIImage imageWithCIImage:dataImage];
//    [self.view addSubview:tempImageView];
    
}

+(NSString *)changeChineseToTaskStype:(NSString *)Chinese{
    
    NSArray *ChineseArry = @[@"检测任务",@"设计",@"开发",@"测试",@"研究",@"讨论",@"外出",@"界面",@"事务",@"其他"];
    __block NSUInteger key;
    [ChineseArry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:Chinese]) {
            key = idx;
        }
    }];
    NSString *stype = [NSString stringWithFormat:@"%lu",(unsigned long)key];
    return stype;
}
+(NSString *)changeChineseToProity:(NSString *)Chinese{
    NSArray *ChineseArry = @[@"一般任务",@"重要任务",@"紧急任务"];
    __block NSUInteger key;
    [ChineseArry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:Chinese]) {
            key = idx;
        }
    }];
    //对应1，2，3
    NSString *stype = [NSString stringWithFormat:@"%lu",(unsigned long)key+1];
    return stype;
}
+(NSString *)changeProityToChinese:(NSString *)Proity{
    if (Proity == nil||[Proity isEqualToString:@""      ]) {
        return @"";
    }
    NSInteger Proity_new = [Proity integerValue];
    switch (Proity_new) {
        case 1:
            return @"一般任务";
            break;
        case 2:
            return @"重要任务";
            break;
        default:
            return @"紧急任务";
            break;
    }
}
+(NSString *)appendingStringFromArry:(NSArray *)arry{
    __block NSString *str = @"";
    if (arry.count == 0) {
        return @"";
    }
    [arry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([str isEqualToString:@""]) {
                str=[NSString stringWithFormat:@"%@",obj];
            }else{
                str=[NSString stringWithFormat:@"%@,%@",str,obj];
            }
        }
    }];
    return str;
}
+(NSString *)appendingBlankFromArry:(NSArray *)arry{
    __block NSString *str = @"";
    if (arry.count == 0) {
        return @"";
    }
    [arry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            if ([str isEqualToString:@""]) {
                str=[NSString stringWithFormat:@"%@",obj];
            }else{
                str=[NSString stringWithFormat:@"%@ %@",str,obj];
            }
        }
    }];
    return str;
}
-(void)addImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = image;
    [self addSubview:imageView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat imageW = 60;
    CGFloat imageH = 60;
    CGFloat btnPading = 20;
    CGFloat padding = (self.bounds.size.width - 3*imageW)/4;
    for (int i=0; i<count; i++) {
        UIImageView *imag = self.subviews[i];
        imag.tag = i;
        CGFloat imageX = padding + (i%3)*(imageW+padding);
        CGFloat imageY = (i/3)*(imageW+padding);
        NSLog(@"%f----第几个%d",imageX,i);
        imag.frame = CGRectMake(imageX, imageY, imageW, imageH);
        
        UIButton *rightBtn = [[UIButton alloc]init];
        [rightBtn setBackgroundColor:[UIColor redColor]];
        rightBtn.tag = i;
        rightBtn.frame = CGRectMake(imageW - btnPading, 0, btnPading, btnPading);
        [imag addSubview:rightBtn];
        
        [rightBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)deleteImageView:(UIButton *)btn{
    
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    for (UIImageView *tempIV in self.subviews) {
        if (tempIV.tag == btn.tag) {
            [tempIV removeFromSuperview];
        }
    }
    [self layoutSubviews];
}
//监听键盘上下
//NSNotification为UIKeyboardWillChangeFrameNotification的通知

+(void)keyboardUp:(UIView *)keyView note:(NSNotification *)note{
    // 1.获取键盘的Y值
    NSDictionary *dict  = note.userInfo;
    CGRect keyboardFrame = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    // 获取动画执行时间
    CGFloat duration = [dict[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    // 2.计算需要移动的距离
    CGFloat sizeHeight = kWindowHeight - 64;
    CGFloat translationY = keyboardY - sizeHeight;
    
    [UIView animateWithDuration:duration delay:0.0 options:7 << 16 animations:^{
        // 需要执行动画的代码
        keyView.transform = CGAffineTransformMakeTranslation(0, translationY);
    } completion:^(BOOL finished) {
        // 动画执行完毕执行的代码
    }];
}


//汉字转拼音
+ (NSString *)transformToPinyin:(NSString *)text {
    NSMutableString *mutableString = [NSMutableString stringWithString:text];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}
//URL编码转化
+ (NSString *)URLEncodedString:(NSString *)url{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)url,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
}

//图片左右摆动方法
//view左右摆动
+ (void)shakeHorizontally:(UIView *)taget{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.5;
    animation.values = @[@(-12), @(12), @(-8), @(8), @(-4), @(4), @(0) ];
    [taget.layer addAnimation:animation forKey:@"shake"];
}

+ (void)flipWithDurationDirection:(NSInteger)direction tagetView:(UIView *)taget
{
    NSString *subtype = nil;
    
    switch (direction)
    {
        case 0:
            subtype = @"fromTop";
            break;
        case 1:
            subtype = @"fromLeft";
            break;
        case 2:
            subtype = @"fromBottom";
            break;
        case 3:
        default:
            subtype = @"fromRight";
            break;
    }
    
    CATransition *transition = [CATransition animation];
    
    transition.startProgress = 0;
    transition.endProgress = 1.0;
    transition.type = @"flip";
    transition.subtype = subtype;
    transition.duration = 0.3f;
    transition.repeatCount = 2;
    transition.autoreverses = NO;
    
    [taget.layer addAnimation:transition
                      forKey:@"spin"];
}

+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//把UIImageView切成圆形
-(UIImageView *)clipToCircleFrom:(UIImageView *)origonImageView{
    CGFloat imageViewWidth = origonImageView.frame.size.width;
//    origonImageView.layer.cornerRadius=imageViewWidth*0.5;
//    origonImageView.layer.masksToBounds=YES;
    //1-用路径遮罩！
    CAShapeLayer *mask = [CAShapeLayer new];
    mask.path = [UIBezierPath bezierPathWithRoundedRect:origonImageView.bounds cornerRadius:imageViewWidth*0.5].CGPath;
    origonImageView.layer.mask = mask;
    
    
    
    //2- 通过图片生成遮罩，
    UIImage *maskImage = [UIImage imageNamed:@"someimg"];
    CALayer *mask2 = [CALayer new];
    mask2.frame = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    mask2.contents = (__bridge id _Nullable)(maskImage.CGImage);
//    origonImageView.layer.mask = mask2;
    
    
    return origonImageView;
}
+(void)animationTranscationMethod{
    [CATransaction begin];
    [CATransaction setCompletionBlock: ^{
        // 回调
    }];
    //do...something
    [CATransaction commit];
}

@end
#pragma mark - 网络发送封装
//*******************网络发送封装AFN*************************************//


@implementation DBWSendNetTool
static AFHTTPSessionManager *manager;
+(NSString *)UrlstringByDic:(NSDictionary *)params{
    NSString *paramsStr = @"";
    for(id key in params) {
        NSLog(@"key :%@  value :%@", key, [params objectForKey:key]);
        paramsStr = [paramsStr stringByAppendingString:key];
        paramsStr = [paramsStr stringByAppendingString:@"="];
        paramsStr = [paramsStr stringByAppendingString:[params objectForKey:key]];
        paramsStr = [paramsStr stringByAppendingString:@"&"];
    }
    // 处理多余的&以及返回含参url
    if (paramsStr.length > 1) {
        // 去掉末尾的&
        paramsStr = [paramsStr substringToIndex:paramsStr.length - 1];
        
    }
    return paramsStr;
}
+(AFHTTPSessionManager *)sharedHttpSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.0;
        __weak typeof(manager) weakmanager = manager;
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            /**
             *  导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
             */
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"lianda" ofType:@"cer"];//自签名证书
            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
            SecCertificateRef caRef = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)caCert);
            NSCAssert(caRef != nil, @"caRef is nil");
            NSSet *cerArray = [[NSSet alloc]initWithArray:@[caCert]];
            weakmanager.securityPolicy.pinnedCertificates = cerArray;
            
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
            
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential = nil;
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                if ([weakmanager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if (credential) {
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
            
            return disposition;
        }];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        //validatesDomainName 是否需要验证域名，默认为YES；
        securityPolicy.validatesDomainName = NO;//不验证证书的域名
        manager.securityPolicy  = securityPolicy;
    });
    
    return manager;
}
- (AFSecurityPolicy *)customSecurityPolicy {
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"xxx" ofType:@"cer"];//证书的路径
//    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    return  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
}

+ (NSURLSessionDataTask *)JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail {
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    NSString *idfv =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    dict[@"deviceId"]=[idfv uppercaseString];
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
        AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",@"text/json",nil];
    [manager.requestSerializer setValue:[idfv uppercaseString] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].userId forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].Organinfo.organId forHTTPHeaderField:@"organRootId"];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail) {
            NSError *error = [NSError errorWithDomain:@"请检查网络连接" code:-100 userInfo:nil];
            fail(error);
            return nil;
        }
    }
    NSURLSessionDataTask *task = [manager GET:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
//            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]&&responseObject[@"token"]) {
             [AppUtil sharedAppUtil].token = responseObject[@"token"];
        }

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //错误2000 没有权限
            NSDictionary *responseDic = responseObject;
            if ([responseDic.allKeys containsObject:@"errorCode"]&&![OtherEasyFuncation isBlank:responseDic[@"errorCode"]]&&[responseDic[@"errorCode"] integerValue]==2000) {
                UIView *keyView = [UIApplication sharedApplication].keyWindow;
                [MBProgressHUD showError:@"没有权限" toView:keyView];
                return ;
            }

        }
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD showError:@"网络连接错误" toView:nil];
        if (fail) {
            fail(error);
        }
    }];
    return task;
}
+ (void)JSONDataSynchronousWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail {
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    NSString *idfv =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    dict[@"deviceId"]=[idfv uppercaseString];
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;

    NSArray *urlStrArry = [url componentsSeparatedByString:@"?"];
    NSString *firstStr = urlStrArry.firstObject;
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    [manager.requestSerializer setValue:[idfv uppercaseString] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].userId forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].Organinfo.organId forHTTPHeaderField:@"organRootId"];

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail) {
            NSError *error = [NSError errorWithDomain:@"请检查网络连接" code:-100 userInfo:nil];
            fail(error);
            return;
        }
    }
    [manager GET:firstStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [responseObject start];
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        [responseObject waitUntilFinished];
        if (responseObject[@"token"]) {
            [AppUtil sharedAppUtil].token = responseObject[@"token"];
        }
        if ([responseObject[@"errorCode"] isEqualToString:@"2000"]) {//错误2000 没有权限
            UIView *keyView = [UIApplication sharedApplication].keyWindow;
            [MBProgressHUD showError:@"没有权限" toView:keyView];
            return ;
        }
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fail) {
            fail(error);
        }
    }];
}
+ (void)downFileWithUrl:(NSString *)url andVideoPath:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock  success:(void (^)(NSURL * json))success fail:(void (^)(NSError* err))fail {
      AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath,NSURLResponse *response) {
        
        return destination(targetPath,response);
        
    } completionHandler:^(NSURLResponse *response,NSURL *filePath, NSError *error) {
        //此处已经在主线程了
        if (!error) {
            if (success) {
                success(filePath);
            }
        }else{
            if (fail) {
                fail(error);
            }
        }
        
    }];
    [downloadTask resume];
}
/**
 *  POST jsonData
 *
 *  @param url     <#url description#>
 *  @param dict    <#dict description#>
 *  @param success <#success description#>
 *  @param fail    <#fail description#>
 */
+ (void)postJSONDataWithUrl:(NSString *)url Data:(id)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail
{
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    NSData *postData =[dict mj_JSONData];
    AFURLSessionManager *manager =  [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];;
        __weak typeof(manager) weakmanager = manager;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
        
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        /**
         *  导入多张CA证书（Certification Authority，支持SSL证书以及自签名的CA），请替换掉你的证书名称
         */
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"lianda" ofType:@"cer"];//自签名证书
        NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
        SecCertificateRef caRef = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)caCert);
        NSCAssert(caRef != nil, @"caRef is nil");
        NSSet *cerArray = [[NSSet alloc]initWithArray:@[caCert]];
        weakmanager.securityPolicy.pinnedCertificates = cerArray;
        
        
        NSArray *caArray = @[(__bridge id)(caRef)];
        NSCAssert(caArray != nil, @"caArray is nil");
        
        OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
        SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
        NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([weakmanager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        return disposition;
    }];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;//不验证证书的域名
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *idfv =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *headDic = [NSMutableDictionary dictionary];
    headDic[@"deviceId"]=[idfv uppercaseString];
    headDic[@"userId"]=[AppUtil sharedAppUtil].userId;
    headDic[@"token"]=[AppUtil sharedAppUtil].token;
    headDic[@"organRootId"]=[AppUtil sharedAppUtil].Organinfo.organId;
    [request setAllHTTPHeaderFields:headDic];
    [request setHTTPBody:postData];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if ([responseObject isKindOfClass:[NSData class]]) {
           
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
            NSLog(@"%@",responseObject);
        }
        if (!error) {
            if (success) {
                success(responseObject);
            }
        } else {
            if (fail) {
                fail(error);
            }
        }
    }] resume];

}
+ (void)postJSONWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail
{
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    NSString *idfv =[[[UIDevice currentDevice] identifierForVendor] UUIDString];
    dict[@"deviceId"]=[idfv uppercaseString];
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    [manager.requestSerializer setValue:[idfv uppercaseString] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].userId forHTTPHeaderField:@"userId"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[AppUtil sharedAppUtil].Organinfo.organId forHTTPHeaderField:@"organRootId"];
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}
+ (void)Activity_JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail {
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    NSArray *urlStrArry = [url componentsSeparatedByString:@"?"];
    NSString *firstStr = urlStrArry.firstObject;
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    [manager GET:firstStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        !success?:success(responseObject);
        return ;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
+ (void)DBW_JSONDataWithUrl:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail {
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    [self adjustNetStatue];
    NSMutableDictionary *keyDict = [dict copy];
    NSArray *urlStrArry = [url componentsSeparatedByString:@"?"];
    NSString *firstStr = urlStrArry.firstObject;
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
    
    if ([DBW_MyPackages MyselfTotalStr:firstStr ContainsSubString:@"board/boardUser.json"]) {
        [self newGetBoardUsersWithDict:dict success:^(id json) {//替换方法
            !success?:success(json);
        }];
        return;
    }
    
    NSString *dictStr = [keyDict mj_JSONString];//保证存储的唯一性 把参数也存入数据库key
    NSString *fmdbKey = [NSString stringWithFormat:@"%@%@",firstStr,dictStr];
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    [manager GET:firstStr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        BOOL resultBool = [DBW_MyPackages shareFMDBwithPath:@"nuknow.sqilte"];
        if (resultBool) {
            [DBW_MyPackages addStatus:responseObject ByStr:fmdbKey andUserId:[AppUtil sharedAppUtil].userId];
        }
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        if ([responseObject[@"errorCode"] isEqualToString:@"2000"]) {//错误2000 没有权限
            [SVProgressHUD showInfoWithStatus:@"没有权限"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            return ;
        }
        if ([responseObject[@"errorCode"] isEqualToString:@"10000"]) {//错误2000 没有权限
            !success?:success(responseObject);
            return ;
        }
        if ([AppUtil detectionJsonDic:responseObject]) {
            return ;
        }
        !success?:success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        !fail?:fail(error);
    }];
}

+ (void)DBW_JSONDataWithFirstGetDataFromLocation:(BOOL)fromLoacationBool Url:(NSString *)url Data:(NSMutableDictionary *)dict success:(void (^)(id json))success fail:(void (^)(NSError* err))fail{
    
    
    if (fromLoacationBool) {
        NSMutableDictionary *keyDict = [dict copy];
        NSArray *urlStrArry = [url componentsSeparatedByString:@"?"];
        NSString *firstStr = urlStrArry.firstObject;
//        NSString *dictStr = [keyDict mj_JSONString];//保证存储的唯一性 把参数也存入数据库key
        NSString *fmdbKey = [NSString stringWithFormat:@"%@",firstStr];
        NSDictionary *tempDict = [DBW_MyPackages getDictionFromSqliteByStr:fmdbKey andUserId:[AppUtil sharedAppUtil].userId];
        if (tempDict&&tempDict.count>0) {
            if (![tempDict[@"errorCode"]isEqualToString:@"102"]&&![AppUtil detectionJsonDic:[NSMutableDictionary dictionaryWithDictionary:tempDict]]) {
                !success?:success(tempDict);
            }
        }
    }
    [self DBW_JSONDataWithUrl:url Data:dict success:^(id json) {
        if (fromLoacationBool) {
            NSArray *urlStrArry = [url componentsSeparatedByString:@"?"];
            NSString *firstStr = urlStrArry.firstObject;
            NSString *fmdbKey = [NSString stringWithFormat:@"%@",firstStr];
            [DBW_MyPackages addStatus:json ByStr:fmdbKey andUserId:[AppUtil sharedAppUtil].userId];
        }
        !success?:success(json);
    }  fail:fail];
}
+(void)adjustNetStatue{
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态发生改变的时候调用这个block
//        switch (status) {
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"WIFI");
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"自带网络");
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:
//            {
//                [MBProgressHUD showError:@"请检查网络是否连接" toView:nil];
//            }
//                break;
//                
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未知网络");
//                break;
//            default:
//                break;
//        }
//    }];
//    // 开始监控
//    [mgr startMonitoring];
}
+(void)newGetBoardUsersWithDict:(NSDictionary *)dict success:(void (^)(id json))success{
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    [manager GET:COMBINSERVER_URL(@"board/getBoardUserList.json") parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        NSLog(@"%@",[responseObject mj_JSONString]);
        if ([responseObject[@"errorCode"] isEqualToString:@"0"]||[responseObject[@"errorCode"] isEqualToString:@"2001"]) {
            !success?:success(responseObject);
            return ;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
/**
 *  上传图片
 *
 *  @param url        上传地址
 *  @param image      上传图片
 *  @param filrType   上传类型
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
                                  errorBlock:(void (^)(NSError* err))errorBlock {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    
    if ( [OtherEasyFuncation isBlankString:fileName]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        fileName=[NSString stringWithFormat:@"%@%@.jpg",[AppUtil sharedAppUtil].userId,str];
        formatter=nil;
    }
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
    dict[@"uploadFileName"]=fileName;
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];;
    NSURLSessionDataTask *op= [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        errorBlock(error);
    }];
    return op;
}
+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                                       image:(UIImage *)image
                                    fileName:(NSString *) fileName
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    if (imageData.length>10000) {
        imageData = UIImageJPEGRepresentation(image, 0.8);
    }
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc] init];
    //申明返回的结果是json类型
    //如果报接受类型不一致请替换一致text/html或别的
    

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    NSURLSessionDataTask *op= [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        errorBlock(error);
    }];
    return op;
}

+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                                       imageData:(NSData *)imagedata
                                    fileName:(NSString *) fileName
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock {
    NSData *imageData = imagedata;
    AFHTTPSessionManager *manager = [DBWSendNetTool sharedHttpSessionManager];
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSURLSessionDataTask *op= [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"*/*"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        errorBlock(error);
    }];
    return op;
}

+ (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)url
                             andLoacationUrl:(NSString *)DocumentLocationUrl
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock{
    NSArray *docuArry = [DocumentLocationUrl componentsSeparatedByString:@"/"];
    NSString *lastAppendStr = @"";
    if (docuArry.count>0) {
        lastAppendStr = docuArry.lastObject;
    }
    
    NSData *tempFileData = [NSData dataWithContentsOfFile:DocumentLocationUrl];
    if (!tempFileData) {
        tempFileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:DocumentLocationUrl]];
    }
    NSString *fileName = lastAppendStr;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/xml",@"text/xml",@"text/plain",@"application/json",@"text/html",nil];
    NSURLSessionDataTask *op= [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:tempFileData name:@"file" fileName:fileName mimeType:@"*/*"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    return op;
}
/**公用上传**/
+ (NSURLSessionDataTask *)uploadImageWithUrl:(NSString *)url
                             andLoacationUrl:(NSString *)DocumentLocationUrl
                                  completion:(void (^)(id json))completion
                                  errorBlock:(void (^)(NSError* err))errorBlock {
    
    NSArray *docuArry = [DocumentLocationUrl componentsSeparatedByString:@"/"];
    NSString *lastAppendStr = @"";
    if (docuArry.count>0) {
        lastAppendStr = docuArry.lastObject;
    }
    
    NSData *tempFileData = [NSData dataWithContentsOfFile:DocumentLocationUrl];
    if (!tempFileData) {
        tempFileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:DocumentLocationUrl]];
    }
    NSString *fileName = lastAppendStr;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    dict[@"userId"]=[AppUtil sharedAppUtil].userId;
    dict[@"token"]=[AppUtil sharedAppUtil].token;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSURLSessionDataTask *op= [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:tempFileData name:@"upload" fileName:fileName mimeType:@"*/*"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSLog(@"%@",responseObject);
            NSString *date = [responseObject mj_JSONString];
            responseObject = [date mj_JSONObject];
        }
        completion(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
    return op;
}
@end
#pragma mark - 封装button
//*******************封装button*************************************//
@implementation DBWMyButton
+ (UIButton *)createNormalButton:(id)target frame:(CGRect)rect btnTitle:(NSString *)title act:(SEL)act normaleImage:(NSString *)normaleImage hightImage:(NSString *)hightImageName{
    UIButton *btn = [[UIButton alloc]initWithFrame:rect];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:normaleImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:act forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)initNavigationLRitem:(id)target  act:(SEL)act normaleImage:(NSString *)normaleImage hightImage:(NSString *)hightImageName{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:normaleImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:act forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    return btn;
}
@end


#pragma mark - 封装字符串长高
//*******************封装字符串长高*************************************//
@implementation StringWidthAndHeightMethod
+ (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

+(NSString *)getCurrentDate{
    NSDate *date1 = [NSDate date];
    //然后您需要定义一个NSDataFormat的对象
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
    dateFormat.dateFormat = @"yyyy年MM月dd日 HH:mm:SS";
    //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
    NSString * dateToString = [dateFormat stringFromDate:date1];
    return dateToString;
}
@end

#pragma mark - 快速得到沙盒地址
//*******************快速得到沙盒地址*************************************//
@implementation GetDownAddress
+ (NSString *)getDocumentAddress:(NSString *)Str{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *pathFile = [path stringByAppendingPathComponent:Str];
    return pathFile;
}
+ (NSString *)getCacheAddress:(NSString *)Str{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *pathFile = [path stringByAppendingPathComponent:Str];
    return pathFile;
}
@end
//#pragma mark - 键盘收回的方法
////*******************键盘收回的方法*************************************//
//@implementation UIViewController (DismissKeyboard)
//-(void)setupForDismissKeyboard{
//    UIButton *cover = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    cover.backgroundColor = [UIColor clearColor];
//    [cover addTarget:self action:@selector(keyboradDissmiss) forControlEvents:UIControlEventTouchUpInside];
//    [self.view insertSubview:cover atIndex:0];
//}
//-(void)keyboradDissmiss{
//    [self.view endEditing:NO];
//}
//@end


#pragma mark - 拖拽气泡  上
//*******************拖拽气泡方法*************************************//
@implementation UnReadBubbleView{
    
    UIBezierPath *cutePath;
    UIColor *fillColorForCute;
    
    CADisplayLink *displayLink;
    
    UIView *frontView;
    UIView *backView;
    CGFloat r1; // backView
    CGFloat r2; // frontView
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint initialPoint;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
    
    UIPanGestureRecognizer *pan;
    
    CGFloat critical;
}

+(UnReadBubbleView *)creatAunReadButtonView{
    UnReadBubbleView *unReadButton = [[UnReadBubbleView alloc] initWithFrame:CGRectMake(60, 60, 25, 25)];
    unReadButton.allowPan = YES;
    return unReadButton;
}

-(void)setFrame:(CGRect)frame{
    if (frame.size.width!=frame.size.height) {
        _bubbleWidth = frame.size.height=frame.size.width;
        initialPoint = frame.origin;
    }
    [super setFrame:frame];
}

-(void)setBubbleWidth:(CGFloat)bubbleWidth{
    _bubbleWidth=bubbleWidth;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bubbleWidth, bubbleWidth);
}

-(id)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, 25, 25);
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
        _viscosity=10;
        _breakViscosity=_viscosity/2.;
        _bubbleColor = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1];
        _allowPan=YES;
        _showGameCenterAnimation=NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
        _viscosity  = 10;
        _breakViscosity=_viscosity/2.;
        _bubbleColor = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1];
        _allowPan=YES;
        _showGameCenterAnimation=NO;
        self.bubbleWidth = frame.size.height;
        initialPoint = frame.origin;
    }
    return self;
}

-(void)removeFromSuperview{
    
    [frontView removeFromSuperview];
    [backView removeFromSuperview];
    frontView=nil;
    backView=nil;
    
    [super removeFromSuperview];
}

-(void)didMoveToSuperview{
    [self start];
}

-(void)start{
    
    shapeLayer = [CAShapeLayer layer];
    
    self.backgroundColor = [UIColor clearColor];
    frontView = [[UIView alloc]initWithFrame:CGRectMake(initialPoint.x,initialPoint.y, self.bubbleWidth, self.bubbleWidth)];
    
    r2 = frontView.bounds.size.width / 2;
    frontView.layer.cornerRadius = r2;
    frontView.backgroundColor = self.bubbleColor;
    
    backView = [[UIView alloc]initWithFrame:frontView.frame];
    r1 = backView.bounds.size.width / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.bubbleColor;
    
    self.bubbleLabel = [[UILabel alloc]init];
    self.bubbleLabel.frame = CGRectMake(0, 0, frontView.bounds.size.width, frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;
    
    [frontView insertSubview:self.bubbleLabel atIndex:0];
    
    [self.superview addSubview:backView];
    [self.superview addSubview:frontView];
    
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
    
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;
    
    backView.hidden = YES;
    
    if (_showGameCenterAnimation) {
        [self AddAniamtionLikeGameCenterBubble];
    }
    else{
        [self RemoveAniamtionLikeGameCenterBubble];
    }
    
    if (_allowPan) {
        [frontView addGestureRecognizer:pan];
    }
    else{
        [frontView removeGestureRecognizer:pan];
    }
}

-(void)dragMe:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self.superview];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        backView.hidden = NO;
        fillColorForCute = self.bubbleColor;
        if (_showGameCenterAnimation) {
            [self RemoveAniamtionLikeGameCenterBubble];
        }
        if (displayLink == nil) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        frontView.center = dragPoint;
        if (r1 <= _breakViscosity) {
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
            [displayLink invalidate];
            displayLink = nil;
            
        }
        else {
            CGFloat xDist = (frontView.frame.origin.x - initialPoint.x);
            
            CGFloat yDist = (frontView.frame.origin.y - initialPoint.y);
            critical=sqrtf(xDist*xDist+yDist*yDist);
        }
        
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        CGFloat xDist = (frontView.frame.origin.x - initialPoint.x);
        
        CGFloat yDist = (frontView.frame.origin.y - initialPoint.y);
        CGFloat newCritical=sqrtf(xDist*xDist+yDist*yDist);
        
        if (r1 <=_breakViscosity&&critical<newCritical) {
            [self removeFromSuperview];
        }
        else{
            backView.hidden = YES;
            fillColorForCute = [UIColor clearColor];
            [shapeLayer removeFromSuperlayer];
            [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                frontView.center = oldBackViewCenter;
            } completion:^(BOOL finished) {
                
                if (finished) {
                    if (_showGameCenterAnimation) {
                        [self AddAniamtionLikeGameCenterBubble];
                    }
                    [displayLink invalidate];
                    displayLink = nil;
                }
                
            }];
        }
    }
}

-(void)displayLinkAction:(CADisplayLink *)dis{
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    //    NSLog(@"%f", acosf(cosDigree));
    r1 = oldBackViewFrame.size.width / 2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    [self drawRect];
}

-(void)drawRect{
    backView.center = oldBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    if (backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        [self.superview.layer insertSublayer:shapeLayer below:frontView.layer];
    }
    
}

-(void)AddAniamtionLikeGameCenterBubble{
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(frontView.frame, frontView.bounds.size.width / 2 - 3, frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)RemoveAniamtionLikeGameCenterBubble{
    [frontView.layer removeAllAnimations];
}
@end
#pragma mark - 拖拽气泡  下



#pragma mark - 控制字符串的长度
//*******************控制字符串的长度*************************************//
@implementation DBWMyString
+ (NSString *)getSubStringBySize:(NSString *)textStr andSize:(int)Strsize{    
    NSString *retStr = textStr;
    NSInteger icnt = [self getBytesLength:textStr];
    if (icnt>Strsize) {
        for (int i = Strsize/2; i<textStr.length; i++) {
            NSString *subStr = [textStr substringToIndex:i];
            if ([self getBytesLength:subStr]<=Strsize) {
                retStr = subStr;
            }else{
                break;
            }
        }
    }
    return retStr;
}
+(NSInteger)getBytesLength:(NSString*)str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
@end


//*******************判断是否是第一次登录**************************//
#pragma mark - 判断是否是第一次登录
@implementation DBWFirstLogin
static NSString *versionKey = @"CFBundleShortVersionString";
+(BOOL)firstLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    //获得当前打开软件的版本好
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([lastVersion isEqualToString:currentVersion]) {
        return NO;
    }else{
       return YES;
    }
}
+(void)saveCurrentVersion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //获得当前打开软件的版本好
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    [defaults setObject:currentVersion forKey:versionKey];
    [defaults synchronize];
}

+(BOOL)firstLoginWithControllerString:(NSString *)controllerSting{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //获得当前打开软件的版本好
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    NSString *conLocationString = [NSString stringWithFormat:@"%@%@",controllerSting,versionKey];
    NSString *lastVersion = [defaults objectForKey:conLocationString];
    
    if ([lastVersion isEqualToString:currentVersion]) {
        return NO;
    }else{
        return YES;
    }
}
+(void)saveCurrentVersionWithControllerString:(NSString *)controllerSting{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //获得当前打开软件的版本好
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    NSString *conLocationString = [NSString stringWithFormat:@"%@%@",controllerSting,versionKey];
    
    [defaults setObject:currentVersion forKey:conLocationString];
    [defaults synchronize];
}
@end




//*******************一些简单的封装**************************//
#pragma mark - 一些简单的封装。。。有重复的


@implementation DBW_MyPackages

//图片压缩到指定大小
+ (UIImage*)dealImage:(UIImage *)source ByScalingAndCroppingForSize:(CGSize)targetSize{
    UIImage *sourceImage = source;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
    UIGraphicsEndImageContext();
    return newImage;
}

+(CGFloat)labelLinePaddingWithText:(UILabel *)label andPaddingHeigh:(CGFloat)padding{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:15];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [label.text length])];
    [label setAttributedText:attributedString1];
    [label sizeToFit];
    CGFloat h = label.bounds.size.height;
    return h;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+(void)runTimeByInstrance:(id)weakVC{
    unsigned int numIvars; //成员变量个数
    Ivar *vars = class_copyIvarList([weakVC class], &numIvars);
    
    NSString *key=nil;
    NSString *key2=nil;
    
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];  //获取成员变量的名字
        key2 = [NSString stringWithUTF8String:ivar_getTypeEncoding(thisIvar)]; //获取成员变量的数据类型
        
        NSLog(@"variable name :%@ andType :%@", key,key2);
    }
    free(vars);
}

+(BOOL)higherThanSeven{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}
/**
 *  转换图片大小
 *  Create by liuxinyan on 15/11/28
 *  @param Newsize 新的大小
 *
 *  @return 新的大小的UIImage
 */
+ (UIImage *)TransformOriganImage:(UIImage *)currentImage toSize:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [currentImage drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (BOOL)valiMobile:(NSString *)mobileNum {
    
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|7[016]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[07]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (BOOL)valiEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)valiNumber:(NSString *)numberstr{
    
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:numberstr];
}
+ (BOOL)valifloat:(NSString *)floatstr{
    
    NSString *numberRegex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\\.[0-9]+)|([0-9]*[1-9][0-9]*))$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:floatstr];
}
//
+(BOOL)MyselfTotalStr:(NSString *)totalStr ContainsSubString:(NSString *)sub{
    if ([totalStr rangeOfString:sub].location !=NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

+(UIColor *)dbwFirstFontColor{
    UIColor *color = RGBACOLOR(154, 154, 154, 1);
    return color;
}
+(UIColor *)dbwSecondFontColor{
    UIColor *color = RGBACOLOR(81, 81, 81, 1);
    return color;
}
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize{
   
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

+(CGSize)sizeWithText:(UILabel *)lable maxSize:(CGSize)maxSize{

    CGSize nameSize = [lable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil].size;
    return nameSize;
}
//计算label 特定字体的宽高
+(CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize andSpecialFont:(CGFloat)FontSize{
    CGSize nameSize = [self sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:FontSize] andMaxSize:maxSize andText:text];
    return nameSize;
}
+(CGSize)sizeWithFont:(UIFont *)textFont andMaxSize:(CGSize)maxSize andText:(NSString *)text{
    UIFontDescriptor *fontDesc = textFont.fontDescriptor;
    NSString *size = fontDesc.fontAttributes[@"NSFontSizeAttribute"];
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:fontDesc.fontAttributes[@"NSFontNameAttribute"] size:[size floatValue]]} context:nil].size;
    return nameSize;
}
+(BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
+(CGSize)defaultSizeWithText:(NSString *)text{
    CGSize nameSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0]} context:nil].size;
    return nameSize;
}
//返回两个frame的最大Y值
+(CGFloat)getMaxYBetweenOneFrame:(CGRect)oneFrame andTwoFrame:(CGRect)twoFrame{
    CGFloat oneMaxY = CGRectGetMaxY(oneFrame);
    CGFloat twoMaxY = CGRectGetMaxY(twoFrame);
    CGFloat maxY = oneMaxY > twoMaxY ? oneMaxY : twoMaxY;
    return maxY;
}

+(NSString *) getDoucumentPaths:(NSString *)filePath{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:filePath];
    return path;
}
//获得cachesPahts
+(NSString *) getCachesPaths:(NSString *)filePath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path = [docPath stringByAppendingPathComponent:filePath];
    return path;
}


+(BOOL)saveObjectOf:(id)object toFile:(NSString *)path{
    return [NSKeyedArchiver archiveRootObject:object toFile:path];
}

+(UIButton *)getDefaultButton:(id)target action:(SEL)action andTitleName:(NSString *)titlename normal_image:(NSString *)normal_name highlighted_image:(NSString *)highlighted_name background_image:(NSString *)background_image titlefont:(CGFloat)font titlepadding:(CGFloat)padding{
    
    UIButton *defaultBtn = [[UIButton alloc] init];
    [defaultBtn setImage:[UIImage imageNamed:normal_name] forState:UIControlStateNormal];
    if (background_image.length < 1) {
        [defaultBtn setBackgroundImage:[self imageWithColor:[self getRandomColoralpha:0.5]] forState:UIControlStateSelected];
    }else{
        [defaultBtn setBackgroundImage:[UIImage imageNamed:background_image] forState:UIControlStateSelected];
    }
    [defaultBtn setTitle:titlename forState:UIControlStateNormal];
    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    defaultBtn.titleLabel.font = [UIFont systemFontOfSize:font];
    defaultBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    defaultBtn.adjustsImageWhenHighlighted = NO;
    defaultBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    defaultBtn.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, 0);
    
    NSDictionary *attrs = @{NSFontAttributeName : defaultBtn.titleLabel.font};
    CGFloat titleW = [titlename boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    CGFloat btnW = defaultBtn.currentImage.size.width + padding + titleW;
    CGFloat btnH = defaultBtn.currentImage.size.height;
    
    defaultBtn.frame =  CGRectMake(0, 0, btnW, btnH);
    [defaultBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return defaultBtn;
}


+(UITableViewCell *)cellWithTableView:(UITableView *)tableView andIdenty:(NSString *)identifier NibNamed:(NSString *)nibName
{
    // 1.取缓存中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建cell
    if (cell == nil) {
        // 如果找不到就从xib中创建cell
        // 需要传入一个owner对象，就能调用这个对象里的方法.如果不传入own会报野指针错误。
        cell =  [[[NSBundle mainBundle] loadNibNamed:nibName owner:tableView.delegate options:nil] firstObject];
    }
    return cell;
}

//创建一个可重用的headerAndfooterView
+(UITableViewHeaderFooterView *)headerFooterViewWithTableView:(UITableView *)tableView andIdenty:(NSString *)identifier NibNamed:(NSString *)nibName{
    //从缓存池里取
    UITableViewHeaderFooterView *headerOrFooterView = (UITableViewHeaderFooterView *)[tableView dequeueReusableCellWithIdentifier:identifier];
    //创建
    if (headerOrFooterView == nil) {
        headerOrFooterView = [[[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil]firstObject];
    }
    return headerOrFooterView;
}
//自定义navigation主题
+(void)initNavigationItem{
    UINavigationBar *navBar = [UINavigationBar appearance];
    //统一背景颜色
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    // 设置导航条上返回按钮和图片的颜色
    [navBar setTintColor:[UIColor whiteColor]];
    
    // 1.2设置所有导航条的标题颜色
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:md];
    
    // 1.3设置UIBarButtonItem的主题
//    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
}

+(UIColor *)getRandomColoralpha:(CGFloat)alpha{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:alpha];
}
//得到一个颜色的背景图片
+(UIImage *)imageWithColor:(UIColor *)color{
    CGFloat imageW = 100;
    CGFloat imageH = 100;
    //开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    //画一个color颜色矩形筐
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    //得到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭行下文
    UIGraphicsEndImageContext();
    return image;
}

//把一个图片包装成40*40大小的barbuttonItem
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action andSize:(CGFloat)imageW{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if ([imageName isEqualToString:@"加号.png"]) {
        UIImage *rightImage=[UIImage imageNamed:@"加号.png"];
        [rightBtn setFrame:CGRectMake(0, 0, 25, 25)];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn setImage:rightImage forState:UIControlStateHighlighted];
        [rightBtn setImage:rightImage forState:UIControlStateSelected];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, -15, -15, -20);
        rightBtn.contentMode = UIViewContentModeScaleToFill;
        UIBarButtonItem * rightButton =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        return rightButton;
    }else{
        UIImage *rightImage=[[UIImage imageNamed:imageName] imageWithTintColor:kMainColor];
        [rightBtn setFrame:CGRectMake(0, 0, imageW, imageW)];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
        [rightBtn setImage:rightImage forState:UIControlStateHighlighted];
        [rightBtn setImage:rightImage forState:UIControlStateSelected];
        rightBtn.contentMode = UIViewContentModeScaleToFill;
        UIBarButtonItem * rightButton =[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        return rightButton;
    }
}
+(NSString *)ChineseCharacterChangToSpell:(NSString *)ChineseCharacter{
 
    NSMutableString *ms = [[NSMutableString alloc] initWithString:ChineseCharacter];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"pinyin: %@", ms);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"pinyin: %@", ms);
    }
    return ms;
    
}

//数据库－－－存
//
static FMDatabaseQueue *_dataBase;
+(BOOL)shareFMDBwithPath:(NSString *)fmdbpath{
    NSString *path = [self getCachesPaths:fmdbpath];
    _dataBase = [[FMDatabaseQueue alloc]initWithPath:path];
    __block BOOL resultBool = NO;
    [_dataBase inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL result = [db executeUpdate:@"create table if not exists t_status (id integer primary key autoincrement,destionStr text,userId text,dict blob);"];
        if (result) {
            resultBool = YES;
        }else{
            resultBool = NO;
        }
    }];
    return resultBool;
}
+(BOOL)addStatus:(NSDictionary *)dict ByStr:(NSString *)destionStr andUserId:(NSString *)userId{
    __block BOOL resultBool = NO;
    [_dataBase inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        BOOL result = [db executeUpdate:@"insert into t_status (destionStr,userId,dict) values(?,?,?)",destionStr,userId,data];
        if (result) {
            resultBool = YES;
        }else{
            resultBool = NO;
        }
    }];
    return resultBool;
}
+(void)addstatusFromArry:(NSArray *)dictArry ByStr:(NSString *)destionStr andUserId:(NSString *)userId{
    [dictArry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addStatus:obj ByStr:destionStr andUserId:userId];
    }];
}
//数据库－－-取
+(NSDictionary *)getDictionFromSqliteByStr:(NSString *)destionStr andUserId:(NSString *)userId{
    __block NSDictionary *dict = nil;
    [_dataBase inTransaction:^(FMDatabase *db, BOOL *rollback) {
        dict = [NSDictionary dictionary];
        FMResultSet *rs = [db executeQuery:@"select * from t_status where destionStr = ? and userId = ?",destionStr,userId];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"dict"];
            dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }];
    return dict;
}

+(NSMutableArray *)compentStrByLength:(NSInteger)lengthNumber andOrignString:(NSString *)orignStr{
    NSMutableArray *totalArry = [NSMutableArray array];
    NSInteger count = orignStr.length/lengthNumber;
    for (int i = 0; i<count; i++) {
        NSString *temp = [orignStr substringToIndex:lengthNumber];
        orignStr = [orignStr substringFromIndex:lengthNumber];
        [totalArry addObject:temp];
    }
    NSInteger backCode = orignStr.length%lengthNumber;
    NSRange rang = NSMakeRange(orignStr.length - backCode, backCode);
    NSString *lastCode = [orignStr substringWithRange:rang];
    [totalArry addObject:lastCode];
    return totalArry;
}
@end

@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)act {
    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    if (highImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:highImageName] forState:UIControlStateHighlighted];
    }
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    [button addTarget:target action:act forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}
@end


@implementation UIImage (Exness)
-(UIImage *)dbw_getCicleImage{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    CGContextClip(ctx);
    [self drawInRect:rect];
    
    UIImage *lastImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return lastImg;
}
+(UIImage *)dbwresizeImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 200) resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, 0, 0) resizingMode:UIImageResizingModeTile];
}
- (UIImage *)dbw_clipImageInRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}
-(UIImage*) circleImageWithParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, self.size.width - inset * 2.0f, self.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
#pragma mark 画带有圆角的图片
+ (UIImage*)cutImage:(UIImage *)orImage WithRadius:(int)radius
{
    UIGraphicsBeginImageContext(orImage.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+orImage.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+orImage.size.height;
    float x4 = x1;
    float y4 = y3;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, orImage.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, orImage.size.width, orImage.size.height), orImage.CGImage);
    
    
    
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimage;
}
@end


@implementation NSString (Exness)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end

#pragma mark - 字符串中是否含有中文
//如果要将一个自定义对象保存到文件中，必须实现nscoding协议

@implementation ChineseInclude
+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end

#pragma mark - 字符串中是否含有中文
//如果要将一个自定义对象保存到文件中，必须实现nscoding协议

@interface OtherEasyFuncation()

@end

@implementation OtherEasyFuncation


/***动态字符串，富文本字符串**/
+(NSMutableAttributedString *)attributeString:(NSString *)fromStr andColor:(UIColor *)fromColor andAppendString:(NSString *)rightString andColor:(UIColor *)rightColor{
    
    NSMutableAttributedString *fromAttributedStr = [[NSMutableAttributedString alloc]initWithString:fromStr];
    
    [fromAttributedStr addAttribute:NSFontAttributeName
                              value:dbwFonts4(14)
                              range:NSMakeRange(0, fromStr.length)];
    
    [fromAttributedStr addAttribute:NSForegroundColorAttributeName
     
                              value:fromColor
     
                              range:NSMakeRange(0, fromStr.length)];
    
    //1_03
    //添加图片
    NSTextAttachment *imgAttach = [[NSTextAttachment alloc] init];
    imgAttach.image = [[UIImage imageNamed:@"1_03"] imageWithTintColor:rightColor];
    imgAttach.bounds = CGRectMake(0, -1.5, 13, 13);
    NSAttributedString *imgAttributeStr = [NSAttributedString attributedStringWithAttachment:imgAttach];
    [fromAttributedStr appendAttributedString:imgAttributeStr];
    
    
    
    NSMutableAttributedString *toAttributedStr = [[NSMutableAttributedString alloc]initWithString:rightString];
    [toAttributedStr addAttribute:NSFontAttributeName
                            value:dbwFonts4(12)
                            range:NSMakeRange(0, rightString.length)];
    [toAttributedStr addAttribute:NSForegroundColorAttributeName
                            value:rightColor
                            range:NSMakeRange(0, rightString.length)];
    [fromAttributedStr appendAttributedString:toAttributedStr];
    
    return fromAttributedStr;
}

+(UIView *)CRMBuildBlankImageView{
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kWindowWidth, kWindowHeight - 64)];
    mainView.backgroundColor = RGBCOLOR(245, 244, 247);
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 150, 150)];
    imgView.centerX = kWindowWidth*0.5;
    imgView.image = [UIImage imageNamed:@"敬请期待"];
    [mainView addSubview:imgView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.maxY + 30, kWindowWidth, 25)];
    firstLabel.text = @"程序员正在挑灯奋战中...";
    firstLabel.font = dbwFonts(16);
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.textColor = RGBCOLOR(159, 171, 182);
    [mainView addSubview:firstLabel];
    
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, firstLabel.maxY + 10, kWindowWidth, 25)];
    secondLabel.text = @"敬请期待";
    secondLabel.font = dbwFonts(16);
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.textColor = RGBCOLOR(159, 171, 182);
    [mainView addSubview:secondLabel];
    
    return mainView;
}
static UIActivityIndicatorView *_testActivityIndicator;
+(UIWebView *)openTelephoneWithNumber:(NSString *)phoneNumberStr{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumberStr];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    return callWebview;
}

+ (UIColor *) colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+ (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}
+(NSMutableDictionary *)getCurrentWifiInformation{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        dict[@"SSID"] = info[@"SSID"];
        if (info[@"BSSID"]) {
            NSArray *macArr= [info[@"BSSID"] componentsSeparatedByString:@":"];
            NSInteger a = [self numberWithHexString:macArr[0]];
            NSInteger b = [self numberWithHexString:macArr[1]];
            NSInteger c = [self numberWithHexString:macArr[2]];
            NSInteger d = [self numberWithHexString:macArr[3]];
            NSInteger e = [self numberWithHexString:macArr[4]];
            NSInteger f = [self numberWithHexString:macArr[5]];
            dict[@"BSSID"] = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",a,b,c,d,e,f];

        }
    }
    
    return dict;
}
+(void)shapeWithMask{
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:redView];
    //    self.redView = redView;
    CGRect fromRect = CGRectMake(50, 50, 50, 50);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:fromRect];
    CGRect nRect = CGRectInset(fromRect, -1000, -1000);
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithOvalInRect:nRect];
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc] init];
    shapLayer.path = bezierPath.CGPath;
    redView.layer.mask = shapLayer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(bezierPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(bezierPath2.CGPath);
    animation.duration = 5.25;
    animation.delegate = self;
    [shapLayer addAnimation:animation forKey:@"path"];
    
    /**结束后实现这个方法*/
//    - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
//        [self.redView.layer removeAllAnimations];
//        [self.redView.layer.mask removeFromSuperlayer];
//    }
    
}
+(void)rotateToUpright{
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
+(void)rotateToLeft{
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
+ (UIImage *)createShareImage:(NSString *)imageName Context:(NSString *)text{
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGFloat nameFont;
    CGFloat startY = 5;
    if (text.length==1) {
        nameFont = 40.f;
    }else{
        nameFont = 30.f;
        startY = 10;
    }
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    [text drawAtPoint:CGPointMake((imageSize.width-sizeToFit.size.width)/2,startY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIActivityIndicatorView *)showflowinView:(UIView *)bodyView{
    if (bodyView == nil) {
        bodyView = [UIApplication sharedApplication].keyWindow;
//        CGPoint centerPoint = [keyView convertPoint:view.center toView:view];
    }
    UIActivityIndicatorView * ActivityIndicator;
    if (ActivityIndicator == nil) {
        ActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [ActivityIndicator sizeToFit];
        [ActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        ActivityIndicator.color = [[UIColor grayColor] colorWithAlphaComponent:0.7]; // 改变圈圈的颜色为红色； iOS5引入
    }
    CGPoint point = [[UIApplication sharedApplication].keyWindow convertPoint:[UIApplication sharedApplication].keyWindow.center toView:bodyView];
    ActivityIndicator.center = point;
    ActivityIndicator.hidden = NO;
    ActivityIndicator.tag = -999;
    [ActivityIndicator startAnimating];
    [bodyView addSubview:ActivityIndicator];
    return ActivityIndicator;
}
+(void)hiddenFlowerInview:(UIView *)view{
   UIActivityIndicatorView *ActivityIndicator =  [view viewWithTag:-999];
//    ActivityIndicator.hidden = YES;
    [ActivityIndicator stopAnimating];
    [ActivityIndicator removeFromSuperview];
    ActivityIndicator = nil;
}
+(void)shwoFlowerOnview:(UIView *)view{
    if (_testActivityIndicator == nil) {
        _testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_testActivityIndicator sizeToFit];
        [_testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        _testActivityIndicator.color = [[UIColor blackColor] colorWithAlphaComponent:0.5]; // 改变圈圈的颜色为红色； iOS5引入
    }
    UIView *keyView = [UIApplication sharedApplication].keyWindow;
    CGPoint centerPoint = [keyView convertPoint:view.center toView:view];
    _testActivityIndicator.center = centerPoint;
    _testActivityIndicator.hidden = NO;
    [_testActivityIndicator startAnimating];
    [view addSubview:_testActivityIndicator];
}
+(void)hiddenFlowerOnview:(UIView *)view{
    if ([view.subviews containsObject:_testActivityIndicator]&& _testActivityIndicator != nil) {
        _testActivityIndicator.hidden = YES;
        [_testActivityIndicator stopAnimating];
        [_testActivityIndicator removeFromSuperview];
        _testActivityIndicator = nil;
    }
}
//计算page方法
+(NSInteger)getPageFromeArry:(NSMutableArray *)arry andOnceFileNo:(NSInteger)onceNo{
    return arry.count/onceNo+(arry.count%onceNo>0?1:0);
}

+(NSInteger)cachesFileSizeWithPath:(NSString *)path{
    //文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    //判断是否为文件
    BOOL dir = NO;
    BOOL exists = [mgr fileExistsAtPath:path isDirectory:&dir];
    if (!exists) return 0;//说明文件或文件夹不存在
    if (dir) { //是一个文件夹
        //遍历caches里面的内容 -- 直接和间接内容
        NSArray *subpaths = [mgr subpathsAtPath:path];
        NSInteger totalBytes = 0;
        //如果是一个文件夹，则遍历该文件夹下的文件
        for (NSString *subpath in subpaths) {
            //获得全路径
            NSString *fullpath = [path stringByAppendingPathComponent:subpath];
            BOOL directory = NO;
            [mgr fileExistsAtPath:fullpath isDirectory:&directory];
            if (!directory) { //不是文件夹，计算文件的大小
                totalBytes += [[mgr attributesOfItemAtPath:fullpath error:nil][NSFileSize] integerValue];
            }
        }
        return totalBytes;
    } else { //是一个文件
        return [[mgr attributesOfItemAtPath:path error:nil][NSFileSize] integerValue];
    }
}


+ (NSString *)getCurrentDateWithString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/*
 *时间格式转换
 */
+(NSString *)getCutypetimeFromStr:(NSString *)datetime withFormat:(NSString *)format{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    if ([format isEqualToString:@""]) {
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formater setDateFormat:format];
    }
    NSDate* date = [formater dateFromString:datetime];
    return [self getCutypetimeFromDate:date withFormat:format];
}

+(NSString *)getCutypetimeFromDate:(NSDate *)datetime withFormat:(NSString *)format{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
//    formater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    if ([format isEqualToString:@""]) {
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [formater setDateFormat:format];
    }
    NSString* dateString = [formater stringFromDate:datetime];
    return dateString;
}

+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"%ld",imageData.length);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}
+(BOOL)adjustIfRunYear:(int)year {
    if ((year%4==0 && year %100 !=0) || year%400==0) {
        return YES;
    }else {
        return NO;
    }
    return NO;
}
//scrollview上下滑动，navigationbar变色值
+(CGFloat)getNavigationBarAlphWithScrollViewOffset:(CGFloat)offset{
    CGFloat alpha = 0;
    if (offset > 50) {
        alpha = MIN(1, 1 - ((50 + 64 - offset) / 64));
    }
    return alpha;
}
//添加消失donghua
+(CATransition *)getFadeAnimation{
    /**用法[self.view.layer addAnimation:transition forKey:@""]*/
    CATransition *transition = [CATransition animation];
    transition.type = @"fade";
    transition.duration = 0.35f;
    return transition;
}
+(BOOL)isBlank:(id)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}
+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
+(NSString *)RetBlankString:(NSString *)string{
    if ([OtherEasyFuncation isBlankString:string]) {
        return @"";
    }
    else{
        return string;
    }
}
+(UIImage *)imageFromView:(UIView *)snapView{
    UIGraphicsBeginImageContextWithOptions(snapView.bounds.size, NO, 0.0f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [snapView.layer renderInContext:contextRef];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(NSInteger)getMaxRownumberWithTotalElements:(NSInteger)totalNmber andEveryRowcount:(NSInteger)everyNumber{
    NSInteger reportCnt = 0;
    if (totalNmber%everyNumber == /* DISABLES CODE */ (0))
    {
        reportCnt = totalNmber/everyNumber;
    }
    else
    {
        reportCnt = totalNmber/everyNumber+1;
    }
    return reportCnt;
}
+(UIView *)buildImgviewWithStr:(NSString *)imgs andShowWords:(NSString *)words andTBHeight:(CGFloat)tbHeigth{
    
    UIView *imgBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, tbHeigth)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth*150*1.0f/320, kWindowWidth*150*1.0f/320)];
    img.contentMode = UIViewContentModeScaleToFill;
    img.image = [UIImage imageNamed:imgs];
    img.center = imgBackView.center;
    img.y = (tbHeigth - 160)*0.5-80+25;
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, img.maxY, kWindowWidth, 30)];
    bottomLabel.text = words;
    bottomLabel.textColor = RGBCOLOR(204, 204, 204);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [imgBackView addSubview:img];
    [imgBackView addSubview:bottomLabel];
    
    return imgBackView;
}
+(void)buildBankImgWithTabelView:(UITableView *)tableView andAdjustWithArry:(NSMutableArray *)arry andImgs:(NSString *)imgs andShowWords:(NSString *)words andTBHeight:(CGFloat)tbHeigth{
    UIView *imgBackView = [[UIView alloc] initWithFrame:tableView.bounds];
    if (tbHeigth != 0) {
        imgBackView.height = tbHeigth;
    }
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth*150*1.0f/320, kWindowWidth*150*1.0f/320)];
    img.contentMode = UIViewContentModeScaleToFill;
    img.image = [UIImage imageNamed:imgs];
    img.center = imgBackView.center;
    img.y = (tableView.bounds.size.height - 160)*0.5-80;
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, img.maxY, kWindowWidth, 30)];
    bottomLabel.text = words;
    bottomLabel.textColor = RGBCOLOR(204, 204, 204);
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [imgBackView addSubview:img];
    [imgBackView addSubview:bottomLabel];
    if (arry.count == 0) {
        tableView.backgroundView = imgBackView;
    }else{
        tableView.backgroundView = nil;
    }
}
+(void)buildBankImgWithTabelView:(UITableView *)tableView andAdjustWithArry:(NSMutableArray *)arry{
    UIView *imgBackView = [[UIView alloc] initWithFrame:tableView.bounds];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
    img.contentMode = UIViewContentModeScaleToFill;
    img.image = [UIImage imageNamed:@"zhouxingchi"];
    img.center = imgBackView.center;
    img.y = (tableView.bounds.size.height - 160)*0.5-80;
    [imgBackView addSubview:img];
    if (arry.count == 0) {
        tableView.backgroundView = imgBackView;
    }else{
        tableView.backgroundView = nil;
    }
}

+(void)buildBankImgWithCollectionView:(UICollectionView *)collectionView andAdjustWithArry:(NSMutableArray *)arry{
    UIView *imgBackView = [[UIView alloc] initWithFrame:collectionView.bounds];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
    img.contentMode = UIViewContentModeScaleToFill;
    img.image = [UIImage imageNamed:@"zhouxingchi"];
    img.center = imgBackView.center;
    img.y = (collectionView.bounds.size.height - 160)*0.5-80;
    [imgBackView addSubview:img];
    if (arry.count == 0) {
        collectionView.backgroundView = imgBackView;
    }else{
        collectionView.backgroundView = nil;
    }
}

+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 {
    
    UIImage *circleImg = [image2 circleImageWithParam:4];
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    CGFloat padding = 5;
    CGRect imgRect = CGRectMake(padding, padding, image1.size.width - 2*padding, image1.size.width - 2*padding);
    
    [circleImg drawInRect:imgRect];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


+(UIImage *)getProgressImageWithRect:(CGRect)imgRect andStartColor:(UIColor *)startColor andEndColor:(UIColor *)endColor{
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(imgRect.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    //绘制Path
    CGRect rect = imgRect;
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(gc);
    CGContextAddPath(gc, path);
    CGContextClip(gc);
    CGContextDrawLinearGradient(gc, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(gc);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+(CATransform3D)getTransForm3DWithAngle:(CGFloat)angle{
    CATransform3D transform =CATransform3DIdentity;//获取一个标准默认的CATransform3D仿射变换矩阵
    transform.m34=4.5/-2000;//透视效果
    transform=CATransform3DRotate(transform,angle,1,0,0);//获取旋转angle角度后的rotation矩阵。
    return transform;
}
@end
#pragma mark - UIViewController的扩展方法，判断bool值是否为真，如果是执行第一个方法，不是的话执行第二个方法
@implementation UIViewController(DBWExtession)

-(void)ifBool:(BOOL)flag performFirstAct:(SEL)firstAct orPerformSecondAct:(SEL)secondAct{
    if ([self respondsToSelector:firstAct]&&[self respondsToSelector:secondAct]) {
        if (flag) {
            [self performSelector:firstAct withObject:nil];
        }else{
            [self performSelector:secondAct withObject:nil];
        }
    }
}

@end


@implementation NSString(DBWExtession)

- (NSString *)removeHTML2{
    
    NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    
    
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&hellip;" withString:@" "];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@" "];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@" "];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"——"];
    plainText = [plainText stringByReplacingOccurrencesOfString:@"&rarr;" withString:@"——"];
    return plainText;
    
}
- (NSString *)removeHTML{
    
    NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    
    for (int i = 0; i < [components count]; i = i + 2) {
        
        [componentsToKeep addObject:[components objectAtIndex:i]];
        
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@""];
    return plainText;
}
- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
-(NSDictionary *)changeJsonUrlToDictionary{
    NSError *error;
    NSString *requestTmp = [NSString stringWithString:self];
    
    NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:&error];  //解析r
    
    return resultDic;
}
@end

static AVSpeechSynthesizer *_synthesizer;
@implementation DBWSpeakMethod : NSObject
+(void)startSpeakWithText:(NSString *)text{
    if (text.length == 0) {
        return;
    }
    if (_synthesizer == nil) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    utterance.rate *= 0.5;
    [_synthesizer speakUtterance:utterance];
}
+(void)stopSpeaking{
    if (_synthesizer && _synthesizer.isSpeaking) {
        [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    _synthesizer = nil;
}
@end

@interface DBWAlertView()<UIAlertViewDelegate>

/***/
@property(nonatomic,strong) UIAlertView *alert;

@end
static CancelBlcok cancelBlcok;
static SuccessBlcok successBlock;
static UIAlertViewStyle tempStype;
static DBWAlertView *tempAlertView;

@implementation DBWAlertView

+(instancetype)alertView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBWAlertView *temp = [[DBWAlertView alloc] init];
        tempAlertView = temp;
    });
    return tempAlertView;
}
-(void)createAlertViewStyle:(UIAlertViewStyle )stype andTitle:(NSString *)title andMessage:(NSString *)message andcancelButton:(NSString *)cancelStr andotherButton:(NSString *)otherStr  andCancelBlcok:(CancelBlcok)cancel andSureBlock:(SuccessBlcok)sureBlock{
    
    cancelBlcok = cancel;
    successBlock = sureBlock;
    tempStype = stype;
    self.alert = nil;
    self.alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelStr otherButtonTitles:otherStr, nil];
    self.alert.alertViewStyle = stype;
    [self.alert show];
}
-(void)createAlertViewStyle:(UIAlertViewStyle )stype andTitle:(NSString *)title andCancelBlcok:(CancelBlcok)cancel andSureBlock:(SuccessBlcok)sureBlock{
    
    cancelBlcok = cancel;
    successBlock = sureBlock;
    tempStype = stype;
    self.alert = nil;
    self.alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert.alertViewStyle = stype;
    [self.alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (tempStype != UIAlertViewStylePlainTextInput) {
        if (buttonIndex == 0) {
            !cancelBlcok?:cancelBlcok(@"");
        }else{
            !successBlock?:successBlock(@"");
        }
    }else{
        UITextField *nameField = [alertView textFieldAtIndex:0];
        if (buttonIndex == 0) {
            !cancelBlcok?:cancelBlcok(nameField.text);
        }else{
            !successBlock?:successBlock(nameField.text);
        }
    }
}
@end
