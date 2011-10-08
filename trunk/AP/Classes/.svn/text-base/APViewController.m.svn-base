//
//  APViewController.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APViewController.h"

#import "APGameSelectionController.h"
#import "APOptionsViewController.h"
#import "APAboutViewController.h"
#import "APGameViewController.h"
#import "APPhysics.h"

@implementation APViewController

@synthesize gameSelectionController;
@synthesize aboutViewController;
@synthesize optionsViewController;
@synthesize gameView; 

static APViewController* single;

+ (APViewController *)single
{
	return single;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	single = self;
}

- (IBAction)quickStartButtonPressed
{
	[APPhysics single].stopped = TRUE;
	[APPhysics single].gameMode = @"std";
	[[NSUserDefaults standardUserDefaults] setObject:@"s00005" forKey:@"selected_map"];
	self.gameView = [[APGameViewController alloc] initWithNibName:@"APGameViewController" bundle:nil];
	[self.gameView release];
	[contentView addSubview:gameView.view];
	CGRect gameViewFrame = CGRectMake(1*480, 0, 480, 300);
	gameView.view.frame = gameViewFrame;
	contentView.contentSize = CGSizeMake(480*2, 300);
	[contentView scrollRectToVisible:gameViewFrame animated:YES];
	[APPhysics single].stopped = FALSE;
}

- (IBAction)startGameButtonPressed
{
	self.gameSelectionController = [[APGameSelectionController alloc] initWithNibName:@"APGameSelectionController" bundle:nil];
	[self.gameSelectionController release];
	[contentView addSubview:gameSelectionController.view];
	CGRect gameSelectionControllerFrame = CGRectMake(480, 0, 480, 300);
	gameSelectionController.view.frame = gameSelectionControllerFrame;
	contentView.contentSize = CGSizeMake(480*2, 300);
	[contentView scrollRectToVisible:gameSelectionControllerFrame animated:YES];
}

- (IBAction)optionsButtonPressed
{
	self.optionsViewController = [[APOptionsViewController alloc] initWithNibName:@"APOptionsViewController" bundle:nil];
	[self.optionsViewController release];
	[contentView addSubview:optionsViewController.view];
	CGRect optionsViewControllerFrame = CGRectMake(480, 0, 480, 300);
	optionsViewController.view.frame = optionsViewControllerFrame;
	contentView.contentSize = CGSizeMake(480*2, 300);
	[contentView scrollRectToVisible:optionsViewControllerFrame animated:YES];
}

- (IBAction)aboutButtonPressed
{
	self.aboutViewController = [[APAboutViewController alloc] initWithNibName:@"APAboutViewController" bundle:nil];
	[self.aboutViewController release];
	[contentView addSubview:aboutViewController.view];
	CGRect aboutViewControllerFrame = CGRectMake(480, 0, 480, 300);
	aboutViewController.view.frame = aboutViewControllerFrame;
	contentView.contentSize = CGSizeMake(480*2, 300);
	[contentView scrollRectToVisible:aboutViewControllerFrame animated:YES];
}

- (void)showMain
{
	[contentView scrollRectToVisible:CGRectMake(0,0 , 1, 1) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.x == 0) {
		self.gameSelectionController = nil;
		self.optionsViewController = nil;
		self.aboutViewController = nil;
		self.gameView = nil;
	}
}

- (void)dealloc {
	single = nil;
    [super dealloc];
}

@end
