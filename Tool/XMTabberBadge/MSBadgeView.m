//
//  MSBadgeView.m
//  MishiOS
//
//  Created by 夏敏 on 8/12/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#import "MSBadgeView.h"
//#import "MSCommonUI.h"

@interface BadgeLabel : UILabel

@end

static const CGFloat kInsertLength = 4;

@implementation BadgeLabel

-(void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets edges = {0,0,0,0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, edges)];
}

@end


@interface MSBadgeView()

@property (nonatomic, strong) BadgeLabel *badgeLabel;
@property (nonatomic, strong) UIColor *aroundColor;
@property (nonatomic, strong) UIColor *numberColor;

@end

@implementation MSBadgeView
@synthesize badgeStyle = _badgeStyle;
@synthesize number = _number;
@synthesize labelSize = _labelSize;

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.badgeStyle == MSBadgeDrawCircleStyle) {
        [self drawCircleStyle:context rect:rect];
    }
    
    if (self.badgeStyle == MSBadgeDrawNumberStyle) {
        [self drawNumberStyle:context rect:rect];
    }
}

-(void)drawNumberStyle:(CGContextRef)context rect:(CGRect)rect{
    CGContextSaveGState(context);

    CGContextSetFillColorWithColor(context, self.aroundColor.CGColor);
    
    CGFloat left_CircleCenterX = (rect.size.width - self.labelSize.width)/2;
    CGPoint left_Center = CGPointMake(left_CircleCenterX, rect.size.height / 2);
    CGFloat left_radius = rect.size.height / 2 - 1; //can't set radius equal to a half of rect's height
    CGFloat left_startAngle = M_PI/2;
    CGFloat left_endAngle =  - M_PI/2;
    CGContextBeginPath(context);
    CGContextAddArc(context, left_Center.x, left_Center.y, left_radius, left_startAngle, left_endAngle, 0);
    
    CGFloat right_CircleCenterX = left_CircleCenterX + self.labelSize.width;
    CGPoint right_Center = CGPointMake(right_CircleCenterX, rect.size.height / 2);
    CGFloat right_radius = rect.size.height / 2 - 1;
    CGFloat right_startAngle = - M_PI/2;
    CGFloat right_endAngle = M_PI/2;
    CGContextAddArc(context, right_Center.x, right_Center.y, right_radius, right_startAngle, right_endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}

-(void)drawCircleStyle:(CGContextRef)context rect:(CGRect)rect{
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, self.aroundColor.CGColor);
    
    CGPoint cetnter = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = cetnter.x * .9;
    CGFloat startAngle = - M_2_PI;
    CGFloat endAngle = (2 * M_PI + startAngle);
    
    CGContextBeginPath(context);
    CGContextAddArc(context, cetnter.x, cetnter.y, radius, startAngle, endAngle, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
}


-(void)layoutSubviews{

    if (self.badgeStyle == MSBadgeDrawNumberStyle) {
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    [super layoutSubviews];
}

-(void)setUp{
    self.badgeStyle = MSBadgeDrawNoneStyle;
}

#pragma mark - MSBadgeViewProtocol

-(void)setBadgeColor:(UIColor *)badgeColor aroundColor:(UIColor *)aroundColor{
    self.numberColor = badgeColor;
    self.aroundColor = aroundColor;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Accessor

-(UILabel *)badgeLabel{
    if (nil == _badgeLabel) {
        _badgeLabel = [[BadgeLabel alloc] init];
        _badgeLabel.font = [UIFont systemFontOfSize:10.0];
    }
    return _badgeLabel;
}

-(void)setNumber:(NSString *)number{
    _number = number;
    self.badgeLabel.text = number;
    if (self.badgeLabel.superview == nil) {
        [self addSubview:self.badgeLabel];
    }
    [self.badgeLabel sizeToFit];
    
    CGSize size = self.badgeLabel.frame.size;
    size.width -= kInsertLength;
    self.labelSize = size;
}

-(void)setNumberColor:(UIColor *)numberColor{
    _numberColor = numberColor;
    if (self.badgeLabel) {
        self.badgeLabel.textColor = _numberColor;
    }
}


@end
