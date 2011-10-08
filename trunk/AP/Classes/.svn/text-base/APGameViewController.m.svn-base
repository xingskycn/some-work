//
//  APGameViewController.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APGameViewController.h"

#import "APPhysics.h"
#import "APChar.h"

#import "APQuickStartGenerator.h"
#import "APViewController.h"
#import "APAdapter.h"
#import "APStatsViewController.h"
#import "APMap.h"

@implementation APGameViewController

@synthesize playerChar;
@synthesize userInput;
@synthesize connectionMode;
@synthesize contentView;
@synthesize debugLabel;
@synthesize statsView;

static APGameViewController* single;

+ (APGameViewController *)single
{
	return single;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	single = self;
   	NSString* mapID = [[NSUserDefaults standardUserDefaults] objectForKey:@" "];
	if ([mapID hasPrefix:@"r"]) {
		[APPhysics single].gameMode = @"run";
	}else {
		[APPhysics single].gameMode = @"std";
	}

	if ([[APPhysics single].gameMode isEqualToString:@"run"]) {
		[self setupContentViewForRun];
	} else
	{
		APMap* map = [APMap mapForMapID:[[NSUserDefaults standardUserDefaults] objectForKey:@"selected_map"]];
		[contentView insertSubview:map atIndex:0];
		[[APPhysics single].maps removeAllObjects];
		[[APPhysics single].maps addObject:map];
		contentView.contentSize = map.frame.size;
	}
	
	
	self.userInput = [NSMutableDictionary dictionary];
	
	self.playerChar = [APQuickStartGenerator getPlayerCharForContentView:contentView 
											 userInput:self.userInput
											  gameView:self];
	
	[[APAdapter single] announcePlayerWithNewID:YES];
	
	self.statsView = [[APStatsViewController alloc] initWithNibName:@"APStatsViewController" bundle:nil];
	self.statsView.view.frame = CGRectMake(30, 66, 450, 169);
	[self.statsView updateStats];
	[self.view addSubview:self.statsView.view];
	[self.statsView release];
}

- (void)setupContentViewForRun
{
	int toFill = 480;
	APMap* map;
	while (toFill > 0) {
		map = [APMap mapForMapID:[[NSUserDefaults standardUserDefaults] objectForKey:@"selected_map"]];
		[[APPhysics single].maps addObject:map];
		[contentView addSubview:map];
		map.frame = CGRectMake(480-toFill, 0, map.frame.size.width, map.frame.size.height);
		toFill -= map.frame.size.width;
	}
	
	contentView.contentSize = CGSizeMake((480-toFill)*2, map.frame.size.height); 
}

- (void)dealloc {
	NSLog(@"gameview dealloc %d",[self.statsView retainCount]);
	self.statsView = nil;
	[APPhysics single].stopped = TRUE;
	[[APPhysics single].maps removeAllObjects];
	self.debugLabel = nil;
	self.playerChar = nil;
	self.userInput = nil;
	[self.view removeFromSuperview];
	single = nil;
    [super dealloc];
}


- (IBAction)backButtonPressed:(UIButton *)button
{
	[[APViewController single] showMain];
	[[APAdapter single] disconnectPlayer];
}

- (IBAction)directionButtonTouchDown:(UIButton *)button
{
	if (button == leftJumpButton || button == rightJumpButton) {
		[userInput setObject:[[NSObject new] autorelease] forKey:@"jump"];
	}
	
	if (button == leftRunButton) {
		[userInput setObject:[[NSObject new] autorelease] forKey:@"left"];
		[userInput removeObjectForKey:@"right"];
	}
	
	if (button == rightRunButton) {
		[userInput setObject:[[NSObject new] autorelease] forKey:@"right"];
		[userInput removeObjectForKey:@"left"];
	}
}

- (IBAction)directionButtonTouchUp:(UIButton *)button
{
	if (button == leftJumpButton || button == rightJumpButton) {
		[userInput removeObjectForKey:@"jump"];
	}
	
	if (button == leftRunButton) {
		[userInput removeObjectForKey:@"left"];
	}
	
	if (button == rightRunButton) {
		[userInput removeObjectForKey:@"right"];
	}
}

- (void)scoredOnPlayer:(APChar *)chr
{
	splashLabel.text = [NSString stringWithFormat:@"Scored on %@!",chr.nameLabel.text];
	splashLabel.alpha = 0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.1];
	[UIView setAnimationDelegate:self];
	[UIView	setAnimationDidStopSelector:@selector(fadeoutSplashLabel)];
	splashLabel.alpha = 1;
	[UIView commitAnimations];
}

- (void)fadeoutSplashLabel
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:1];
	splashLabel.alpha = 0;
	[UIView commitAnimations];
}

- (void)updatedPosition:(CGRect)frame
{	
	if ([[APPhysics single].gameMode isEqualToString:@"std"]) {
		
		//FRAME ORIGN IS PLAYERCHR CENTER!
		int x2org = contentView.contentSize.width>frame.origin.x+240?frame.origin.x+240:contentView.contentSize.width;
		int x1org = 0>frame.origin.x-240?0:frame.origin.x-240;
		int y2org = contentView.contentSize.height>frame.origin.y+150?frame.origin.y+150:contentView.contentSize.height;
		int y1org = 0>frame.origin.y-150?0:frame.origin.y-150;
		
		CGRect viewRect = CGRectMake(x1org,y1org,x2org-x1org,y2org-y1org);
		[contentView scrollRectToVisible:viewRect animated:NO];
	}else if ([[APPhysics single].gameMode isEqualToString:@"run"]) {
		
		int allMapsWidth = 0;
		for (APMap* map in [APPhysics single].maps) {
			allMapsWidth += map.frame.size.width;
		}
		
		if (frame.origin.x + 480 > allMapsWidth) {
			if (frame.origin.x - frame.size.width>0) {
				[APPhysics single].mapPosition = CGPointMake(frame.origin.x-frame.size.width, 0);
				contentView.contentOffset = CGPointMake(frame.origin.x-frame.size.width, contentView.contentOffset.y);
				
				for (UIView* view in [contentView subviews]) {
					if ([view isKindOfClass:[APChar class]]) {
						APChar* chr = ((APChar *)view);
						chr.position = CGPointMake(chr.position.x-frame.size.width, chr.position.y);
					}
					
					view.frame = CGRectMake(view.frame.origin.x-frame.size.width, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
				}
			}
			
			APMap* map = [APMap mapForMapID:[[NSUserDefaults standardUserDefaults] objectForKey:@"selected_map"]];
			[[APPhysics single].maps addObject:map];
			[contentView insertSubview:map atIndex:0];
			map.frame = CGRectMake(allMapsWidth, 0, map.frame.size.width, map.frame.size.height);
			[APPhysics single].mapVelocity = CGPointMake([APPhysics single].mapVelocity.x+0.3, 0);
		}else {
			contentView.contentOffset = CGPointMake(frame.origin.x, contentView.contentOffset.y);
			for (UIView* view in [contentView subviews]) {
				if (!CGRectIntersectsRect(view.frame, contentView.bounds)) {
					if (view == playerChar) {
						if (playerChar.position.y>0) {
							playerChar.dead = TRUE;
						}
						
					}else {
						if ([[APPhysics single].maps containsObject:view]) {
							[[APPhysics single].maps removeObject:view];
							[view removeFromSuperview];
						}
					}
				}
			}
		}
		
		int y2org = contentView.contentSize.height>frame.origin.y+150?frame.origin.y+150:contentView.contentSize.height;
		int y1org = 0>frame.origin.y-150?0:frame.origin.y-150;
		
		[contentView scrollRectToVisible:CGRectMake(contentView.contentOffset.x, y1org, 1, y2org-y1org) animated:NO];
	}	
}

@end
