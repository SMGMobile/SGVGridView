//
//  NSDictionary+SGVViewData.h
//  Pods
//
//  Created by 季风 on 2017/7/31.
//
//

#import <Foundation/Foundation.h>
#import "SGVConst.h"

@interface NSDictionary (SGVViewData)
@property (nonatomic, strong, readonly) NSString *sgvDataID;
@property (nonatomic, strong, readonly) NSString *sgvUniqueID;
@property (nonatomic, assign, readonly) SGVLayoutType sgvLayoutType;
@property (nonatomic, assign, readonly) int sgvNumberInRow;
@property (nonatomic, strong, readonly) NSArray *sgvItems;
@property (nonatomic, strong, readonly) NSString *sgvItemID;
@property (nonatomic, strong, readonly) NSString *sgvItemName;
@property (nonatomic, strong, readonly) NSString *sgvImageURL;
@property (nonatomic, strong, readonly) NSString *sgvBigImageURL;
@property (nonatomic, strong, readonly) NSString *sgvItemDescription;
@property (nonatomic, strong, readonly) NSString *sgvOrder;
@property (nonatomic, strong, readonly) NSString *sgvPath;
@property (nonatomic, strong, readonly) NSDictionary *sgvSecondPageData;
@property (nonatomic, strong, readonly) NSDictionary *sgvExtraInfo;
@end
