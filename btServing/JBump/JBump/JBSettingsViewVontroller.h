//
//  JBSettingsViewVontroller.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBSettingsViewVontroller : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    
}

@property (retain, nonatomic) IBOutlet UITableView *skinTableView;
@property (retain, nonatomic) IBOutlet UISwitch *cSkinDownloadSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *scoreBoardSwitch;
@property (retain, nonatomic) IBOutlet UISlider *playerNameSlider;
@property (retain, nonatomic) IBOutlet UITextField *playerNameText;

@property (nonatomic, retain) NSMutableArray *allSkins;
@property (nonatomic, retain) NSIndexPath *selectedCell;

- (IBAction)playerNameTextChanged:(id)sender;
- (IBAction)playerNameSizeValueChanged:(id)sender;
- (IBAction)customSkinDownloadValueChanged:(id)sender;
- (IBAction)showScoreBoardValueChanged:(id)sender;

@end
