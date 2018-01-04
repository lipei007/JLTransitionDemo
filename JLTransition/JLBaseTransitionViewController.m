//
//  JLBaseTransitionViewController.m
//  JLTransitionDemo
//
//  Created by Jack on 2017/3/24.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import "JLBaseTransitionViewController.h"

#import "JLPresentationController.h"
#import "JLInteractiveTransition.h"

#import "JLBaseTransitionAnimation.h"

@interface JLBaseTransitionViewController ()

@property (nonatomic,strong) JLBaseTransitionAnimation *pushAnimator;
@property (nonatomic,strong) JLBaseTransitionAnimation *popAnimator;

@property (nonatomic,strong) JLInteractiveTransition *presentInteractiveTransition;
@property (nonatomic,strong) JLInteractiveTransition *dismissInteractiveTransition;

@property (nonatomic,strong) JLBaseTransitionAnimation *presentAnimator;
@property (nonatomic,strong) JLBaseTransitionAnimation *dismissAnimator;


@end

@implementation JLBaseTransitionViewController

- (void)comonInit {
    // present
    self.transitioningDelegate = self;
    /**
     * 非Customer时，
     * Present会将FromVC.view从Window移除
     * Dismiss动画结束后VC.view自动添加到Window
     */
    self.modalPresentationStyle = UIModalPresentationCustom;

    self.presentAnimator = [[JLBaseTransitionAnimation alloc] initWithTransitionType:JLTransitionTypePresent];
    self.dismissAnimator = [[JLBaseTransitionAnimation alloc] initWithTransitionType:JLTransitionTypeDismiss];
    
    // navigation
    self.pushAnimator = [[JLBaseTransitionAnimation alloc] initWithTransitionType:JLTransitionTypePush];
    self.popAnimator = [[JLBaseTransitionAnimation alloc] initWithTransitionType:JLTransitionTypePop];
}

#pragma mark - View Controller LifeCyle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self comonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self comonInit];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self comonInit];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // interactiveTransition初始化必须在loadView之后
    
    __weak typeof(self) weakSelf = self;
//    self.presentInteractiveTransition = [[JLInteractiveTransition alloc] initWithInteractiveViewController:self];
//    self.presentInteractiveTransition.startSide = JLInteractiveStartLeftSide;
//    self.presentInteractiveTransition.startInteraction = ^{
//        [weakSelf present];
//    };
    
    self.dismissInteractiveTransition = [[JLInteractiveTransition alloc] initWithInteractiveViewController:self];
    self.dismissInteractiveTransition.startSide = JLInteractiveStartLeftSide;
    self.dismissInteractiveTransition.startInteraction = ^{
        [weakSelf dismiss];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /**
     * 时间线上，在从viewWillAppear方法开始
     * 设置navigationController.delegate才会有用。
     */
    if (self.navigationController) {
        self.navigationController.delegate = self;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
// ios 8
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {

    return [[JLPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];

}

#pragma mark - Animator

// present
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self.presentAnimator;
}

// dismiss
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {

    return self.dismissAnimator;
    
}

#pragma mark - Interactive

// interactive present

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {

    return self.presentInteractiveTransition.isInteraction ? self.presentInteractiveTransition : nil;
}

// interactive dismiss
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {

    return self.dismissInteractiveTransition.isInteraction ? self.dismissInteractiveTransition : nil;
}

#pragma mark - Override

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    /**
     * push之后会将FromVC.view从NavigationController.view上移除
     * pop的时候需要将VC.view添加回NavigationController.view
     */
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimator;
    } else if (operation == UINavigationControllerOperationPop) {
        return self.popAnimator;
    } else {
        return nil;
    }
    
}


- (void)present {
    
}

- (void)dismiss {
    
}




@end
