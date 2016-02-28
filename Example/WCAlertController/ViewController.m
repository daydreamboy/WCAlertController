//
//  WCViewController.m
//  WCAlertController
//
//  Created by wesley_chen on 02/24/2016.
//  Copyright (c) 2016 wesley_chen. All rights reserved.
//

#import "ViewController.h"

#import <WCAlertController/WCAlertController.h>

#import "RootViewController.h"
#import "ModalViewController.h"
#import "ContentViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *buttonAlertNavController;
@property (nonatomic, strong) UIButton *buttonAlertViewController;

@property (nonatomic, strong) UIButton *buttonPresentNavController;
@property (nonatomic, strong) UIButton *buttonPresentViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat spacingV = 10;
    CGFloat startY = 60;

    _buttonAlertNavController = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonAlertNavController.frame = CGRectMake(0, startY, screenSize.width, 40);
    [_buttonAlertNavController setTitle:@"alert Nav Controller" forState:UIControlStateNormal];
    [_buttonAlertNavController addTarget:self action:@selector(alertNavController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonAlertNavController];

    startY = CGRectGetMaxY(_buttonAlertNavController.frame) + spacingV;
    
    _buttonAlertViewController = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonAlertViewController.frame = CGRectMake(0, startY, screenSize.width, 40);
    [_buttonAlertViewController setTitle:@"alert View Controller" forState:UIControlStateNormal];
    [_buttonAlertViewController addTarget:self action:@selector(alertViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonAlertViewController];

    startY = CGRectGetMaxY(_buttonAlertViewController.frame) + spacingV;
    
    _buttonPresentNavController = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonPresentNavController.frame = CGRectMake(0, startY, screenSize.width, 40);
    [_buttonPresentNavController setTitle:@"present Nav Controller" forState:UIControlStateNormal];
    [_buttonPresentNavController addTarget:self action:@selector(presentNavController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonPresentNavController];
    
    startY = CGRectGetMaxY(_buttonPresentNavController.frame) + spacingV;
    
    _buttonPresentViewController = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonPresentViewController.frame = CGRectMake(0, startY, screenSize.width, 40);
    [_buttonPresentViewController setTitle:@"present modal View  Controller" forState:UIControlStateNormal];
    [_buttonPresentViewController addTarget:self action:@selector(presentViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonPresentViewController];
}

#pragma mark - Actions

- (void)presentViewController:(id)sender {
    ModalViewController *modalViewController = [ModalViewController new];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

- (void)presentNavController:(id)sender {
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)alertViewController:(id)sender {
    ContentViewController *viewController = [ContentViewController new];
    
    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
        if (viewController == contentViewController) {
            NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");
            if (!presented) {
                NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
            }
        }
    }];
    alert.showDuration = 7;//0.3;
    NSLog(@"dismissDuration: %f", alert.dismissDuration);
    alert.dismissDuration = 7;//0.2;
    alert.maskViewColor = [UIColor yellowColor];
    [alert presentAlertAnimated:YES];
}

- (void)alertNavController:(id)sender {
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navController.view.layer.cornerRadius = 10;
    navController.view.clipsToBounds = YES;
    //        navController.view.frame = CGRectMake(0, 0, 300, 400);
    
    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:navController completion:nil];
    alert.showDuration = 7;
    alert.dismissDuration = 7;
    [alert presentAlertAnimated:YES];
}

@end
