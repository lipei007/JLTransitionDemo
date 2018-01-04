//
//  ViewController.m
//  JLTransitionDemo
//
//  Created by Jack on 2017/3/24.
//  Copyright © 2017年 buakaw. All rights reserved.
//

#import "ViewController.h"
#import "SencondViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"to second" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(100, 100, 100, 60);
    
    [self.view addSubview:btn];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.backgroundColor = [UIColor redColor];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
}


- (void)btnClick:(UIButton *)sender {

    [self present];
    
//    [self.navigationController pushViewController:scdVC animated:YES];
    
//    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"123" message:@"456" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *c = [UIAlertAction actionWithTitle:@"8" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [a addAction:c];
//    [self presentViewController:a animated:YES completion:nil];
    
}

- (void)present {
    SencondViewController *scdVC = [[SencondViewController alloc] init];
    
    scdVC.preferredContentSize = CGSizeMake(300, 260);
    [self presentViewController:scdVC animated:YES completion:nil];
}






@end
