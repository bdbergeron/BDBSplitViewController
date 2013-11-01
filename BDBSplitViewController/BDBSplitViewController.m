//
//  BDBSplitViewController.m
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "BDBSplitViewController.h"

#import <QuartzCore/QuartzCore.h>


typedef enum {
    BDBMasterViewStateHidden,
    BDBMasterViewStateVisible
} BDBMasterViewState;


#pragma mark -
@interface BDBSplitViewController ()

@property (nonatomic, strong) UIView *detailDimmingView;
@property (nonatomic, strong) UITapGestureRecognizer *detailTapGesture;

@property (nonatomic, strong, readwrite) UIBarButtonItem *showHideMasterViewButtonItem;
@property (nonatomic, strong, readwrite) UIBarButtonItem *closeMasterViewButtonItem;

@property (nonatomic, readwrite) BDBMasterViewState masterViewState;

@property (nonatomic, assign, readwrite) BOOL masterViewIsHidden;

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
- (id)initWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc
{
    NSParameterAssert(mvc);
    NSParameterAssert(dvc);

    self = [super init];
    if (self)
    {
        NSArray *viewControllers = @[mvc, dvc];
        if ([mvc isKindOfClass:[UINavigationController class]] && [dvc isKindOfClass:[UINavigationController class]])
            self.viewControllers = viewControllers;
        else
        {
            NSMutableArray *mutableViewControllers = [NSMutableArray array];
            [viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
                if (![vc isKindOfClass:[UINavigationController class]])
                    [mutableViewControllers addObject:[[UINavigationController alloc] initWithRootViewController:vc]];
                else
                    [mutableViewControllers addObject:vc];
            }];
            self.viewControllers = mutableViewControllers;
        }

        if ([dvc isKindOfClass:[BDBDetailViewController class]])
            self.delegate = (BDBDetailViewController *)dvc;

        [self.detailViewController addObserver:self forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
    [self configureMasterView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [self configureMasterView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.masterViewController.view.frame = [self masterViewFrameForState:self.masterViewState];
    self.detailViewController.view.frame = [self detailViewFrameForState:self.masterViewState];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self.detailViewController] && [keyPath isEqualToString:@"view.frame"])
    {
        UIView *view = self.detailViewController.view;
        CGRect currentFrame = [change[@"new"] CGRectValue];
        CGRect properFrame = [self detailViewFrameForState:self.masterViewState];
        if (!CGRectEqualToRect(currentFrame, properFrame))
            view.frame = [self detailViewFrameForState:self.masterViewState];
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

    self.masterViewDisplayStyle = BDBMasterViewDisplayStyleNormal;
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
    NSAssert(viewControllers && viewControllers.count == 2, @"viewControllers must contain a master and a detail view controller.");

    [super setViewControllers:viewControllers];
    [self configureMasterView];
}

#pragma mark Master / Detail Accessors
- (UIViewController *)masterViewController
{
    if (self.viewControllers.count < 1)
        return nil;
    else
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
    _masterViewDisplayStyle = style;

    switch (style)
    {
        case BDBMasterViewDisplayStyleSticky:
        {
            self.detailViewShouldDim = NO;
            self.masterViewShouldDismissOnTap = NO;
            [self showMasterViewControllerAnimated:NO completion:nil];
            break;
        }

        case BDBMasterViewDisplayStyleDrawer:
        {
            self.detailViewShouldDim = YES;
            self.masterViewShouldDismissOnTap = YES;
            [self hideMasterViewControllerAnimated:NO completion:nil];
            break;
        }

        case BDBMasterViewDisplayStyleNormal:
        default:
        {
            self.detailViewShouldDim = NO;
            self.masterViewShouldDismissOnTap = NO;
            if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
                [self showMasterViewControllerAnimated:NO completion:nil];
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
            return (CGRect){{-masterViewFrame.size.width, 0}, masterViewFrame.size};
            break;
        }

        case BDBMasterViewStateVisible:
        default:
        {
            return (CGRect){CGPointZero, masterViewFrame.size};
            break;
        }
    }
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
- (void)showMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    self.masterViewState = BDBMasterViewStateVisible;
    self.masterViewController.view.alpha = 1.0;

    if (self.detailViewShouldDim)
    {
        self.detailDimmingView.frame = self.view.bounds;
        self.detailDimmingView.hidden = NO;
    }

    if (self.masterViewShouldDismissOnTap)
        self.detailTapGesture.enabled = YES;

    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailDimmingView.alpha = 1.0;
                             self.masterViewController.view.frame = [self masterViewFrameForState:BDBMasterViewStateVisible];
                             self.detailViewController.view.frame = [self detailViewFrameForState:BDBMasterViewStateVisible];
                         }
                         completion:^(BOOL finished) {
                             self.showHideMasterViewButtonItem.title = @"Hide";

                             [self.view setNeedsLayout];

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        self.showHideMasterViewButtonItem.title = @"Hide";

        [self.view setNeedsLayout];

        if (completion)
            completion();
    }
}

- (void)hideMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    self.masterViewState = BDBMasterViewStateHidden;

    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.detailDimmingView.alpha = 0.0;
                             self.masterViewController.view.frame = [self masterViewFrameForState:BDBMasterViewStateHidden];
                             self.detailViewController.view.frame = [self detailViewFrameForState:BDBMasterViewStateHidden];
                         }
                         completion:^(BOOL finished) {
                             self.masterViewController.view.alpha = 0.0;
                             self.detailDimmingView.hidden = YES;
                             self.detailTapGesture.enabled = NO;

                             self.showHideMasterViewButtonItem.title = @"Show";

                             [self.view setNeedsLayout];

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        self.masterViewController.view.alpha = 0.0;
        self.detailDimmingView.hidden = YES;
        self.detailTapGesture.enabled = NO;

        self.showHideMasterViewButtonItem.title = @"Show";

        [self.view setNeedsLayout];

        if (completion)
            completion();
    }
}

@end


#pragma mark -
@implementation BDBDetailViewController

- (BOOL)splitViewController:(BDBSplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
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
