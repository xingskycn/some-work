//
//  JBMapCreatorSelectionViewController.h
//  JBump
//
//  Created by Nils Ziehn on 10/11/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBMapCreatorSelectionViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIButton *editExistingMapButton;
@property (retain, nonatomic) IBOutlet UITableView *settingsTableView;
@property (retain, nonatomic) IBOutlet UITableView *existingMapsTableView;
@property (retain, nonatomic) NSMutableArray* settingsArray;
@property (retain, nonatomic) NSMutableArray* existingMaps;

- (IBAction)editExistingMapButtonPressed:(id)sender;

@end
