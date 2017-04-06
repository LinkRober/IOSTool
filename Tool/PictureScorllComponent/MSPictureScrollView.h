//
//  MSPictureScrollView.h
//  MishiOS
//
//  Created by 夏敏 on 11/16/15.
//  Copyright © 2015 ___MISHI___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^asyImageLoad)(NSString *url,UIImageView *targetImageView);

@interface MSPictureScrollView : UIView

@property (nonatomic, strong) UIPageControl *pageControl;



- (instancetype)initWithPictureArray:(NSArray *)pictures initializeImage:(asyImageLoad)loadImage;
- (void)showFromView:(UIView *)view;
- (void)showFromView:(UIView *)view atIndex:(NSInteger)index;
- (void)dismiss;

@end
