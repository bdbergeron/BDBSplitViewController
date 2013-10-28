//
//  BDBSplitViewController.m
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "BDBSplitViewController.h"

#import <QuartzCore/QuartzCore.h>


#pragma mark -
@interface BDBSplitViewController ()

@property (nonatomic, strong) UIView *detailDimmingView;
@property (nonatomic, strong) UITapGestureRecognizer *detailTapGesture;

@property (nonatomic, strong, readwrite) UIBarButtonItem *showHideMasterViewButtonItem;
@property (nonatomic, strong, readwrite) UIBarButtonItem *closeMasterViewButtonItem;

@property (nonatomic, assign, readwrite) BOOL masterViewIsHidden;

- (void)initialize;
- (void)configureMasterView;

- (void)toggleMasterView:(UIBarButtonItem *)sender;
- (void)closeMasterView:(UIBarButtonItem *)sender;

@end


#pragma mark -
@implementation BDBSplitViewController

#pragma mark Initialization
- (id)initWithMasterViewController:(UIViewController *)mvc detailViewController:(UIViewController *)dvc
{
    NSParameterAssert(mvc);
    NSParameterAssert(dvc);

    self = [super init];
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

        [self initialize];
        [self configureMasterView];
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
    self.view.backgroundColor = [UIColor blackColor];
    [self hideMasterViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.detailViewController.view.frame = self.view.bounds;
}

- (void)initialize
{
    self.detailDimmingView = [[UIView alloc] initWithFrame:self.view.frame];
    self.detailDimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.detailDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.detailDimmingView.alpha = 0.0;
    self.detailDimmingView.hidden = YES;
    [self.view insertSubview:self.detailDimmingView aboveSubview:self.detailViewController.view];

    self.detailTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailViewTapped:)];
    self.detailTapGesture.numberOfTapsRequired = 1;
    self.detailTapGesture.numberOfTouchesRequired = 1;
    [self.detailDimmingView addGestureRecognizer:self.detailTapGesture];

    self.shouldDimDetailView = YES;
    self.shouldDismissMasterViewOnTap = YES;
}

- (void)configureMasterView
{
    self.masterViewController.view.clipsToBounds = NO;
    self.masterViewController.view.layer.masksToBounds = NO;
    self.masterViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.masterViewController.view.layer.shadowOffset = (CGSize){0, 0};
    self.masterViewController.view.layer.shadowRadius = 10.0;
    self.masterViewController.view.layer.shadowOpacity = 0.8;
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

#pragma mark Master / Detail Properties
- (BOOL)masterViewIsHidden
{
    return (self.masterViewController.view.alpha == 0.0);
}

- (void)setMasterViewIsHidden:(BOOL)hidden
{
    self.masterViewController.view.alpha = (hidden) ? 0.0 : 1.0;
}

- (CGFloat)detailDimmingViewOpacity
{
    return CGColorGetAlpha(self.detailDimmingView.backgroundColor.CGColor);
}

- (void)setDetailDimmingViewOpacity:(CGFloat)opacity;
{
    NSAssert(opacity >= 0.0 && opacity <= 1.0, @"Opacity must be between 0 and 1.");
    self.detailDimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:opacity];
}

#pragma mark Detail View Tap Gesture
- (void)detailViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self hideMasterViewControllerAnimated:YES completion:nil];
}

#pragma mark Show / Hide Master View
- (void)showMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    self.masterViewIsHidden = NO;

    if (self.shouldDimDetailView)
    {
        self.detailDimmingView.frame = self.view.bounds;
        self.detailDimmingView.hidden = NO;
    }

    if (self.shouldDismissMasterViewOnTap)
        self.detailTapGesture.enabled = YES;

    self.showHideMasterViewButtonItem.title = @"Hide";

    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.masterViewController.view.frame = (CGRect){self.view.bounds.origin, self.masterViewController.view.bounds.size};
                             self.detailDimmingView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [self.view setNeedsLayout];
                             [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        [self.view setNeedsLayout];
        [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

        if (completion)
            completion();
    }
}

- (void)hideMasterViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
                             self.masterViewController.view.frame = (CGRect){{-CGRectGetWidth(self.masterViewController.view.bounds), CGRectGetMinY(self.masterViewController.view.bounds)}, self.masterViewController.view.bounds.size};
                             self.detailDimmingView.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.masterViewIsHidden = YES;

                             self.detailDimmingView.hidden = YES;
                             self.detailTapGesture.enabled = NO;

                             [self.view setNeedsLayout];
                             [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

                             self.showHideMasterViewButtonItem.title = @"Show";

                             if (completion)
                                 completion();
                         }];
    }
    else
    {
        self.masterViewIsHidden = YES;

        self.detailDimmingView.hidden = YES;
        self.detailTapGesture.enabled = NO;

        [self.view setNeedsLayout];
        [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];

        self.showHideMasterViewButtonItem.title = @"Show";

        if (completion)
            completion();
    }
}

@end


#pragma mark -
@implementation BDBDetailViewController

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return self.splitViewController.masterViewIsHidden;
}

@end
