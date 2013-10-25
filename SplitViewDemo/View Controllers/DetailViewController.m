//
//  DetailViewController.m
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "BDBSplitViewController.h"
#import "DetailViewController.h"


#pragma mark -
@interface DetailViewController ()

@end


#pragma mark -
@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = self.splitViewController.showHideMasterButtonItem;
}

#pragma mark UISplitViewController Delegate
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return self.splitViewController.masterIsHidden;
}

@end
