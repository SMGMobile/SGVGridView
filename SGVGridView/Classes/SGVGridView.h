//
//  SGVGridView.h
//  TestServyouFoundation
//
//  Created by Rain on 15/9/9.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGVDragProtocol.h"
#import "SGVConst.h"

//动态布局的内容如何滚动
typedef NS_ENUM(NSUInteger, SGVContentShowType) {
    SGVContentShowTypeScroll, //动态布局的View高度固定，内容超出后在自身view内滚动
    SGVContentShowTypeExpand //动态布局的View高度根据内容确定，高度不断延伸，所以需要将它添加到UIScrollView中
};


@class SGVGridView;
@class SGVCollectionViewBaseCell;
@class SGVTableViewBaseCell;

@protocol SGVGridViewDelegate <NSObject>

@optional
/**
 *	@brief	拖拽将要开始
 */
-(void)dragCollectionViewWillBegin:(SGVGridView *)dyLayoutView;
/**
 *	@brief	拖拽结束
 */
-(void)dragCollectionViewEnd:(SGVGridView *)dyLayoutView;

/**
 *  点击items事件
 *
 *  @param dyLayoutView self
 *  @param item         对应数据
 */
-(void)didSelectedView:(SGVGridView *)dyLayoutView WithItem:(NSDictionary *)item;

/**
 *	@brief	九宫格需要定制红点或未读数view时使用的接口，普通的请直接使用SGVCollectionViewBaseCell对象中的hotCountShowWay和hotCount属性；
 *
 *	@param 	dynamicLayoutView 	动态布局view
 *	@param 	collectionViewCell 	九宫格cell
 *	@param 	indexPath 	位置
 *
 *	@return 红点或未读数view
 */
-(UIView *)dynamicLayoutView:(SGVGridView *)dynamicLayoutView collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath;

/**
 *	@brief	列表需要定制红点或未读数view时使用的接口，普通的请直接使用SGVTableViewBaseCell对象中的hotCountShowWay和hotCount属性；
 *
 *	@param 	dynamicLayoutView 	动态布局view
 *	@param 	tableViewCell 	列表cell
 *	@param 	indexPath 	位置
 *
 *	@return 红点或未读数view
 */
-(UIView *)dynamicLayoutView:(SGVGridView *)dynamicLayoutView tableViewCell:(SGVTableViewBaseCell *)tableViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath;

/**
 *	@brief	九宫格项目有个性化的新增数据时，使用该接口进行数据更改；建议不要在该接口中直接往cell对象上新增view；
 *
 *	@param 	dynamicLayoutView 	动态布局view
 *	@param 	collectionViewCell 	九宫格cell
 *	@param 	indexPath 	位置
 *
 */
-(void)customWithDynamicLayoutView:(SGVGridView *)dynamicLayoutView collectionView:(UICollectionView *)collectionView collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell indexPath:(NSIndexPath *)indexPath;

/**
 *	@brief	列表项目有个性化的新增数据时，使用该接口进行数据更改；建议不要在该接口中直接往cell对象上新增view；
 *
 *	@param 	dynamicLayoutView 	动态布局view
 *	@param 	tableView 	列表
 *	@param 	tableViewCell 	列表cell
 *	@param 	indexPath 	位置
 *
 */
-(void)customWithDynamicLayoutView:(SGVGridView *)dynamicLayoutView tableView:(UITableView *)tableView tableViewCell:(SGVTableViewBaseCell *)tableViewCell indexPath:(NSIndexPath *)indexPath;
/**
 *	@brief	当showType为SGVContentShowTypeExpand，view的高度变化后，会调用此方法；
 *
 *	@param 	aDynamicLayoutView 	动态布局view
 */
-(void)frameUpdated:(SGVGridView *)aDynamicLayoutView;
@end

@class SGVCollectionViewLayout;
/**
 *	@brief	税友表格视图
 */
@interface SGVGridView: UIView <SGVDragProtocol>

/**
 *  内容展示方式
 */
@property (nonatomic, assign) SGVContentShowType showType;

/**
 *  页面id，请求时上传的字段，用于区别不同页面
 */
@property (nonatomic, copy) NSString *fitId;
@property (nonatomic, strong) NSString *uniqueID;

/**
 *  界面显示类型，默认为九宫格
 */
@property (nonatomic) SGVLayoutType layoutType;

/**
 *  九宫格显示时每行的个数，默认是3个一行。
 */
@property (nonatomic) int numberOfRow;

/**
 *  九宫格显示时是否需要分割线，默认有
 */
@property (nonatomic) BOOL needSeparatrix;
/**
 九宫格显示时cell是否需要整行填充，默认YES
 */
@property (nonatomic, assign) BOOL fullRowPadding;
/**是否开启拖动的时候所有cell抖动的效果，默认YES*/
@property (nonatomic, assign) BOOL shakeWhenDragging;
/**
 *  九宫格表格背景色
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;

/**
 *  表格文字背景色
 */
@property (nonatomic, strong) UIColor *cellFontColor;

/**
 *  表格选中背景色
 */
@property (nonatomic, strong) UIColor *cellSelectedColor;

/**
 *	@brief	see SVDynamicLayoutItem 数组
 */
@property (nonatomic, strong) NSArray *dyLayoutItems;

/**
 *	@brief	代理
 */
@property (nonatomic, weak)id <SGVGridViewDelegate >delegate;

/**
 *  布局对象
 */
@property (nonatomic, strong) SGVCollectionViewLayout *dyCollectionViewLayout;

/**
 *	@brief	视图的初始化
 *
 *	@param 	frame 	frame
 *	@param 	data 	九宫格数据字典，字段见SGVGridViewDataName.h中的定义
 *
 *	@return	视图的对象
 */
-(instancetype)initWithFrame:(CGRect)frame
       dynamicLayoutData:(NSDictionary *)data;

/**
 *	@brief	根据fitId重新查询数据，并进行初始化
 *
 */
-(void)servyouSetup;

/**
 *	@brief	刷新界面，数据不会重新查询
 *
 */
- (void)reloadData;

/**
 *	@brief	设置九宫格视图的个性化cell信息
 *
 *	@param 	cellIdentifier 	cell的ID
 *	@param 	cellClass 	cell的类，需继承自SGVCollectionViewBaseCell
 *
 */
- (void)setCollectionViewCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass;

/**
 *	@brief	设置列表视图的个性化cell信息
 *
 *	@param 	cellIdentifier 	cell的ID
 *	@param 	cellClass 	cell的类，需继承自SGVTableViewBaseCell
 *
 */
- (void)setTableViewCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass;

@end
