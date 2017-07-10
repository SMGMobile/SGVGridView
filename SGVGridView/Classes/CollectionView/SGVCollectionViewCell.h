//
//  SGVCollectionViewCell.h
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVCollectionViewBaseCell.h"

@interface SGVCollectionViewCell: SGVCollectionViewBaseCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *functionNameLabel;

@property (nonatomic, strong) UILabel *unReadLabel;

/**
 *	@brief	cell上数据重置到默认数据
 *
 *	@param 	无
 *
 *	@return	无
 */
-(void)resetEmptyData;

@end
