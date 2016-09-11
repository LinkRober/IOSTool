
//  UITabBar+Badge.h
//  MishiOS
//
//  Created by 夏敏 on 8/12/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

@property (nonatomic, strong) UIColor *badgeColor;
@property (nonatomic, strong) UIColor *aroundColor;

-(void)setUpCustomBadgeView:(NSInteger)tabNumber;

-(void)showBadgeNumber:(NSString *)number atTabIndex:(NSInteger)tabIndex;
-(void)showBadge:(NSInteger)tabIndex;

-(void)hideBadgeAtIndex:(NSInteger)tabIndex;

@end
