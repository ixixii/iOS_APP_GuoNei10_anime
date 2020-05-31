//
//  FilmModel.h
//  帅哥韩语
//
//  Created by beyond on 2018/1/6.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmModel : NSObject
@property (nonatomic,copy) NSString *imgurl;
@property (nonatomic,copy) NSString *ID;
    @property (nonatomic,copy) NSString *pubtime;
    
    @property (nonatomic,copy) NSString *content;
    
    // 图片宽和高
    @property(nonatomic,assign)NSInteger width;
    @property(nonatomic,assign)NSInteger height;

@property(nonatomic,assign)NSInteger islike;


- (NSString *)titleStr;
@end
