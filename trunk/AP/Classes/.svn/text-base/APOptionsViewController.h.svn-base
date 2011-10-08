//
//  APOptionsViewController.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface APOptionsViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITextField* playerNameField;
	IBOutlet UITableView* skinSelectionTable;
	
	IBOutlet UISwitch* customSkinDownloadSwitch;
	IBOutlet UISwitch* showScoreBoardSwitch;
	
	IBOutlet UISlider* fontSizeSlider;
	
	NSArray* skins;
}

@property (nonatomic, retain) NSArray* skins;

- (IBAction)saveButtonPressed:(UIButton *)button;
- (IBAction)playerNameDisplaySizeChanged:(UISlider *)slider;

@end
