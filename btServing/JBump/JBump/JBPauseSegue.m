//
//  JBPauseSegue.m
//  JBump
//
//  Created by Sebastian Pretscher on 13.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBPauseSegue.h"
#import "JBAppDelegate.h"
#import "JBQuickGameViewController.h"

@implementation JBPauseSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[JBQuickGameViewController class]]) {
        if (((JBQuickGameViewController*)self.sourceViewController).gameViewController!=nil) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.sourceViewController view].superview cache:YES];
            [UIView setAnimationDuration:1.0];
            [[self.sourceViewController view].superview addSubview:((JBQuickGameViewController*)self.sourceViewController).gameViewController.view];
            [[self.sourceViewController view] removeFromSuperview];
            [((JBAppDelegate*)[UIApplication sharedApplication].delegate).viewController addChildViewController:((JBQuickGameViewController*)self.sourceViewController).gameViewController];
        }
    } else {
        ((JBQuickGameViewController*)self.destinationViewController).gameViewController=self.sourceViewController;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.sourceViewController view].superview cache:YES];
        [UIView setAnimationDuration:1.0];
        [[self.sourceViewController view].superview addSubview:[self.destinationViewController view]];
        [[self.sourceViewController view] removeFromSuperview];
 
        [UIView commitAnimations];
        [((JBAppDelegate*)[UIApplication sharedApplication].delegate).viewController addChildViewController:self.destinationViewController];
    }
    //[self.sourceViewController removeFromParentViewController];
}


@end
