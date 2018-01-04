//
//  JLInteractiveTransition.h
//  JLTransitionDemo
//
//  Created by Jack on 2017/11/20.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *JLInteractiveStartTopSide;
UIKIT_EXTERN NSString *JLInteractiveStartLeftSide;
UIKIT_EXTERN NSString *JLInteractiveStartBottomSide;
UIKIT_EXTERN NSString *JLInteractiveStartRightSide;


@interface JLInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic,assign,readonly,getter=isInteraction) BOOL interaction;
@property (nonatomic,copy) void(^startInteraction)(void);
@property (nonatomic,copy) NSString *startSide;

- (instancetype)initWithInteractiveViewController:(UIViewController *)viewController;



@end
