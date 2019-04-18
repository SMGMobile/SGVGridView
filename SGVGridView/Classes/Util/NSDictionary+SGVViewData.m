//
//  NSDictionary+SGVViewData.m
//  Pods
//
//  Created by 季风 on 2017/7/31.
//
//

#import "NSDictionary+SGVViewData.h"
#import "SGVGridViewDataName.h"

@implementation NSDictionary (SGVViewData)

#pragma mark -
#pragma mark - getter
- (NSString *)sgvDataID {
    return self[kSGVDataKeyDataID];
}

- (NSString *)sgvUniqueID {
    return self[kSGVDataKeyUniqueID];
}

- (SGVLayoutType)sgvLayoutType {
    return [self[kSGVDataKeyLayoutType] intValue];
}

- (int)sgvNumberInRow {
    return [self[kSGVDataKeyNumberInRow] intValue];
}

- (NSArray *)sgvItems {
    return [self convertToJSON:self[kSGVDataKeyItems]];
}

- (NSString *)sgvItemID {
    return self[kSGVDataKeyItemID];
}

- (NSString *)sgvItemName {
    return self[kSGVDataKeyItemName];
}

- (NSString *)sgvImageURL {
    return self[kSGVDataKeyImageURL];
}

- (NSString *)sgvBigImageURL {
    return self[kSGVDataKeyBigImageURL];
}

- (NSString *)sgvItemDescription {
    return self[kSGVDataKeyItemDescription];
}

- (NSString *)sgvOrder {
    return self[kSGVDataKeyOrder];
}

- (NSString *)sgvPath {
    return self[kSGVDataKeyPath];
}

- (NSDictionary *)sgvSecondPageData {
    return [self convertToJSON:self[kSGVDataKeySecondPageData]];
}

- (NSDictionary *)sgvExtraInfo {
    return [self convertToJSON:self[kSGVDataKeyExtraInfo]];
}

- (id)convertToJSON:(id)value {
    NSError *err;
    //判断是否为json字符串
    if ([value isKindOfClass:[NSString class]]) {
        NSString *jsonstr = (NSString*)value;
        NSString *containString = @":";
        NSRange range = [jsonstr rangeOfString:containString];
        if (range.location == NSNotFound || jsonstr.length==0) {
            return nil;
        }
        NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
        id dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        return dict;
    } else if ([value isKindOfClass:[NSData class]]) {
        NSString *jsonstr = [[NSString alloc]initWithData:(NSData *)value encoding:NSUTF8StringEncoding];
        NSString *containString = @":";
        NSRange range = [jsonstr rangeOfString:containString];
        if (range.location == NSNotFound || jsonstr.length==0) {
            return nil;
        }
        id dict = [NSJSONSerialization JSONObjectWithData:(NSData *)value options:NSJSONReadingAllowFragments error:&err];
        return dict;
    } else if ([value isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return value;
    }
}

@end
