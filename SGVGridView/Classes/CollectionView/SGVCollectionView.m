//
//  SGVCollectionView.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVCollectionView.h"
#import "SGVCollectionViewBaseCell.h"
#import "SGVCollectionViewCell.h"
#import "SGVCollectionViewLayout.h"
#import "XWDragCellCollectionView.h"
#import "SGVUtil.h"

static NSString *identifier = @"SGVCollectionViewCellidentifier";

@interface SGVCollectionView () <XWDragCellCollectionViewDataSource,XWDragCellCollectionViewDelegate>
{
    int extra;
}

/**
 *  底层的滚动视图，可以用来控制九宫格是否横向翻页，暂时不使用
 */
@property (strong, nonatomic,getter = mainView) UIScrollView *mainView;

/**
 *  九宫格视图
 */
@property (strong, nonatomic,getter = collectionView) XWDragCellCollectionView *collectionView;

/**
 *  自定义表格ID
 */
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 *  自定义表格Class
 */
@property (nonatomic, assign) Class cellClass;

@property (nonatomic, strong) NSMutableArray *oldItems;
@property (nonatomic, assign) CGSize actualItemSize;
@end

@implementation SGVCollectionView
@synthesize dyLayout = _dyLayout;
@synthesize isDragSquare =_isDragSquare;

#pragma mark - Public
- (void)reload {
    [self.collectionView reloadData];
    [self setNeedsLayout];
}

- (void)setCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass {
    self.cellIdentifier = cellIdentifier;
    self.cellClass = cellClass;
    
    [_collectionView registerClass:self.cellClass forCellWithReuseIdentifier:self.cellIdentifier];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //表格信息
        self.cellIdentifier = identifier;
        self.cellClass = [SGVCollectionViewCell class];
        
        //默认是垂直滑动
        self.scrollType = SGVCollectionScrollTypeVertical;
        _numberOfRow = 3;
        _needSeparatrix = YES;
        [self addSubview:self.mainView];
        [self.mainView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self setCollectionViewBackgroundColor];
    
    int screenWidth=self.bounds.size.width;
    int perWidth, perHeight;
    //总宽度减去左侧，右侧和中间的空白，除以每行个数取余，得到余下的像素
    extra=lroundf(screenWidth-(self.numberOfRow - 1)*self.dyLayout.minimumInteritemSpacing - self.dyLayout.sectionInset.left - self.dyLayout.sectionInset.right)%self.numberOfRow;
    
    //总宽度减去左侧，右侧和中间的空白，除以每行个数取整，得到每个九宫格的平均宽度
    perWidth= (int)(lroundf(screenWidth-(self.numberOfRow - 1)*self.dyLayout.minimumInteritemSpacing - self.dyLayout.sectionInset.left - self.dyLayout.sectionInset.right)/self.numberOfRow);
    
    switch (self.dyLayout.itemSizeType) {
        case SGVCollectionViewItemSizeTypeProportion:
            //保持原始比例，通过平均宽度算出平均高度
            perHeight = perWidth*self.dyLayout.itemSize.height/self.dyLayout.itemSize.width;
            break;
        case SGVCollectionViewItemSizeTypeFixedHeight: {
            //保持固定高度
            perHeight = self.dyLayout.itemSize.height;
            break;
        }
        default:
            break;
    }
    
    self.actualItemSize = CGSizeMake(perWidth, perHeight);
    
    //设置collectionView实时高度
    double number = self.numberOfRow;
    int row=ceil(self.items.count/number);
    int height= self.dyLayout.sectionInset.top + self.actualItemSize.height*row + self.dyLayout.minimumLineSpacing*(row-1) + self.dyLayout.sectionInset.bottom;
    if (height<0) {
        height=0;
    }
    
    if (self.showType == SGVContentShowTypeScroll) {
        CGRect collectRect = self.bounds;
        if (height<collectRect.size.height) {
            collectRect.size.height = height;
        }
        
        [self.collectionView setFrame:collectRect];
    } else if (self.showType == SGVContentShowTypeExpand) {
        CGRect collectRect = self.bounds;
        collectRect.size.height = height;
        self.collectionView.frame = collectRect;
        CGRect selfRect = self.frame;
        if (selfRect.size.height!=height) {
            selfRect.size.height = height;
            self.frame = selfRect;
            [self.delegate updateFrameHeight:height fromCollectionView:self];
        }
    }
    self.mainView.frame = self.bounds;
}

#pragma mark -
#pragma mark - Private
- (void)loadCountHotViewWithCell:(SGVCollectionViewBaseCell *)cell WithIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCell:countHotViewForCellIndex:)]) {
        UIView *countHotView =[self.delegate collectionViewCell:cell countHotViewForCellIndex:indexPath];
        cell.countHotView = countHotView;
    }
}

#pragma mark - setter
- (void)setItems:(NSArray *)aItems {
    _items = aItems;
    [self reload];
}

- (void)setNumberOfRow:(int)numberOfRow {
    _numberOfRow = numberOfRow;
    [self reload];
}

- (void)setFullRowPadding:(BOOL)fullRowPadding {
    _fullRowPadding = fullRowPadding;
    [self reload];
}

- (void)setShakeWhenDragging:(BOOL)shakeWhenDragging {
    _shakeWhenDragging = shakeWhenDragging;
    self.collectionView.shakeWhenMoveing = _shakeWhenDragging;
    [self reload];
}

- (void)setDyLayout:(SGVCollectionViewLayout *)dyLayout {
    _dyLayout = dyLayout;
    self.collectionView.collectionViewLayout = _dyLayout;
    [self.collectionView setNeedsLayout];
}

#pragma mark - getter
- (UIScrollView *)mainView {
    if (!_mainView) {
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_mainView setBackgroundColor:[UIColor clearColor]];
    }
    return _mainView;
}

- (SGVCollectionViewLayout *) dyLayout {
    if (!_dyLayout) {
        _dyLayout =[[SGVCollectionViewLayout alloc]init];
        [_dyLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _dyLayout.minimumLineSpacing=1;
        _dyLayout.minimumInteritemSpacing=1;
        _dyLayout.headerReferenceSize = CGSizeMake(0, 0);
        _dyLayout.footerReferenceSize = CGSizeMake(0, 0);
    }
    return _dyLayout;
}

- (XWDragCellCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[XWDragCellCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.dyLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.minimumPressDuration = 0.5;
        [_collectionView registerClass:self.cellClass forCellWithReuseIdentifier:self.cellIdentifier];
        [self setCollectionViewBackgroundColor];
    }
    return _collectionView;
}

- (void)setCollectionViewBackgroundColor {
    if (_collectionView&&_needSeparatrix) {
        [_collectionView setBackgroundColor:[SGVUtil colorWithHexString:@"#f3f3f3"]];
    } else {
        [_collectionView setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark -
#pragma mark - SVDynamicLayoutDrag
- (void)setIsDragSquare:(BOOL)aIsDragSquare {
    _isDragSquare = aIsDragSquare;
    self.collectionView.isDragSquare  = aIsDragSquare;
}

-(void)saveDrag {
    [self.collectionView xw_stopEditingModel];
}

-(void)cancelDrag {
    [self.collectionView xw_stopEditingModel];
}

- (void)startDrag {
    [self.collectionView xw_enterEditingModel];
}

#pragma mark -
#pragma mark - XWDragCellCollectionViewDataSource,XWDragCellCollectionViewDelegate
- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    _items = newDataArray;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(collectionViewMovedEnd:)]) {
        [self.delegate collectionViewMovedEnd:self];
    }
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView {
    return _items;
}

- (BOOL)collectionView:(XWDragCellCollectionView *)collectionView cellCanDragAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:cellCanDragAtIndexPath:)]) {
        return [self.delegate collectionView:self cellCanDragAtIndexPath:indexPath];
    }
    return YES;
}

- (BOOL)collectionView:(XWDragCellCollectionView *)collectionView cellCanMoveAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:cellCanMoveAtIndexPath:)]) {
        return [self.delegate collectionView:self cellCanMoveAtIndexPath:indexPath];
    }
    return YES;
}

/**
 *	@brief	拖拽将要开始
 */
-(void)dragCollectionViewWillBegin:(XWDragCellCollectionView *)collectionView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionViewWillBegin:)]) {
        [self.delegate dragCollectionViewWillBegin:self];
    }
}

/**
 *	@brief	拖拽结束
 */
-(void)dragCollectionViewEnd:(XWDragCellCollectionView *)collectionView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCollectionViewEnd:)]) {
        [self.delegate dragCollectionViewEnd:self];
    }
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {//如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.fullRowPadding) {
        double number = self.numberOfRow;
        //每行都要填满cell
        NSInteger row = ceil(self.items.count/number)*self.numberOfRow;
        return row;
    } else {
        return self.items.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    SGVCollectionViewBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    //cell清空数据
    [cell resetEmptyData];
    
    if (self.cellBackgroundColor) {
        cell.backgroundColor = self.cellBackgroundColor;
    }
    if (self.cellFontColor) {
        cell.cellFontColor = self.cellFontColor;
    }
    if (self.cellSelectedColor) {
        cell.cellSelectedColor = self.cellSelectedColor;
    }
    CGFloat widthScale = self.actualItemSize.width / kSGVStandardItemSizeWidth;
    CGFloat heightScale = self.actualItemSize.height / kSGVStandardItemSizeHeight;
    CGFloat scale = widthScale < heightScale ? widthScale : heightScale;
    cell.scale = scale;
    cell.imageSize = self.dyLayout.imageSize;
    
    if (row < self.items.count) {
        cell.item = self.items[row];
        [self loadCountHotViewWithCell:cell WithIndexPath:indexPath];
        //调用代理方法修改cell
        if (self.delegate&&[self.delegate respondsToSelector:@selector(customWithCollectionView:collectionViewCell:indexPath:)]) {
            [self.delegate customWithCollectionView:collectionView collectionViewCell:cell indexPath:indexPath];
        }
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row]%self.numberOfRow<extra) {
        return CGSizeMake(self.actualItemSize.width+1, self.actualItemSize.height);
    }else {
        return self.actualItemSize;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    if (row < self.items.count && !self.collectionView.isEditing) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCollectionView:dataItem:)]) {
            [self.delegate didCollectionView:self dataItem:self.items[indexPath.row]];
        }
    }
    
}

@end
