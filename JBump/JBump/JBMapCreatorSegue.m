//
//  JBMapCreatorSegue.m
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBMapCreatorSegue.h"
#import "JBAppDelegate.h"
#import "JBMapCreatorSelectionViewController.h"
#import "JBMapCreatorSettingsViewController.h"
#import "JBMapCreatorViewController.h"

@implementation JBMapCreatorSegue

- (void)perform{
    [self.destinationViewController view].frame = CGRectMake(0, 0, 480, 320);
    [self.sourceViewController view].frame = CGRectMake(0, 0, 480, 320);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[self.sourceViewController view].superview cache:YES];
    [UIView setAnimationDuration:1.0];
    [[self.sourceViewController view].superview addSubview:[self.destinationViewController view]];
    [[self.sourceViewController view] removeFromSuperview];
    [UIView commitAnimations];
    
    if ([self.identifier isEqualToString:@"toMapSettings"]) {
        JBMapCreatorSelectionViewController* source = (JBMapCreatorSelectionViewController*)self.sourceViewController;
        JBMapCreatorSettingsViewController* destination = (JBMapCreatorSettingsViewController*)self.destinationViewController;
        NSIndexPath* indexpath = [source.settingsTableView indexPathForSelectedRow];
        if (indexpath) {
            destination.advancedSettings = [[source.settingsArray objectAtIndex:indexpath.row] objectForKey:@"settings"];
            destination.settingsName.text = [[source.settingsArray objectAtIndex:indexpath.row] objectForKey:@"name"];
        }
        
    }else if([self.identifier isEqualToString:@"startMapCreatorWithSettings"] )
    {
        JBMapCreatorSettingsViewController* source = (JBMapCreatorSettingsViewController*)self.sourceViewController;
        JBMapCreatorViewController* destination = (JBMapCreatorViewController*)self.destinationViewController;
        
    }
    [((JBAppDelegate*)[UIApplication sharedApplication].delegate).viewController addChildViewController:self.destinationViewController];
    [self.sourceViewController removeFromParentViewController];
}
@end
