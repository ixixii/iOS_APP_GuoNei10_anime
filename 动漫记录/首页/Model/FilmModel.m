//
//  FilmModel.m
//  帅哥韩语
//
//  Created by beyond on 2018/1/6.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import "FilmModel.h"

@implementation FilmModel


- (NSString *)titleStr
{
    // 根据content切割
    NSArray *arr =[_content componentsSeparatedByString:@"》"];
    NSString *temp = arr[0];
    NSString *titleStr = temp;
    if ([temp hasPrefix:@"《"]) {
        titleStr = [temp substringFromIndex:1];
    }
    
    if (titleStr.length > 0) {
        return titleStr;
    } else {
        return @"";
    }
}
@end
