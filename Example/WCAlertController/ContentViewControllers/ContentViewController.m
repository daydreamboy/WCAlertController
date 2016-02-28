//
//  ContentViewController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/26.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "ContentViewController.h"

#import <WCAlertController/WCAlertController.h>

@interface ContentViewController ()
@property (nonatomic, strong) UIButton *buttonDismissAlert;
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.view.backgroundColor = [UIColor greenColor];
    self.view.frame = CGRectMake(0, 0, 200, 300);
    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = YES;
    
    CGSize viewSize = self.view.frame.size;
    
    self.navigationController.view.frame = self.view.frame;
    
    _buttonDismissAlert = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonDismissAlert.frame = CGRectMake(0, 60, viewSize.width, 40);
    [_buttonDismissAlert setTitle:@"Dismiss alert" forState:UIControlStateNormal];
    [_buttonDismissAlert addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonDismissAlert];
}

#pragma mark - Actions

- (void)barItemClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.buttonDismissAlert) {
        [self dismissAlertControllerAnimated:NO];
    }
}

#pragma mark

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"_cmd: %@, %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), parent);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"_cmd: %@, %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), parent);
}

@end
