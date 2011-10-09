//
//  JBGameViewController.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBGameLayer;

@interface JBGameViewController : UIViewController{
    int sideViewState;
}

@property (nonatomic, retain)JBGameLayer *gameLayer;

@property (retain, nonatomic) IBOutlet UIView *sideView;
@property (retain, nonatomic) IBOutlet UIButton *popout;
@property (retain, nonatomic) IBOutlet UIButton *popin;

- (IBAction)jumpButtonPressed:(id)sender;
- (IBAction)leftButtonPressed:(id)sender;
- (IBAction)rightButtonPressed:(id)sender;
- (IBAction)popinButtonPressed:(id)sender;
- (IBAction)popoutButtonPressed:(id)sender;


@end
