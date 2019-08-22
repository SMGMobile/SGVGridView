//
//  SGVDragProtocol.h
//  Squares
//
//  Created by Rain on 2017/2/23.
//  Copyright © 2017年 smg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	九宫格拖拽的协议
 */
@protocol SGVDragProtocol <NSObject>
@property (nonatomic) BOOL isDragSquare;/**<是否拖拽，默认是NO*/
/**
 开始拖拽
 */
- (void)startDrag;
/**
 保存拖拽后的排序数据
 */
- (void)saveDrag;
/**
 取消拖拽，取消后界面排序会重置会本次拖拽前的状态
 */
- (void)cancelDrag;
@optional
/**
 清空之前拖拽后保存的数据，并以原始数据中的排序，刷新界面
 */
- (void)clearDragData;
@end
