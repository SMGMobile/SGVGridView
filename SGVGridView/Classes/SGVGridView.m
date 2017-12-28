//
//  SGVGridView.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/9.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVGridView.h"
#import "SGVTableView.h"
#import "SGVCollectionView.h"
#import "SGVCollectionViewBaseCell.h"
#import "SGVConst.h"
#import "SGVGridViewDataName.h"
#import "NSDictionary+SGVViewData.h"

@interface SGVGridView() <SGVTableViewDelegate,SGVCollectionViewDelegate>
/**
 *  九宫格界面对象
 */
@property (nonatomic, strong) SGVCollectionView *dyLayoutCollectionView;
/**
 *  列表界面对象
 */
@property (nonatomic, strong) SGVTableView *dyLayoutTableView;
/**
 *  九宫格模型
 */
@property (nonatomic, strong) NSDictionary *viewData;
@property (nonatomic, strong) NSMutableArray *savedOrders;
@property (nonatomic, strong) NSArray *sortedItems;
@end

@implementation SGVGridView
@synthesize isDragSquare = _isDragSquare;

#pragma mark - Public
- (void)reloadData {
    //如果是九宫格
    if (_layoutType == SGVLayoutTypeSquare) {
        //设置数据
        _dyLayoutCollectionView.items = self.sortedItems;
        [self showCollectionView];
    } else if (_layoutType == SGVLayoutTypeTable) {
        //设置数据
        _dyLayoutTableView.items = self.sortedItems;
        [self showTableView];
    }
}

- (void)setCollectionViewCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass {
    if (_dyLayoutCollectionView) {
        [_dyLayoutCollectionView setCellIdentifier:cellIdentifier cellClass:cellClass];
        [self reloadData];
    }
}

- (void)setTableViewCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass {
    if (_dyLayoutTableView) {
        [_dyLayoutTableView setCellIdentifier:cellIdentifier cellClass:cellClass];
        [self reloadData];
    }
}

- (void)updateWithDynamicLayoutData:(NSDictionary *)data {
    _viewData = data;
    [self servyouSetup];
}

#pragma mark -
#pragma mark - INIT
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSGVGridViewUpdateNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame dynamicLayoutData:nil];
}

- (instancetype)initWithFrame:(CGRect)frame dynamicLayoutData:(NSDictionary *)data {
    if (self = [super initWithFrame:frame]) {
        _layoutType = SGVLayoutTypeSquare;
        _numberOfRow = 3;
        _needSeparatrix = YES;
        _fullRowPadding = YES;
        _shakeWhenDragging = YES;
        _viewData = data;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:kSGVGridViewUpdateNotification object:nil];
        [self servyouSetup];
    }
    return self;
}


- (void)updateUI:(NSNotification *)notification {
    NSLog(@"begin - (void)updateUI:(NSNotification *)notification");
    id data = [notification.userInfo objectForKey:kSGVNotificationKeyViewData];
    NSString *dataID = [notification.userInfo objectForKey:kSGVNotificationKeyDataID];
    if ([dataID isEqualToString:self.fitId]&&data) {
        self.viewData = data;
        [self servyouSetup];
    }
}

#pragma mark - Private
    
- (void)servyouSetup {
    self.fitId = self.viewData.sgvDataID;
    self.uniqueID = self.viewData.sgvUniqueID;
    
    self.savedOrders = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:kSGVUserDefaultKeyCustomOrders, self.uniqueID]] mutableCopy];
    
    self.layoutType = self.viewData.sgvLayoutType;
    int numberInRow = self.viewData.sgvNumberInRow;
    if (numberInRow > 0) {
        _numberOfRow = numberInRow;
    }
    
    NSArray *squareItems = self.viewData.sgvItems;
    NSSortDescriptor *sortDescriptor =[NSSortDescriptor sortDescriptorWithKey:kSGVDataKeyOrder ascending:YES comparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = [NSString stringWithFormat:@"%@", obj1];
        NSString *str2 = [NSString stringWithFormat:@"%@", obj2];
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    squareItems = [squareItems sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.dyLayoutItems = squareItems;
    [self transformItems];
    [self reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.dyLayoutTableView.frame = self.bounds;
    self.dyLayoutCollectionView.frame = self.bounds;
    if (self.sortedItems&&self.sortedItems.count>0) {
        if (_layoutType == SGVLayoutTypeSquare) {
            [self.dyLayoutCollectionView setNeedsLayout];
//            self.dyLayoutCollectionView.items = self.sortedItems;
//            [_dyLayoutCollectionView reload];
        } else {
            [self.dyLayoutTableView setNeedsLayout];
//            self.dyLayoutTableView.items = self.sortedItems;
//            [_dyLayoutTableView reload];
        }
    }
}

/**
 通过保存的排序数据转换items
 */
- (void)transformItems {
    NSMutableArray *targetArray = [NSMutableArray array];
    NSMutableArray *sourceArray = [self.dyLayoutItems mutableCopy];
    for (NSString *itemID in self.savedOrders) {
        for (NSInteger index=0; index<sourceArray.count; index++) {
            NSDictionary *item = sourceArray[index];
            if ([itemID isEqualToString:item[kSGVDataKeyItemID]]) {
                NSMutableDictionary *mItem = [item mutableCopy];
                [mItem setObject:@(targetArray.count) forKey:kSGVDataKeyOrder];
                [targetArray addObject:[mItem copy]];
                [sourceArray removeObject:item];
                break;
            }
        }
    }
    // 添加剩余的item
    for (NSDictionary *item in sourceArray) {
        NSMutableDictionary *mItem = [item mutableCopy];
        [mItem setObject:@(targetArray.count) forKey:kSGVDataKeyOrder];
        [targetArray addObject:[mItem copy]];
    }
    self.sortedItems = [targetArray copy];
}

/**
 *  展示collectionView
 */
- (void)showCollectionView {
    if (![self.dyLayoutCollectionView isDescendantOfView:self]) {
        [self addSubview:self.dyLayoutCollectionView];
    }
    self.dyLayoutCollectionView.hidden = NO;
    self.dyLayoutTableView.hidden = YES;
    
    self.dyLayoutCollectionView.showType = _showType;
    self.dyLayoutCollectionView.needSeparatrix = _needSeparatrix;
    self.dyLayoutCollectionView.fullRowPadding = _fullRowPadding;
    self.dyLayoutCollectionView.shakeWhenDragging = _shakeWhenDragging;
    self.dyLayoutCollectionView.cellBackgroundColor = self.cellBackgroundColor;
    self.dyLayoutCollectionView.cellFontColor = self.cellFontColor;
    self.dyLayoutCollectionView.cellSelectedColor = self.cellSelectedColor;
    self.dyLayoutCollectionView.numberOfRow = self.numberOfRow;
    [self.dyLayoutCollectionView setNeedsLayout];
}

/**
 *  展示TableView
 */
- (void)showTableView {
    if (![self.dyLayoutTableView isDescendantOfView:self]) {
        [self addSubview:self.dyLayoutTableView];
    }
    self.dyLayoutTableView.hidden = NO;
    self.dyLayoutCollectionView.hidden = YES;
    
    self.dyLayoutTableView.showType = _showType;
    [self.dyLayoutTableView setNeedsLayout];
}

#pragma mark - setter
- (void)setDyLayoutItems:(NSArray *)dyLayoutItems {
    _dyLayoutItems = dyLayoutItems;
    [self transformItems];
    [self reloadData];
    if (!_dyLayoutItems) {
        //        [self startWaittingWithSuperView:self];
    }else{
        //        [self stopWaitting];
    }
}

- (void)setShowType:(SGVContentShowType)showType {
    _showType = showType;
    [self reloadData];
}

- (void)setLayoutType:(SGVLayoutType)layoutType {
    _layoutType = layoutType;
    [self reloadData];
}

- (void)setNeedSeparatrix:(BOOL)needSeparatrix {
    _needSeparatrix = needSeparatrix;
    [self reloadData];
}

- (void)setFullRowPadding:(BOOL)fullRowPadding {
    _fullRowPadding = fullRowPadding;
    [self reloadData];
}

- (void)setShakeWhenDragging:(BOOL)shakeWhenDragging {
    _shakeWhenDragging = shakeWhenDragging;
    [self reloadData];
}

- (void)setDyCollectionViewLayout:(SGVCollectionViewLayout *)dyCollectionViewLayout {
    _dyCollectionViewLayout = dyCollectionViewLayout;
    self.dyLayoutCollectionView.dyLayout = _dyCollectionViewLayout;
}

- (void)setNumberOfRow:(int)numberOfRow {
    //如果九宫格服务端配置了每行的数量，则不允许在代码中修改
    int number = self.viewData.sgvNumberInRow;
    if (number > 0) {
        return;
    }
    _numberOfRow = numberOfRow;
    [self reloadData];
}

- (void)setCellBackgroundColor:(UIColor *)cellBackgroundColor {
    _cellBackgroundColor = cellBackgroundColor;
    [self reloadData];
}

- (void)setCellFontColor:(UIColor *)cellFontColor {
    _cellFontColor = cellFontColor;
    [self reloadData];
}

- (void)setCellSelectedColor:(UIColor *)cellSelectedColor {
    _cellSelectedColor = cellSelectedColor;
    [self reloadData];
}

#pragma mark -
#pragma mark - getter
- (SGVCollectionView *)dyLayoutCollectionView {
    if (!_dyLayoutCollectionView) {
        _dyLayoutCollectionView =[[SGVCollectionView alloc]initWithFrame:self.bounds];
        _dyLayoutCollectionView.delegate = self;
        _dyLayoutCollectionView.numberOfRow = self.numberOfRow;
    }
    return _dyLayoutCollectionView;
}

- (SGVTableView *)dyLayoutTableView {
    if (!_dyLayoutTableView) {
        _dyLayoutTableView =[[SGVTableView alloc]initWithFrame:self.bounds];
        _dyLayoutTableView.delegate = self;
    }
    return _dyLayoutTableView;
}

- (NSMutableArray *)savedOrders {
    if (!_savedOrders) {
        _savedOrders = [NSMutableArray array];
    }
    return _savedOrders;
}

- (NSArray *)sortedItems {
    if (!_sortedItems) {
        _sortedItems = [NSArray array];
    }
    return _sortedItems;
}

#pragma mark -
#pragma mark - SVDynamicLayoutDrag
- (void)setIsDragSquare:(BOOL)aIsDragSquare {
    _isDragSquare = aIsDragSquare;
    self.dyLayoutCollectionView.isDragSquare = aIsDragSquare;
}

- (NSArray *)draggedItems {
    return self.dyLayoutCollectionView.items;
}

- (void)saveDrag {
    [self.savedOrders removeAllObjects];
    for (NSInteger index =0; index<self.dyLayoutCollectionView.items.count; index++) {
        NSDictionary *item = self.dyLayoutCollectionView.items[index];
        
        [self.savedOrders addObject:[NSString stringWithFormat:@"%@",item[kSGVDataKeyItemID]]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.savedOrders forKey:[NSString stringWithFormat:kSGVUserDefaultKeyCustomOrders, self.uniqueID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self transformItems];
    [self.dyLayoutCollectionView saveDrag];
}

- (void)cancelDrag {
    [self.dyLayoutCollectionView cancelDrag];
    [self reloadData];
}

- (void)startDrag {
    [self.dyLayoutCollectionView startDrag];
}

- (void)clearDragData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:kSGVUserDefaultKeyCustomOrders, self.uniqueID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.savedOrders removeAllObjects];
    [self transformItems];
    [self reloadData];
}

#pragma mark -
#pragma mark - SGVTableViewDelegate
- (void)didTableView:(SGVTableView *)tableView dataItem:(NSDictionary *)dataItem {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedView:WithItem:)]) {
        [self.delegate didSelectedView:self WithItem:dataItem];
    }
}

- (UIView *)tableViewCell:(SGVTableViewBaseCell *)tableViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath {
    UIView *countHotView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicLayoutView:tableViewCell:countHotViewForCellIndex:)]) {
        countHotView =[self.delegate dynamicLayoutView:self tableViewCell:tableViewCell countHotViewForCellIndex:indexPath];
    }
    return countHotView;
}

- (void)updateFrameHeight:(CGFloat)height fromTableView:(SGVTableView *)aTableView {
    if (self.layoutType!=SGVLayoutTypeTable) {
        return;
    }
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
    //高度变化后通知其代理
    if ([self.delegate respondsToSelector:@selector(frameUpdated:)]) {
        [self.delegate frameUpdated:self];
    }
}

#pragma mark -
#pragma mark - SGVCollectionViewDelegate
- (void)dragCollectionViewWillBegin:(SGVCollectionView *)collectionView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionViewWillBegin:)]) {
        [self.delegate dragCollectionViewWillBegin:self];
    }
}

- (void)dragCollectionViewEnd:(SGVCollectionView *)collectionView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionViewEnd:)]) {
        [self.delegate dragCollectionViewEnd:self];
    }
}

- (void)collectionViewMovedEnd:(SGVCollectionView *)collectionView {
    if ([self.delegate respondsToSelector:@selector(collectionViewMovedEnd:)]) {
        [self.delegate collectionViewMovedEnd:self];
    }
}

- (BOOL)collectionView:(SGVCollectionView *)collectionView cellCanDragAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:cellCanDragAtIndexPath:)]) {
        return [self.delegate collectionView:self cellCanDragAtIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(SGVCollectionView *)collectionView cellCanMoveAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:cellCanMoveAtIndexPath:)]) {
        return [self.delegate collectionView:self cellCanMoveAtIndexPath:indexPath];
    }
    return YES;
}

- (void)didCollectionView:(SGVCollectionView *)collectionView dataItem:(NSDictionary *)dataItem {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedView:WithItem:)]) {
        [self.delegate didSelectedView:self WithItem:dataItem];
    }
}

- (UIView *)collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell countHotViewForCellIndex:(NSIndexPath *)indexPath {
    UIView *countHotView = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dynamicLayoutView:collectionViewCell:countHotViewForCellIndex:)]) {
        countHotView =[self.delegate dynamicLayoutView:self collectionViewCell:collectionViewCell countHotViewForCellIndex:indexPath];
    }
    return countHotView;
}

- (void)customWithCollectionView:(UICollectionView *)collectionView collectionViewCell:(SGVCollectionViewBaseCell *)collectionViewCell indexPath:(NSIndexPath *)indexPath {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customWithDynamicLayoutView:collectionView:collectionViewCell:indexPath:)]) {
        [self.delegate customWithDynamicLayoutView:self collectionView:collectionView collectionViewCell:collectionViewCell indexPath:indexPath];
    }
}

- (void)customWithTableView:(UITableView *)tableView tableViewCell:(SGVTableViewBaseCell *)tableViewCell indexPath:(NSIndexPath *)indexPath {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customWithDynamicLayoutView:tableView:tableViewCell:indexPath:)]) {
        [self.delegate customWithDynamicLayoutView:self tableView:tableView tableViewCell:tableViewCell indexPath:indexPath];
    }
}

- (void)updateFrameHeight:(CGFloat)height fromCollectionView:(SGVCollectionView *)aCollectionView {
    if (self.layoutType!=SGVLayoutTypeSquare) {
        return;
    }
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
    //高度变化后通知其代理
    if ([self.delegate respondsToSelector:@selector(frameUpdated:)]) {
        [self.delegate frameUpdated:self];
    }
}

@end
