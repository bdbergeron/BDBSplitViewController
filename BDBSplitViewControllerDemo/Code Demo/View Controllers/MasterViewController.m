//
//  MasterViewController.m
//
//  Copyright (c) 2013 Bradley David Bergeron
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

#import "MasterViewController.h"
#import "BDBSplitViewController.h"


#pragma mark -
@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Master View";

    self.navigationItem.leftBarButtonItem = self.splitViewController.closeMasterViewButtonItem;

    self.tableView.rowHeight = 90.0;
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

    switch (indexPath.row)
    {
        case 2:
        {
            cell.textLabel.text = @"Drawer Style";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"Sticky Style";
            break;
        }
        case 0:
        default:
        {
            cell.textLabel.text = @"Normal Style";
            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDBDetailViewController *detailView;
    switch (indexPath.row)
    {
        case 2:
        {
            detailView = [NSClassFromString(@"DrawerDetailViewController") new];
            break;
        }
        case 1:
        {
            detailView = [NSClassFromString(@"StickyDetailViewController") new];
            break;
        }
        case 0:
        default:
        {
            detailView = [NSClassFromString(@"NormalDetailViewController") new];
            break;
        }
    }

    UIViewController *currentDetailView = [(UINavigationController *)self.splitViewController.detailViewController topViewController];
    if (![currentDetailView isKindOfClass:[detailView class]])
    {
        if (self.splitViewController.masterViewDisplayStyle == BDBMasterViewDisplayStyleDrawer || indexPath.row == 2)
            [self.splitViewController hideMasterViewControllerAnimated:YES completion:^{
                [self.splitViewController setDetailViewController:detailView];
            }];
        else
            [self.splitViewController setDetailViewController:detailView];
    }
}

@end
