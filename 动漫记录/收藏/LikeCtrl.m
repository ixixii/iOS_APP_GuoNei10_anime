//
//  LikeCtrl.m
//  动漫记录
//
//  Created by beyond on 2020/5/25.
//  Copyright © 2020 sg32. All rights reserved.
//

#import "LikeCtrl.h"

#import "SDCycleScrollView.h"
#import "BeyondTool.h"
// ------
#import "FilmListCell.h"
#import "FilmListSectionHeaderView.h"
#import "FilmModel.h"
// ------
#import <SDWebImage/UIImageView+WebCache.h>
// ------
// 神作补完计划
#import "CZPickerView.h"

@interface LikeCtrl ()<SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,CZPickerViewDelegate,CZPickerViewDataSource>
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

@implementation LikeCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // 冗余
    self.isLikeMode = YES;
    
    [self loadDataFromPlist];
    [self calcCellHeight];
    [self addAllSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAndTableNoti:) name:kFilmDataSourceChangedNotification object:nil];
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
    
    // 只显示收藏时isLike = 1
    if (self.isLikeMode) {
        // 遍历
        NSMutableArray *tempMArr = [NSMutableArray array];
        for (FilmModel *model in allFilmModelArr) {
            if (model.islike == 1) {
                [tempMArr addObject:model];
            }
        }
        _displayModelArr = tempMArr;
    }
}
- (void)calcCellHeight
{
    _totalHeightArr = [NSMutableArray array];
    FilmListCell *tempCell = [FilmListCell filmListCell];
    _contentLabelFont = tempCell.contentLabel.font;
    
    for (FilmModel *model in _displayModelArr) {
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
    [backButton setImage:[UIImage imageNamed:@"btn_navi_todo.png"] forState:UIControlStateNormal];
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
    view.titleLabel.text = @"动漫收藏列表";
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
    
    // 是不是收藏模式发出的通知
    NSString *isLikeModePostNoti = [NSString stringWithFormat:@"%@",@(self.isLikeMode)];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kFilmDataSourceChangedNotification object:isLikeModePostNoti];
}

#pragma mark - 右按钮：神作补完
- (void)rightButtonAction:(UIButton *)btn
{
        NSString *title = [NSString stringWithFormat:@"动漫补番计划(%d)",_unWatchFilmModelArr.count];
        CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:title
                                                       cancelButtonTitle:@"取消"
                                                      confirmButtonTitle:@"确定"];
        picker.checkMarkNeedless = YES;
        picker.delegate = self;
        picker.dataSource = self;
        picker.tapBackgroundToDismiss = YES;
        [picker show];
}

#pragma mark - 接收到通知了，刷新表格
- (void)reloadDataAndTableNoti:(NSNotification *)noti
{
    BOOL isLikeModePostNoti = [[noti object] boolValue];

    if (isLikeModePostNoti == NO && self.isLikeMode == NO) {
        // 列表发__列表收:刷新表格
        [_tableView reloadData];
    }else{
        // 其他情况,一律重新loadPlist
        [self loadDataFromPlist];
        [self calcCellHeight];
        [_tableView reloadData];
    }
}
#pragma mark - 选择列表
- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return _unWatchFilmModelArr.count;
}
- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row
{
    FilmModel *model = _unWatchFilmModelArr[row];
    NSString *content = model.content;
    return content;
}
@end
