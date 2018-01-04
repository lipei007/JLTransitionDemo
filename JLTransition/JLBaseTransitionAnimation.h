//
//  JLBaseTransitionAnimation.h
//  JLTransitionDemo
//
//  Created by Jack on 2017/11/27.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    JLTransitionTypePresent = 0,
    JLTransitionTypeDismiss = 1,
    JLTransitionTypePush    = 2,
    JLTransitionTypePop     = 3
} JLTransitionType;


@interface JLBaseTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) JLTransitionType transitionType;

- (instancetype)initWithTransitionType:(JLTransitionType)type;

- (void)startPresentTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startDimissTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startPushTransition:(id<UIViewControllerContextTransitioning>)transitionContext;
- (void)startPopTransition:(id<UIViewControllerContextTransitioning>)transitionContext;


@end
