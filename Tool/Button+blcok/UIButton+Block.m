//
//  UIButton+Block.m
//  MishiOS
//
//  Created by 夏敏 on 7/18/16.
//  Copyright © 2016 ___MISHI___. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static NSString *const kMSBlockButton = @"kMSBlockButton";
static NSString *const MSBlockKey = @"MSBlockKey";

@interface UIButton()

@property (nonatomic, copy) TargetBlock targetBlock;

@end

@implementation UIButton (Block)

-(void)setTargetBlock:(TargetBlock)targetBlock{
    objc_setAssociatedObject(self, (__bridge const void *)(MSBlockKey), targetBlock, OBJC_ASSOCIATION_COPY);
}

-(TargetBlock)targetBlock{
    return objc_getAssociatedObject(self, (__bridge const void *)(MSBlockKey));
}


+(instancetype)buttonWithType:(UIButtonType)buttonType withTargetBlock:(TargetBlock)targetBlock{
    UIButton *button = [UIButton buttonWithType:buttonType];
    button.targetBlock = targetBlock;
    [button addTarget:button action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}


- (void)action:(id)sender {
    self.targetBlock(self);
}

@end
