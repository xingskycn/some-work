//
//  JBBluetoothViewController.m
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBPreGameViewController.h"
#import "JBMapManager.h"
#import "JBHero.h"
#import "JBSkinManager.h"
#import "JBSkin.h"
#import "JBTavern.h"
#import "JBMap.h"
#import "JBPreGameMapsTableViewCell.h"

@implementation JBPreGameViewController

@synthesize multiplayerAdapter;
@synthesize gameTypeButton;
@synthesize readyButton;
@synthesize startButton;
@synthesize playersTableView;
@synthesize mapsTablleView;
@synthesize aNewConnectionbutton;

@synthesize maps, players;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.players = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.multiplayerAdapter = [[JBMultiplayerAdapter alloc] init];
    //self.multiplayerAdapter.preGameDelegate = self;
    //[self.bluetoothAdapter setupConnectionForPreGameViewController:self];
    
    self.maps = [JBMapManager getAllStandardMaps];
}


- (void)viewDidUnload
{
    [self setGameTypeButton:nil];
    [self setReadyButton:nil];
    [self setStartButton:nil];
    [self setPlayersTableView:nil];
    [self setMapsTablleView:nil];
    [self setANewConnectionbutton:nil];
    [self setPlayers:nil];
    [self setMaps:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [gameTypeButton release];
    [readyButton release];
    [startButton release];
    [playersTableView release];
    [mapsTablleView release];
    [aNewConnectionbutton release];
    //[players release];
    //[maps release];
    [super dealloc];
}

- (void)addPlayerToGame:(NSDictionary *)player {
    [self.players addObject:player];
}

- (void)changeMaps:(NSMutableArray *)maps {
    //TODO
}

#pragma mark tableViewStuff

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.playersTableView) {
        return [[self.multiplayerAdapter.tavern getAllPlayers] count];
    }
    if (tableView==self.mapsTablleView) {
        return self.maps.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.playersTableView) {
        static NSString *cellIdentifier = @"playersCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        
        JBHero *aHero = [[self.multiplayerAdapter.tavern getAllPlayers] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = aHero.name;
        
        JBSkin *playerSkin = [JBSkinManager getSkinWithID:aHero.skinID];
        
        cell.imageView.image = playerSkin.image;
        
        return cell;
    }
    
    if (tableView==self.mapsTablleView) {
        static NSString *cellIdentifier = @"mapsCell";
        
        JBPreGameMapsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[JBPreGameMapsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.mapsTablleView) {
        return 120.0f;
    }
    
    return 80.0f;
}

#pragma mark JBGameAdapterPregameViewDelegate

- (void)newPlayerAnnounced:(JBHero *)hero {
    [self.playersTableView reloadData];
}

- (JBHero *)requestPlayerAnnouncement:(NSString *)playerI {
    return nil;
}

- (void)playerDisconnected:(JBHero *)hero {
    [self.playersTableView reloadData];
}

- (void)player:(JBHero *)hero didReadyChange:(BOOL)ready {
    
}

- (void)playerDidStartGame:(JBHero *)hero {
    
}

@end
