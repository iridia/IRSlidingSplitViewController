//
//  IRSlidingPanGestureRecognizerDelegate.h
//  IRSlidingSplitViewController
//
//  Created by Evadne Wu on 7/26/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IRSlidingPanGestureRecognizer;
@protocol IRSlidingPanGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@optional

- (BOOL) slidingPanGestureRecognizer:(IRSlidingPanGestureRecognizer *)recognizer canPreventGestureRecognizer:(UIGestureRecognizer *)otherRecognizer proposedAnswer:(BOOL)superAnswer;

- (BOOL) slidingPanGestureRecognizer:(IRSlidingPanGestureRecognizer *)recognizer canBePreventedByGestureRecognizer:(UIGestureRecognizer *)otherRecognizer proposedAnswer:(BOOL)superAnswer;

@end
