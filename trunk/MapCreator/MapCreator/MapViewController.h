//
//  MapViewController.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UISlider *magnifier;
- (IBAction)switchEditStyle:(id)sender;
- (IBAction)closeSidebar:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
