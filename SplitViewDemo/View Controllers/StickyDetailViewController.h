//
//  StickyDetailViewController.h
//  SplitViewDemo
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BDBSplitViewController.h"


#pragma mark -
@interface StickyDetailViewController : BDBDetailViewController
<UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *labelContainerView;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *githubLabel;

@end
