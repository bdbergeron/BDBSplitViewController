//
//  BDBSplitViewController.m
//
//  Created by Bradley Bergeron on 10/25/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "BDBSplitViewController.h"


#pragma mark -
@interface BDBSplitViewController ()

@property (nonatomic, assign, readwrite) BOOL masterIsHidden;

@end


#pragma mark -
@implementation BDBSplitViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.masterIsHidden = NO;
    }
    return self;
}

#pragma mark Master / Detail Accessors
- (UIViewController *)masterViewController
{
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
    self.viewControllers = @[self.masterViewController, dvc];
}

#pragma mark Show/Hide Master View Button
- (UIBarButtonItem *)showHideMasterButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"Hide" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMaster:)];
}

- (void)toggleMaster:(UIBarButtonItem *)sender
{
    if (self.masterIsHidden)
    {
        [self showMasterViewControllerAnimated:YES];
        sender.title = @"Hide";
    }
    else
    {
        [self hideMasterViewControllerAnimated:YES];
        sender.title = @"Show";
    }
}

#pragma mark Show / Hide Master View
- (void)showMasterViewControllerAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
//                             self.masterViewController.view.frame = (CGRect){CGPointZero, self.masterViewController.view.frame.size};
                             self.detailViewController.view.frame = (CGRect){{self.masterViewController.view.frame.size.width, 0}, self.detailViewController.view.frame.size};
                         }
                         completion:^(BOOL finished) {
                             self.masterIsHidden = NO;
//                             [self.view setNeedsLayout];
//                             [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
                         }];
    }
    else
    {
        self.masterIsHidden = NO;
        [self.view setNeedsLayout];
        [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
    }
}

- (void)hideMasterViewControllerAnimated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.detailViewController.view.frame = (CGRect){{100, CGRectGetMidY(self.detailViewController.view.frame)}, self.detailViewController.view.frame.size};
//                             self.masterViewController.view.frame = (CGRect){{-CGRectGetWidth(self.masterViewController.view.frame), 0}, self.masterViewController.view.frame.size};
                         }
                         completion:^(BOOL finished) {
                             self.masterIsHidden = YES;
//                             [self.view setNeedsLayout];
//                             [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
                         }];
    }
    else
    {
        self.masterIsHidden = YES;
        [self.view setNeedsLayout];
        [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:0];
    }
}

@end
