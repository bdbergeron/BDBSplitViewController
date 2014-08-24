//
//  MasterViewController.m
//
//  Copyright (c) 2013-2014 Bradley David Bergeron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "BDBSplitViewController.h"
#import "DrawerDetailViewController.h"
#import "MasterViewController.h"
#import "NormalDetailViewController.h"
#import "StickyDetailViewController.h"


#pragma mark -
@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Master View", nil);

    self.tableView.rowHeight = 90.f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.bdb_splitViewController.masterViewDisplayStyle == BDBSplitViewControllerMasterDisplayStyleDrawer) {
        self.tableView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.6f];
    } else {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    switch (indexPath.row) {
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"Drawer Style", nil);

            break;
        }
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"Sticky Style", nil);

            break;
        }
        case 0:
        default: {
            cell.textLabel.text = NSLocalizedString(@"Normal Style", nil);

            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDBDetailViewController *detailVC;

    switch (indexPath.row) {
        case 2: {
            detailVC = [DrawerDetailViewController new];

            break;
        }
        case 1: {
            detailVC = [StickyDetailViewController new];

            break;
        }
        case 0:
        default: {
            detailVC = [NormalDetailViewController new];
        }
    }

    UINavigationController *detailNavVC = (UINavigationController *)self.bdb_splitViewController.detailViewController;

    UIViewController *currentDetailVC = detailNavVC.topViewController;

    if (![currentDetailVC isKindOfClass:[detailVC class]]) {
        if (self.bdb_splitViewController.masterViewDisplayStyle == BDBSplitViewControllerMasterDisplayStyleDrawer || indexPath.row == 2) {
            [self.bdb_splitViewController hideMasterViewControllerAnimated:YES completion:^{
                detailNavVC.viewControllers = @[detailVC];
            }];
        } else {
            detailNavVC.viewControllers = @[detailVC];
        }
    }
}

@end
