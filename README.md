# BDBSplitViewController

BDBSplitViewController is a nice drop-in replacement for UISplitViewController with a few fancy features.

![Drawer Demo](https://dl.dropboxusercontent.com/u/6225/GitHub/BDBSplitViewController/Drawer.gif)

## Usage

BDBSplitViewController contains just a few simple properties and methods that allow you to get your app running and looking good in no time. Take a look at the included demo app for a quick run-down on how to implement it in your app!

### Instantiation

You can instantiate a new BDBSplitViewController instance programmatically, using XIBs, or using Storyboars, depending on your preferred flavor of UI development. If you are going the programmatic route, be sure to add `#include "BDBSplitViewController.h"` to the top of the header or implementation file for your master and detail view controllers. You must do this in order for Xcode to register the BDBSplitViewController methods and properties, otherwise it will think you're trying to access methods and properties of the standard UISplitViewController.

```objc
+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc;
+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc style:(BDBMasterViewDisplayStyle) style;

- (id)initWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc;
- (id)initWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc style:(BDBMasterViewDisplayStyle)style;
```

### Master / Detail Views

In order to simplify the process of implementation, I created a UIViewController subclass called BDBDetailViewController. All it does is implement the `splitViewController:shouldHideViewController:inOrientation:` delegate method in order to properly handle device rotation and maintain the visible state of the master view. For your detail views, you can either subclass BDBDetailViewController or re-implement the delegate method. Consdiering it's already written for you, you're gonna use it, right?

To ease communication between master and detail views, you can use the `masterViewController` and `detailViewController` properties. And yes, you can even change the detail view if you need to!

```objc
@property (nonatomic, strong, readonly) UIViewController *masterViewController;
@property (nonatomic, strong)           UIViewController *detailViewController;
```

Showing and hiding the master view is accomplished with a simple pair of methods.

```objc
- (void)showMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
```

Finally, if you ever need to determine whether or not the master view is visible, there's the `masterViewIsHidden` property.

```objc
@property (nonatomic, assign, readonly) BOOL masterViewIsHidden;
```

## Display Styles

To change the style in which BDBSplitViewController displays the master and detail views, you can change the `masterViewDisplayStyle` property.

```objc
typedef enum {
    BDBMasterViewDisplayStyleNormal,
    BDBMasterViewDisplayStyleSticky,
    BDBMasterViewDisplayStyleDrawer
} BDBMasterViewDisplayStyle;
```

### Normal

The Normal style mimics the behavior of the standard UISplitViewController wiht added support for showing and hiding the master view on command. Device rotation will reset the master view display state.

### Sticky

Sticky allows for the master view to be pinned open or closed without being affected by device rotation.

### Drawer

Drawer was the original style I created for BDBSplitViewController. The detail view occupies the entire screen, and the master view slides in on top of the detail view. The detail view is dimmed while the master view is visible.

## Customization

```objc
@property (nonatomic, assign) BOOL masterViewShouldDismissOnTap;
```

To quickly dismiss the master view, a user can simply tap on the dimmed detail view. Default is NO for Normal and Sticky styles, YES for Drawer.

```objc
@property (nonatomic, assign) BOOL detailViewShouldDim;
```

When the master view controller is shown, the detail view gets dimmed. Default is NO for Normal and Sticky style, YES for Drawer.

```objc
@property (nonatomic) CGFloat detailViewDimmingOpacity;
```

You can change the default dimming opacity if you want. The default is 0.4. Has no effect unless `detailViewShouldDim` is set to YES.

```objc
@property (nonatomic) CGFloat masterViewAnimationDuration;
```

Customize the duration of the master view show/hide animation. Default is 0.3 seconds.

## Credits

BDBSplitViewController is brought to you by [Bradley David Bergeron](http://www.bradbergeron.com). Cheers!
