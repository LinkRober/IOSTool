//
//  UITabBar+Badge.m
//  MishiOS
//
//  Created by 夏敏 on 8/12/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#import "UITabBar+Badge.h"
#import <objc/runtime.h>
#import "MSBadgeView.h"


#define kDotSize  CGSizeMake(6, 6)

static const CGFloat kLabelToppadding = 4.0f;
static const CGFloat kBadgeViewTopPadding = 3.0f;
static const CGFloat kBadgeViewRightPadding = 35.0f;
static const char kBadgeColor;
static const char kBadges;
static const char kAroundColor;

@interface UITabBar()

@property (nonatomic, strong) NSMutableArray <UIView<MSBadgeViewProtocol> *>*badges;

@end

@implementation UITabBar (Badge)


-(void)setBadges:(NSMutableArray *)badges{
    objc_setAssociatedObject(self, &kBadges, badges, OBJC_ASSOCIATION_RETAIN);
}

-(NSMutableArray *)badges{
    return objc_getAssociatedObject(self, &kBadges);
}

-(void)setBadgeColor:(UIColor *)badgeColor{
    objc_setAssociatedObject(self, &kBadgeColor, badgeColor, OBJC_ASSOCIATION_RETAIN);
}

-(UIColor *)badgeColor{
    return objc_getAssociatedObject(self, &kBadgeColor);
}


-(void)setAroundColor:(UIColor *)aroundColor{
    objc_setAssociatedObject(self, &kAroundColor, aroundColor, OBJC_ASSOCIATION_RETAIN);
}

-(UIColor *)aroundColor{
    return objc_getAssociatedObject(self, &kAroundColor);
}

#pragma mark - Public
-(void)setUpCustomBadgeView:(NSInteger)tabNumber{
    [self generateBages:tabNumber];
}


#pragma mark - show badge
-(void)showBadge:(NSInteger)tabIndex{
    self.badges[tabIndex].badgeStyle = MSBadgeDrawCircleStyle;
    [self layoutBadgeFrameAtTabIndex:tabIndex];
    [self.badges[tabIndex] setNeedsDisplay];
}
-(void)showBadgeNumber:(NSString *)number atTabIndex:(NSInteger)tabIndex{
    self.badges[tabIndex].badgeStyle = MSBadgeDrawNumberStyle;
    self.badges[tabIndex].number = number;
    [self layoutBadgeFrameAtTabIndex:tabIndex];
    [self.badges[tabIndex] setNeedsDisplay];
}

#pragma mark - hide badge

-(void)hideBadgeAtIndex:(NSInteger)tabIndex{
    self.badges[tabIndex].badgeStyle = MSBadgeDrawNoneStyle;
    [self.badges[tabIndex] setNeedsDisplay];
}

#pragma mark - Private

-(void)generateBages:(NSInteger)tabNumber{
    self.badges = [[NSMutableArray alloc] initWithCapacity:tabNumber];
    for (int i = 0; i < tabNumber;i ++ ) {
        UIView<MSBadgeViewProtocol> *badgeView = [self badgeView];
        [self addSubview:badgeView];
        [self.badges addObject:badgeView];
    }
}

-(UIView<MSBadgeViewProtocol > *)badgeView{
    MSBadgeView *badge = [[MSBadgeView alloc] init];
    [badge setBadgeColor:self.badgeColor aroundColor:self.aroundColor];
    return badge;
}

- (void)layoutBadgeFrameAtTabIndex:(NSInteger)tabIndex {
    
    UIView<MSBadgeViewProtocol> * _Nonnull badgeView = self.badges[tabIndex];
    CGFloat floatSum = self.badges.count;
    if (badgeView.badgeStyle == MSBadgeDrawCircleStyle){
        CGSize size = kDotSize;
        CGFloat reduceX = self.frame.size.width * ((self.badges.count - (tabIndex + 1))/floatSum) + size.width + kBadgeViewRightPadding;
        badgeView.frame = CGRectMake(self.frame.size.width - reduceX,kBadgeViewTopPadding, size.width, size.height);
    }else if (badgeView.badgeStyle == MSBadgeDrawNumberStyle){
        CGFloat badgeViewHeight = badgeView.labelSize.height + kLabelToppadding;
        CGFloat badgeViewWidth = badgeView.labelSize.width + badgeViewHeight;
        CGFloat reduceX = self.frame.size.width * ((self.badges.count - (tabIndex + 1))/floatSum) + badgeViewWidth + kBadgeViewRightPadding;
        badgeView.frame = CGRectMake(self.frame.size.width - reduceX, kBadgeViewTopPadding, badgeViewWidth, badgeViewHeight);
        
    }
}

@end
