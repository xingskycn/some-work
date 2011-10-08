//
//  APViewController.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APAboutViewController;
@class APGameSelectionController;
@class APOptionsViewController;
@class APGameViewController;

@interface APViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView* contentView;
	
	APGameSelectionController* gameSelectionController;
	APOptionsViewController* optionsViewController;
	APAboutViewController* aboutViewController;
	
	APGameViewController* gameView;
}

+ (APViewController *)single;

@property (nonatomic, retain) APGameSelectionController* gameSelectionController;
@property (nonatomic, retain) APOptionsViewController* optionsViewController;
@property (nonatomic, retain) APAboutViewController* aboutViewController;
@property (nonatomic, retain) APGameViewController* gameView;

- (IBAction)quickStartButtonPressed;
- (IBAction)startGameButtonPressed;
- (IBAction)optionsButtonPressed;
- (IBAction)aboutButtonPressed;

- (void)showMain; // shifts the scrollview to display the main view

@end

