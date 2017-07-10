//
//  SGVTableViewBaseCell.h
//  
//
//  Created by 季风 on 16/5/17.
//
//

#import <UIKit/UIKit.h>

@interface SGVTableViewBaseCell : UITableViewCell

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


@property (nonatomic,assign)BOOL showLine;


/**
 *	@brief	cell上数据重置到默认数据
 *
 *	@param 	无
 *
 *	@return	无
 */
-(void)resetEmptyData;

@end
