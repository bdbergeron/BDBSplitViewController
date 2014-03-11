//
//  DrawerDetailViewController.m
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "DrawerDetailViewController.h"


#pragma mark -
@implementation DrawerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Drawer";

    [self.splitViewController setMasterViewDisplayStyle:BDBMasterViewDisplayStyleDrawer animated:YES];
    self.navigationItem.leftBarButtonItem = self.splitViewController.showHideMasterViewButtonItem;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.github addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
}

- (void)infoItemTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/bdbergeron"]];
}

@end
