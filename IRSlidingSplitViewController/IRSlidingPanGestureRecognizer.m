//
//  IRSlidingPanGestureRecognizer.m
//  IRSlidingSplitViewController
//
//  Created by Evadne Wu on 7/26/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRSlidingPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation IRSlidingPanGestureRecognizer

- (BOOL) canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {

	BOOL superAnswer = [super canPreventGestureRecognizer:preventedGestureRecognizer];
	
	if ([self.delegate respondsToSelector:@selector(slidingPanGestureRecognizer:canPreventGestureRecognizer:proposedAnswer:)]) {
	
		return [self.delegate slidingPanGestureRecognizer:self canPreventGestureRecognizer:preventedGestureRecognizer proposedAnswer:superAnswer];
	
	}
	
	return superAnswer;

}

- (BOOL) canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {

	BOOL superAnswer = [super canBePreventedByGestureRecognizer:preventingGestureRecognizer];
	
	if ([self.delegate respondsToSelector:@selector(slidingPanGestureRecognizer:canBePreventedByGestureRecognizer:proposedAnswer:)]) {
		
		return [self.delegate slidingPanGestureRecognizer:self canBePreventedByGestureRecognizer:preventingGestureRecognizer proposedAnswer:superAnswer];
		
	}
	
	return superAnswer;

}

@end
