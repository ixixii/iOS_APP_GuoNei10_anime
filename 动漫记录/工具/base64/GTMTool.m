//
//  GTMTool.m
//  NiHongGo
//
//  Created by xss on 2015/09/25.
//  Copyright (c) 2015年 beyond. All rights reserved.
//

#import "GTMTool.h"


#import "GTMBase64.h"
@implementation GTMTool



#pragma mark - 加密
// 对文件夹下的所有东西进行base64加密
// 例如: /Users/beyond/Desktop/tmp_tai_pic
// 加密前a.gif         word.sqlite
// 加密后encode_a.gif  encode_word.sqlite

+ (void)encodeFilesAtFolderPath:(NSString *)folderFullPath
{
//    NSString *picFolderPath = @"/Users/beyond/Desktop/tmp_tai_pic";
    
    NSString *picFolderPath = folderFullPath;
    NSArray *shortPicNameArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:picFolderPath error:nil];
    NSLog(@"arr:%@",shortPicNameArr);
    
    for (NSString *shortPicName in shortPicNameArr) {
        // /Users/beyond/Desktop/tmp_tai_pic/9.png
        NSString *fullPicPath = [picFolderPath stringByAppendingPathComponent:shortPicName];
        NSLog(@"fullPicPath:%@",fullPicPath);
        // 读原始数据
        NSData *imageDataOrigin = [NSData dataWithContentsOfFile:fullPicPath];
        
        // 对前1000位进行异或处理
        unsigned char * cByte = (unsigned char*)[imageDataOrigin bytes];
        for (int index = 0; (index < [imageDataOrigin length]) && (index < kEncodeKeyLength); index++, cByte++)
        {
            *cByte = (*cByte) ^ arrayForEncode[index];
        }
        
        //对NSData进行base64编码
        NSData *imageDataEncode = [GTMBase64 encodeData:imageDataOrigin];
        
        
        
        // /Users/beyond/Desktop/tmp_tai_pic/encode_9.png
        NSString *newShortPicName = [NSString stringWithFormat:@"encode_%@",shortPicName];
        NSString *newFullPicPath = [picFolderPath stringByAppendingPathComponent:newShortPicName];
        NSLog(@"newFullPicPath:%@",newFullPicPath);
        
        [imageDataEncode writeToFile:newFullPicPath atomically:YES];
        
        
        
    }
}





#pragma mark - 解密
// encode_1.gif
+ (NSData *)decodeDataWithNameInBundle:(NSString *)name
{
    NSString *filePath = [kMainBundle pathForResource:name ofType:nil];
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
    return dataDecode;
}

// bundle中 加密的图片,但是不需传入前缀,例如: 1.gif
+ (NSData *)decodeDataWithNameInBundleWithoutPrefix:(NSString *)name
{
    return [self decodeDataWithNameInBundle:[NSString stringWithFormat:@"encode_%@",name]];
}
+ (NSData *)decodeDataWithFullPath:(NSString *)fullPath
{
    //
    // 读取被加密文件对应的数据
    NSData *dataEncoded = [NSData dataWithContentsOfFile:fullPath];
    // 对NSData进行base64解码
    NSData *dataDecode = [GTMBase64 decodeData:dataEncoded];
    
    
    // 对前1000位进行异或处理
    unsigned char * cByte = (unsigned char*)[dataDecode bytes];
    for (int index = 0; (index < [dataDecode length]) && (index < kEncodeKeyLength); index++, cByte++)
    {
        *cByte = (*cByte) ^ arrayForEncode[index];
    }
    return dataDecode;
}

+(NSData *)decodeDataWithData:(NSData *)data
{
    //
    // 读取被加密文件对应的数据
    NSData *dataEncoded = data;
    // 对NSData进行base64解码
    NSData *dataDecode = [GTMBase64 decodeData:dataEncoded];
    
    
    // 对前1000位进行异或处理
    unsigned char * cByte = (unsigned char*)[dataDecode bytes];
    for (int index = 0; (index < [dataDecode length]) && (index < kEncodeKeyLength); index++, cByte++)
    {
        *cByte = (*cByte) ^ arrayForEncode[index];
    }
    return dataDecode;
}
@end
