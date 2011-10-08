//
//  APGameSelectionController.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APGameSelectionController.h"

#import "APAdapter.h"
#import "APBluetoothAdapter.h"
#import "APWebAdapter.h"
#import "APPhysics.h"
#import "APViewController.h"
#import "APGameViewController.h"
#import "APPreGameViewController.h"

@implementation APGameSelectionController

@synthesize gameView;
@synthesize preGameView;

static APGameSelectionController* single;

+ (APGameSelectionController *)single
{
	return single;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	single = self;
}

- (IBAction)internetGameButtonPressed
{
	//[self showPreGameView];
	NSLog(@"APGameSelectionController->internetGameButtonPressed()");
	
	[APAdapter setSingle:[APWebAdapter single]];
	[APAdapter single].delegate = [APPhysics single];
	
	[[APAdapter single] setupConnectionForSender:self callback:@selector(showPreGameView)];
}


- (IBAction)bluetoothGameButtonPressed
{
	NSLog(@"APGameSelectionController->bluetoothGameButtonPressed()");

	[APAdapter setSingle:[APBluetoothAdapter single]];
	[APAdapter single].delegate = [APPhysics single];
	
	[[APAdapter single] setupConnectionForSender:self callback:@selector(showPreGameView)];
}

- (IBAction)showPreGameView
{
	self.preGameView = [[APPreGameViewController alloc] initWithNibName:@"APPreGameViewController" bundle:nil];
	[self.preGameView release];
	[contentView addSubview:preGameView.view];
	CGRect preGameViewFrame = CGRectMake(480, 0, 480, 300);
	preGameView.view.frame = preGameViewFrame;
	contentView.contentSize = CGSizeMake(480*2, 300);
	[contentView scrollRectToVisible:preGameViewFrame animated:YES];
}

- (void)showGameView
{
	self.gameView = [[APGameViewController alloc] initWithNibName:@"APGameViewController" bundle:nil];
	[self.gameView release];
	[contentView addSubview:gameView.view];
	CGRect gameViewFrame = CGRectMake(2*480, 0, 480, 300);
	gameView.view.frame = gameViewFrame;
	contentView.contentSize = CGSizeMake(480*3, 300);
	[contentView scrollRectToVisible:gameViewFrame animated:YES];
	[APPhysics single].stopped = FALSE;
}

- (void)shutPreGameView
{
	[contentView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.x == 0) {
		self.preGameView = nil;
		self.gameView = nil;
	}
}

- (IBAction)backButtonPressed:(UIButton *)button
{
	[[APViewController single] showMain];
}


- (void)dealloc {
	NSLog(@"APGameSelectionController.dealloc()");
	self.gameView = nil;
	single = nil;
    [super dealloc];
}


@end
