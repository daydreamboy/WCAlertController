//
//  ContentViewController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/26.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "ContentViewController.h"

#import "PresentedViewController.h"

#import <WCAlertController/WCAlertController.h>
#import <MessageUI/MessageUI.h>

@interface ContentViewController () <MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) UIButton *buttonDismissAlert;
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"_cmd: %@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    self.view.backgroundColor = [UIColor greenColor];
    self.view.frame = CGRectMake(0, 0, 200, 200);
    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

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
//        [self dismissAlertControllerAnimated:NO];

//        PresentedViewController *viewController = [PresentedViewController new];
//        [self presentViewController:viewController animated:YES completion:nil];
        [self showMFMessageComposeViewController];
    }
}

- (void)showMFMessageComposeViewController {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        NSString *phoneNumber = @"123456789";
        controller.recipients = @[phoneNumber];//[NSArray arrayWithObject:[ONEUserStore sharedInstance].codeModel.target_number];
        NSString *content     = @"content";//[ONEUserStore sharedInstance].codeModel.content;
        controller.body       = content;
        controller.messageComposeDelegate = self;

        if (self.standOnViewController) {
            [self.standOnViewController.alertController presentViewController:controller animated:YES completion:nil];
        }
    }
    else {
        //提示：此设备没有短信功能
        //[self showAlertViewTitle:nil message:@"此设备不支持短信"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark
/*
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
 */

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    controller.delegate = nil;
    switch (result) {
        case MessageComposeResultSent: {
        }
        break;

        case MessageComposeResultCancelled:
            [self.standOnViewController.alertController dismissViewControllerAnimated:YES completion:nil];
            break;

        default:
            break;
    }
}

@end
