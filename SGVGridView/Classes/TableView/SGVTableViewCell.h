//
//  SGVTableViewBaseCell.h
//  TestSMGFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVTableViewBaseCell.h"

@interface SGVTableViewCell : SGVTableViewBaseCell
/**
 *  未读消息标签
 */
@property (nonatomic, getter=unReadLabel, strong) UILabel *unReadLabel;
/**
 *  分割线标签
 */
@property (nonatomic, getter=lineLabel, strong) UILabel *lineLabel;

@end
