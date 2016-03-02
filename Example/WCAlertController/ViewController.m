//
//  WCViewController.m
//  WCAlertController
//
//  Created by wesley_chen on 02/24/2016.
//  Copyright (c) 2016 wesley_chen. All rights reserved.
//

#import "ViewController.h"

#import <WCAlertController/WCAlertController.h>

#import "NavRootViewController.h"
#import "ContentViewController.h"
#import "ModalViewController.h"
#import "RootViewController.h"

#define CELL_TITLE  @"title"
#define CELL_ACTION @"action"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *buttonAlertNavController;
@property (nonatomic, strong) UIButton *buttonAlertViewController;

@property (nonatomic, strong) UIButton *buttonPresentNavController;
@property (nonatomic, strong) UIButton *buttonPresentViewController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@property (nonatomic, strong) WCAlertController *alert1;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];

    if (self) {
        _listData = [NSMutableArray array];
        [_listData addObject:@{
             CELL_TITLE: @"alert Nav Controller (UIWindow)",
             CELL_ACTION: NSStringFromSelector(@selector(alertNavController:)),
         }];
        [_listData addObject:@{
             CELL_TITLE: @"alert View Controller (UIWindow)",
             CELL_ACTION: NSStringFromSelector(@selector(alertViewController:)),
         }];

        [_listData addObject:@{
             CELL_TITLE: @"present Nav Controller",
             CELL_ACTION: NSStringFromSelector(@selector(presentNavController:)),
         }];
        [_listData addObject:@{
             CELL_TITLE: @"present modal View  Controller",
             CELL_ACTION: NSStringFromSelector(@selector(presentViewController:)),
         }];

        [_listData addObject:@{
             CELL_TITLE: @"alert Nav Controller (UIViewController)",
             CELL_ACTION: NSStringFromSelector(@selector(alertNavControllerOnViewController:)),
         }];
        [_listData addObject:@{
             CELL_TITLE: @"alert View Controller (UIViewController)",
             CELL_ACTION: NSStringFromSelector(@selector(alertViewControllerOnViewController:)),
         }];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    CGSize viewSize = self.view.frame.size;

    CGFloat statusBarHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight, viewSize.width, viewSize.height - statusBarHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"ViewController_UITableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }

    cell.textLabel.text = _listData[indexPath.row][CELL_TITLE];

    if (indexPath.row % 2) {
        cell.textLabel.textColor = [UIColor redColor];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SEL action = NSSelectorFromString(_listData[indexPath.row][CELL_ACTION]);
    IMP imp = [self methodForSelector:action];
    void (*func)(id, SEL, id) = (void *)imp;
    func(self, action, self);

//    [self performSelector:action withObject:self];
}

#pragma mark - Actions

- (void)presentViewController:(id)sender {
    ModalViewController *modalViewController = [ModalViewController new];

    [self presentViewController:modalViewController
                       animated:YES
                     completion:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self dismissViewControllerAnimated:YES completion:nil];
//        });
    }];
}

- (void)presentNavController:(id)sender {
    RootViewController *rootViewController = [RootViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    [self presentViewController:navController animated:YES completion:nil];
}

- (void)alertViewController:(id)sender {
    ContentViewController *viewController = [ContentViewController new];

    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController
                                                                             completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
        if (viewController == contentViewController) {
            NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");

            if (!presented) {
                NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
            }
        }
    }];

//    alert.showDuration = 7;//0.3;
    NSLog(@"dismissDuration: %f", alert.dismissDuration);
//    alert.dismissDuration = 7;//0.2;
    alert.maskViewColor = [UIColor yellowColor];
    alert.maskViewBlurred = YES;
//    [alert presentAlertAnimated:YES];
    [self presentAlertController:alert animated:YES];
}

- (void)alertNavController:(id)sender {
    NavRootViewController *rootViewController = [NavRootViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

    navController.view.layer.cornerRadius = 10;
    navController.view.clipsToBounds = YES;
    //        navController.view.frame = CGRectMake(0, 0, 300, 400);

    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:navController completion:nil];
    alert.showDuration = 7;
    alert.dismissDuration = 7;
//    [alert presentAlertAnimated:YES];
}

- (void)alertViewControllerOnViewController:(id)sender {
    NSLog(@"start: %f", CACurrentMediaTime());
//    [self presentAlertController:self.alert1 animated:YES];
    [self.alert1 presentAlertAnimated:YES];
}

- (WCAlertController *)alert1 {
    if (!_alert1) {
        ContentViewController *viewController = [ContentViewController new];

        WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController
                                                                     fromHostViewController:self
                                                                                 completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
            if (viewController == contentViewController) {
                NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");

                if (!presented) {
                    NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
                }
                if (presented == YES) {
                    NSLog(@"end: %f", CACurrentMediaTime());
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self dismissAlertControllerAnimated:NO];
//                    });
                }
            }
        }];
//        alert.maskViewColor = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
//        alert.maskViewBlurred = YES;
        alert.showDuration = 7;//0.3;
//        alert.dismissDuration = 7;//0.2;

        _alert1 = alert;
    }

    return _alert1;
}

- (void)alertNavControllerOnViewController:(id)sender {
//    NavRootViewController *rootViewController = [NavRootViewController new];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
//
//    navController.view.layer.cornerRadius = 10;
//    navController.view.clipsToBounds = YES;
//    //        navController.view.frame = CGRectMake(0, 0, 300, 400);
//
//    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:navController completion:nil];
//    alert.showDuration = 7;
//    alert.dismissDuration = 7;
//    [alert presentAlertAnimated:YES];
}

@end
