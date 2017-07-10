//
//  SGVTableViewBaseCell.m
//  
//
//  Created by 季风 on 16/5/17.
//
//

#import "SGVTableViewBaseCell.h"

@implementation SGVTableViewBaseCell

#pragma mark -
#pragma mark - Public
-(void)resetEmptyData
{
    self.item = nil;
    self.hotCountShowWay = 0;
    self.hotCount = 0;
    self.countHotView = nil;
}

#pragma mark - setter

-(void)setcountHotView:(UIView *)countHotView {
    _countHotView = countHotView;
    [self setNeedsLayout];
}

- (void)setItem:(NSDictionary *)item {
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

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    [self setNeedsLayout];
}

@end
