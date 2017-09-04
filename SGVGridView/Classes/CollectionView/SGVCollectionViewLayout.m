//
//  SGVCollectionViewLayout.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVCollectionViewLayout.h"
#import "SGVConst.h"

@implementation SGVCollectionViewLayout

- (instancetype)init {
    if (self=[super init]) {
        self.minimumLineSpacing = 1;
        self.minimumInteritemSpacing = 1;
        self.maximumInteritemSpacing = 1;
        self.itemSize = CGSizeMake(kSGVStandardItemSizeWidth,kSGVStandardItemSizeHeight);
        self.imageSize = CGSizeMake(kSGVStandardImageSizeWidth, kSGVStandardImageSizeHeight);
    }
    return self;
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing {
    [super setMinimumInteritemSpacing:minimumInteritemSpacing];
    _maximumInteritemSpacing = minimumInteritemSpacing;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据 maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        // 只有系统计算的间距大于 maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
    }
    return attributes;
}

@end
