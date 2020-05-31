//
//  FilmListCell.h
//  帅哥韩语
//
//  Created by beyond on 2018/1/6.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilmModel;
@interface FilmListCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *wrapViewConstraint;
    @property (weak, nonatomic) IBOutlet UIView *wrapView;
    @property (weak, nonatomic) IBOutlet UIImageView *imgView;
    @property (weak, nonatomic) IBOutlet UILabel *contentLabel;
    // 返回xib界面上写的重用cellID
+ (NSString *)cellID;
    
    // 从xib中加载 实例化一个FilmListCell对象
+ (instancetype)filmListCell;
    
    // 参数是数据模型对象,填充值到xib中各个控件 ,并返回封装好数据之后的对象
    - (instancetype)cellWithCellModel:(FilmModel *)cellModel;

@end
