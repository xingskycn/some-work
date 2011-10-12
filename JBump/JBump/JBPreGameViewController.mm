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
#import "JBBluetoothAdapter.h"
#import "JBMap.h"

@interface JBPreGameViewController()

@property (nonatomic, retain) NSArray* maptypes;
@property (assign) int selectedMapType;

@end

@implementation JBPreGameViewController
//private
@synthesize maptypes;
@synthesize selectedMapType;


//public

@synthesize playersReady;
@synthesize multiplayerAdapter;
@synthesize gameTypeButton;
@synthesize readyButton;
@synthesize startButton;
@synthesize playersTableView;
@synthesize mapsTablleView;
@synthesize aNewConnectionbutton;

@synthesize maps, players;

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
    
    if (!self.players) {
        self.players = [NSMutableArray array];
    }
    if (!self.maptypes) {
        self.maptypes = [JBMapManager getMapTypes];
        playersWaitingForGame = 1;
    }
    if (!playersReady) {
        self.playersReady = [NSMutableDictionary dictionary];
    }
    self.multiplayerAdapter = [[JBBluetoothAdapter alloc] init];
    //self.multiplayerAdapter.preGameDelegate = self;
    //[self.bluetoothAdapter setupConnectionForPreGameViewController:self];
    
    self.maps = [JBMapManager getAllMapsWithPrefix:
                 [[self.maptypes objectAtIndex:selectedMapType] objectForKey:jbID]];
    [self.gameTypeButton setTitle:[[self.maptypes objectAtIndex:selectedMapType] objectForKey:jbNAME] forState:UIControlStateNormal];
    [self.startButton setEnabled:NO];
    
    self.playersReady = [NSMutableDictionary dictionary];
    playersWaitingForGame = 1;
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

- (IBAction)readyButtonPressed:(id)sender {
    NSString *myPlayerID = [NSString stringWithFormat:@"%d",self.multiplayerAdapter.tavern.localPlayer.playerID];
    if ([playersReady objectForKey: myPlayerID]!=nil) {
        [self player:myPlayerID didReadyChange:NO];
        [self.multiplayerAdapter sendPlayerReadyChange:NO];
        [self.readyButton setSelected:NO];
    } else {
        [self player:myPlayerID didReadyChange:YES];
        [self.multiplayerAdapter sendPlayerReadyChange:YES];
        [self.readyButton setSelected:YES];
    }
}

- (IBAction)startButtonPressed:(id)sender {
    [self.multiplayerAdapter sendGameStartedByPlayer:self.multiplayerAdapter.tavern.localPlayer.name];
}

- (IBAction)newConnectionPressed:(id)sender {
    [(JBBluetoothAdapter*)self.multiplayerAdapter setupConnectionForPreGameViewController:self];
}

- (IBAction)changeGameType:(id)sender {
    self.selectedMapType = (self.selectedMapType +1)%maptypes.count;
    [self.gameTypeButton setTitle:[[self.maptypes objectAtIndex:selectedMapType] objectForKey:jbNAME] forState:UIControlStateNormal];
    self.maps = [JBMapManager getAllMapsWithPrefix:
                 [[self.maptypes objectAtIndex:selectedMapType] objectForKey:jbID]];
    [self.mapsTablleView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
}

- (IBAction)sendImgTest:(id)sender {
    UIImage* img = [UIImage imageNamed:@"default.png"];
    
    [self.multiplayerAdapter sendData:UIImagePNGRepresentation(img) info:nil];
}

#pragma mark tableViewStuff

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
        JBMap* map = [maps objectAtIndex:indexPath.row];
        cell.mainView.image = map.thumbnail;
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.mapsTablleView) {
        JBMap* map = [maps objectAtIndex:indexPath.row];
        
        return map.thumbnail.size.height;
    }
    
    return 80.0f;
}

#pragma mark JBGameAdapterPregameViewDelegate

- (void)newPlayerAnnounced:(JBHero *)hero {
    playersWaitingForGame=[self.multiplayerAdapter.tavern getAllPlayers].count;
    [self.playersTableView reloadData];
}

- (void)playerDisconnected:(JBHero *)hero {
    playersWaitingForGame=[self.multiplayerAdapter.tavern getAllPlayers].count;
    [self.playersTableView reloadData];
}

- (void)player:(NSString *)heroID didReadyChange:(BOOL)ready {
    if (ready) {
        [playersReady setObject:heroID forKey:heroID];
        if ([playersReady allKeys].count>=playersWaitingForGame) {
            [self.startButton setEnabled:YES];
        }
    } else {
        [playersReady removeObjectForKey:heroID];
        if ([playersReady allKeys].count<playersWaitingForGame) {
            [self.startButton setEnabled:NO];
        }
    }
    
}

- (void)playerDidStartGame:(JBHero *)hero {
    //TODO
}

@end
