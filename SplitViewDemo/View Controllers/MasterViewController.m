//
//  MasterViewController.m
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

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
    UITableViewCell *cell; //= [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

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
            detailView = [[NSClassFromString(@"DrawerDetailViewController") alloc] init];
            break;
        }
        case 1:
        {
            detailView = [[NSClassFromString(@"StickyDetailViewController") alloc] init];
            break;
        }
        case 0:
        default:
        {
            detailView = [[NSClassFromString(@"NormalDetailViewController") alloc] init];
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
