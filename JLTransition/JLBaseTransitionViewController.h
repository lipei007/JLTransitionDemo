//
//  JLBaseTransitionViewController.h
//  JLTransitionDemo
//
//  Created by Jack on 2017/3/24.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLBaseTransitionViewController : UIViewController <UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate>

- (void)present;
- (void)dismiss;
- (void)navigate;

@end
