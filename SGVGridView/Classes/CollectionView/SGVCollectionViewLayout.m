//
//  SGVCollectionViewLayout.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVCollectionViewLayout.h"

@implementation SGVCollectionViewLayout

- (instancetype)init {
    if (self=[super init]) {
        self.minimumLineSpacing = 1;
        self.minimumInteritemSpacing = 1;
        self.itemSize = CGSizeMake(90,90);
    }
    return self;
}

@end
