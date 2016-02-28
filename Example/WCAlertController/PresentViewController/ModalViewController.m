//
//  ModalViewController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/25.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()
@property (nonatomic, strong) UIButton *buttonDismiss;
@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    CGSize viewSize = self.view.frame.size;
    CGFloat height = 40;
    
    _buttonDismiss = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonDismiss.frame = CGRectMake(0, (viewSize.height - height) / 2.0, viewSize.width, height);
    [_buttonDismiss setTitle:@"Dismiss" forState:UIControlStateNormal];
    [_buttonDismiss addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonDismiss];
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.buttonDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
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


@end
