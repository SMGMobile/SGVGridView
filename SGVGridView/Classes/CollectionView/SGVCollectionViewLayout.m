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
        self.itemSize = CGSizeMake(kSGVStandardItemSizeWidth,kSGVStandardItemSizeHeight);
        self.imageSize = CGSizeMake(kSGVStandardImageSizeWidth, kSGVStandardImageSizeHeight);
    }
    return self;
}

@end
