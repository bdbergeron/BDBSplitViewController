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
@interface MasterViewController ()

@end


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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

@end
