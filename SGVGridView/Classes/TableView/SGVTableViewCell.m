//
//  SGVTableViewCell.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVTableViewCell.h"
#import "SGVUtil.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SGVConst.h"
#import "SGVGridViewDataName.h"
#import "NSDictionary+SGVViewData.h"

#define UnRead_Width 14

#define UnReadOffset 6

@interface SGVTableViewCell()

@end

@implementation SGVTableViewCell

#pragma mark -
#pragma mark - Public
-(void)resetEmptyData {
    [super resetEmptyData];
    // 不用这句代码会导致多次刷新九宫格时空白cell因为时序问题显示重用前的图片……
    [self.imageView sd_setImageWithURL:nil];
}

#pragma mark - 
#pragma mark - LifeCycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self servyouSetup];
    }
    return self;
}

-(void)servyouSetup
{
    [self addSubview:self.unReadLabel];
    [self bringSubviewToFront:self.unReadLabel];
    self.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    
    [self.textLabel setFont:[UIFont systemFontOfSize:16.0f]];
    self.textLabel.textColor = [SGVUtil colorWithHexString:kSGVMainTextColor];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.detailTextLabel setTextColor:[UIColor grayColor]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect imageViewRect = self.imageView.frame;
    
    imageViewRect.size.height = self.frame.size.height - 14;
    imageViewRect.size.width = imageViewRect.size.height;
    imageViewRect.origin.y = 7;
    
    self.imageView.frame = imageViewRect;
    self.textLabel.frame = CGRectMake(self.imageView.frame.origin.x+self.imageView.frame.size.width+10, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
    self.textLabel.font = [UIFont systemFontOfSize:16.0f*SGVAdaptRate];
    
    NSInteger unReadWidth = 0;
    NSInteger unReadHeight= 0;
    NSString *unReadText = kSGVEmptyString;
    
    if (self.item) {
        NSString *imageURL = self.item.sgvImageURL;
        if (![SGVUtil strNilOrEmpty:imageURL]) {
            //支持网络图片和本地图片
            if ([imageURL hasPrefix:@"http://"]||[imageURL hasPrefix:@"https://"]) {
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:[SGVUtil cellDefaultImageName]] options:SDWebImageRefreshCached|SDWebImageRetryFailed|SDWebImageAllowInvalidSSLCertificates];
            } else {
                [self.imageView setImage:[UIImage imageNamed:imageURL]];
            }
        }else{
            [self.imageView setImage:[UIImage imageNamed:[SGVUtil cellDefaultImageName]]];
        }
        
        NSString *itemName = self.item.sgvItemName;
        if (itemName&&itemName.length>0) {
            self.textLabel.text = itemName;
        }
        
        if (self.hotCount > 0) {
            //未读信息数量大于0时显示
            if (!self.hotCountShowWay) {
                unReadWidth = UnRead_Width-4;
                unReadHeight = unReadWidth;
            }else{
                //显示数字时，因为数字位数不同，所以设置不同的宽度
                unReadHeight = UnRead_Width;
                if (self.hotCount>0&&self.hotCount<10) {
                    unReadText = [NSString stringWithFormat:@"%lu",(unsigned long)self.hotCount];
                    unReadWidth = UnRead_Width;
                    
                }else if (self.hotCount>99){
                    unReadText = @"99+";
                    unReadWidth = UnReadOffset*2+UnRead_Width;
                }else if (self.hotCount>=10&&self.hotCount<=99){
                    unReadText = [NSString stringWithFormat:@"%lu",(unsigned long)self.hotCount];
                    unReadWidth = UnRead_Width+UnReadOffset;
                }
            }
            
        }
        NSInteger imageWidht = self.imageView.frame.size.width;
        [self.unReadLabel setText:unReadText];
        CGRect unReadRect = CGRectMake(imageWidht+self.imageView.frame.origin.x-unReadWidth, 1, unReadWidth, unReadHeight);
        self.unReadLabel.frame = unReadRect;
        //圆角半径根据高度确定
        self.unReadLabel.layer.cornerRadius = unReadHeight/2;
        if (self.countHotView) {
            [self.countHotView removeFromSuperview];
        }
    }
    [self.contentView addSubview:self.lineLabel];
    
    if (self.countHotView) {
        [self addSubview:self.countHotView];
        [_unReadLabel removeFromSuperview];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *unReadLabelBackgroundColor = self.unReadLabel.backgroundColor;
    UIColor *countHotViewBackgroundColor;
    if (self.countHotView) {
        countHotViewBackgroundColor = self.countHotView.backgroundColor;
    }
    [super setSelected:selected animated:animated];
    
    self.unReadLabel.backgroundColor = unReadLabelBackgroundColor;
    if (self.countHotView && countHotViewBackgroundColor) {
        self.countHotView.backgroundColor = countHotViewBackgroundColor;
    }

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *unReadLabelBackgroundColor = self.unReadLabel.backgroundColor;
    UIColor *countHotViewBackgroundColor;
    if (self.countHotView) {
        countHotViewBackgroundColor = self.countHotView.backgroundColor;
    }
    
    [super setHighlighted:highlighted animated:animated];
    
    self.unReadLabel.backgroundColor = unReadLabelBackgroundColor;
    if (self.countHotView && countHotViewBackgroundColor) {
        self.countHotView.backgroundColor = countHotViewBackgroundColor;
    }
}

#pragma mark - getter

- (UILabel *)unReadLabel
{
    if (!_unReadLabel) {
        _unReadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unReadLabel.backgroundColor = [UIColor redColor];
        _unReadLabel.textColor = [UIColor whiteColor];
        _unReadLabel.textAlignment = NSTextAlignmentCenter;
        _unReadLabel.layer.cornerRadius = UnRead_Width/2;
        _unReadLabel.layer.masksToBounds = YES;
        _unReadLabel.font = [UIFont systemFontOfSize:11.0f];
    }
    return _unReadLabel;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-0.5f, [UIScreen mainScreen].bounds.size.width, 0.5f)];
        [_lineLabel setBackgroundColor:[SGVUtil colorWithHexString:@"#d6d6d6"]];
    }
    
    return _lineLabel;
}

@end
