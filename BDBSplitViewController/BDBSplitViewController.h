//
//  BDBSplitViewController.h
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BDBSplitViewControllerDelegate;

typedef enum {
    BDBMasterViewDisplayStyleNormal,
    BDBMasterViewDisplayStyleSticky,
    BDBMasterViewDisplayStyleDrawer
} BDBMasterViewDisplayStyle;


#pragma mark -
@interface BDBSplitViewController : UISplitViewController

@property (nonatomic, strong, readonly) UIViewController *masterViewController;
@property (nonatomic, strong)           UIViewController *detailViewController;

@property (nonatomic, strong, readonly) UIBarButtonItem *showHideMasterViewButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *closeMasterViewButtonItem;

@property (nonatomic, assign, readonly)  BOOL masterViewIsHidden;

@property (nonatomic) BDBMasterViewDisplayStyle masterViewDisplayStyle;
@property (nonatomic, assign) BOOL masterViewShouldDismissOnTap;

@property (nonatomic, assign) BOOL detailViewShouldDim;
@property (nonatomic) CGFloat detailViewDimmingOpacity;


#pragma mark Initialization
- (id)initWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc;

#pragma mark Show / Hide Master View
- (void)showMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end


#pragma mark -
@interface UIViewController (BDBSplitViewController)

@property (nonatomic, readonly, retain) BDBSplitViewController *splitViewController;

@end


#pragma mark -
@interface BDBDetailViewController : UIViewController
<UISplitViewControllerDelegate>

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation;

@end
