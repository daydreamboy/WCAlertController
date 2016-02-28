//
//  SecondViewController.m
//  WCAlertController
//
//  Created by wesley chen on 16/2/25.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "SecondViewController.h"

#import <WCAlertController/WCAlertController.h>

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss Me" style:UIBarButtonItemStyleDone target:self action:@selector(barItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)barItemClicked:(UIBarButtonItem *)sender {
    if (self.navigationController.alertController) {
        // contentViewController dismiss the alert
        [self.navigationController dismissAlertControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
