//
//  StickyDetailViewController.m
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "StickyDetailViewController.h"


#pragma mark -
@implementation StickyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Sticky";

    [self.splitViewController setMasterViewDisplayStyle:BDBMasterViewDisplayStyleSticky animated:YES];
    self.navigationItem.leftBarButtonItem = self.splitViewController.showHideMasterViewButtonItem;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.twitter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
}

- (void)infoItemTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/bradbergeron"]];
}

@end
