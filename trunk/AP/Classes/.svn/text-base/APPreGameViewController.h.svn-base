//
//  APPreGameViewController.h
//  AP
//
//  Created by Ziehn Nils on 6/22/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface APPreGameViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView* mapSelector;
	IBOutlet UITableView* playersTable;
	
	IBOutlet UIButton* startButton;
	
	NSArray* maps;
	NSMutableArray* players;
}

@property (nonatomic, readonly) UITableView* mapSelector;
@property (nonatomic, retain) NSArray* maps;
@property (nonatomic, retain) NSMutableArray* players;

- (IBAction)readyButtonPressed:(UIButton *)button;
- (IBAction)startButtonPressed:(UIButton *)button;
- (IBAction)backButtonPressed:(UIButton *)button;

- (void)readyChange;

@end
