//
//  MusicListSectionHeaderView.h
//  帅哥韩语
//
//  Created by beyond on 2017/12/30.
//  Copyright © 2017年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmListSectionHeaderView : UIView
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countNoLabel;

// heartImgView
@property (weak, nonatomic) IBOutlet UIImageView *heartImgView;

+ (instancetype)filmListSectionHeaderView;
@end
