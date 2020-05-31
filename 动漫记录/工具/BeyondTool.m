//
//  BeyondTool.m
//  动漫记录
//
//  Created by beyond on 2020/5/25.
//  Copyright © 2020 sg32. All rights reserved.
//

#import "BeyondTool.h"
#import "GTMBase64.h"

static CGRect oldframe;

@implementation BeyondTool

+ (void)showImageView:(UIImageView *)avatarImageView wordString:(NSString *)wordString
{
    
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:
                              CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                         [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    // 添加一个Label Logo
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    label.text = kAppName;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    [backgroundView addSubview:label];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64, ScreenWidth, 64)];
    label2.text = wordString;
    label2.font = [UIFont systemFontOfSize:18];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor blackColor];
    [backgroundView addSubview:label2];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    float height = image.size.height * ScreenWidth / image.size.width;
    if (isnan(height)) {
        return;
    }
    float y = (ScreenHeight - height)/2;
    imageView.frame = CGRectMake(0,  y, ScreenWidth, height);
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:10 animations:^{
            label.alpha = 0;
            label2.alpha = 0;
        }];
    }];
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}


#pragma mark - 数据加解密
// 解密plist文件
// 将encode_xxx的文件,解密成一个数组; 参数就是xxx,不含.plist后缀,也不含encode_前缀
+ (NSArray *)arrFromEncodedPlistNameWithoutExtInDoc:(NSString *)plistName
{
    NSString *encodedPlistName = [NSString stringWithFormat:@"encode_%@",plistName];
    NSString *filePath = [kDocFolder stringByAppendingPathComponent:encodedPlistName];
    // 进行了加密后,根据data生成图片
    // 读取被加密文件对应的数据
    NSData *dataEncoded = [NSData dataWithContentsOfFile:filePath];
    // 对NSData进行base64解码
    NSData *dataDecode = [GTMBase64 decodeData:dataEncoded];
    // 对前1000位进行异或处理
    unsigned char * cByte = (unsigned char*)[dataDecode bytes];
    for (int index = 0; (index < [dataDecode length]) && (index < kEncodeKeyLength); index++, cByte++)
    {
        *cByte = (*cByte) ^ arrayForEncode[index];
    }
    // 根据解密后的Data生成Image
    NSString *error;
    NSPropertyListFormat format;
    NSArray* plistArr = [NSPropertyListSerialization propertyListFromData:dataDecode
                                                         mutabilityOption:NSPropertyListImmutable
                                                                   format:&format
                                                         errorDescription:&error];
    if (!plistArr) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:dataDecode options:NSJSONReadingAllowFragments error:nil];
        return arr;
    }
    return plistArr;
}
#pragma mark - 加密数据
+ (void)encodeData:(NSData *)imageDataOrigin toDocPath:(NSString *)docFullPath
{
    // 对前1000位进行异或处理
    unsigned char * cByte = (unsigned char*)[imageDataOrigin bytes];
    for (int index = 0; (index < [imageDataOrigin length]) && (index < kEncodeKeyLength); index++, cByte++)
    {
        *cByte = (*cByte) ^ arrayForEncode[index];
    }
    
    //对NSData进行base64编码
    NSData *imageDataEncode = [GTMBase64 encodeData:imageDataOrigin];
    
    [imageDataEncode writeToFile:docFullPath atomically:YES];
}

+(void)showMessage:(NSString *)message duration:(NSInteger)duration
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:22] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:duration animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
