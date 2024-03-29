//
//  JBBluetoothViewController.h
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBMultiplayerAdapter.h"

@class JBMap;
@class JBProgressView;

@interface JBPreGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, JBMultiplayerAdapterPregameDelegate> {
    
    int playersWaitingForGame;
    
    
}

@property(retain, nonatomic) NSMutableDictionary *playersReady;

@property (nonatomic, retain) JBMultiplayerAdapter *multiplayerAdapter;
@property (retain, nonatomic) IBOutlet UIButton *gameTypeButton;
@property (retain, nonatomic) IBOutlet UIButton *readyButton;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UITableView *playersTableView;
@property (retain, nonatomic) IBOutlet UITableView *mapsTablleView;
@property (retain, nonatomic) IBOutlet UIButton *aNewConnectionbutton;

@property (retain, nonatomic) NSMutableArray *players;
@property (retain, nonatomic) NSMutableArray *maps;

- (void)addPlayerToGame:(NSDictionary*)player;
- (void)changeMaps:(NSMutableArray*)maps;
- (IBAction)readyButtonPressed:(id)sender;
- (IBAction)startButtonPressed:(id)sender;
- (IBAction)newConnectionPressed:(id)sender;
- (IBAction)changeGameType:(id)sender;


// Contents of request popout
@property (retain, nonatomic) IBOutlet UILabel *requestTitelLabel;
@property (retain, nonatomic) IBOutlet UILabel *requestMessageLabel;
@property (retain, nonatomic) IBOutlet JBProgressView *requestProgressBar;
@property (retain, nonatomic) IBOutlet UIButton *closeRequestButton;
@property (retain, nonatomic) IBOutlet UIView *requestPopout;
@property (retain, nonatomic) JBMap *selectedMap;
@property (retain, nonatomic) IBOutlet UIButton *confirmRequestButton;


- (IBAction)closeRequestPopout:(id)sender;
- (IBAction)confirmRequest:(id)sender;


@end
