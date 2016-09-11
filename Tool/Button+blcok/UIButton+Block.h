//
//  UIButton+Block.h
//  MishiOS
//
//  Created by 夏敏 on 7/18/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TargetBlock)(id sender);

@interface UIButton (Block)

@property (nonatomic, copy,readonly) TargetBlock targetBlock;

+(instancetype)buttonWithType:(UIButtonType)buttonType withTargetBlock:(TargetBlock)targetBlock;

@end
