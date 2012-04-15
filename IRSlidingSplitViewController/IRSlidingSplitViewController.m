//
//  IRSlidingSplitViewController.m
//  IRSlidingSplitViewControllerTest
//
//  Created by Evadne Wu on 4/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRSlidingSplitViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface IRSlidingSplitViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, readwrite, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end


@implementation IRSlidingSplitViewController
@synthesize masterViewController, detailViewController;
@synthesize panGestureRecognizer, tapGestureRecognizer;

- (void) setMasterViewController:(UIViewController *)newMasterViewController {

	if (masterViewController == newMasterViewController)
		return;
	
	[masterViewController removeFromParentViewController];
	[masterViewController.view removeFromSuperview];
	
	masterViewController = newMasterViewController;
	
	[self addChildViewController:masterViewController];
	[self.view addSubview:masterViewController.view];
	
	[self.view setNeedsLayout];

}

- (void) setDetailViewController:(UIViewController *)newDetailViewController {

	if (detailViewController == newDetailViewController)
		return;
	
	[detailViewController removeFromParentViewController];
	[detailViewController.view removeFromSuperview];
	
	detailViewController = newDetailViewController;
	
	[self addChildViewController:detailViewController];
	[self.view addSubview:detailViewController.view];

	[self.view setNeedsLayout];
	
}

- (CGRect) rectForMasterView {

	return self.view.bounds;

}

- (CGRect) rectForDetailView {

	if (self.showingMasterViewController)
		return CGRectOffset(self.view.bounds, 280, 0);
	
	return self.view.bounds;

}

- (UIPanGestureRecognizer *) panGestureRecognizer {

	if (panGestureRecognizer)
		return panGestureRecognizer;
	
	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.delaysTouchesBegan = YES;
	
	return panGestureRecognizer;

}

- (UITapGestureRecognizer *) tapGestureRecognizer {

	if (tapGestureRecognizer)
		return tapGestureRecognizer;
	
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.cancelsTouchesInView = NO;
	tapGestureRecognizer.delaysTouchesBegan = NO;
	tapGestureRecognizer.delaysTouchesEnded = NO;
	
	return tapGestureRecognizer;

}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

	UIView *detailView = self.detailViewController.view;
	CGRect detailVisibleRect = CGRectIntersection(self.view.bounds, [self.view convertRect:detailView.bounds fromView:detailView]);
	
	BOOL touchInDetailVisibleRect = !CGRectEqualToRect(detailVisibleRect, CGRectNull) &&
		CGRectContainsPoint(detailVisibleRect, [gestureRecognizer locationInView:self.view]);
	
	if (gestureRecognizer == panGestureRecognizer)
		return !self.showingMasterViewController && touchInDetailVisibleRect;
	
	if (gestureRecognizer == tapGestureRecognizer)
		return self.showingMasterViewController && touchInDetailVisibleRect;
	
	return NO;

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

	if (gestureRecognizer == tapGestureRecognizer)
		return YES;
	
	if (gestureRecognizer == panGestureRecognizer)
		return NO;
	
	return YES;

}

- (void) handlePan:(UIPanGestureRecognizer *)panGR {

	#pragma unused(panGR)

	switch (panGR.state) {
		
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateBegan: {
			break;
		}
		
		case UIGestureRecognizerStateChanged: {
			
			CGRect oldDetailRect = [self rectForDetailView];
			CGPoint translation = [panGR translationInView:self.view];
			self.detailViewController.view.frame = CGRectOffset(oldDetailRect, translation.x, 0);
			
			break;
			
		}
		
		case UIGestureRecognizerStateEnded: {

			CGPoint translation = [panGR translationInView:self.view];
			
			if (!self.showingMasterViewController && translation.x > 0) {
				
				self.showingMasterViewController = YES;
				
			} else if (self.showingMasterViewController && translation.x < 0) {
				
				self.showingMasterViewController = NO;
				
			}
			
			//	Pass through
			
		}
		
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed: {

			CGRect detailRect = self.detailViewController.view.frame;
			CGRect desiredDetailRect = [self rectForDetailView];
			
			if (!CGRectEqualToRect(detailRect, desiredDetailRect)) {

				[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
				
					self.detailViewController.view.frame = [self rectForDetailView];
					[self layoutViews];

				} completion:nil];
			
			}

			break;

		}
		
	}

}

- (void) handleTap:(UITapGestureRecognizer *)tapGR {

	#pragma unused(tapGR)
	
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	
	[UIView animateWithDuration:0.25 delay:0 options:options animations:^{
		
		self.showingMasterViewController = NO;
		
		[self.view layoutSubviews];
		[self layoutViews];

	} completion:nil];
	
}

- (void) viewDidLoad {

	[super viewDidLoad];
	
	[self.view addGestureRecognizer:self.panGestureRecognizer];
	[self.view addGestureRecognizer:self.tapGestureRecognizer];

}

- (void) viewDidUnload {
	
	[super viewDidUnload];
	
	self.panGestureRecognizer = nil;
	self.tapGestureRecognizer = nil;

}

- (void) viewDidLayoutSubviews {

	[super viewDidLayoutSubviews];
	[self layoutViews];

}

- (void) layoutViews {

	UIView *masterView = self.masterViewController.view;
	UIView *detailView = self.detailViewController.view;
	
	masterView.frame = [self rectForMasterView];
	detailView.frame = [self rectForDetailView];
	
	[detailView.superview bringSubviewToFront:detailView];
	detailView.userInteractionEnabled = !self.showingMasterViewController;

}

@end
