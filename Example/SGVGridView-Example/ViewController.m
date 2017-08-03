//
//  ViewController.m
//  SGVGridView-Example
//
//  Created by 季风 on 2017/7/10.
//  Copyright © 2017年 servyou. All rights reserved.
//

#import "ViewController.h"
#import <SGVGridView/ServyouGridView.h>

@interface ViewController () <SGVGridViewDelegate>
@property (nonatomic, strong) SGVGridView *gridView;
@property (nonatomic, strong) SGVGridView *gridView2;
@property (nonatomic, strong) SGVGridView *gridView3;
@property (nonatomic, strong) SGVGridView *gridView4;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.gridView];
    [self.view addSubview:self.gridView2];
    [self.view addSubview:self.gridView3];
    [self.view addSubview:self.gridView4];
}

#pragma mark -
#pragma mark - SGVGridViewDelegate
-(void)didSelectedView:(SGVGridView *)dyLayoutView WithItem:(NSDictionary *)item {
    NSLog(@"%@:%@", item.sgvItemName, item.sgvExtraInfo);
}

#pragma mark -
#pragma mark - getter
-(SGVGridView *)gridView
{
    if (!_gridView) {
        NSDictionary *dict;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"001" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        if (data) {
            NSError *error;
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        _gridView = [[SGVGridView alloc]initWithFrame:CGRectZero dynamicLayoutData:dict];
        _gridView.frame = CGRectMake(15, 0, 345, 0);
        _gridView.showType = SGVContentShowTypeExpand;
        _gridView.delegate = self;
        _gridView.isDragSquare = YES;
    }
    return _gridView;
}

-(SGVGridView *)gridView2
{
    if (!_gridView2) {
        NSDictionary *dict;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"001" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        if (data) {
            NSError *error;
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        _gridView2 = [[SGVGridView alloc]initWithFrame:CGRectZero dynamicLayoutData:dict];
        _gridView2.frame = CGRectMake(15, 240, 345, 100);
        _gridView2.showType = SGVContentShowTypeScroll;
        _gridView2.delegate = self;
    }
    return _gridView2;
}

-(SGVGridView *)gridView3
{
    if (!_gridView3) {
        NSDictionary *dict;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"001" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        if (data) {
            NSError *error;
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        _gridView3 = [[SGVGridView alloc]initWithFrame:CGRectZero dynamicLayoutData:dict];
        _gridView3.frame = CGRectMake(15, 350, 345, 100);
        _gridView3.showType = SGVContentShowTypeExpand;
        _gridView3.delegate = self;
        _gridView3.layoutType = SGVLayoutTypeTable;
    }
    return _gridView3;
}

-(SGVGridView *)gridView4
{
    if (!_gridView4) {
        NSDictionary *dict;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"001" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:bundlePath];
        if (data) {
            NSError *error;
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        _gridView4 = [[SGVGridView alloc]initWithFrame:CGRectZero dynamicLayoutData:dict];
        _gridView4.frame = CGRectMake(15, 567, 345, 100);
        _gridView4.showType = SGVContentShowTypeScroll;
        _gridView4.delegate = self;
        _gridView4.layoutType = SGVLayoutTypeTable;
    }
    return _gridView4;
}

@end
