//
//  NormalDetailViewController.m
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "NormalDetailViewController.h"


#pragma mark -
@implementation NormalDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Normal";

    [self.splitViewController setMasterViewDisplayStyle:BDBMasterViewDisplayStyleNormal animated:YES];
    self.navigationItem.leftBarButtonItem = self.splitViewController.showHideMasterViewButtonItem;

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
        self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.website addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoItemTapped:)]];
}

- (void)infoItemTapped:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bradbergeron.com"]];
}

@end
