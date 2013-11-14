//
//  DrawerDetailViewController.h
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BDBSplitViewController.h"


#pragma mark -
@interface DrawerDetailViewController : BDBDetailViewController
<UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *github;

@end
