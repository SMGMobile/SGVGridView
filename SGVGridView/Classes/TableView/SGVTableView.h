//
//  SGVTableView.h
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGVGridView.h"

@class SGVTableView;
@class SGVTableViewBaseCell;

@protocol SGVTableViewDelegate <NSObject>
/**
 *  点击列表delegate方法
 *
 *  @param tableView view
 *  @param dataItems 对应数据源
 */
- (void)didTableView:(SGVTableView *)tableView dataItem:(NSDictionary *)dataItem;

/**
 *	@brief	修改表格
 *
 *	@param 	tableView 	tableView
 *	@param 	tableViewCell 	tableViewCell
 *	@param 	indexPath 	位置
 *
 */
-(void)customWithTableView:(UITableView *)tableView tableViewCell:(SGVTableViewBaseCell *)tableViewCell indexPath:(NSIndexPath *)indexPath;

/**
 *	@brief	提供tableView红点或未读数view接口
 *
 *	@param 	tableViewCell 	tableViewCell
 *	@param 	indexPath 	位置
 *
 *	@return 红点或未读数view
 */
-(UIView *)tableViewCell:(SGVTableViewBaseCell *)tableViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath;
/**
 *	@brief	更新view的高度
 *
 *	@param 	height 	需要的高度
 *
 *	@return 无
 */
- (void)updateFrameHeight:(CGFloat)height fromTableView:(SGVTableView *)aTableView;
@end

@interface SGVTableView : UIView
/**
 *  内容展示方式
 */
@property (nonatomic, assign) SGVContentShowType showType;

/**
 *  列表数据
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  delegate
 */
@property (nonatomic, weak)id <SGVTableViewDelegate>delegate;

/**
 *	@brief	刷新界面
 *
 *	@param 	无
 *
 *	@return	无
 */
- (void)reload;

/**
 *	@brief	设置个性化cell信息
 *
 *	@param 	cellIdentifier 个性化cell标识符
 *	@param 	cellClass 个性化cell类
 *
 *	@return	无
 */
- (void)setCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass;
@end
