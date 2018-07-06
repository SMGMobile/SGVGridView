//
//  SGVTableView.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVTableView.h"
#import "SGVTableViewBaseCell.h"
#import "SGVTableViewCell.h"
#import "SGVUtil.h"

static CGFloat cellHeight =50;

@interface SGVTableView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong,getter=tableView) UITableView*tableView;

/**
 *  自定义表格ID
 */
@property (nonatomic, strong) NSString *cellIdentifier;

/**
 *  自定义表格Class
 */
@property (nonatomic, assign) Class cellClass;

@end

@implementation SGVTableView

static NSString *identifier = @"SGVTableViewCell";

#pragma mark - INIT
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.cellIdentifier = identifier;
        self.cellClass = [SGVTableViewCell class];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showType==SGVContentShowTypeExpand) {
        self.tableView.scrollEnabled = NO;
        CGFloat height = cellHeight * self.items.count;
        if (height<0) {
            height=0;
        }
        CGRect tableViewRect =  self.bounds;
        tableViewRect.size.height = height;
        self.tableView.frame = tableViewRect;
        
        CGRect selfRect = self.frame;
        selfRect.size.height = height;
        self.frame = selfRect;
        
        [self.delegate updateFrameHeight:height fromTableView:self];
    } else if (self.showType==SGVContentShowTypeScroll) {
        self.tableView.frame = self.bounds;
        self.tableView.scrollEnabled = YES;
    }
    [self reload];
}

#pragma mark - 
#pragma mark - Private
-(void)loadCountHotViewWithCell:(SGVTableViewBaseCell *)cell WithIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:countHotViewForCellIndex:)]) {
        UIView *countHotView =[self.delegate tableViewCell:cell countHotViewForCellIndex:indexPath];
        cell.countHotView = countHotView;
    }
}

#pragma mark - Public 
- (void)reload {
    [_tableView reloadData];
}

- (void)setCellIdentifier:(NSString *)cellIdentifier cellClass:(Class)cellClass {
    self.cellIdentifier = cellIdentifier;
    self.cellClass = cellClass;
}

#pragma mark - setter、geter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#endif
    }
    return _tableView;
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    SGVTableViewBaseCell *cell =[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (cell == nil) {
        //为了保证下面方法执行，所以不能在初始化的时候调用registerClass或registerNib方法
        cell =[[self.cellClass alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [SGVUtil colorWithHexString:@"#cccccc"];
    cell.selectedBackgroundView.alpha =0;
    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell resetEmptyData];

    cell.item = self.items[row];
    
    //调用自定义红点界面方法
    [self loadCountHotViewWithCell:cell WithIndexPath:indexPath];
    
    //所有控件创建完毕后再调用代理方法，由外部进行修改
    if (self.delegate&&[self.delegate respondsToSelector:@selector(customWithTableView: tableViewCell:indexPath:)]) {
        [self.delegate customWithTableView:tableView tableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击单元格");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row < self.items.count) {
        if (self.delegate  && [self.delegate respondsToSelector:@selector(didTableView:dataItem:)]) {
            [self.delegate didTableView:self dataItem:self.items[indexPath.row]];
        }
    }
}

@end
