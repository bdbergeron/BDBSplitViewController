//
//  BDBSplitViewController.m
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BDBSplitViewController.h"


typedef NS_ENUM(NSInteger, BDBMasterViewState)
{
    BDBMasterViewStateHidden,
    BDBMasterViewStateVisible
};


static void * const kBDBSplitViewKVOContext = (void *)&kBDBSplitViewKVOContext;


#pragma mark -
@interface BDBSplitViewController ()

@property (nonatomic, strong) UIView *detailDimmingView;
@property (nonatomic, strong) UITapGestureRecognizer *detailTapGesture;

@property (nonatomic, strong, readwrite) UIBarButtonItem *showHideMasterViewButtonItem;
@property (nonatomic, strong, readwrite) UIBarButtonItem *closeMasterViewButtonItem;

@property (nonatomic, readwrite) BDBMasterViewState masterViewState;

@property (nonatomic, assign, readwrite) BOOL masterViewIsHidden;

- (void)setupWithViewControllers:(NSArray *)viewControllers;

- (void)initialize;
- (void)configureMasterView;

- (void)toggleMasterView:(UIBarButtonItem *)sender;
- (void)closeMasterView:(UIBarButtonItem *)sender;

- (CGRect)masterViewFrameForState:(BDBMasterViewState)state;
- (CGRect)detailViewFrameForState:(BDBMasterViewState)state;

@end


#pragma mark -
@implementation BDBSplitViewController

#pragma mark Initialization
+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc
                             detailViewController:(UIViewController *)dvc
{
    return [[[self class] alloc] initWithMasterViewController:mvc
                                         detailViewController:dvc];
}

+ (instancetype)splitViewWithMasterViewController:(UIViewController *)mvc
                             detailViewController:(UIViewController *)dvc
                                            style:(BDBMasterViewDisplayStyle)style
{
    return [[[self class] alloc] initWithMasterViewController:mvc
                                         detailViewController:dvc
                                                        style:style];
}

- (id)initWithMasterViewController:(UIViewController *)mvc
              detailViewController:(UIViewController *)dvc
{
    NSParameterAssert(mvc);
    NSParameterAssert(dvc);

    self = [super init];
    if (self)
    {
        [self setupWithViewControllers:@[mvc, dvc]];
    }
    return self;
}

- (id)initWithMasterViewController:(UIViewController *)mvc
              detailViewController:(UIViewController *)dvc
                             style:(BDBMasterViewDisplayStyle)style
{
    self = [self initWithMasterViewController:mvc detailViewController:dvc];
    if (self)
    {
        [self setupWithViewControllers:@[mvc, dvc]];
        _masterViewDisplayStyle = style;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupWithViewControllers:super.viewControllers];
    }
    return self;
}

- (void)setupWithViewControllers:(NSArray *)viewControllers
{
    NSParameterAssert(viewControllers);
    NSAssert(viewControllers.count == 2, @"viewControllers array must conatin both a master view controller and a detail view controller.");

    NSMutableArray *mutableViewControllers = [NSMutableArray array];
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        if (![vc isKindOfClass:[UINavigationController class]])
            [mutableViewControllers addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
        else
            [mutableViewControllers addObject:vc];
    }];
    self.viewControllers = mutableViewControllers;

    _masterViewDisplayStyle = BDBMasterViewDisplayStyleNormal;

    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
        _masterViewState = BDBMasterViewStateHidden;
    else
        _masterViewState = BDBMasterViewStateVisible;
}

#pragma mark View Lifecycle
- (void)dealloc
{
    [self.detailViewController removeObserver:self forKeyPath:@"view.frame" context:kBDBSplitViewKVOContext];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0.0];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.masterViewController.view.frame = [self masterViewFrameForState:self.masterViewState];
    self.detailViewController.view.frame = [self detailViewFrameForState:self.masterViewState];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (self.masterViewDisplayStyle == BDBMasterViewDisplayStyleNormal)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            if (self.masterViewIsHidden)
                [self showMasterViewControllerAnimated:YES completion:nil];
        }
        else
            [self hideMasterViewControllerAnimated:YES completion:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (self.masterViewState == BDBMasterViewStateHidden)
        self.masterViewController.view.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == kBDBSplitViewKVOContext)
    {
        if ([object isEqual:self.detailViewController] && [keyPath isEqualToString:@"view.frame"])
        {
            UIView *view = self.detailViewController.view;
            CGRect currentFrame = [change[@"new"] CGRectValue];
            CGRect properFrame = [self detailViewFrameForState:self.masterViewState];
            if (!CGRectEqualToRect(currentFrame, properFrame))
                view.frame = [self detailViewFrameForState:self.masterViewState];
        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)initialize
{
    self.detailDimmingView = [[UIView alloc] initWithFrame:self.view.frame];
    self.detailDimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.detailDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:self.detailDimmingOpacity];
    self.detailDimmingView.alpha = 0.0;
    self.detailDimmingView.hidden = YES;
    [self.view insertSubview:self.detailDimmingView aboveSubview:self.detailViewController.view];

    self.detailTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailViewTapped:)];
    self.detailTapGesture.numberOfTapsRequired = 1;
    self.detailTapGesture.numberOfTouchesRequired = 1;
    [self.detailDimmingView addGestureRecognizer:self.detailTapGesture];

    self.masterViewAnimationDuration = 0.3;

    [self configureMasterView];
}

- (void)configureMasterView
{
    if (self.masterViewDisplayStyle == BDBMasterViewDisplayStyleDrawer)
    {
        self.masterViewController.view.clipsToBounds = NO;
        self.masterViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        self.masterViewController.view.layer.shadowOffset = (CGSize){0, 0};
        self.masterViewController.view.layer.shadowRadius = 10.0;
        self.masterViewController.view.layer.shadowOpacity = 0.8;
    }
    else
    {
        self.masterViewController.view.clipsToBounds = YES;
        self.masterViewController.view.layer.shadowColor = nil;
        self.masterViewController.view.layer.shadowRadius = 0.0;
        self.masterViewController.view.layer.shadowOpacity = 0.0;
    }
}

#pragma mark UIBarButtonItems
- (UIBarButtonItem *)showHideMasterViewButtonItem
{
    if (!_showHideMasterViewButtonItem)
        _showHideMasterViewButtonItem = [[UIBarButtonItem alloc] initWithTitle:(self.masterViewIsHidden) ? @"Show" : @"Hide"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(toggleMasterView:)];
    return _showHideMasterViewButtonItem;
}

- (UIBarButtonItem *)closeMasterViewButtonItem
{
    if (!_closeMasterViewButtonItem)
        _closeMasterViewButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(closeMasterView:)];
    return _closeMasterViewButtonItem;
}

- (void)toggleMasterView:(UIBarButtonItem *)sender
{
    if (self.masterViewIsHidden)
        [self showMasterViewControllerAnimated:YES completion:nil];
    else
        [self hideMasterViewControllerAnimated:YES completion:nil];
}

- (void)closeMasterView:(UIBarButtonItem *)sender
{
    if (!self.masterViewIsHidden)
        [self hideMasterViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewController Overrides
- (void)setViewControllers:(NSArray *)viewControllers
{
    NSParameterAssert(viewControllers);
    NSAssert(viewControllers.count == 2, @"viewControllers array must conatin both a master view controller and a detail view controller.");

    self.delegate = nil;
    [self.detailViewController removeObserver:self
                                   forKeyPath:@"view.frame"
                                      context:kBDBSplitViewKVOContext];

    [super setViewControllers:viewControllers];

    [self.detailViewController addObserver:self
                                forKeyPath:@"view.frame"
                                   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                   context:kBDBSplitViewKVOContext];

    UIViewController *dvc = [(UINavigationController *)viewControllers[1] topViewController];
    if ([dvc isKindOfClass:[BDBDetailViewController class]])
        self.delegate = (BDBDetailViewController *)dvc;

    [self configureMasterView];
}

#pragma mark Master / Detail Accessors
- (UIViewController *)masterViewController
{
    NSAssert(self.viewControllers.count > 0, @"self.viewControllers does not conatin a master view controller.");
    return self.viewControllers[0];
}

- (UIViewController *)detailViewController
{
    if (self.viewControllers.count < 2)
        return nil;
    else
        return self.viewControllers[1];
}

- (void)setDetailViewController:(UIViewController *)dvc
{
    NSParameterAssert(dvc);

    if ([dvc isKindOfClass:[UINavigationController class]])
        self.viewControllers = @[self.masterViewController, dvc];
    else
        self.viewControllers = @[self.masterViewController, [[UINavigationController alloc] initWithRootViewController:dvc]];
}

#pragma mark Master View
- (void)setMasterViewDisplayStyle:(BDBMasterViewDisplayStyle)style
{
    [self setMasterViewDisplayStyle:style animated:NO];
}

- (void)setMasterViewDisplayStyle:(BDBMasterViewDisplayStyle)style
                         animated:(BOOL)animated
{
    _masterViewDisplayStyle = style;

    switch (style)
    {
        case BDBMasterViewDisplayStyleSticky:
        {
            self.detailViewShouldDim = NO;
            self.masterViewShouldDismissOnTap = NO;
            break;
        }

        case BDBMasterViewDisplayStyleDrawer:
        {
            self.detailViewShouldDim = YES;
            self.masterViewShouldDismissOnTap = YES;
            self.masterViewState = BDBMasterViewStateHidden;
            break;
        }

        case BDBMasterViewDisplayStyleNormal:
        default:
        {
            self.detailViewShouldDim = NO;
            self.masterViewShouldDismissOnTap = NO;
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
                [self showMasterViewControllerAnimated:animated completion:nil];
            else
                [self hideMasterViewControllerAnimated:animated completion:nil];
            break;
        }
    }

    [self configureMasterView];
}

- (BOOL)masterViewIsHidden
{
    return (self.masterViewState == BDBMasterViewStateHidden);
}

- (CGRect)masterViewFrameForState:(BDBMasterViewState)state
{
    CGRect masterViewFrame = self.masterViewController.view.frame;

    switch (state)
    {
        case BDBMasterViewStateHidden:
        {
            masterViewFrame = (CGRect){{-masterViewFrame.size.width, 0}, masterViewFrame.size};
            break;
        }

        case BDBMasterViewStateVisible:
        default:
        {
            masterViewFrame = (CGRect){CGPointZero, masterViewFrame.size};
            break;
        }
    }

    return masterViewFrame;
}

#pragma mark Detail View
- (CGFloat)detailDimmingOpacity
{
    if (!_detailViewDimmingOpacity)
        _detailViewDimmingOpacity = 0.4;
    return _detailViewDimmingOpacity;
}

- (void)setDetailDimmingOpacity:(CGFloat)opacity
{
    NSAssert(opacity >= 0.0 && opacity <= 1.0, @"Opacity must be between 0 and 1.");

    _detailViewDimmingOpacity = opacity;
    self.detailDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:opacity];
}

- (void)detailViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self hideMasterViewControllerAnimated:YES completion:nil];
}

- (CGRect)detailViewFrameForState:(BDBMasterViewState)state
{
    if (self.masterViewDisplayStyle == BDBMasterViewDisplayStyleDrawer)
        return self.view.bounds;

    CGRect masterViewFrame = self.masterViewController.view.frame;
    CGRect detailViewFrame = self.detailViewController.view.frame;

    CGRect frame;
    switch (state)
    {
        case BDBMasterViewStateHidden:
        {
            frame = self.view.bounds;
            break;
        }

        case BDBMasterViewStateVisible:
        default:
        {
            frame = (CGRect){{masterViewFrame.size.width + 1, 0}, {self.view.bounds.size.width - masterViewFrame.size.width - 1, detailViewFrame.size.height}};
            break;
        }
    }

    return frame;
}

#pragma mark Show / Hide Master View
- (void)showMasterViewControllerAnimated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    if (!self.masterViewIsHidden)
        return;

    if (self.detailViewShouldDim)
    {
        self.detailDimmingView.frame = self.view.bounds;
        self.detailDimmingView.hidden = NO;
    }

    if (self.masterViewShouldDismissOnTap)
        self.detailTapGesture.enabled = YES;

    if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerWillShowMasterViewController:)])
        [self.svcDelegate splitViewControllerWillShowMasterViewController:self];

    [self.masterViewController viewWillAppear:animated];

    self.masterViewState = BDBMasterViewStateVisible;
    self.masterViewController.view.hidden = NO;

    if (animated)
    {
        [UIView animateWithDuration:self.masterViewAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailDimmingView.alpha = 1.0;
                             self.masterViewController.view.frame = [self masterViewFrameForState:BDBMasterViewStateVisible];
                             self.detailViewController.view.frame = [self detailViewFrameForState:BDBMasterViewStateVisible];
                         }
                         completion:^(BOOL finished) {
                             self.showHideMasterViewButtonItem.title = @"Hide";

                             [self.masterViewController viewDidAppear:animated];
                             [self.view setNeedsLayout];

                             if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerDidShowMasterViewController:)])
                                 [self.svcDelegate splitViewControllerDidShowMasterViewController:self];

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        self.showHideMasterViewButtonItem.title = @"Hide";

        [self.masterViewController viewDidAppear:animated];
        [self.view setNeedsLayout];

        if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerDidShowMasterViewController:)])
            [self.svcDelegate splitViewControllerDidShowMasterViewController:self];

        if (completion)
            completion();
    }
}

- (void)hideMasterViewControllerAnimated:(BOOL)animated
                              completion:(void (^)(void))completion
{
    if (self.masterViewIsHidden)
        return;

    if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerWillHideMasterViewController:)])
        [self.svcDelegate splitViewControllerWillHideMasterViewController:self];

    [self.masterViewController viewWillDisappear:animated];

    self.masterViewState = BDBMasterViewStateHidden;

    if (animated)
    {
        [UIView animateWithDuration:self.masterViewAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailDimmingView.alpha = 0.0;
                             self.masterViewController.view.frame = [self masterViewFrameForState:BDBMasterViewStateHidden];
                             self.detailViewController.view.frame = [self detailViewFrameForState:BDBMasterViewStateHidden];
                         }
                         completion:^(BOOL finished) {
                             self.masterViewController.view.hidden = YES;

                             self.detailDimmingView.hidden = YES;
                             self.detailTapGesture.enabled = NO;

                             self.showHideMasterViewButtonItem.title = @"Show";

                             [self.masterViewController viewDidDisappear:animated];
                             [self.view setNeedsLayout];

                             if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerDidHideMasterViewController:)])
                                 [self.svcDelegate splitViewControllerDidHideMasterViewController:self];

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        self.masterViewController.view.hidden = YES;

        self.detailDimmingView.hidden = YES;
        self.detailTapGesture.enabled = NO;

        self.showHideMasterViewButtonItem.title = @"Show";

        [self.masterViewController viewDidDisappear:animated];
        [self.view setNeedsLayout];

        if ([self.svcDelegate respondsToSelector:@selector(splitViewControllerDidHideMasterViewController:)])
            [self.svcDelegate splitViewControllerDidHideMasterViewController:self];

        if (completion)
            completion();
    }
}

@end


#pragma mark -
@implementation UIViewController (BDBSplitViewController)

- (BDBSplitViewController *)splitViewController
{
    UIViewController *parentViewController = self;
    while (parentViewController)
    {
        if ([parentViewController isKindOfClass:[BDBSplitViewController class]])
            return (BDBSplitViewController *)parentViewController;
        parentViewController = parentViewController.parentViewController;
    }
    return nil;
}

@end


#pragma mark -
@implementation BDBDetailViewController

- (BOOL)splitViewController:(BDBSplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    switch (svc.masterViewDisplayStyle)
    {
        case BDBMasterViewDisplayStyleSticky:
            return NO;

        case BDBMasterViewDisplayStyleDrawer:
            return svc.masterViewIsHidden;

        case BDBMasterViewDisplayStyleNormal:
        default:
        {
            if (svc.masterViewIsHidden)
                return UIInterfaceOrientationIsPortrait(orientation);
            else
                return NO;
        }
    }
}

@end
