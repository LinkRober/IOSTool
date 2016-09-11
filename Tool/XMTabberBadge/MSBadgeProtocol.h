//
//  MSBadgeProtocol.h
//  MishiOS
//
//  Created by 夏敏 on 8/12/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#ifndef MSBadgeProtocol_h
#define MSBadgeProtocol_h
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MSBadgeDrawStyle) {
    MSBadgeDrawCircleStyle,
    MSBadgeDrawNumberStyle,
    MSBadgeDrawNoneStyle,
};

@protocol MSBadgeViewProtocol <NSObject>

@property (nonatomic, assign) MSBadgeDrawStyle badgeStyle;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, assign) CGSize labelSize;

-(void)setBadgeColor:(UIColor *)badgeColor aroundColor:(UIColor *)aroundColor;

@end

#endif /* MSBadgeProtocol_h */
