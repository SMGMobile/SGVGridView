//
//  SGVCollectionViewLayout.h
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SGVCollectionViewItemSizeType) {
    SGVCollectionViewItemSizeTypeProportion, //保持宽高比
    SGVCollectionViewItemSizeTypeFixedHeight, //固定高度
};

@interface SGVCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) SGVCollectionViewItemSizeType itemSizeType;
@property (nonatomic, assign) CGSize imageSize;
@end
