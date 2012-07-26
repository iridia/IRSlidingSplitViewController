//
//  IRSlidingPanGestureRecognizer.h
//  IRSlidingSplitViewController
//
//  Created by Evadne Wu on 7/26/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRSlidingPanGestureRecognizerDelegate.h"


@interface IRSlidingPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) id<IRSlidingPanGestureRecognizerDelegate> delegate;

@end
