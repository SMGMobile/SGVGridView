//
//  SGVCollectionViewBaseCell.h
//  BusinessFrameworkDemo
//
//  Created by 季风 on 16/5/16.
//  Copyright © 2016年 yourcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGVCollectionViewBaseCell : UICollectionViewCell
/**
 *  九宫格项目模型对象
 */
@property (nonatomic, strong) NSDictionary *item;

/**
 *  未读信息的显示方式，0：红点，1：数字
 */
@property (nonatomic, assign) NSUInteger hotCountShowWay;

/**
 *  未读信息数量
 */
@property (nonatomic, assign) NSUInteger hotCount;

/**
 *  未读信息个性化视图
 */
@property (nonatomic, strong) UIView *countHotView;

/**
 *  表格文字背景色
 */
@property (nonatomic, strong) UIColor *cellFontColor;

/**
 *  表格文字基础字号（以iPhone6界面为准）
 */
@property (nonatomic, assign) CGFloat cellBaseFontSize;

/**
 *  表格选中背景色
 */
@property (nonatomic, strong) UIColor *cellSelectedColor;
/**
 图片大小
 */
@property (nonatomic, assign) CGSize imageSize;
/**
 cell实际大小与预设大小的比例，该值受屏幕分辨率，每行cell的个数影响
 */
@property (nonatomic, assign) CGFloat scale;
/**
 *	@brief	cell上数据重置到默认数据
 *
 */
-(void)resetEmptyData;

@end
