//
//  SGVConst.h
//  Pods
//
//  Created by 季风 on 2017/7/6.
//
//

#ifndef SGVConst_h
#define SGVConst_h

#define SGVAdaptRate ([UIScreen mainScreen].bounds.size.width)/375.0

static NSString *kSGVMainTextColor = @"#333333";
static NSString *kSGVEmptyString = @"";

static NSString *kSGVDefaultImageName = @"SGVGridViewImages.bundle/fxtx";

static NSString *kSGVUserDefaultKeyCustomOrders = @"%@_orders";

typedef NS_ENUM(NSUInteger, SGVLayoutType) {
    SGVLayoutTypeSquare,//九宫格模式,默认
    SGVLayoutTypeTable   //列表模式
};

static CGFloat const kSGVStandardItemSizeWidth = 120.0f;
static CGFloat const kSGVStandardItemSizeHeight = 120.0f;
static CGFloat const kSGVStandardImageSizeWidth = 40.0f;
static CGFloat const kSGVStandardImageSizeHeight = 40.0f;

#endif /* SGVConst_h */
