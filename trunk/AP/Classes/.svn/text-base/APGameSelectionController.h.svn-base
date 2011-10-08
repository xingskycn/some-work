//
//  APGameSelectionController.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APGameViewController;
@class APPreGameViewController;

@interface APGameSelectionController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView* contentView;
	APGameViewController* gameView;
	APPreGameViewController*preGameView;
}

+ (APGameSelectionController *)single;

@property (nonatomic, retain) APGameViewController* gameView;
@property (nonatomic, retain) APPreGameViewController*preGameView;

- (IBAction)internetGameButtonPressed;
- (IBAction)bluetoothGameButtonPressed;
- (IBAction)showPreGameView;
- (void)showGameView;
- (IBAction)backButtonPressed:(UIButton *)button;
- (void)shutPreGameView;

@end
