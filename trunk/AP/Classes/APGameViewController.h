//
//  APGameViewController.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APChar;
@class APStatsViewController;

@interface APGameViewController : UIViewController {
	IBOutlet UIButton*  leftRunButton;
	IBOutlet UIButton*  rightRunButton;
	IBOutlet UIButton*  leftJumpButton;
	IBOutlet UIButton*  rightJumpButton;
	IBOutlet UIButton*  backButton;
	
	IBOutlet UIScrollView* contentView;
	
	APChar* playerChar;
	
	NSMutableDictionary* userInput;
	
	NSString* connectionMode;
	
	IBOutlet UILabel* debugLabel;
	
	IBOutlet UILabel* splashLabel;
	
	APStatsViewController* statsView;
}

+ (APGameViewController *)single;

@property (nonatomic, retain) APChar* playerChar;
@property (nonatomic, retain) NSMutableDictionary* userInput;
@property (nonatomic, copy) NSString* connectionMode;
@property (nonatomic, assign) UIScrollView* contentView;
@property (nonatomic, assign) UILabel* debugLabel;
@property (nonatomic, retain) APStatsViewController* statsView;

- (IBAction)backButtonPressed:(UIButton *)button;
- (IBAction)directionButtonTouchDown:(UIButton *)button;
- (IBAction)directionButtonTouchUp:(UIButton *)button;
- (void)updatedPosition:(CGRect)frame;
- (void)scoredOnPlayer:(APChar *)chr;
- (void)setupContentViewForRun;
@end
