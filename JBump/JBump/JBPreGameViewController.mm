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
@property (retain, nonatomic) NSString* requestedMapID;
@property (retain, nonatomic) NSString* missingMapID;

@end

@implementation JBPreGameViewController

//private
@synthesize maptypes;
@synthesize selectedMapType;
@synthesize requestedMapID;
@synthesize missingMapID;


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
@synthesize selectedMap;

// Contents of request popout
@synthesize requestTitelLabel;
@synthesize requestProgressBar;
@synthesize closeRequestButton;
@synthesize requestPopout;
@synthesize requestMessageLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Hide Request Popout
    self.requestPopout.frame = CGRectMake(120, -120, 240, 120);
    
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
    [self setRequestTitelLabel:nil];
    [self setRequestProgressBar:nil];
    [self setCloseRequestButton:nil];
    [self setRequestPopout:nil];
    [self setRequestMessageLabel:nil];
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
    [requestTitelLabel release];
    [requestProgressBar release];
    [closeRequestButton release];
    [requestPopout release];
    [requestMessageLabel release];
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

- (IBAction)closeRequestPopout:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.requestPopout.frame = self.requestPopout.frame = CGRectMake(120, -120, 240, 120);
    [UIView commitAnimations];
}

- (IBAction)confirmRequest:(id)sender {
    if (self.missingMapID) {
        [self.multiplayerAdapter askForMapWithID:self.missingMapID];
        self.requestMessageLabel.text = @"the request has been send";
    }else{
        [self.multiplayerAdapter sendMapForID:self.requestedMapID];
        self.requestMessageLabel.text = @"map sending in progress";
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mapsTablleView) {
        JBMap* map = [self.maps objectAtIndex:indexPath.row];
        self.selectedMap = map;
        [self.multiplayerAdapter shoutMapChangeToMap:map.ID];
    }
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
    // TODO::
}

- (void)mapChangeToID:(NSString *)mapID
{
    [[mapID retain] autorelease];
    if (![JBMapManager getMapWithID:mapID]) {
        self.requestTitelLabel.text = [NSString stringWithFormat:@">%@< map missing!",[mapID substringFromIndex:3]];
        self.requestMessageLabel.text = @"Do you want to transfer it?";
        self.missingMapID = mapID;
        self.requestedMapID = nil;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.requestPopout.frame = self.requestPopout.frame = CGRectMake(120, 0, 240, 120);
        [UIView commitAnimations];
    }else{
        self.missingMapID = nil;
        self.requestedMapID = nil;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        self.requestPopout.frame = self.requestPopout.frame = CGRectMake(120, -120, 240, 120);
        [UIView commitAnimations];
        
        NSString*prefix = [mapID substringWithRange:NSMakeRange(0, 3)];
        for (NSDictionary* dict in self.maptypes) {
            if ([prefix isEqualToString:[dict objectForKey:jbID]]) {
                self.selectedMapType =  [self.maptypes indexOfObject:dict];
                [self.gameTypeButton setTitle:[dict objectForKey:jbNAME] forState:UIControlStateNormal];
                self.maps = [JBMapManager getAllMapsWithPrefix:prefix];
                [self.mapsTablleView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
                for (JBMap* map in self.maps) {
                    if ([map.ID isEqualToString:mapID]) {
                        [self.mapsTablleView selectRowAtIndexPath:
                         [NSIndexPath indexPathForRow:[self.maps indexOfObject:map] inSection:0]
                                                         animated:YES scrollPosition:UITableViewScrollPositionTop];
                    }
                }
            }
        }
    }
}

- (void)newMapReceiving
{
    self.requestMessageLabel.text = @"receiving map data";
}

- (void)mapRequestReceivedForID:(NSString *)mapID
{
    self.requestTitelLabel.text = [NSString stringWithFormat:@"another player lacks >%@<",[mapID substringFromIndex:3]];
    self.requestMessageLabel.text = @"Do you want to transfer it?";
    self.missingMapID = nil;
    self.requestedMapID = mapID;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    self.requestPopout.frame = self.requestPopout.frame = CGRectMake(120, 0, 240, 120);
    [UIView commitAnimations];
}

@end
