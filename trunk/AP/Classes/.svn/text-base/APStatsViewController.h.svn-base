//
//  APStatsViewController.h
//  AP
//
//  Created by Ziehn Nils on 6/19/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface APStatsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* statsTable;
	IBOutlet UIView* container;
	
	IBOutlet UIButton* slideLeftButton;
	IBOutlet UIButton* slideRightButton;
	
	NSMutableArray* statsInformation;
	
}

@property (nonatomic, retain) NSArray* statsInformation;

- (void)updateStats;

- (IBAction)slideLeftButtonPressed:(UIButton *)button;
- (IBAction)slideRightButtonPressed:(UIButton *)button;
- (void)updateStatsForGameModeStd;
- (void)updateStatsForGameModeRun;

@end
