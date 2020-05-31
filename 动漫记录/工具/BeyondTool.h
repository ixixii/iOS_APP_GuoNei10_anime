//
//  BeyondTool.h
//  动漫记录
//
//  Created by beyond on 2020/5/25.
//  Copyright © 2020 sg32. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BeyondTool : NSObject
+ (void)showImageView:(UIImageView *)avatarImageView wordString:(NSString *)wordString;
+ (void)hideImage:(UITapGestureRecognizer*)tap;
#pragma mark - 数据加解密
// 解密plist文件
// 将encode_xxx的文件,解密成一个数组; 参数就是xxx,不含.plist后缀,也不含encode_前缀
+ (NSArray *)arrFromEncodedPlistNameWithoutExtInDoc:(NSString *)plistName;
+ (void)encodeData:(NSData *)imageDataOrigin toDocPath:(NSString *)docFullPath;
+(void)showMessage:(NSString *)message duration:(NSInteger)duration;
@end

NS_ASSUME_NONNULL_END
