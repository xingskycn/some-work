//
//  JBSegue.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSegue.h"
#import "JBAppDelegate.h"

@implementation JBSegue

- (void)perform {

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.sourceViewController view].superview cache:YES];
    [UIView setAnimationDuration:1.0];
    [[self.sourceViewController view].superview addSubview:[self.destinationViewController view]];
    [[self.sourceViewController view] removeFromSuperview];
    [UIView commitAnimations];
    
    [((JBAppDelegate*)[UIApplication sharedApplication].delegate).viewController addChildViewController:self.destinationViewController];
    [self.sourceViewController removeFromParentViewController];
}

@end
