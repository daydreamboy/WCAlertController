//
//  RootViewController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/24.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"
#import <WCAlertController/WCAlertController.h>

@interface RootViewController ()
@property (nonatomic, strong) UIButton *buttonPush;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    self.view.backgroundColor = [UIColor greenColor];
    self.view.frame = CGRectMake(0, 0, 200, 300);
    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = YES;
    
    CGSize viewSize = self.view.frame.size;
    
    self.navigationController.view.frame = self.view.frame;
    
    _buttonPush = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonPush.frame = CGRectMake(0, 60, viewSize.width, 40);
    [_buttonPush setTitle:@"push UIViewController" forState:UIControlStateNormal];
    [_buttonPush addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonPush];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss Me" style:UIBarButtonItemStyleDone target:self action:@selector(barItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark - Actions

- (void)barItemClicked:(UIBarButtonItem *)sender {
    if (self.navigationController.alertController) {
        // contentViewController dismiss the alert
        [self.navigationController dismissAlertControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.buttonPush) {
        SecondViewController *secondViewController = [SecondViewController new];
        [self.navigationController pushViewController:secondViewController animated:YES];
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
