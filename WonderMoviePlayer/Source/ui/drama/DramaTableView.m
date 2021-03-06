//
//  DramaTableView.m
//  WonderMoviePlayer
//
//  Created by Zhuang Yanjun on 11/28/13.
//  Copyright (c) 2013 Tencent. All rights reserved.
//

#import "DramaTableView.h"
#import "UIView+Sizes.h"

@implementation DramaTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame style:style indicatorStyle:UIActivityIndicatorViewStyleWhite loadingTextColor:[UIColor whiteColor] errorTextColor:[UIColor whiteColor]];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style indicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle loadingTextColor:(UIColor *)loadingTextColor errorTextColor:(UIColor *)errorTextColor
{
    if (self = [super initWithFrame:frame style:style]) {
        UIView *loadingHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 35)];
        loadingHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.loadingHeaderView = loadingHeaderView;
        
        UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        [loadingHeaderView addSubview:loadingIndicator];
        loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        loadingIndicator.hidesWhenStopped = YES;
        [loadingHeaderView addSubview:loadingIndicator];
        _headerLoadingView = loadingIndicator;
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:loadingHeaderView.bounds];
        loadingLabel.text = NSLocalizedString(@"正在加载", nil);
        loadingLabel.font = [UIFont systemFontOfSize:13];
        loadingLabel.textColor = loadingTextColor;
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [loadingHeaderView addSubview:loadingLabel];
        
        // Adjust center
        [loadingLabel sizeToFit];
        CGFloat padding = 5;
        CGFloat width = loadingIndicator.width + loadingLabel.width + padding;
        loadingIndicator.center = CGPointMake(CGRectGetMidX(loadingHeaderView.bounds) - width / 2 + loadingIndicator.width / 2, CGRectGetMidY(loadingHeaderView.bounds));
        loadingLabel.center = CGPointMake(CGRectGetMidX(loadingHeaderView.bounds) + width / 2 - loadingLabel.width / 2 , CGRectGetMidY(loadingHeaderView.bounds));
        
        UIView *retryHeaderView = [[UIView alloc] initWithFrame:loadingHeaderView.frame];
        retryHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.retryHeaderView = retryHeaderView;
        
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [retryButton setTitle:NSLocalizedString(@"加载失败，点击重试", nil) forState:UIControlStateNormal];
        retryButton.frame = retryHeaderView.bounds;
        [retryButton addTarget:self action:@selector(onClickRetryHeader:) forControlEvents:UIControlEventTouchUpInside];
        retryButton.backgroundColor = [UIColor clearColor];
        [retryButton setTitleColor:errorTextColor forState:UIControlStateNormal];
        retryButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [retryHeaderView addSubview:retryButton];
        retryButton.frame = retryHeaderView.bounds;
        
        UIView *loadingFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 35)];
        loadingFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.loadingFooterView = loadingFooterView;
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        [loadingFooterView addSubview:loadingIndicator];
        loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        loadingIndicator.hidesWhenStopped = YES;
        [loadingFooterView addSubview:loadingIndicator];
        _footerLoadingView = loadingIndicator;
        
        loadingLabel = [[UILabel alloc] initWithFrame:loadingFooterView.bounds];
        loadingLabel.text = NSLocalizedString(@"正在加载", nil);
        loadingLabel.font = [UIFont systemFontOfSize:13];
        loadingLabel.textColor = loadingTextColor;
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [loadingFooterView addSubview:loadingLabel];
        
        // Adjust center
        [loadingLabel sizeToFit];
        width = loadingIndicator.width + loadingLabel.width + padding;
        loadingIndicator.center = CGPointMake(CGRectGetMidX(loadingFooterView.bounds) - width / 2 + loadingIndicator.width / 2, CGRectGetMidY(loadingFooterView.bounds));
        loadingLabel.center = CGPointMake(CGRectGetMidX(loadingFooterView.bounds) + width / 2 - loadingLabel.width / 2 , CGRectGetMidY(loadingFooterView.bounds));
        
        UIView *retryFooterView = [[UIView alloc] initWithFrame:loadingFooterView.frame];
        retryFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.retryFooterView = retryFooterView;

        retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [retryButton setTitle:NSLocalizedString(@"加载失败，点击重试", nil) forState:UIControlStateNormal];
        retryButton.frame = retryFooterView.bounds;
        [retryButton addTarget:self action:@selector(onClickRetryFooter:) forControlEvents:UIControlEventTouchUpInside];
        retryButton.backgroundColor = [UIColor clearColor];
        [retryButton setTitleColor:errorTextColor forState:UIControlStateNormal];
        retryButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [retryFooterView addSubview:retryButton];
        retryButton.frame = retryFooterView.bounds;
    }
    return self;
}


#pragma mark State
- (void)setHeaderState:(DramaLoadMoreState)state
{
//    NSLog(@"setHeaderState %d", state);
    _headerState = state;
    switch (state) {
        case DramaLoadMoreStateNormal:
            [self setTableHeaderViewAnimated:nil];
            break;
        case DramaLoadMoreStateLoading:
            [self setTableHeaderViewAnimated:self.loadingHeaderView];
            [_headerLoadingView startAnimating];
            break;
        case DramaLoadMoreStateFailed:
            [self setTableHeaderViewAnimated:self.retryHeaderView];
            break;
    }

    [self setNeedsLayout];
}

- (void)setFooterState:(DramaLoadMoreState)state
{
//    NSLog(@"setFooterState %d", state);
    _footerState = state;
    switch (state) {
        case DramaLoadMoreStateNormal:
            [self setTableFooterViewAnimated:nil];
            break;
        case DramaLoadMoreStateLoading:
            [self setTableFooterViewAnimated:self.loadingFooterView];
            [_footerLoadingView startAnimating];
            break;
        case DramaLoadMoreStateFailed:
            [self setTableFooterViewAnimated:self.retryFooterView];
            break;
    }
    
    [self setNeedsLayout];
}

- (void)setTableHeaderViewAnimated:(UIView *)tableHeaderView
{
//    NSLog(@"setTableHeaderViewAnimated %@, %@", tableHeaderView, self.tableHeaderView);
    tableHeaderView.width = self.width;
    if (tableHeaderView == nil) {
        if (self.tableHeaderView != nil) {
            CGFloat orgHeight = self.tableHeaderView.height;
            [UIView animateWithDuration:0.3f animations:^{
                self.tableHeaderView.height = 0;
            } completion:^(BOOL finished) {
                self.tableHeaderView.height = orgHeight;
//                NSLog(@"[2]%@", self.tableHeaderView);
                self.tableHeaderView = nil;
            }];
        }
    }
    else {
        CGFloat initHeight = 0;
        if (self.tableHeaderView != nil) {
            initHeight = self.tableHeaderView.height;
        }
        CGFloat destHeight = tableHeaderView.height;
        
        tableHeaderView.height = initHeight;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tableHeaderView.height = destHeight;
            self.tableHeaderView = tableHeaderView;
        } completion:^(BOOL finished) {
//            NSLog(@"[1]%@", self.tableHeaderView);
        }];
    }
}

- (void)setTableFooterViewAnimated:(UIView *)tableFooterView
{
    tableFooterView.width = self.width;
    tableFooterView.top = MAX(self.contentSize.height, self.height);
    if (tableFooterView == nil) {
        if (self.tableFooterView != nil) {
            CGFloat orgHeight = self.tableFooterView.height;
            [UIView animateWithDuration:0.3f animations:^{
                self.tableFooterView.height = 0;
            } completion:^(BOOL finished) {
                self.tableFooterView.height = orgHeight;
//                NSLog(@"[2]%@", tableFooterView);
                self.tableFooterView = nil;
            }];
        }
    }
    else {
        CGFloat initHeight = 0;
        if (self.tableFooterView != nil) {
            initHeight = self.tableFooterView.height;
        }
        CGFloat destHeight = tableFooterView.height;
        
        tableFooterView.height = initHeight;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tableFooterView.height = destHeight;
            self.tableFooterView = tableFooterView;
        } completion:^(BOOL finished) {
//            NSLog(@"[1]%@", self.tableFooterView);
        }];
    }

}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll %f", scrollView.contentOffset.y);
    if (_headerLoadingEnabled) {
        BOOL loadMore = [self shouldTriggerHeaderLoadMore:scrollView];
        if (scrollView.isDragging && _headerState == DramaLoadMoreStateNormal && loadMore && !_isHeaderLoading) {
            [self setHeaderState:DramaLoadMoreStateLoading];
            [self loadMoreHeader];
        }
    }
    if (_footerLoadingEnabled) {
        BOOL loadMore = [self shouldTriggerFooterLoadMore:scrollView];
        if (scrollView.isDragging && _footerState == DramaLoadMoreStateNormal && loadMore && !_isFooterLoading) {
            [self setFooterState:DramaLoadMoreStateLoading];
            [self loadMoreFooter];
        }
    }
}

- (BOOL)shouldTriggerHeaderLoadMore:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= 0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)shouldTriggerFooterLoadMore:(UIScrollView *)scrollView
{
    CGFloat maxContentOffset = MAX(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    CGFloat offset = scrollView.contentOffset.y;
    if (offset >= maxContentOffset) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark Public
- (void)failLoadMoreHeader
{
    if (_headerLoadingEnabled) {
        if (_headerState == DramaLoadMoreStateLoading) {
            [self setHeaderState:DramaLoadMoreStateFailed];
        }
    }
}

- (void)finishLoadMoreHeader
{
    if (_headerLoadingEnabled) {
        if (_headerState == DramaLoadMoreStateLoading) {
            [self setHeaderState:DramaLoadMoreStateNormal];
        }
    }
}

- (void)failLoadMoreFooter
{
    if (_footerLoadingEnabled) {
        if (_footerState == DramaLoadMoreStateLoading) {
            [self setFooterState:DramaLoadMoreStateFailed];
        }
    }
}

- (void)finishLoadMoreFooter
{
    if (_footerLoadingEnabled) {
        if (_footerState == DramaLoadMoreStateLoading) {
            [self setFooterState:DramaLoadMoreStateNormal];
        }
    }
}

#pragma mark UI Action
- (IBAction)onClickRetryHeader:(id)sender
{
    [self setHeaderState:DramaLoadMoreStateLoading];
    [self loadMoreHeader];
}

- (IBAction)onClickRetryFooter:(id)sender
{
    [self setFooterState:DramaLoadMoreStateLoading];
    [self loadMoreFooter];
}

- (void)loadMoreHeader
{
    if ([self.delegate respondsToSelector:@selector(dramaTableViewDidTriggerLoadMoreHeader:)]) {
        [self.delegate dramaTableViewDidTriggerLoadMoreHeader:self];
    }
}

- (void)loadMoreFooter
{
    if ([self.delegate respondsToSelector:@selector(dramaTableViewDidTriggerLoadMoreFooter:)]) {
        [self.delegate dramaTableViewDidTriggerLoadMoreFooter:self];
    }
}

@end
