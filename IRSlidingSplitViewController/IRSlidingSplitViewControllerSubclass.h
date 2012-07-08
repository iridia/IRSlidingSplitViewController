//
//  IRSlidingSplitViewControllerSubclass.h
//  IRSlidingSplitViewController
//
//  Created by Evadne Wu on 7/8/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRSlidingSplitViewController.h"

@interface IRSlidingSplitViewController () <UIGestureRecognizerDelegate>

- (CGRect) rectForMasterView;	//	always self.view.bounds
- (CGRect) rectForDetailView;	//	self.view.bounds + { 200.0f, 0.0f } offset if showingMasterViewController

- (CGPoint) detailViewTranslationForGestureTranslation:(CGPoint)translation;	//	{ translation.x, 0 }
- (BOOL) shouldShowMasterViewControllerWithGestureTranslation:(CGPoint)translation velocity:(CGPoint)velocity;	//	looks at velocity.x and showingMasterViewController

- (void) configureMasterView:(UIView *)view;	//	called when view is placed
- (void) configureDetailView:(UIView *)view;	//	called when view is placed
- (void) layoutViews;	//	called internally, override for more layout

@property (nonatomic, readonly, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readonly, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (void) handlePan:(UIPanGestureRecognizer *)panGR;
- (void) handleTap:(UITapGestureRecognizer *)tapGR;

@end
