//
//  SGVGridViewDataName.h
//  Pods
//
//  Created by 季风 on 2017/7/10.
//
//

#import <Foundation/Foundation.h>

/**
 *  有数据更新，需要刷新界面通知
 */
extern NSString * const kSGVGridViewUpdateNotification;
/**
 *  刷新界面通知userInfo中的DataID字段的key
 */
extern NSString * const kSGVNotificationKeyDataID;
/**
 *  刷新界面通知userInfo中的Data字段的key
 */
extern NSString * const kSGVNotificationKeyViewData;

// 表格数据ID，用以初始化
extern NSString * const kSGVDataKeyDataID;
// 表格唯一识别ID，用来保存拖拽数据等场景，该字段的值和DataID一般不相同
extern NSString * const kSGVDataKeyUniqueID;
// 布局类型：九宫格、列表
extern NSString * const kSGVDataKeyLayoutType;
// 每行的单元格数量
extern NSString * const kSGVDataKeyNumberInRow;
// 数组，表格的项目数据列表
extern NSString * const kSGVDataKeyItems;
// 项目的ID
extern NSString * const kSGVDataKeyItemID;
// 项目的显示名称
extern NSString * const kSGVDataKeyItemName;
// 项目的图片地址，本地路径或者网络地址
extern NSString * const kSGVDataKeyImageURL;
// 项目的排序
extern NSString * const kSGVDataKeyOrder;
// 项目点击后的跳转路径，可以是网络地址、原生VC、原生方法等
extern NSString * const kSGVDataKeyPath;
