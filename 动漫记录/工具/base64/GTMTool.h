//
//  GTMTool.h
//  NiHongGo
//
//  Created by xss on 2015/09/25.
//  Copyright (c) 2015年 beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTMTool : NSObject


// 对文件夹下的所有东西进行base64加密
// /Users/beyond/Desktop/tmp_tai_pic
// 加密前a.gif
// 加密后encode_a.gif
+(void)encodeFilesAtFolderPath:(NSString *)folderFullPath;


// 加密的完整图片名: encode_1.gif
+ (NSData *)decodeDataWithNameInBundle:(NSString *)name;


// 加密的图片,但是不需传入前缀 1.gif
+ (NSData *)decodeDataWithNameInBundleWithoutPrefix:(NSString *)name;

+ (NSData *)decodeDataWithFullPath:(NSString *)fullPath;

+ (NSData *)decodeDataWithData:(NSData *)data;

 
@end
