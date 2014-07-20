//
//  BDBSplitViewController.h
//
//  Copyright (c) 2013 Bradley David Bergeron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

@import UIKit;


@protocol BDBSplitViewControllerDelegate;

/**
 *  Styles for the master view controller.
 *
 *  @since 1.1.0
 */
typedef NS_ENUM(NSInteger, BDBMasterViewDisplayStyle) {
    /**
     *  The default style. Doesn't do anything special compared to a regular UISplitViewController.
     *
     *  @since 1.1.0
     */
    BDBMasterViewDisplayStyleNormal,

    /**
     *  Maintains the current state of the master view upon device rotation. When the split view is 
     *  created, the master view is visible.
     *
     *  @since 1.1.0
     */
    BDBMasterViewDisplayStyleSticky,

    /**
     *  Shows the master view in a drawer that slides in and out. The detail view encompasses the
     *  full width of the screen.
     *
     *  @since 1.1.0
     */
    BDBMasterViewDisplayStyleDrawer
};


#pragma mark -
@interface BDBSplitViewController : UISplitViewController

/**
 *  BDBSplitViewController delegate.
 *
 *  @since 1.0.0
 */
@property (nonatomic, weak) id <BDBSplitViewControllerDelegate> svcDelegate;

/**
 *  Quickly access the master view controller.
 *
 *  @since 1.0.0
 */
@property (nonatomic, readonly) UIViewController *masterViewController;

/**
 *  Set and/or access the detail view controller.
 *
 *  @since 1.0.0
 */
@property (nonatomic) UIViewController *detailViewController;

/**
 *  A simple Show/Hide UIBarButtonItem that you can use to toggle the master view state.
 *  Automatically changes the label based on the current state of the master view.
 *
 *  @since 1.0.0
 */
@property (nonatomic, readonly) UIBarButtonItem *showHideMasterViewButtonItem;

/**
 *  A simple Close UIBarButtonItem that you can use to close the master view controller.
 *
 *  @since 1.0.0
 */
@property (nonatomic, readonly) UIBarButtonItem *closeMasterViewButtonItem;

/**
 *  Quickly check whether or not the master view is hidden.
 *
 *  @since 1.0.0
 */
@property (nonatomic, assign, readonly) BOOL masterViewIsHidden;

/**
 *  Set/get the master view display state.
 *
 *  @since 1.1.0
 */
@property (nonatomic) BDBMasterViewDisplayStyle masterViewDisplayStyle;

/**
 *  Whether or not the master view automatically hides when the detail view is tapped.
 *  When masterViewDisplayState is set to Drawer, this value defaults to YES. Otherwise,
 *  the default value is NO;
 *
 *  @since 1.1.0
 */
@property (nonatomic, assign) BOOL masterViewShouldDismissOnTap;

/**
 *  Set/get the duration of the master view show/hide animations. Default is 0.3 seconds.
 *
 *  @since 1.2.0
 */
@property (nonatomic) CGFloat masterViewAnimationDuration;

/**
 *  Whether or not the detail view should dim when the master view is shown. When
 *  masterViewDisplayStyle is set to Drawer, this value defaults to YES. Otherwise,
 *  the default value is NO.
 *
 *  @since 1.1.0
 */
@property (nonatomic, assign) BOOL detailViewShouldDim;

/**
 *  Set/get the opacity of the detail dimming view. Default is 0.4.
 *
 *  @since 1.1.0
 */
@property (nonatomic) CGFloat detailViewDimmingOpacity;

@property (nonatomic) UIStatusBarStyle preferredStatusBarStyle;

#pragma mark Initialization
/**
 *  Create and initialize a split view with the given master and detail view controllers.
 *
 *  @param mvc Master view controller.
 *  @param dvc Detail view controller.
 *
 *  @return New BDBSplitViewController instance.
 *
 *  @since 1.2.0
 */
+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc
                             detailViewController:(UIViewController *)dvc;

/**
 *  Create and initialize a split view with the given master and detail view controllers using the 
 *  specified style.
 *
 *  @param mvc   Master view controller.
 *  @param dvc   Detail view controller.
 *  @param style Master view display style.
 *
 *  @return New BDBSplitViewController instance.
 *
 *  @since 1.2.0
 */
+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc
                             detailViewController:(UIViewController *)dvc
                                            style:(BDBMasterViewDisplayStyle) style;

/**
 *  Initialize a new split view controller instance with the given master and detail view 
 *  controllers.
 *
 *  @param mvc Master view controller.
 *  @param dvc Detail view controller.
 *
 *  @return Initialized BDBSplitViewController instance.
 *
 *  @since 1.0.0
 */
- (instancetype)initWithMasterViewController:(UIViewController *)mvc
                        detailViewController:(UIViewController *)dvc;

/**
 *  Initialize a new split view controller instance with the given master and detail view 
 *  controllers using the spcified style.
 *
 *  @param mvc   Master view controller.
 *  @param dvc   Detail view controller.
 *  @param style Master view display style.
 *
 *  @return Initialized BDBSplitViewController instance.
 *
 *  @since 1.2.0
 */
- (instancetype)initWithMasterViewController:(UIViewController *)mvc
                        detailViewController:(UIViewController *)dvc
                                       style:(BDBMasterViewDisplayStyle)style;


#pragma mark Show / Hide Master View
/**
 *  Show the master view controller.
 *
 *  @param animated   Whether or not to animate showing.
 *  @param completion Callback to be performed once the master view is visible.
 *
 *  @since 1.0.0
 */
- (void)showMasterViewControllerAnimated:(BOOL)animated
                              completion:(void (^)(void))completion;

/**
 *  Hide the master view controller.
 *
 *  @param animated   Whether or not to animate hiding.
 *  @param completion Callback to be performed once the master view has been hidden.
 *
 *  @since 1.0.0
 */
- (void)hideMasterViewControllerAnimated:(BOOL)animated
                              completion:(void (^)(void))completion;


#pragma mark Customization
/**
 *  Set the master view display style.
 *
 *  @param style    New display style for the master view.
 *  @param animated Whether or not to animate the transition to the new display style.
 *
 *  @since 1.2.1
 */
- (void)setMasterViewDisplayStyle:(BDBMasterViewDisplayStyle)style
                         animated:(BOOL)animated;

@end


#pragma mark -
@protocol BDBSplitViewControllerDelegate <NSObject>

@optional

/**
 *  Delegate method called before the master view is shown.
 *
 *  @param svc The active split view controller instance calling the delegate method.
 *
 *  @since 1.2.0
 */
- (void)splitViewControllerWillShowMasterViewController:(BDBSplitViewController *)svc;

/**
 *  Delegate method called after the master view is shown.
 *
 *  @param svc The active split view controller instance calling the delegate method.
 *
 *  @since 1.2.2
 */
- (void)splitViewControllerDidShowMasterViewController:(BDBSplitViewController *)svc;

/**
 *  Delegate method called before teh master view is hidden.
 *
 *  @param svc The active split view controller instance calling the delegate method.
 *
 *  @since 1.2.0
 */
- (void)splitViewControllerWillHideMasterViewController:(BDBSplitViewController *)svc;

/**
 *  Delegate method called after the master view is hidden.
 *
 *  @param svc The active split view controller instance calling the delegate method.
 *
 *  @since 1.2.2
 */
- (void)splitViewControllerDidHideMasterViewController:(BDBSplitViewController *)svc;


@end


#pragma mark -
@interface UIViewController (BDBSplitViewController)

/**
 *  Quickly access the owning split view controller of the current view controller.
 *
 *  @since 1.0.0
 */
@property (nonatomic, readonly) BDBSplitViewController *splitViewController;

@end


#pragma mark -
@interface BDBDetailViewController : UIViewController <UISplitViewControllerDelegate>

/**
 *  UISplitViewDelegate method that is needed in order to properly maintain the master
 *  view state when the device is rotated. If you do not use the BDBDetailViewController
 *  subclass as the parent class of your detail view controller, the split view will not
 *  operate properly.
 *
 *  @param svc         The active split view controller calling the delegate method.
 *  @param vc          View controller to hide.
 *  @param orientation The orientation that the device is being rotated to.
 *
 *  @return Whether or not to hide the view controller in the new device orientation.
 *
 *  @since 1.0.0
 */
- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation;

@end
