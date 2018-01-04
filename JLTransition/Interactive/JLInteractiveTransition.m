//
//  JLInteractiveTransition.m
//  JLTransitionDemo
//
//  Created by Jack on 2017/11/20.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import "JLInteractiveTransition.h"

CGFloat const valid_margin = 20;
NSString const *JLInteractiveStartTopSide    = @"JLInteractiveStartTopSide";
NSString const *JLInteractiveStartLeftSide   = @"JLInteractiveStartLeftSide";
NSString const *JLInteractiveStartBottomSide = @"JLInteractiveStartBottomSide";
NSString const *JLInteractiveStartRightSide  = @"JLInteractiveStartRightSide";


@interface JLInteractiveTransition()
{
    __weak UIViewController *_viewController;
    BOOL _validPan;
    BOOL _userPan;
    CGPoint _startPoint;
    CGRect _originFrame;
}

@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

@end

@implementation JLInteractiveTransition

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    }
    return _panGesture;
}

- (instancetype)initWithInteractiveViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        if (viewController) {
            _viewController = viewController;
            [viewController.view addGestureRecognizer:self.panGesture];
        }
    }
    return self;
}

- (CGFloat)width {
    return CGRectGetWidth(_viewController.view.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(_viewController.view.frame);
}

- (BOOL)isInteraction {
    return _userPan;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if (!_viewController) {
        return;
    }
    if (self.startInteraction == nil) {
        return;
    }
    
    CGPoint v = [panGesture velocityInView:_viewController.view.superview];
    CGPoint p = [panGesture locationInView:_viewController.view.superview];
    CGFloat x = p.x;
    CGFloat y = p.y;

    if (panGesture.state == UIGestureRecognizerStateBegan) {
        _originFrame = _viewController.view.frame;
        
        x = p.x - CGRectGetMinX(_originFrame);
        y = p.y - CGRectGetMinY(_originFrame);
        
        if (!self.startSide) {
            _validPan = NO;
        } else {
            if (self.startSide == JLInteractiveStartTopSide) {
                
                if (y >= 0 && y <= valid_margin) {
                    if (v.y > 0) {
                        _validPan = YES;
                    } else {
                        _validPan = NO;
                    }
                } else {
                    _validPan = NO;
                }
                
            } else if (self.startSide == JLInteractiveStartLeftSide) {
                
                if (x >= 0 && x <= valid_margin) {
                    if (v.x > 0) {
                        _validPan = YES;
                    } else {
                        _validPan = NO;
                    }
                } else {
                    _validPan = NO;
                }
                
            } else if (self.startSide == JLInteractiveStartBottomSide) {
                
                if (y >= [self height] - valid_margin && y <= [self height]) {
                    if (v.y < 0) {
                        _validPan = YES;
                    } else {
                        _validPan = NO;
                    }
                } else {
                    _validPan = NO;
                }
                
            } else if (self.startSide == JLInteractiveStartRightSide) {
                
                if (x >= [self width] - valid_margin && x <= [self width]) {
                    if (v.x < 0) {
                        _validPan = YES;
                    } else {
                        _validPan = NO;
                    }
                } else {
                    _validPan = NO;
                }
            }
        }
        
        
        if (_validPan) {
            _userPan = YES;
            _startPoint = p;
            self.startInteraction();
        } else {
            _userPan = NO;
            _startPoint = CGPointZero;
        }
        
    } else {
        
        if (_validPan) {
            
            x = p.x - CGRectGetMinX(_originFrame);
            y = p.y - CGRectGetMinY(_originFrame);
            
            CGFloat len = fabs(p.x - _startPoint.x);
            CGFloat per = len / [self width];
            NSLog(@"start: %f  p: %f  len: %f  width: %f  per %f",_startPoint.x,p.x,len,[self width],per);
            if (panGesture.state == UIGestureRecognizerStateChanged) {
                [self updateInteractiveTransition:per];
            } else {
                _userPan = NO;
                if (per >= 0.2) {
                    [self finishInteractiveTransition];
                } else {
                    [self cancelInteractiveTransition];
                }
            }
        }
        
    }
    
    
    
}

@end
