//
//  JLPresentationController.m
//  JLTransitionDemo
//
//  Created by Jack on 2017/11/20.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import "JLPresentationController.h"

@interface JLPresentationController ()

@property (nonatomic,strong) UIView *dimmingView;

@end

@implementation JLPresentationController

- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [UIView new];
        _dimmingView.backgroundColor = [UIColor grayColor];
    }
    return _dimmingView;
}

- (void)presentationTransitionWillBegin {
    self.dimmingView.frame = self.containerView.bounds;
    self.dimmingView.alpha = 0.f;
    
    [self.containerView addSubview:self.dimmingView];
    [self.containerView addSubview:self.presentedView];
    
    // 确保我们的动画与其他动画一道儿播放。
    id<UIViewControllerTransitionCoordinator> transitionCoordiantor = self.presentedViewController.transitionCoordinator;
    [transitionCoordiantor animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = .4f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (completed) {
//        [self.dimmingView removeFromSuperview];
    }
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGSize size = self.containerView.bounds.size;
    
    UIViewController *presentedVC = self.presentedViewController;
    size = presentedVC.preferredContentSize;
    if (size.width <= 0 || size.height <= 0) {
        size = self.containerView.bounds.size;
    }
    
    CGFloat w = CGRectGetWidth(self.containerView.bounds);
    CGFloat h = CGRectGetHeight(self.containerView.bounds);
    
    return CGRectMake((w - size.width) * 0.5, (h - size.height) * 0.5, size.width, size.height);
}

- (void)dismissalTransitionWillBegin {
    // 确保我们的动画与其他动画一道儿播放。
    id<UIViewControllerTransitionCoordinator> transitionCoordiantor = self.presentedViewController.transitionCoordinator;
    [transitionCoordiantor animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed) {
//        [self.dimmingView removeFromSuperview];
    }
}

// 屏幕旋转调用此方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.frame = self.containerView.bounds;
        self.presentedView.frame = [self frameOfPresentedViewInContainerView];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
}


@end
