//
//  MSPictureScrollView.m
//  MishiOS
//
//  Created by 夏敏 on 11/16/15.
//  Copyright © 2015 ___MISHI___. All rights reserved.
//

#import "MSPictureScrollView.h"

#define KSCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

static NSTimeInterval const kDuration = 0.2;
static const float KMAXZOOMRATIO = 0.423351;
static const float KMINZOOMRATIO = 1.875158;

@interface MSPictureScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat ImageHeight;
    CGFloat ImageWidth;
    
    CGFloat originHeight;
    CGFloat originiScale;
}

@property (nonatomic, strong) NSMutableArray *picturesArray;
@property (nonatomic, strong) NSMutableArray *imageViewsArray;
@property (nonatomic, strong) UIImageView *currentImageView;


@property (nonatomic, strong) UIScrollView  *scrollowView;


@property (nonatomic, strong) asyImageLoad loadImage;


@end

@implementation MSPictureScrollView

#pragma mark - Life Cycle

-(instancetype)initWithPictureArray:(NSArray *)pictures initializeImage:(asyImageLoad)loadImage{
    self = [super init];
    if (self) {
        self.picturesArray = [[NSMutableArray alloc] initWithArray:pictures];
        self.loadImage = loadImage;
        [self setUp];
    }
    return self;
}



-(void)layoutSubviews {
    
    NSArray *scrollowViewConstraints = @[
                                         [NSLayoutConstraint constraintWithItem:self.scrollowView
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:KSCREENHEIGHT],
                                         [NSLayoutConstraint constraintWithItem:self.scrollowView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:ImageWidth],
                                         [NSLayoutConstraint constraintWithItem:self.scrollowView
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0],
                                         [NSLayoutConstraint constraintWithItem:self.scrollowView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:0]
                                         ];
    [self addConstraints:scrollowViewConstraints];
    
    
    NSArray *pageControlConstraints = @[
                                        [NSLayoutConstraint constraintWithItem:self.pageControl
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0],
                                        [NSLayoutConstraint constraintWithItem:self.pageControl
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-50]
                                        ];
    [self addConstraints:pageControlConstraints];

    [super layoutSubviews];
}


#pragma mark - Public

-(void)showFromView:(UIView *)view{
    
    [view addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:kDuration animations:^{
        self.alpha = 1;
    }];
}


-(void)showFromView:(UIView *)aView atIndex:(NSInteger)index {
    if ( index > self.picturesArray.count - 1) {
        [self showFromView:aView];
    }
    else {
        self.scrollowView.contentOffset = CGPointMake(index *ImageWidth , KSCREENHEIGHT/2 - ImageHeight/2);
        self.pageControl.currentPage = index;
        [self showFromView:aView];
    }
}

-(void)dismiss{
    [self removeFromSuperview];
}

#pragma mark - Private

- (void)setUp{
    
    ImageWidth = KSCREENHEIGHT;
    ImageHeight = KSCREENWIDTH*3/4;
    self.frame = CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self addGestureRecognizer:tap];

    UIScrollView *scrollowView = [[UIScrollView alloc] init];
    scrollowView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollowView.contentSize = CGSizeMake(ImageWidth * self.picturesArray.count, KSCREENHEIGHT);
    scrollowView.pagingEnabled = YES;
    scrollowView.showsHorizontalScrollIndicator = NO;
    scrollowView.showsVerticalScrollIndicator = NO;
    scrollowView.bounces = NO;
    [scrollowView setDelegate:self];
    [self addSubview:scrollowView];
    self.scrollowView = scrollowView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    pageControl.hidesForSinglePage = YES;
    pageControl.numberOfPages = self.picturesArray.count;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    [self configureScrollowWithPicture:self.picturesArray];
    self.currentImageView = [self.imageViewsArray firstObject];
}


- (void)configureScrollowWithPicture:(NSMutableArray *)array {
    
    [array enumerateObjectsUsingBlock:^(NSString  *_Nonnull pictureObj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *aImageView = [self getImageViewWithStringUrl:pictureObj];
        
        if (idx == 0)originHeight = aImageView.image.size.height;
        if (idx == 0)originiScale = originHeight / KSCREENWIDTH;
        
        aImageView.frame = CGRectMake(idx * ImageWidth, KSCREENHEIGHT/2 - ImageHeight/2, ImageWidth, ImageHeight);
        ;
        
        [self.scrollowView addSubview:aImageView];
        
        [self.imageViewsArray addObject:aImageView];
    }];
    
    
    
}

- (UIImageView *)getImageViewWithStringUrl:(NSString *)string {
    UIImageView *aImageView = [[UIImageView alloc] init];
    aImageView.tag = 0;
    self.loadImage(string,aImageView);
    aImageView.userInteractionEnabled = YES;
    aImageView.multipleTouchEnabled = YES;
    aImageView.contentMode = UIViewContentModeScaleAspectFill;
    aImageView.clipsToBounds = YES;
    //single
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    tap.numberOfTapsRequired = 1;
    [aImageView addGestureRecognizer:tap];
    //double
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapImageView:)];
    doubleTap.numberOfTapsRequired = 2;
    [aImageView addGestureRecognizer:doubleTap];
    //pin
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinImageView:)];
    [aImageView addGestureRecognizer:pinGes];
    //single tap < double tap
    
    [tap requireGestureRecognizerToFail:doubleTap];

    
    return aImageView;
}


-(void)resetImageViewScale
{
    [self.imageViewsArray enumerateObjectsUsingBlock:^(UIImageView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:.3 animations:^{
            obj.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            obj.tag = 0;
        }];
    }];
}

#pragma mark - Action

- (void)tapView
{
    [UIView animateWithDuration:kDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

- (void)tapImageView:(UITapGestureRecognizer *)tapGes{
    tapGes.view.transform = CGAffineTransformIdentity;
    self.currentImageView.tag = 0;
    [self tapView];
}

- (void)doubleTapImageView:(UITapGestureRecognizer *)tapGes{
    
    if (self.currentImageView.tag == 1) {
        [UIView animateWithDuration:.3 animations:^{
            tapGes.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.currentImageView.tag = 0;
        }];
    }
    else {
        [UIView animateWithDuration:.3 animations:^{
            tapGes.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
        } completion:^(BOOL finished) {
            self.currentImageView.tag = 1;
        }];
    }
    
}

- (void)pinImageView:(UIPinchGestureRecognizer *)gesture{
    
    CGFloat needScale = gesture.scale;
    UIView *targetView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGAffineTransform transform = targetView.transform;
        CGAffineTransform nextTransform = CGAffineTransformScale(transform, needScale, needScale);
        targetView.transform = nextTransform;
        gesture.scale = 1.0;
        self.currentImageView.tag = 1;
    }
    
    
    CGFloat currentImageViewScale = (KSCREENWIDTH *3/4) / self.currentImageView.frame.size.height;
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        if (currentImageViewScale < KMAXZOOMRATIO) {
            [UIView animateWithDuration:.3 animations:^{
                
                gesture.view.transform = CGAffineTransformMakeScale(1.5, 1.5);
                self.currentImageView.tag = 1;
            }];
        }
        
        if (currentImageViewScale > KMINZOOMRATIO) {
            [UIView animateWithDuration:.3 animations:^{
                
                gesture.view.transform = CGAffineTransformIdentity;
                self.currentImageView.tag = 1;
            }];
        }
        
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / KSCREENWIDTH;
    self.pageControl.currentPage = index;
    self.currentImageView = self.imageViewsArray[index];
    originHeight = self.currentImageView.image.size.height;
    originiScale = originHeight / KSCREENWIDTH;
    [self resetImageViewScale];
}

#pragma mark - Accessor

-(NSMutableArray *)imageViewsArray {
    if (nil == _imageViewsArray) {
        _imageViewsArray = [[NSMutableArray alloc] init];
    }
    return _imageViewsArray;
}

@end
