//
//  SGVConst.h
//  Pods
//
//  Created by 季风 on 2017/7/6.
//
//

#ifndef SGVConst_h
#define SGVConst_h

#define SGVAdaptRate ([UIScreen mainScreen].bounds.size.width)/320.0

static NSString *kSGVEmptyString = @"";

static NSString *kSGVDefaultImageName = @"SGVGridViewImages.bundle/fxtx";

static NSString *kSGVUserDefaultKeyCustomOrders = @"%@_orders";

typedef NS_ENUM(NSUInteger, SGVLayoutType) {
    SGVLayoutTypeSquare,//九宫格模式,默认
    SGVLayoutTypeTable   //列表模式
};

#endif /* SGVConst_h */
