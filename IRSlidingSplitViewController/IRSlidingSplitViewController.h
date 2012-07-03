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

- (CGRect) rectForMasterView;	//	always self.view.bounds
- (CGRect) rectForDetailView;	//	self.view.bounds + { 200.0f, 0.0f } offset if showingMasterViewController

- (CGPoint) detailViewTranslationForGestureTranslation:(CGPoint)translation;	//	{ translation.x, 0 }
- (BOOL) shouldShowMasterViewControllerWithGestureTranslation:(CGPoint)translation;	//	looks at translation.x and showingMasterViewController

- (void) configureMasterView:(UIView *)view;	//	called when view is placed
- (void) configureDetailView:(UIView *)view;	//	called when view is placed

@property (nonatomic, readonly, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end
