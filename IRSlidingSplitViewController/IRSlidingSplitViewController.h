//
//  IRSlidingSplitViewController.h
//  IRSlidingSplitViewControllerTest
//
//  Created by Evadne Wu on 4/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRSlidingSplitViewController : UIViewController

@property (nonatomic, readwrite, assign) BOOL showingMasterViewController;
@property (nonatomic, readwrite, strong) IBOutlet UIViewController *masterViewController;
@property (nonatomic, readwrite, strong) IBOutlet UIViewController *detailViewController;

- (void) setShowingMasterViewController:(BOOL)showingMasterViewController animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;

- (void) setMasterViewController:(UIViewController *)toMasterVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;
- (void) setDetailViewController:(UIViewController *)toDetailVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback;

- (CGRect) rectForMasterView;
- (CGRect) rectForDetailView;

@property (nonatomic, readonly, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end
