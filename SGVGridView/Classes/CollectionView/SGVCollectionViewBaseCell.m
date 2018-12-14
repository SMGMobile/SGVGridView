//
//  SGVCollectionViewBaseCell.m
//  BusinessFrameworkDemo
//
//  Created by 季风 on 16/5/16.
//  Copyright © 2016年 yourcompany. All rights reserved.
//

#import "SGVCollectionViewBaseCell.h"

@interface SGVCollectionViewBaseCell ()

@end

@implementation SGVCollectionViewBaseCell

#pragma mark -
#pragma mark - Public
-(void)resetEmptyData
{
    self.item = nil;
    self.hotCountShowWay = 0;
    self.hotCount = 0;
    self.countHotView = nil;
    self.cellBaseFontSize = 0;
}

#pragma mark - setter

-(void)setcountHotView:(UIView *)countHotView
{
    _countHotView = countHotView;
    [self setNeedsLayout];
}
- (void)setItem:(NSDictionary *)item
{
    _item = item;
    [self setNeedsLayout];
}

- (void)setHotCountShowWay:(NSUInteger)hotCountShowWay {
    _hotCountShowWay = hotCountShowWay;
    [self setNeedsLayout];
}

- (void)setHotCount:(NSUInteger)hotCount {
    _hotCount = hotCount;
    [self setNeedsLayout];
}

@end
