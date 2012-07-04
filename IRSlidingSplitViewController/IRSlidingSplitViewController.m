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

@end

@implementation IRSlidingSplitViewController
@synthesize showingMasterViewController = _showingMasterViewController;
@synthesize masterViewController = _masterViewController;
@synthesize detailViewController = _detailViewController;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;

- (void) setShowingMasterViewController:(BOOL)flag {

	[self setShowingMasterViewController:flag animated:NO completion:nil];

}

- (void) setShowingMasterViewController:(BOOL)flag animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback {

	if (self.showingMasterViewController == flag) {
	
		if (callback)
			callback(NO);
	
		return;
		
	}
	
	_showingMasterViewController = flag;
	
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

	if (_masterViewController == toMasterVC) {
		
		if (callback)
			callback(NO);
		
		return;
		
	}
	
	[self willChangeValueForKey:@"masterViewController"];
	
	[_masterViewController willMoveToParentViewController:nil];
	[_masterViewController removeFromParentViewController];
	[_masterViewController.view removeFromSuperview];
	
	_masterViewController = toMasterVC;
	
	if (_masterViewController) {
	
		[self addChildViewController:_masterViewController];
		[self configureMasterView:_masterViewController.view];
		[self.view addSubview:_masterViewController.view];
		[_masterViewController didMoveToParentViewController:self];
	
	}
	
	[self didChangeValueForKey:@"masterViewController"];
	
	[self layoutViews];
	
	if (callback)
		callback(YES);

}

- (void) setDetailViewController:(UIViewController *)toDetailVC animated:(BOOL)animate completion:(void(^)(BOOL didFinish))callback {

	if (_detailViewController == toDetailVC) {
		
		if (callback)
			callback(NO);
		
		return;
		
	}
	
	[self willChangeValueForKey:@"detailViewController"];
	
	[_detailViewController willMoveToParentViewController:nil];
	[_detailViewController removeFromParentViewController];
	[_detailViewController.view removeFromSuperview];
	
	_detailViewController = toDetailVC;
	
	if (_detailViewController) {
	
		[self addChildViewController:_detailViewController];
		[self configureDetailView:_detailViewController.view];
		[self.view addSubview:_detailViewController.view];
		[_detailViewController didMoveToParentViewController:self];
	
	}

	[self didChangeValueForKey:@"detailViewController"];
	
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

	if (_panGestureRecognizer)
		return _panGestureRecognizer;
	
	_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	_panGestureRecognizer.delegate = self;
	_panGestureRecognizer.cancelsTouchesInView = YES;

	return _panGestureRecognizer;

}

- (UITapGestureRecognizer *) tapGestureRecognizer {

	if (_tapGestureRecognizer)
		return _tapGestureRecognizer;
	
	_tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	_tapGestureRecognizer.delegate = self;
	_tapGestureRecognizer.cancelsTouchesInView = YES;
	
	return _tapGestureRecognizer;

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

	UIView *detailView = self.detailViewController.view;
	CGRect detailVisibleRect = CGRectIntersection(self.view.bounds, [self.view convertRect:detailView.bounds fromView:detailView]);
	
	BOOL touchInDetailVisibleRect = !CGRectEqualToRect(detailVisibleRect, CGRectNull) &&
		CGRectContainsPoint(detailVisibleRect, [touch locationInView:self.view]);
	
	if (gestureRecognizer == _panGestureRecognizer) {
	
		if (touchInDetailVisibleRect)
			return ![[touch view] isKindOfClass:[UISlider class]];
			
		return NO;
		
	}
	
	if (gestureRecognizer == _tapGestureRecognizer)
		return self.showingMasterViewController && touchInDetailVisibleRect;
	
	return YES;

}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

	if (gestureRecognizer == _tapGestureRecognizer) {
		
		if ([otherGestureRecognizer.view isDescendantOfView:self.detailViewController.view])
			return NO;
		
		if (self.showingMasterViewController)
		if (gestureRecognizer.state == UIGestureRecognizerStateRecognized)
			return NO;
		
		return YES;
		
	}
	
	if (gestureRecognizer == _panGestureRecognizer) {
	
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
			
			if (_showingMasterViewController != shouldShow) {
			
				[self willChangeValueForKey:@"showingMasterViewController"];
				_showingMasterViewController = shouldShow;
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

- (void) setView:(UIView *)view {
	
	[super setView:view];
	
	if (!view) {
	
		_panGestureRecognizer.delegate = nil;
		_panGestureRecognizer = nil;

		_tapGestureRecognizer.delegate = nil;
		_tapGestureRecognizer = nil;
	
	}

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
