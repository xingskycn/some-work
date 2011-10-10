//
//  JBMapCreatorViewController.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "cocos2d.h"
@class JBMapCreatorLayer;
@class JBTouchForwardView;
@class JBHero;

@interface JBMapCreatorViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    int oldEditStyle;
}

//
// Make the brushes and entities available that can be added to the map
//

@property (retain, nonatomic) NSMutableArray* availableBrushesArray;
@property (retain, nonatomic) NSMutableArray* availableEntitiesArray;

//
// the layer the map is going to be drawn on
//

@property (retain, nonatomic) JBMapCreatorLayer* mapCreatorLayer;

//
// the view cotained in the options menu
//

@property (retain, nonatomic) IBOutlet JBTouchForwardView *sideView; // the view containing the hole menu
// choose which kind of item to add to map
@property (retain, nonatomic) IBOutlet UISegmentedControl *kindChooser;
@property (retain, nonatomic) IBOutlet UITableView *contentsTable;
@property (retain, nonatomic) IBOutlet UIButton *openButton; // button to pop out/in the menu
@property (retain, nonatomic) IBOutlet UIView *menuContainer; // containing view for the menu
@property (retain, nonatomic) IBOutlet UISlider *magnifier; // magnification slider
@property BOOL sidebarClosed; // make the open/close state of the menu available

//
// the brackground view of the MapCreator, touches are being forwarded to the mapCreatorLayer
//
@property (retain, nonatomic) IBOutlet JBTouchForwardView *forwarder;

- (IBAction)switchKind:(id)sender;
- (IBAction)closeSidebar:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


@end
