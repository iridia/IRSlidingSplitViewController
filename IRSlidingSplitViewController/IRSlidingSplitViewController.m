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
@synthesize showingMasterViewController;
@synthesize masterViewController, detailViewController;
@synthesize panGestureRecognizer, tapGestureRecognizer;

- (void) setShowingMasterViewController:(BOOL)flag {

	[self setShowingMasterViewController:flag animated:NO completion:nil];

}

- (void) setShowingMasterViewController:(BOOL)flag animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback {

	if (self.showingMasterViewController == flag) {
	
		if (callback)
			callback(NO);
	
		return;
		
	}
	
	showingMasterViewController = flag;
	
	NSTimeInterval duration = animate ? 0.3 : 0;
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{

		[self layoutViews];

	} completion:^(BOOL finished) {
		
		if (callback)
			callback(finished);
		
	}];

}

- (void) setMasterViewController:(UIViewController *)newMasterViewController {

	[self setMasterViewController:newMasterViewController animated:NO completion:nil];

}

- (void) setDetailViewController:(UIViewController *)newDetailViewController {

	[self setDetailViewController:newDetailViewController animated:NO completion:nil];

}

- (void) setMasterViewController:(UIViewController *)toMasterVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback {

	if (masterViewController == toMasterVC) {
		
		if (callback)
			callback(NO);
		
		return;
		
	}
	
	[masterViewController willMoveToParentViewController:nil];
	[masterViewController removeFromParentViewController];
	[masterViewController.view removeFromSuperview];
	
	masterViewController = toMasterVC;
	
	[self addChildViewController:masterViewController];
	[self configureMasterView:masterViewController.view];
	[self.view addSubview:masterViewController.view];
	[masterViewController didMoveToParentViewController:self];
	
	[self layoutViews];
	
	if (callback)
		callback(YES);

}

- (void) setDetailViewController:(UIViewController *)toDetailVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback {

	if (detailViewController == toDetailVC) {
		
		if (callback)
			callback(NO);
		
		return;
		
	}
	
	[detailViewController willMoveToParentViewController:nil];
	[detailViewController removeFromParentViewController];
	[detailViewController.view removeFromSuperview];
	
	detailViewController = toDetailVC;
	
	[self addChildViewController:detailViewController];
	[self configureDetailView:detailViewController.view];
	[self.view addSubview:detailViewController.view];
	[detailViewController didMoveToParentViewController:self];

	[self layoutViews];
	
	if (callback)
		callback(YES);
	
}

- (CGRect) rectForMasterView {

	return self.view.bounds;

}

- (CGRect) rectForDetailView {

	if (self.showingMasterViewController)
		return CGRectOffset(self.view.bounds, 200.0f, 0.0f);
	
	return self.view.bounds;

}

- (CGPoint) detailViewTranslationForGestureTranslation:(CGPoint)translation {

	return (CGPoint){ translation.x, 0 };
	
}

- (BOOL) shouldShowMasterViewControllerWithGestureTranslation:(CGPoint)translation {

	if (!self.showingMasterViewController && translation.x > 0)
		return YES;
		
	if (self.showingMasterViewController && translation.x < 0)
		return NO;
	
	return self.showingMasterViewController;

}

- (UIPanGestureRecognizer *) panGestureRecognizer {

	if (panGestureRecognizer)
		return panGestureRecognizer;
	
	panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	panGestureRecognizer.delegate = self;
	panGestureRecognizer.cancelsTouchesInView = YES;

	return panGestureRecognizer;

}

- (UITapGestureRecognizer *) tapGestureRecognizer {

	if (tapGestureRecognizer)
		return tapGestureRecognizer;
	
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tapGestureRecognizer.delegate = self;
	tapGestureRecognizer.cancelsTouchesInView = YES;
	
	return tapGestureRecognizer;

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

	UIView *detailView = self.detailViewController.view;
	CGRect detailVisibleRect = CGRectIntersection(self.view.bounds, [self.view convertRect:detailView.bounds fromView:detailView]);
	
	BOOL touchInDetailVisibleRect = !CGRectEqualToRect(detailVisibleRect, CGRectNull) &&
		CGRectContainsPoint(detailVisibleRect, [touch locationInView:self.view]);
	
	if (gestureRecognizer == panGestureRecognizer) {
	
		if (touchInDetailVisibleRect)
			return ![[touch view] isKindOfClass:[UISlider class]];
			
		return NO;
		
	}
	
	if (gestureRecognizer == tapGestureRecognizer)
		return self.showingMasterViewController && touchInDetailVisibleRect;
	
	return YES;

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

	if (gestureRecognizer == tapGestureRecognizer) {
		
		if ([otherGestureRecognizer.view isDescendantOfView:self.detailViewController.view])
			return NO;
		
		if (self.showingMasterViewController)
		if (gestureRecognizer.state == UIGestureRecognizerStateRecognized)
			return NO;
		
		return YES;
		
	}
	
	if (gestureRecognizer == panGestureRecognizer) {
	
		if ([otherGestureRecognizer.view isDescendantOfView:self.masterViewController.view])
			return NO;
		
		return NO;
		
	}
	
	return YES;

}

- (void) handlePan:(UIPanGestureRecognizer *)panGR {

	#pragma unused(panGR)

	switch (panGR.state) {
		
		case UIGestureRecognizerStatePossible: {
			break;
		}
		
		case UIGestureRecognizerStateBegan: {
			
			__block UIView * (^firstResponderInView)(UIView *) = [^ (UIView *view) {

				if ([view isFirstResponder])
					return view;
				
				for (UIView *aSubview in view.subviews) {
					UIView *foundFirstResponder = firstResponderInView(aSubview);
					if (foundFirstResponder)
						return foundFirstResponder;
				}
				
				return (UIView *)nil;

			} copy];
			
			[firstResponderInView(self.masterViewController.view) resignFirstResponder];
			[firstResponderInView(self.detailViewController.view) resignFirstResponder];
			
			firstResponderInView = nil;
			
			break;
			
		}
		
		case UIGestureRecognizerStateChanged: {
			
			CGRect oldDetailRect = [self rectForDetailView];
			CGPoint translation = [panGR translationInView:self.view];
			CGPoint transformedTranslation = [self detailViewTranslationForGestureTranslation:translation];
			
			self.detailViewController.view.frame = CGRectOffset(oldDetailRect, transformedTranslation.x, transformedTranslation.y);
			
			break;
			
		}
		
		case UIGestureRecognizerStateEnded: {

			CGPoint translation = [panGR translationInView:self.view];
			
			BOOL shouldShow = [self shouldShowMasterViewControllerWithGestureTranslation:translation];
			
			if (showingMasterViewController != shouldShow) {
			
				[self willChangeValueForKey:@"showingMasterViewController"];
				showingMasterViewController = shouldShow;
				[self didChangeValueForKey:@"showingMasterViewController"];
				
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
	
	[self setShowingMasterViewController:NO animated:YES completion:nil];
	
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

- (void) viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];
	
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

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {

	if (!self.masterViewController || !self.detailViewController)
		return YES;

	BOOL masterVCRotatable = [self.masterViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
	BOOL detailVCRotatable = [self.detailViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];

	return masterVCRotatable && detailVCRotatable;

}

- (void) configureMasterView:(UIView *)view {

	//	For subclasses

}

- (void) configureDetailView:(UIView *)view {

	//	For subclasses

}

@end
