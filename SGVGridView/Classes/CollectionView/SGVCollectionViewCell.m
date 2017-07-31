//
//  SGVCollectionViewCell.m
//  TestServyouFoundation
//
//  Created by Rain on 15/9/14.
//  Copyright (c) 2015年 Sevryou. All rights reserved.
//

#import "SGVCollectionViewCell.h"
#import "SGVUtil.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "SGVConst.h"
#import "SGVGridViewDataName.h"
#import "NSDictionary+SGVViewData.h"

#define Image_width  45
#define Image_Height 45

#define Font_TextName [UIFont systemFontOfSize:12.0f*SGVAdaptRate]

#define UnRead_Width 14

#define UnReadOffset 6


@interface SGVCollectionViewCell ()
@property (nonatomic, assign)CGSize countHotViewSize;
@end

@implementation SGVCollectionViewCell

#pragma mark -
#pragma mark - Public
-(void)resetEmptyData {
    [super resetEmptyData];
    
    self.iconImageView.image = nil;
    self.iconImageView.frame = CGRectZero;
    self.functionNameLabel.text=@"";
    self.unReadLabel.text=@"";
    self.unReadLabel.frame = CGRectZero;
    self.item = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.functionNameLabel];
        [self addSubview:self.unReadLabel];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [SGVUtil colorWithHexString:@"#f8f8f8"];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.selectedBackgroundView.frame = self.bounds;
    
    if (self.item) {
        //图片
        CGFloat imageWidth = Image_width*SGVAdaptRate;
        CGFloat imageHeight = Image_Height*SGVAdaptRate;
        
        if (self.imageSize.width>0&&self.imageSize.height>0) {
            imageWidth = self.imageSize.width;
            imageHeight = self.imageSize.height;
        }
        
        CGFloat imageOriginX = (self.bounds.size.width - imageWidth)/2;
        CGFloat imageOriginY = (self.bounds.size.height - imageHeight)/2;
        
        NSInteger unReadWidth = 0;
        NSInteger unReadHeight = 0;
        NSString *unReadText = kSGVEmptyString;
        
        self.iconImageView.frame = CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight);
        NSString *imageURL = self.item.sgvImageURL;
        if (![SGVUtil strNilOrEmpty:imageURL]) {
            //支持网络图片和本地图片
            if ([imageURL hasPrefix:@"http://"]||[imageURL hasPrefix:@"https://"]) {
                [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:[SGVUtil cellDefaultImageName]] options:SDWebImageRefreshCached|SDWebImageAllowInvalidSSLCertificates];
            } else {
                [self.iconImageView setImage:[UIImage imageNamed:imageURL]];
            }
        }else{
            [self.iconImageView setImage:[UIImage imageNamed:[SGVUtil cellDefaultImageName]]];
        }
    
        NSString *itemName = self.item.sgvItemName;
        if (itemName&&itemName.length>0) {
            //文字
            CGFloat lbOriginX = 0.f;
            CGFloat lbOriginY = 0.f;
            CGFloat lbWidth = self.bounds.size.width;
            CGFloat lbHeight= 29.0f*SGVAdaptRate;
            //            CGFloat lbHeight = self.bounds.size.height-lbOriginY;
//            CGSize lbSize =[GDUtil getLabelSize:self.squaresDo.name withFloat:12.0f WithLabelWidth:self.width];
//            CGSize lbSize =[self.squaresDo.name sizeWithAttributes:@{NSFontAttributeName:Font_TextName}];
            imageOriginY = (self.bounds.size.height-imageHeight-lbHeight-4.f)/2.f;
            lbOriginY = imageOriginY+imageHeight+4.f;
            
            self.iconImageView.frame = CGRectMake(imageOriginX, imageOriginY, imageWidth, imageHeight);
        
            self.functionNameLabel.numberOfLines = 0;
            self.functionNameLabel.frame = CGRectMake(lbOriginX, lbOriginY, lbWidth, lbHeight);
            [self.functionNameLabel setText:itemName];
            
            if (self.hotCount > 0) {
                //未读信息数量大于0时显示
                if (!self.hotCountShowWay) {
                    unReadWidth =UnRead_Width-4;
                    unReadHeight = unReadWidth;
                }else{
                    unReadHeight = UnRead_Width;
                    //显示数字时，因为数字位数不同，所以设置不同的宽度
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
            NSInteger imageWidht = self.iconImageView.bounds.size.width;
            [self.unReadLabel setText:unReadText];
            CGRect unReadRect = CGRectMake(imageWidht+self.iconImageView.frame.origin.x-unReadWidth/2,self.iconImageView.frame.origin.y-unReadHeight/2, unReadWidth, unReadHeight);
            self.unReadLabel.frame = unReadRect;
            self.unReadLabel.layer.cornerRadius = unReadHeight/2;
            if (self.countHotView) {
                [self.countHotView removeFromSuperview];
            }
        }
    }
    if (self.countHotView) {
        
        [self addSubview:self.countHotView];
        [_unReadLabel removeFromSuperview];
    }
}

-(void)setcountHotViewSize:(CGSize )countHotViewSize {
    _countHotViewSize = countHotViewSize;
}

- (void)setCellSelectedColor:(UIColor *)cellSelectedColor {
    [super setCellSelectedColor:cellSelectedColor];
    self.selectedBackgroundView.backgroundColor = cellSelectedColor;
}

- (void)setCellFontColor:(UIColor *)cellFontColor {
    [super setCellFontColor:cellFontColor];
    self.functionNameLabel.textColor = cellFontColor;
}

#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}


- (UILabel *)functionNameLabel {
    if (!_functionNameLabel) {
        _functionNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_functionNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_functionNameLabel setFont:Font_TextName];
        [_functionNameLabel setTextColor:[UIColor blackColor]];
    }
    return _functionNameLabel;
}

- (UILabel *)unReadLabel {
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

@end
