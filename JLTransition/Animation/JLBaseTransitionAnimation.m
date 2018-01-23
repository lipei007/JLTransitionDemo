//
//  JLBaseTransitionAnimation.m
//  JLTransitionDemo
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import "JLBaseTransitionAnimation.h"

static NSTimeInterval animationDuration = 0.25;

@implementation JLBaseTransitionAnimation

#pragma mark - UIViewControllerAnimatedTransitioning

- (instancetype)initWithTransitionType:(JLTransitionType)type {
    if (self = [super init]) {
        self.transitionType = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (self.transitionType) {
        case JLTransitionTypePresent: {
            [self startPresentTransition:transitionContext];
        }
            break;
        case JLTransitionTypeDismiss: {
            [self startDimissTransition:transitionContext];
        }
            break;
        case JLTransitionTypePush: {
            [self startPushTransition:transitionContext];
        }
            break;
        case JLTransitionTypePop: {
            [self startPopTransition:transitionContext];
        }
            break;
        case JLTransitionTypeTabBar: {
            [self startTabBarTransition:transitionContext];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - Presentation

- (void)startPresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (!transitionContext) {
        return;
    }
    
    // 首先需要得到参与切换的两个ViewController的信息
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [transitionContext containerView].backgroundColor = [UIColor clearColor];
    
    /**
     * 可以将snapshot添加到containerView中index=0，隐藏fromView。对snapshot做动画
     */
//    UIView *fromSnapshot = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    
    // present时，将toView添加到containerView中
    [[transitionContext containerView] addSubview:toVC.view];
    
    // 对于要呈现的VC，我们希望它从屏幕下方出现，因此将初始位置设置到屏幕下边缘
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, screenBounds.size.height);
    
    
    // 开始动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = finalFrame;
        
    } completion:^(BOOL finished) {
        
        // 动画结束后必须向context报告VC切换完成，否者认为你一直还在，会出现无法交互的情况
        BOOL cancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancelled];
        
        if (cancelled) {
            [toVC.view removeFromSuperview];
        }
        
    }];
    
}

- (void)startDimissTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (!transitionContext) {
        return;
    }
    
    // 首先需要得到参与切换的两个ViewController的信息
    //    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // presentStyle = Customer，View是没有从视图层级上移除的。否则Dismiss需要将其添加回来
    //    [[transitionContext containerView] insertSubview:toVC.view atIndex:0];
    
    UIView *fromView = fromVC.view;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect initialFrame = fromView.frame;
        fromView.frame = CGRectOffset(initialFrame, 0, screenBounds.size.height);
        
    } completion:^(BOOL finished) {
        
        BOOL cancelled = [transitionContext transitionWasCancelled];
        // 动画结束后必须向context报告VC切换完成，否者认为你一直还在，会出现无法交互的情况
        [transitionContext completeTransition:!cancelled];
        
        if (cancelled) {
            
        } else {
            // dismiss时，要把fromView从container的视图层级中移除。
            [fromView removeFromSuperview];
            
        }
        
    }];
    
    
}

#pragma mark - Navigation

- (void)startPushTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (!transitionContext) {
        return;
    }
    // 首先需要得到参与切换的两个ViewController的信息
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [transitionContext containerView].backgroundColor = [UIColor clearColor];
    // present时，将toView添加到containerView中
    [[transitionContext containerView] addSubview:toVC.view];
    
    // 对于要呈现的VC，我们希望它从屏幕下方出现，因此将初始位置设置到屏幕下边缘
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, screenBounds.size.height);
    
    // 开始动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = finalFrame;
        
        
    } completion:^(BOOL finished) {
        
        BOOL cancelled = [transitionContext transitionWasCancelled];
        // 动画结束后必须向context报告VC切换完成或取消
        [transitionContext completeTransition:!cancelled];
        
    }];
}

- (void)startPopTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (!transitionContext) {
        return;
    }
    // 首先需要得到参与切换的两个ViewController的信息
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // push后将view从视图层级上移除了，pop时需要加回去
    [[transitionContext containerView] insertSubview:toVC.view atIndex:0];
    
    UIView *fromView = fromVC.view;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect initialFrame = fromView.frame;
        fromView.frame = CGRectOffset(initialFrame, 0, screenBounds.size.height);
        
    } completion:^(BOOL finished) {
        
        
//        [fromView removeFromSuperview];
        BOOL cancelled = [transitionContext transitionWasCancelled];
        // 动画结束后必须向context报告VC切换完成或取消
        [transitionContext completeTransition:!cancelled];
        
        
    }];
}

#pragma mark - TabBar

- (void)startTabBarTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (!transitionContext) {
        return;
    }
    // 首先需要得到参与切换的两个ViewController的信息
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [transitionContext containerView].backgroundColor = [UIColor clearColor];
    // present时，将toView添加到containerView中
    [[transitionContext containerView] addSubview:toVC.view];
    
    // 对于要呈现的VC，我们希望它从屏幕下方出现，因此将初始位置设置到屏幕下边缘
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = CGRectOffset(finalFrame, screenBounds.size.width, 0);
    
    // 开始动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        
        toVC.view.frame = finalFrame;
        
        
    } completion:^(BOOL finished) {
        
        BOOL cancelled = [transitionContext transitionWasCancelled];
        // 动画结束后必须向context报告VC切换完成或取消
        [transitionContext completeTransition:!cancelled];
        
    }];
}

@end
