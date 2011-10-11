//
//  JBMapCreatorSettingsViewController.h
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBMapCreatorSettingsViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITextField *imageUrlField;
@property (retain, nonatomic) IBOutlet UITextField *mapNameField;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) NSMutableArray* advancedSettings;
@property (retain, nonatomic) IBOutlet UITableView *advancedSettingsTableView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton* downloadImageButton;
@property (retain, nonatomic) IBOutlet UIButton* createButton;
@property (assign) BOOL imageDownloadInProgress;
@property (retain, nonatomic) IBOutlet UILabel *settingsName;
- (IBAction)downloadImageButtonPressed:(id)sender;

@end
