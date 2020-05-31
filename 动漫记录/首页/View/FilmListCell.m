//
//  FilmListCell.m
//  帅哥韩语
//
//  Created by beyond on 2018/1/6.
//  Copyright © 2018年 beyond. All rights reserved.
//

#import "FilmListCell.h"

#import "FilmModel.h"

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation FilmListCell
    
    // 返回xib界面上写的重用cellID
+(NSString *)cellID
    {
        // 必须和界面上的一致
        return @"FilmListCellID";
    }
    // 网络中用到
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
    {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            // 从xib创建
            self  = [[NSBundle mainBundle] loadNibNamed:@"FilmListCell" owner:nil options:nil][0];
        }
        return self;
    }
#pragma mark - 初始化 属性设置
#pragma mark 1.设置cell背景view
    
-(void)awakeFromNib{
    
    //cell颜色设置为白色
    //    self.backgroundView=[[UIImageView alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    //    //cell选中的颜色是淡蓝色
    //    self.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageWithColor:UIColorFromRGB(0x81b9ea)]];
    
}
    
    
    // 从xib中加载 实例化一个对象 (网络中未用到)
+ (instancetype)musicListCell
    {
        // mainBundel加载xib,扩展名不用写.xib
        NSArray *arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:@"MusicListCell" owner:nil options:nil];
        FilmListCell *cell = arrayXibObjects[0];
        
        
        
        
        
        return cell;
    }
    
    
    // 网络,参数是数据模型对象,填充值到xib中各个控件 ,并返回封装好数据之后的对象
- (instancetype)cellWithCellModel:(FilmModel *)model
    {
        
        
        _contentLabel.text = model.content;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeHolder.jpg"]];
        
        
        
        // 如果已收藏,isLike为1,加粗
        if (model.islike == 1) {
            _contentLabel.textColor = kColor(7, 11, 80);
        } else {
            _contentLabel.textColor = kColor(0, 0, 0);
        }
        return self;
    }
    // 从xib中加载 实例化一个对象 (网络中未用到)
+ (instancetype)filmListCell
    {
        // mainBundel加载xib,扩展名不用写.xib
        NSArray *arrayXibObjects = [[NSBundle mainBundle] loadNibNamed:@"FilmListCell" owner:nil options:nil];
        FilmListCell *cell = arrayXibObjects[0];
        
        
        
        
        
        return cell;
    }

@end
