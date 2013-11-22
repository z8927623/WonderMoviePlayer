//
//  WonderMovieInfoView.m
//  WonderMoviePlayer
//
//  Created by Zhuang Yanjun on 13-8-26.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "WonderMoviePlayerConstants.h"
#import "WonderMovieInfoView.h"
#import "UIView+Sizes.h"

@interface WonderMovieInfoView ()
@property (nonatomic, retain) UILabel *volumeLabel;
@property (nonatomic, retain) UIImageView *volumeImageView;
@property (nonatomic, retain) UILabel *brightnessLabel;

@property (nonatomic, retain) UILabel *autoNextToastView;
@property (nonatomic, retain) UIView *errorView;
@end

@implementation WonderMovieInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        UIFont *font = [UIFont boldSystemFontOfSize:23];
        UILabel *progressTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18+50-44, 100, 100)];
        self.progressTimeLabel = progressTimeLabel;
        self.progressTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.progressTimeLabel.textAlignment = UITextAlignmentLeft;
        self.progressTimeLabel.font = font;
        self.progressTimeLabel.backgroundColor = [UIColor clearColor];
        self.progressTimeLabel.textColor = [UIColor whiteColor];
        self.progressTimeLabel.height = font.lineHeight;
//        self.progressTimeLabel.hidden = YES;
        self.progressTimeLabel.layer.shadowOpacity = 0.5;
        self.progressTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.progressTimeLabel.layer.shadowRadius = 1;
        self.progressTimeLabel.layer.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:self.progressTimeLabel];
        [progressTimeLabel release];
        
        CGFloat centerButtonSize = 138 / 2;
        self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replayButton setImage:QQVideoPlayerImage(@"replay") forState:UIControlStateNormal];
        self.replayButton.size = CGSizeMake(centerButtonSize, centerButtonSize);
        self.replayButton.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.replayButton.hidden = YES;
        self.replayButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.replayButton];
        
        self.centerPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerPlayButton setImage:QQVideoPlayerImage(@"play") forState:UIControlStateNormal];
        self.centerPlayButton.frame = self.replayButton.frame;
        self.centerPlayButton.hidden = YES;
        self.centerPlayButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.centerPlayButton];
        
        UILabel *nextToast = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 180, 40)];
        nextToast.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        nextToast.center = CGPointMake(CGRectGetMidX(self.bounds), nextToast.center.y);
        nextToast.layer.cornerRadius = 3;
        nextToast.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        nextToast.text = NSLocalizedString(@"即将自动播放下一集", nil);
        nextToast.textColor = [UIColor whiteColor];
        nextToast.textAlignment = UITextAlignmentCenter;
        nextToast.alpha = 0;
        [self addSubview:nextToast];
        self.autoNextToastView = nextToast;
        [nextToast release];
        
        UIView *errorView = [[UIView alloc] initWithFrame:self.bounds];
        errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        errorView.backgroundColor = [UIColor clearColor];
        errorView.hidden = YES;
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"播放地址失效，", nil);
        [label sizeToFit];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        [button setTitle:NSLocalizedString(@"源网页播放", nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.openSourceButton = button;
        [button.titleLabel sizeToFit];
        button.bounds = button.titleLabel.bounds;
        CGFloat width = label.width + button.width;
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, label.height)];
        titleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        label.origin = CGPointZero;
        [titleView addSubview:label];
        button.origin = CGPointMake(label.right, 0);
        [titleView addSubview:button];
        [errorView addSubview:titleView];
        [label release];
        [titleView release];
        titleView.center = CGPointMake(CGRectGetMidX(errorView.bounds), CGRectGetMidY(errorView.bounds));

        self.errorView = errorView;
        [self addSubview:errorView];
        [errorView release];
    }
    return self;
}

- (void)dealloc
{
    self.progressTimeLabel = nil;
    
    self.loadingView = nil;
    self.loadingIndicator = nil;
    self.loadingMessageLabel = nil;
    self.loadingPercentLabel = nil;
    
    self.replayButton = nil;
    self.centerPlayButton = nil;
    
    self.autoNextToastView = nil;
    
    self.errorView = nil;
    self.openSourceButton = nil;
    
    [_volumeView release];
    [_brightnessView release];
    [super dealloc];
}

#pragma mark Loading View

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 181, 101 + 20)];
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        UIImageView *loadingIndicator = [[UIImageView alloc] initWithImage:QQVideoPlayerImage(@"loading")];
        self.loadingIndicator = loadingIndicator;
        self.loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.loadingIndicator.contentMode = UIViewContentModeCenter;
        self.loadingIndicator.frame = CGRectMake(0, 0, _loadingView.width, _loadingView.height - 20);
        [_loadingView addSubview:self.loadingIndicator];
        [loadingIndicator release];

        UILabel *loadingPercentLabel = [[UILabel alloc] initWithFrame:self.loadingIndicator.frame];
        self.loadingPercentLabel = loadingPercentLabel;
        self.loadingPercentLabel.text = @"0%";
        self.loadingPercentLabel.textAlignment = UITextAlignmentCenter;
        self.loadingPercentLabel.backgroundColor = [UIColor clearColor];
        self.loadingPercentLabel.textColor = [UIColor whiteColor];
        
#ifndef MTT_TWEAK_WONDER_MOVIE_PLAYER_FAKE_BUFFER_PROGRESS
        self.loadingPercentLabel.hidden = YES;
#endif // MTT_TWEAK_WONDER_MOVIE_PLAYER_FAKE_BUFFER_PROGRESS
        
        [_loadingView addSubview:self.loadingPercentLabel];
        [loadingPercentLabel release];
        
        CGFloat maxMessageWidth = self.width / 2 > _loadingView.width ? self.width / 2 : _loadingView.width;
        UILabel *loadingMessageLabel = [[UILabel alloc] initWithFrame:
                                        CGRectMake(- (maxMessageWidth - _loadingView.width)/2, self.loadingIndicator.bottom, maxMessageWidth, 20)];
                                        //CGRectMake(0, self.loadingIndicator.bottom, _loadingView.width , 20)];
        self.loadingMessageLabel = loadingMessageLabel;
        self.loadingMessageLabel.text = NSLocalizedString(@" 正在缓冲...", @"");
        self.loadingMessageLabel.textAlignment = UITextAlignmentCenter;
        self.loadingMessageLabel.backgroundColor = [UIColor clearColor];
        self.loadingMessageLabel.textColor = [UIColor whiteColor];
        [_loadingView addSubview:self.loadingMessageLabel];
        [loadingMessageLabel release];
        
        _loadingView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        _loadingView.hidden = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark Public
- (void)startLoading
{
    //NSLog(@"startLoading %d, %d", self.loadingView.hidden, [self.loadingIndicator.layer.animationKeys containsObject:@"rotationAnimation"]);
	self.loadingView.hidden = NO;
    // Bugfix for iOS7
    // Animation will be missed if it is created before presentation in iOS7, so create animation on demand.
    static NSString *animationKey = @"rotationAnimation";
    if (![self.loadingIndicator.layer.animationKeys containsObject:animationKey]) {
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = @(M_PI / 180 * 360);
        rotationAnimation.duration = 1.0f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.removedOnCompletion = NO;
//        rotationAnimation.delegate = self;
        
        [self.loadingIndicator.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)stopLoading
{
    self.loadingView.hidden = YES;
}


- (void)showProgressTime:(BOOL)show animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 1.f : 0 animations:^{
        self.progressTimeLabel.alpha = show ? 1 : 0;
    }];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    NSLog(@"animationDidStop %@ %d", [(CABasicAnimation *)anim keyPath], flag);
//}

#pragma mark VolumeView & BrightnessView
- (UIView *)volumeView
{
#ifdef MTT_TWEAK_WONDER_MOVIE_HIDE_SYSTEM_VOLUME_VIEW
    if (_volumeView == nil) {
        CGFloat width = 120;
        CGFloat y = 20;
        _volumeView = [[UIView alloc] initWithFrame:CGRectMake((self.width - width) / 2, y, width, 55)];
        _volumeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _volumeView.layer.cornerRadius = 3;
        _volumeView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:QQVideoPlayerImage(@"volume") highlightedImage:QQVideoPlayerImage(@"mute")];
        self.volumeImageView = imageView;
        [_volumeView addSubview:imageView];
        imageView.origin = CGPointMake(14, (_volumeView.height - imageView.height) / 2);
        [imageView release];
        
        _volumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 7, 0, _volumeView.width - imageView.right - 7, _volumeView.height)];
        _volumeLabel.backgroundColor = [UIColor clearColor];
        _volumeLabel.textAlignment = UITextAlignmentCenter;
        _volumeLabel.textColor = [UIColor whiteColor];
        _volumeLabel.font = [UIFont systemFontOfSize:18];
        [_volumeView addSubview:_volumeLabel];
        _volumeView.alpha = 0;
    }
    return _volumeView;
#else
    return nil;
#endif
}

- (UIView *)brightnessView
{
    if (_brightnessView == nil) {
        CGFloat width = 120;
        CGFloat y = 20;
        _brightnessView = [[UIView alloc] initWithFrame:CGRectMake((self.width - width) / 2, y, width, 55)];
        _brightnessView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _brightnessView.layer.cornerRadius = 3;
        _brightnessView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:QQVideoPlayerImage(@"brightness")];
        [_brightnessView addSubview:imageView];
        imageView.origin = CGPointMake(14, (_brightnessView.height - imageView.height) / 2);
        [imageView release];
        
        _brightnessLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 7, 0, _brightnessView.width - imageView.right - 7, _brightnessView.height)];
        _brightnessLabel.backgroundColor = [UIColor clearColor];
        _brightnessLabel.textAlignment = UITextAlignmentCenter;
        _brightnessLabel.textColor = [UIColor whiteColor];
        _brightnessLabel.font = [UIFont systemFontOfSize:18];
        [_brightnessView addSubview:_brightnessLabel];
        _brightnessView.alpha = 0;
    }
    return _brightnessView;
}


- (void)showVolume:(CGFloat)volume
{
    [self.brightnessView removeFromSuperview];
    [self addSubview:self.volumeView];
    self.volumeView.alpha = 1;
    self.brightnessView.alpha = 0;
    if (volume <= 0) {
        self.volumeImageView.highlighted = YES;
    }
    else {
        self.volumeImageView.highlighted = NO;
    }
    self.volumeLabel.text = [NSString stringWithFormat:@"%d%%", (int)(volume * 100)];
    [UIView animateWithDuration:1.0f animations:^{
        self.volumeView.alpha = 0;
    }];
}

- (void)showBrightness:(CGFloat)brightness
{
    [self.volumeView removeFromSuperview];
    [self addSubview:self.brightnessView];
    self.volumeView.alpha = 0;
    self.brightnessView.alpha = 1;
    self.brightnessLabel.text = [NSString stringWithFormat:@"%d%%", (int)(brightness * 100)];
    [UIView animateWithDuration:1.0f animations:^{
        self.brightnessView.alpha = 0;
    }];
}

- (void)showAutoNextToast:(BOOL)show animated:(BOOL)animated
{
    [UIView animateWithDuration:(animated ? 0.5f : 0) animations:^{
        self.autoNextToastView.alpha = show ? 1 : 0;
    } completion:^(BOOL finished) {
        if (show) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dimNextToast) object:nil];
            [self performSelector:@selector(dimNextToast) withObject:nil afterDelay:5];
        }
    }];
}

- (void)dimNextToast
{
    [UIView animateWithDuration:0.5f animations:^{
        self.autoNextToastView.alpha = 0;
    }];
}

- (void)showError:(BOOL)show
{
    self.errorView.hidden = !show;
}

@end
