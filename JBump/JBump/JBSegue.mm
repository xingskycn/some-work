//
//  JBSegue.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBSegue.h"
#import "JBAppDelegate.h"
#import "JBMapCreatorViewController.h"
#import "JBGameViewController.h"
#import "JBMenuViewController.h"
#import "JBQuickGameViewController.h"
#import "JBPreGameViewController.h"
#import "JBMultiplayerAdapter.h"
#import "JBTavern.h"

@implementation JBSegue

- (void)perform {
    [[self.destinationViewController view] setFrame:CGRectMake(0, 0, 480, 320)];
    [self.sourceViewController view].frame = CGRectMake(0, 0, 480, 320);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.sourceViewController view].superview cache:YES];
    [UIView setAnimationDuration:1.0];
    [[self.sourceViewController view].superview addSubview:[self.destinationViewController view]];
    [[self.sourceViewController view] removeFromSuperview];
    /*
    if ([self.sourceViewController isKindOfClass:[JBMapCreatorViewController class]]) {
        [[CCDirector sharedDirector] replaceScene:((JBAppDelegate*)[UIApplication sharedApplication].delegate).menuScene];
    }
    
    if ([self.sourceViewController isKindOfClass:[JBGameViewController class]]) {
        [[CCDirector sharedDirector] replaceScene:((JBAppDelegate*)[UIApplication sharedApplication].delegate).menuScene];
    }
    */
    if ([self.destinationViewController isKindOfClass:[JBMenuViewController class]]) {
        [[CCDirector sharedDirector] replaceScene:((JBAppDelegate*)[UIApplication sharedApplication].delegate).menuScene];
    }
    
    if ([self.sourceViewController isKindOfClass:[JBPreGameViewController class]]&&[self.destinationViewController isKindOfClass:[JBMenuViewController class]]) {
        ((JBPreGameViewController*)self.sourceViewController).multiplayerAdapter.tavern.gameLayer=nil;
    }
    
    [UIView commitAnimations];
    
    [((JBAppDelegate*)[UIApplication sharedApplication].delegate).viewController addChildViewController:self.destinationViewController];
    [self.sourceViewController removeFromParentViewController];
}

@end
