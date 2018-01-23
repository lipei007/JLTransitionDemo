//
//  JLExpansionTransitionAnimation.m
//  JLTransitionDemo
//
//  Created by Jack on 2018/1/23.
//  Copyright © 2018年 buakaw. All rights reserved.
//

#import "JLExpansionTransitionAnimation.h"

@interface JLExpansionTransitionAnimation() <CAAnimationDelegate>
{
    id<UIViewControllerContextTransitioning> _transitionContext;
    CAShapeLayer *_maskLayer;
}
@end

@implementation JLExpansionTransitionAnimation

- (void)startPresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (!transitionContext) {
        return;
    }
    
    _transitionContext = transitionContext;
    
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
    toVC.view.backgroundColor = [UIColor redColor];

    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    toVC.view.frame = finalFrame;
    
    
    // mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    _maskLayer = maskLayer;
    
    CGFloat w = CGRectGetWidth(finalFrame);
    CGFloat h = CGRectGetHeight(finalFrame);
    
    CGRect initialRect = CGRectMake(w - 100, 0, 100, 100);
    UIBezierPath *circleMaskPathInitial = [UIBezierPath bezierPathWithOvalInRect:initialRect];
    CGPoint extremePoint = CGPointMake(w, 0);
    CGFloat radius = sqrt((extremePoint.x * extremePoint.x) + (extremePoint.y * extremePoint.y));
    
    CGRect finalRect = CGRectMake(0, 0, w, h);
    finalRect = CGRectInset(finalRect, -radius, -radius);
    UIBezierPath *circleMaskPathFinal = [UIBezierPath bezierPathWithOvalInRect:finalRect];
    
    maskLayer.path = circleMaskPathFinal.CGPath;
    toVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id _Nullable)(circleMaskPathInitial.CGPath);
    maskLayerAnimation.toValue = (__bridge id _Nullable)(circleMaskPathFinal.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.layer.mask = nil;
    
    // 动画结束后必须向context报告VC切换完成，否者认为你一直还在，会出现无法交互的情况
    BOOL cancelled = [_transitionContext transitionWasCancelled];
    [_transitionContext completeTransition:!cancelled];
    
    if (cancelled) {
        [toVC.view removeFromSuperview];
    }
}

@end
