//
//  MapViewController.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
@class MapLayer;
@class TouchForwardView;

@interface MapViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    int oldEditStyle;
}
@property BOOL sidebarClosed;
@property (retain, nonatomic) NSMutableArray* brushArray;
@property (retain, nonatomic) NSMutableArray* entityArray;
@property (retain, nonatomic) MapLayer* mapLayer;
@property (retain, nonatomic) IBOutlet UIView *menuContainer;
@property (retain, nonatomic) IBOutlet TouchForwardView *slideOutView;
@property (retain, nonatomic) IBOutlet UISlider *magnifier;
@property (retain, nonatomic) IBOutlet UISegmentedControl *editStyleControll;
@property (retain, nonatomic) IBOutlet UITableView *contentsTable;
@property (retain, nonatomic) IBOutlet UIButton *ocBarButton;
@property (retain, nonatomic) IBOutlet TouchForwardView *forwarder;

- (IBAction)switchEditStyle:(id)sender;
- (IBAction)closeSidebar:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
