//
//  DetailViewController.m
//
//  Copyright (c) 2014 Bradley David Bergeron
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

#import "DetailViewController.h"


#pragma mark -
@interface DetailViewController ()

- (void)configureView;

@end


#pragma mark -
@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.bdb_splitViewController.masterViewDisplayStyle = BDBSplitViewControllerMasterDisplayStyleSticky;
    [self.bdb_splitViewController showMasterViewControllerAnimated:NO completion:nil];

    self.navigationItem.leftBarButtonItem = self.bdb_splitViewController.showHideMasterViewButtonItem;

    [self configureView];
}

- (void)setDetailItem:(NSDate *)detailItem
{
    if ([self.detailItem isEqualToDate:detailItem]) {
        return;
    }

    _detailItem = detailItem;

    [self configureView];
}

- (void)configureView
{
    if (!self.detailItem) {
        return;
    }

    self.detailDescriptionLabel.text = [self.detailItem description];
}

@end
