//
//  SGVCollectionView.h
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGVGridView.h"

typedef NS_ENUM(NSUInteger, SGVCollectionScrollType) {
    SGVCollectionScrollTypeVertical, //垂直滑动 默认
    SGVCollectionScrollTypeHorizontal, //水平滑动
};

@class SGVCollectionViewLayout;
@class SGVCollectionView;
@class SGVCollectionViewBaseCell;

@protocol SGVCollectionViewDelegate <NSObject>

/**
 *	@brief	拖拽将要开始
 */
-(void)dragCollectionViewWillBegin:(SGVCollectionView *)collectionView;
/**
 *	@brief	拖拽结束
 */
-(void)dragCollectionViewEnd:(SGVCollectionView *)collectionView;

/**
 *	@brief	九宫格表格被点击方法
 *
 *	@param 	collectionView 	九宫格view
 *	@param 	dataItem 	被点击的九宫格表格对应的数据模型
 *
 */
- (void)didCollectionView:(SGVCollectionView *)collectionView dataItem:(NSDictionary *)dataItem;
/**
 *	@brief	提供红点或未读数view接口
 *
 *	@param 	collectionViewCell 	表格view
 *	@param 	indexPath 	位置
 *
 *	@return 红点或未读数view
 */
-(UIView *)collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath;
/**
 *	@brief	修改cell
 *
 *	@param 	collectionView 	表格
 *	@param 	collectionViewCell 	表格view
 *	@param 	indexPath 	位置
 *
 */
-(void)customWithCollectionView:(UICollectionView *)collectionView collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell indexPath:(NSIndexPath *)indexPath;
/**
 *	@brief	更新view的高度
 *
 *	@param 	height 	需要的高度
 *
 */
- (void)updateFrameHeight:(CGFloat)height fromCollectionView:(SGVCollectionView *)aCollectionView;

@end

@interface SGVCollectionView: UIView <SGVDragProtocol>
/**
 *  内容展示方式
 */
@property (nonatomic, assign) SGVContentShowType showType;

/**
 *  每行的个数
 */
@property (nonatomic) int numberOfRow;

/**
 *  九宫格数据
 */
@property (nonatomic, strong) NSArray *items;

/**
 *  水平滑动（默认）、还是垂直滑动
 */
@property (nonatomic) SGVCollectionScrollType scrollType;

/**
 *  是否有分割线 默认YES
 */
@property (nonatomic) BOOL needSeparatrix;
/**
 九宫格显示时cell是否需要整行填充
 */
@property (nonatomic, assign) BOOL fullRowPadding;
/**是否开启拖动的时候所有cell抖动的效果*/
@property (nonatomic, assign) BOOL shakeWhenDragging;

/**
 *  表格背景色
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
 *  布局对象
 */
@property (nonatomic, strong) SGVCollectionViewLayout *dyLayout;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<SGVCollectionViewDelegate> delegate;

/**
 *	@brief	刷新界面
 *
 */
- (void)reload;

/**
 *	@brief	设置个性化cell信息
 *
 *	@param 	cellIdentifier 个性化cell标识符
 *	@param 	cellClass 个性化cell类
 *
 */
- (void)setCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass;
@end
