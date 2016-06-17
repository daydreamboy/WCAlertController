//
//  RootViewController.m
//  UIView+Addition
//
//  Created by chenliang-xy on 15/6/26.
//
//

#import "RootViewController.h"

#import <WCAlertController/WCAlertController.h>

// Content View Controllers
#import "ContentViewController.h"

@interface CellItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) SEL selecor;
@property (nonatomic, assign) Class class;

+ (instancetype)itemWithTitle:(NSString *)title selector:(SEL)selector class:(Class)class;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle selector:(SEL)selector class:(Class)class;

@end

@implementation CellItem

+ (instancetype)itemWithTitle:(NSString *)title selector:(SEL)selector class:(Class)class {
    return [self itemWithTitle:title subtitle:nil selector:selector class:class];
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle selector:(SEL)selector class:(Class)class {
    CellItem *item = [[self class] new];

    item.title = title;
    item.subtitle = subtitle;
    item.selecor = selector;
    item.class = class;

    return item;
}

@end

@interface RootViewController ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation RootViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self prepareForInit];
    }

    return self;
}

- (void)prepareForInit {
    self.title = @"WCAlertController";

    // MARK: Configure data for table view
    _items = @[
        [CellItem itemWithTitle:@"alert on Window" subtitle:@"overlap status bar" selector:@selector(alertOnWindow) class:nil],
        [CellItem itemWithTitle:@"alert on ViewController" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"alert on NavController with yellow color" subtitle:@"underlap status bar" selector:@selector(alertOnNavController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"something" selector:@selector(alertOnViewController) class:nil],
        [CellItem itemWithTitle:@"alert on ViewController" selector:@selector(alertOnViewController) class:nil],
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentSize = CGSizeMake(CGRectGetWidth(self.tableView.frame), CGRectGetHeight(self.tableView.frame) - 64);
}

#pragma mark - Test Methods

- (void)alertOnWindow {
    ContentViewController *viewController = [ContentViewController new];

    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController
                                                                             completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
        // Access content view controller and read properties after presented do some work
        __unused ContentViewController *alertedViewController = contentViewController;
        // id value = alertedViewController.property;

        if (viewController == contentViewController) {
            NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");

            if (!presented) {
                NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
            }
        }
    }];

    [self presentAlertController:alert animated:YES];
}

- (void)alertOnViewController {
    ContentViewController *viewController = [ContentViewController new];

    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController
                                                                 fromHostViewController:self
                                                                             completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
        // Access content view controller and read properties after presented do some work
        __unused ContentViewController *alertedViewController = contentViewController;
        // id value = alertedViewController.property;

        if (viewController == contentViewController) {
            NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");

            if (!presented) {
                NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
            }
        }
    }];
    alert.maskViewBlurred = YES;

    [self presentAlertController:alert animated:YES];
}

- (void)alertOnNavController {
    ContentViewController *viewController = [ContentViewController new];

    WCAlertController *alert = [[WCAlertController alloc] initWithContentViewController:viewController
                                                                 fromHostViewController:self.navigationController
                                                                             completion:^(id contentViewController, BOOL presented, BOOL maskViewTapped) {
        // Access content view controller and read properties after presented do some work
        __unused ContentViewController *alertedViewController = contentViewController;
        // id value = alertedViewController.property;

        if (viewController == contentViewController) {
            NSLog(@"%@ is %@", contentViewController, presented ? @"showed" : @"dismissed");

            if (!presented) {
                NSLog(@"Dismissed by %@", maskViewTapped ? @"tapping background" : @"api caller");
            }
        }
    }];

    alert.maskViewColor = [UIColor yellowColor];

    [self.navigationController presentAlertController:alert animated:YES];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CellItem *item = self.items[indexPath.row];

    if (item.class) {
        [self pushViewController:item.class title:item.title];
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:item.selecor];
#pragma GCC diagnostic pop
    }
}

#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sCellIdentifier = @"RootViewController_sCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
    }

    CellItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subtitle;
    cell.accessoryType = item.class ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    return cell;
}

#pragma mark - Utility Methods

- (void)pushViewController:(Class)viewControllerClass title:(NSString *)title {
    NSAssert([viewControllerClass isSubclassOfClass:[UIViewController class]], @"%@ is not sublcass of UIViewController", NSStringFromClass(viewControllerClass));

    UIViewController *vc = [[viewControllerClass alloc] init];
    vc.title = title;

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
