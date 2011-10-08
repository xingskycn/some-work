//
//  APPreGameViewController.m
//  AP
//
//  Created by Ziehn Nils on 6/22/11.
//  Copyright 2011 ziehn. All rights reserved.
//

#import "APPreGameViewController.h"

#import "APMapDict.h"
#import "APChar.h"
#import "APSkinDict.h"

#import "APPregameViewMapCell.h"
#import "APGameSelectionController.h"
#import "APAdapter.h"

@implementation APPreGameViewController
@synthesize maps;
@synthesize players;
@synthesize mapSelector;

- (void)viewDidLoad
{
	self.maps = [[APMapDict single] listMaps];
	
	self.players = [NSMutableArray array];
	
	NSMutableDictionary* playerInitDict = [NSMutableDictionary new];
	int selectedChar = [[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_ID"] intValue];
	
	UIImage* image = [[[[APSkinDict single] listSkins] objectAtIndex:selectedChar]objectForKey:@"image"];
	
	[playerInitDict setObject:image forKey:@"image"];
	[playerInitDict setObject:@"bunny_1" forKey:@"char_name"];
	[playerInitDict setObject:@"not_ready" forKey:@"game_context"];
	NSString* playerName;
	if(playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"])
		[playerInitDict setObject:playerName forKey:@"player_name"];
	
	APChar* playerChar = [[APChar alloc] initWithDict:playerInitDict];
	[playerInitDict release];
	
	[self.players addObject:playerChar];
	[playerChar release];
	
	[mapSelector reloadData];
	[playersTable reloadData];
	
	[mapSelector selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlayerConnected:) name:@"connection_incomming_ISI" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMapSelected:) name:@"connection_incomming_SNM" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerReadyChange:) name:@"connection_incomming_SRC" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStartedByPlayer:) name:@"connection_incomming_SGS" object:nil];
	[self readyChange];
}

- (void)gameStartedByPlayer:(NSNotification *)notification
{
	//NSString* playerName = [[notification userInfo] objectForKey:@"player_name"];
	[[APGameSelectionController single] showGameView];
	
}

- (void)playerReadyChange:(NSNotification *)notification
{
	NSString* playerName = [[notification userInfo] objectForKey:@"player_name"];
	for (APChar* chr in players) {
		if ([chr.nameLabel.text isEqualToString:playerName]) {
			chr.gameContext = [[notification userInfo] objectForKey:@"ready"];
		}
	}
	[playersTable reloadData];
	[self readyChange];
}

- (void)newPlayerConnected:(NSNotification *)notification
{
	APChar* newPlayer = [[APChar alloc] initWithDict:[notification userInfo]];
	[players addObject:newPlayer];
	[newPlayer release];
	[playersTable reloadData];
}

- (void)newMapSelected:(NSNotification *)notification
{
	NSString* mapID = [[notification userInfo] objectForKey:@"map_ID"];
	for (int i = 0; i < [self.maps count]; i++) {
		if ([[[self.maps objectAtIndex:i] objectForKey:@"map_ID"] isEqualToString:mapID]) {
			
			if (!([[mapSelector indexPathForSelectedRow] row]==i)) {
				[mapSelector selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
				
				NSString* playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
				for (APChar* chr in players) {
					if ([chr.nameLabel.text isEqualToString:playerName]) {
						if ([chr.gameContext isEqualToString:@"ready"]) {
							chr.gameContext = @"not ready";
							[[APAdapter single] sendPlayer:playerName readyChange:chr.gameContext];
							[playersTable reloadData];
							[self readyChange];
						}
						[[NSUserDefaults standardUserDefaults] setObject:mapID forKey:@"selected_map"];
						break;
					}
				}
				
			}
			return;
		}
	}
	
	NSLog(@"MAP NOT FOUND!");
	[[APAdapter single] sendNewMapID:[[self.maps objectAtIndex:[[mapSelector indexPathForSelectedRow] row]] objectForKey:@"map_ID"]];
}

- (IBAction)readyButtonPressed:(UIButton *)button
{
	APChar* player;
	NSString* oldReady;
	NSString* playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
	for (APChar* chr in players) {
		if ([chr.nameLabel.text isEqualToString:playerName]) {
			oldReady = chr.gameContext;
			player = chr;
			break;
		}
	}
	
	if ([oldReady isEqualToString:@"ready"]) {
		player.gameContext = @"not ready";
	}else
	{
		player.gameContext = @"ready";
	}
	[playersTable reloadData];
	[[APAdapter single] sendPlayer:playerName readyChange:player.gameContext];
	
	[self readyChange];
}

- (IBAction)startButtonPressed:(UIButton *)button
{
	[[APGameSelectionController single] showGameView];
	NSString* playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
	[[APAdapter single] sendGameStartedByPlayer:playerName];
}

- (IBAction)backButtonPressed:(UIButton *)button
{
	[[APGameSelectionController single] shutPreGameView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == mapSelector) {
		APPregameViewMapCell* cell = (APPregameViewMapCell *)[tableView dequeueReusableCellWithIdentifier:@"char_cell"];
		if (!cell) {
			cell = [[[APPregameViewMapCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"char_cell"] autorelease];
		}
		cell.mainView.image = [[self.maps objectAtIndex:[indexPath row]] objectForKey:@"image"];
		return cell;
	}else {
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"char_cell"];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"char_cell"] autorelease];
			
		}
		cell.imageView.image = [[players objectAtIndex:[indexPath row]] image];
		cell.textLabel.text = [[[players objectAtIndex:[indexPath row]] nameLabel] text];
		if([[[players objectAtIndex:[indexPath row]] gameContext] isEqualToString:@"ready"])
		{
			cell.detailTextLabel.text = @"ready";
			cell.detailTextLabel.textColor = [UIColor greenColor];
		}else {
			cell.detailTextLabel.text = @"not ready";
			cell.detailTextLabel.textColor = [UIColor redColor];
		}

		return cell;
	}

	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == mapSelector) {
		return 120;
	}else {
		return 80;
	}

}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == playersTable) {
		return [self.players count];
	}else {
		return [self.maps count];
	}
}

- (void)dealloc {
	self.maps = nil;
	self.players = nil;
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView==mapSelector) {
		NSString* mapID = [[self.maps objectAtIndex:[indexPath row]] objectForKey:@"map_ID"];
		[[NSUserDefaults standardUserDefaults] setObject:mapID forKey:@"selected_map"];
		[[APAdapter single] sendNewMapID:mapID];
	}else{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}

- (void)readyChange
{
	BOOL ready = TRUE;
	for (APChar* chr in players) {
		if (![chr.gameContext isEqualToString:@"ready"]) {
			ready = FALSE;
		}
	}
	
	if (ready) {
		startButton.alpha = 1;
		startButton.enabled = TRUE;
	}else {
		startButton.alpha = 0.5;
		startButton.enabled = FALSE;
	}

}

@end
