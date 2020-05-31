//
//  MusicListSectionHeaderView.m
//  帅哥韩语
//
//  Created by beyond on 2017/12/30.
//  Copyright © 2017年 beyond. All rights reserved.
//

#import "FilmListSectionHeaderView.h"

@implementation FilmListSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)filmListSectionHeaderView
{
    FilmListSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:@"FilmListSectionHeaderView" owner:nil options:nil][0];
    
    // 设置高为1像素的视图
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)
    CGFloat lineWidth = SINGLE_LINE_WIDTH;
    CGFloat pixelAdjustOffset = SINGLE_LINE_WIDTH;
    //仅当要绘制的线宽为奇数像素时，绘制位置需要调整
    if (((int)(lineWidth * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    //    xPos yPos
    line.frame = CGRectMake(0-pixelAdjustOffset, 50 - pixelAdjustOffset, ScreenWidth, lineWidth);
    line.backgroundColor = kColor(220, 220, 220);
    [view addSubview:line];
    
    
    return view;
}
@end
