//
//  BDBSplitViewController.h
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
@interface BDBSplitViewController : UISplitViewController

@property (nonatomic, strong, readonly)  UIViewController *masterViewController;
@property (nonatomic, strong, readwrite) UIViewController *detailViewController;

@property (nonatomic, assign, readonly) BOOL masterIsHidden;

@property (nonatomic, strong, readonly) UIBarButtonItem *showHideMasterButtonItem;

- (void)showMasterViewControllerAnimated:(BOOL)animated;
- (void)hideMasterViewControllerAnimated:(BOOL)animated;

@end


@interface UIViewController (BDBSplitViewController)

@property (nonatomic, readonly, retain) BDBSplitViewController *splitViewController;

@end
