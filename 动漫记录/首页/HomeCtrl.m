//
//  HomeCtrl.m
//  动漫记录
//
//  Created by beyond on 2020/5/25.
//  Copyright © 2020 sg32. All rights reserved.
//

#import "HomeCtrl.h"
#import "SDCycleScrollView.h"
#import "BeyondTool.h"
// ------
#import "FilmListCell.h"
#import "FilmListSectionHeaderView.h"
#import "FilmModel.h"
// ------
#import <SDWebImage/UIImageView+WebCache.h>
// ------
#import "SearchResultCtrl.h"

@interface HomeCtrl ()<SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *_headerView;
    NSArray *_infiniteImgNameArr;
    NSArray *_infiniteImgTitleArr;
    // -----------
    UITableView *_tableView;
    
    // 未看的动漫列表
    NSMutableArray *_unWatchFilmModelArr;
    
    // 所有的filmModel
    NSMutableArray *_allModelArr;
    NSMutableArray *_displayModelArr;
    
    UIFont *_contentLabelFont;
    NSMutableArray *_totalHeightArr;
    
    FilmListSectionHeaderView *_headerViewForSectionZero;
    
    // 侧滑删除
    NSInteger _clickedRow;
}
@end

@implementation HomeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDataFromPlist];
    [self calcCellHeight];
    [self addAllSubViews];
}
#pragma mark - 数据源
- (void)loadDataFromPlist
{
    // 这个到时候要改doc目录下的plist
    NSMutableArray *allFilmModelArr = [NSMutableArray arrayWithArray:[FilmModel objectArrayWithKeyValuesArray:[BeyondTool arrFromEncodedPlistNameWithoutExtInDoc:@"film_data"]]];
    
    // 未看的
    _unWatchFilmModelArr = [NSMutableArray arrayWithArray:[FilmModel objectArrayWithKeyValuesArray:[BeyondTool arrFromEncodedPlistNameWithoutExtInDoc:@"film_unwatch_data"]]];
    
    _allModelArr = allFilmModelArr;
    _displayModelArr = allFilmModelArr;
}
- (void)calcCellHeight
{
    _totalHeightArr = [NSMutableArray array];
    FilmListCell *tempCell = [FilmListCell filmListCell];
    _contentLabelFont = tempCell.contentLabel.font;
    
    for (FilmModel *model in _displayModelArr) {
        // 手动计算内容的高度
        CGFloat contentLabelHeight = [self heightForAllChar:model.content fnt:_contentLabelFont showWidth:ScreenWidth - 18 - 18];
        CGFloat wrapViewHeight = 1;
        
        if (model.width > model.height) {
            wrapViewHeight = (ScreenWidth - 18*2)*model.height / (1.0*model.width);
        } else {
            wrapViewHeight = (ScreenWidth - 18*2);
        }
        CGFloat totalHeight = 18 + wrapViewHeight + 15 + contentLabelHeight + 15;
        [_totalHeightArr addObject:@(totalHeight)];
    }
}
// 计算字串 在指定字体下的 全部字符所占的行高
- (CGFloat)heightForAllChar:(NSString *)str fnt:(UIFont *)fnt showWidth:(CGFloat)showWidth
{
    CGSize tmpSize ;
    if (str.length == 0) {
        return 0;
    }else{
        CGRect tmpRect = [str boundingRectWithSize:CGSizeMake(showWidth, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil] context:nil];
        tmpSize = CGSizeMake(tmpRect.size.width, tmpRect.size.height);
    }
    return tmpSize.height;
}

- (void)addAllSubViews
{
    [self addInfiniteScrollView];
    [self addTableView];
    [self addRightSearchBtn];
}
- (void)addRightSearchBtn
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 30,30);
    [backButton setImage:[UIImage imageNamed:@"btn_navi_search.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
}
- (void)addInfiniteScrollView
{
    NSArray *imgNameArr = @[@"infiniteImg_0.jpg",
                            @"infiniteImg_1.jpg",
                            @"infiniteImg_2.jpg",
                            @"infiniteImg_3.jpg",
                            @"infiniteImg_4.jpg",
                            @"infiniteImg_5.jpg",
                            @"infiniteImg_6.jpg",
                            @"infiniteImg_7.jpg",
                            @"infiniteImg_8.jpg",
                            @"infiniteImg_9.jpg",
                            @"infiniteImg_10.jpg",
                            @"infiniteImg_11.jpg",
                            @"infiniteImg_12.jpg"
                          ];
    _infiniteImgNameArr = imgNameArr;
    _infiniteImgTitleArr = @[@"面码",
                             @"未闻花名",
                             @"龙与虎",
                             @"可塑性记忆",
                             @"狼与香辛料",
                             @"冰菓",
                             @"缘之空",
                             @"长门有希",
                             @"只有我不在的城市",
                             @"椎名真白",
                             @"Angel Beats",
                             @"珂朵莉",
                             @"古手梨花"
                           ];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenWidth) shouldInfiniteLoop:YES imageNamesGroup:imgNameArr];
    cycleScrollView.delegate = self;
    
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.autoScrollTimeInterval = 2.4;
    
    [self.view addSubview:cycleScrollView];
    
    _headerView = cycleScrollView;
}
#pragma mark - 点击滚动轮播图时
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *tapImgName = _infiniteImgNameArr[index];
    NSString *tapImgTitle = _infiniteImgTitleArr[index];
    UIImage *img  = [UIImage imageNamed:tapImgName];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.bounds = CGRectZero;
    [self.view addSubview:imgView];
    [BeyondTool showImageView:imgView wordString:tapImgTitle];
}
#pragma mark - tableView
- (void)addTableView
{
    CGFloat tableViewHeight = ScreenHeight - 64;
    tableViewHeight = ScreenHeight - 50;
    CGRect tableViewFrame = CGRectMake(0, 0, ScreenWidth, tableViewHeight);
    UITableView *tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.showsVerticalScrollIndicator = YES;
    _tableView = tableView;
    tableView.backgroundColor = kColor(255, 255, 255);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    tableView.tableHeaderView = _headerView;
    tableView.tableFooterView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[FilmListCell class] forCellReuseIdentifier:[FilmListCell cellID]];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _displayModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilmListCellID";
    
    FilmListCell *cell = (FilmListCell *) [tableView
                                             dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [FilmListCell filmListCell];
    }
    FilmModel *model = _displayModelArr[indexPath.row];
    cell = [cell cellWithCellModel:model];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    CGFloat wrapViewHeight = 1;
    if (model.width > model.height) {
        wrapViewHeight = (ScreenWidth - 18*2)*model.height / (1.0*model.width);
    } else {
        wrapViewHeight = (ScreenWidth - 18*2);
    }
    cell.wrapViewConstraint.constant = wrapViewHeight;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_totalHeightArr[indexPath.row] floatValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FilmListSectionHeaderView *view = [FilmListSectionHeaderView filmListSectionHeaderView];
    view.frame = CGRectMake(0, 0, ScreenWidth, 50);
    view.titleLabel.text = @"动漫观影记录";
    view.countNoLabel.text = [NSString stringWithFormat:@"(共%d部)",_displayModelArr.count];
    _headerViewForSectionZero = view;
    return view;
}

#pragma mark - 点击图片查看大图
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilmModel *model = _displayModelArr[indexPath.row];
    UIImage *img  = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:model.imgurl];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.bounds = CGRectZero;
    [self.view addSubview:imgView];
    [BeyondTool showImageView:imgView wordString:[model titleStr]];
}

#pragma mark - 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    _clickedRow = indexPath.row;
    [self abstract_updateClickedImgModel];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *hintStr = @"";
    FilmModel *model = _displayModelArr[indexPath.row];
    if (model.islike == 1) {
        hintStr = @"取消收藏";
    }else{
        hintStr = @"收藏";
    }
    return hintStr;
}
// 将修改后的保存到doc
- (void)abstract_updateClickedImgModel
{
    FilmModel *clickedModel = _displayModelArr[_clickedRow];
    if (clickedModel.islike == 1) {
        clickedModel.islike = 0;
        [BeyondTool showMessage:@"已取消收藏" duration:3.5];
    } else {
        clickedModel.islike = 1;
        [BeyondTool showMessage:@"已收藏" duration:3.5];
    }
    for (FilmModel *filmModel in _allModelArr) {
        if ([filmModel.ID isEqualToString:clickedModel.ID]) {
            filmModel.islike = clickedModel.islike;
        }
    }
    [self abstract_saveBookArrToDoc];
}

- (void)abstract_saveBookArrToDoc
{
    // 不能把搜索结果覆盖写入磁盘,也不能将用户收藏的覆盖写入磁盘
    NSMutableArray *filmDictArr = [NSMutableArray array];
    for (FilmModel *filmModel in _allModelArr) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:filmModel.ID forKey:@"ID"];
        [dict setObject:@"remark" forKey:@"remark"];
        [dict setObject:@(8.1) forKey:@"score"];
        [dict setObject:@(filmModel.islike) forKey:@"islike"];
        [dict setObject:filmModel.pubtime forKey:@"pubtime"];
        [dict setObject:filmModel.imgurl forKey:@"imgurl"];
        [dict setObject:filmModel.content forKey:@"content"];
        // 1006___1500
        [dict setObject:@(filmModel.width) forKey:@"width"];
        [dict setObject:@(filmModel.height) forKey:@"height"];
        [filmDictArr addObject:dict];
        
    }
    // 读原始数据
    NSData *codeDataOrigin = [NSJSONSerialization dataWithJSONObject:filmDictArr options:NSJSONReadingAllowFragments error:nil];
    
    [BeyondTool encodeData:codeDataOrigin toDocPath:kFilmDataPlistPathInDoc];
    
    // 是不是 收藏页面 发出的通知
    // @"0"
    NSString *isLikeModePostNoti = [NSString stringWithFormat:@"%@",@(NO)];
    NSLog(@"sg__%@",isLikeModePostNoti);
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kFilmDataSourceChangedNotification object:isLikeModePostNoti];
}

#pragma mark - 右按钮搜索
- (void)rightButtonAction:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:kAppName message:@"请输入要查询动漫的关键字,例如:好看,经典,推荐,良心,佳作,神作,封神,酷,炫,炸,燃,泪,哭,虐,感人,治愈,高能,一口气" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    // 输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入关键字";
    }];
    // 确定
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alert.textFields.firstObject;
        if(field.text.length > 0){
            SearchResultCtrl *ctrl = [[SearchResultCtrl alloc]init];
            ctrl.queryStr = field.text;
            NSLog(@"sg__%@",field.text);
            ctrl.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
