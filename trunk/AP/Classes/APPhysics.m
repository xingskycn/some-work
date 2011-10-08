//
//  APPhysics.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APPhysics.h"

#import "APAdapter.h"
#import "APChar.h"
#import "APMap.h"
#import "APMapField.h"
#import "APGameViewController.h"
#import "APStatsViewController.h"

@implementation APPhysics

@synthesize characters;
@synthesize maps;
@synthesize physTimer;
@synthesize player;
@synthesize adapter;
@synthesize stopped;
@synthesize gameView;
@synthesize gameMode;
@synthesize mapPosition;
@synthesize mapVelocity;

static APPhysics* single;

+ (APPhysics *)single
{	
	if (!single) {
		single = [APPhysics new];
	}
	return single;
}

- (id)init
{
	if (self = [super init]) {
		self.physTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(step) userInfo:nil repeats:YES];
		self.characters = [NSMutableDictionary new];
		[self.characters release];
		
		self.maps = [NSMutableArray new];
		[self.maps release];
		
		maxSpeed = 6;
		mapPosition = CGPointMake(0, 0);
	}
	return self;
}

- (void)dealloc
{
	self.characters = nil;
	self.maps = nil;
	self.physTimer = nil;
	self.player = nil;
	single = nil;
	[super dealloc];
}

- (void)step
{
	if (stopped || [self.maps count]==-1 || !self.player) {
		return;
	}
	self.gameView = [APGameViewController single];
	mapPosition = CGPointMake(mapPosition.x+mapVelocity.x, mapPosition.y+mapVelocity.y);
	
	inputSkipCounter ++;
	
	if (player.dead) {
		[player willBeSpawned];
		[self spawnCharacter:player];
	}
	
	for (NSString* chrID in self.characters) {
		APChar* chr;
		if (chr = [adapter.charUpdates objectForKey:chrID]) {
			[player interactWith:chr];
			[chr updateAppearance];
			[adapter.charUpdates removeObjectForKey:chrID];
		}else {
			chr = [self.characters objectForKey:chrID];
			[self calculatePhysicsForChar:chr withUserInput:NO];
			[player interactWith:chr];
			[chr updateAppearance];
		}
	}
	
	for (int i = 0; i < [self.characters count]; i++) {
		APChar* chr = [self.characters objectForKey:[[self.characters allKeys] objectAtIndex:i]];
		chr.timeToLive --;
		if (chr.timeToLive <=0) {
			[chr removeFromSuperview];
			[self.characters removeObjectForKey:chr.chrID];
			[[APGameViewController single].statsView updateStats];
		}
	}
	
	
	[self calculatePhysicsForChar:player withUserInput:YES];
	[player updateAppearance];
	
	
	if([self.gameMode isEqualToString:@"std"])
	{
		[[APGameViewController single] updatedPosition:CGRectMake(player.position.x, player.position.y, 0, 0)];
	}else if ([self.gameMode isEqualToString:@"run"]) {
		float width = 0;
		if ([maps count]>0) {
			width = [[maps lastObject] frame].size.width;
		}
		
		[[APGameViewController single] updatedPosition:CGRectMake(mapPosition.x, player.position.y, width, 0)];
	}
	
	
}

- (void)calculatePhysicsForChar:(APChar *)chr withUserInput:(BOOL)activeUserInput
{
	if (activeUserInput && [self calculateUserInputTiming]) {
		[chr updateUserInputSpeed];
		chr.onFloor = FALSE;
	}
	
	
	APMap* map = [maps lastObject];
	for (APMap* aMap in maps) {
		if (CGRectIntersectsRect(aMap.frame, chr.frame)) {
			map = aMap;
		}
	}
	
	if (chr.onLadder) {
		chr.speed = CGPointMake(chr.userInputSpeed.x,
								chr.userInputSpeed.y);
	}else if (chr.inWater) {
		chr.speed = CGPointMake(chr.speed.x+chr.userInputSpeed.x+map.waterGravity.x,
								chr.speed.y+chr.userInputSpeed.y+map.waterGravity.y);
		chr.speed = CGPointMake(chr.speed.x*0.6, chr.speed.y*0.6);
	}else {
		chr.speed = CGPointMake(chr.speed.x+chr.userInputSpeed.x+map.gravity.x,
								chr.speed.y+chr.userInputSpeed.y+map.gravity.y);
	}
	
	chr.inWater = FALSE;
	chr.onLadder = FALSE;
	
	if (abs(chr.speed.x)>chr.maxXSpeed && abs(chr.speed.x)<maxSpeed+4
		) {
		chr.speed = CGPointMake(chr.maxXSpeed*chr.speed.x/abs(chr.speed.x),chr.speed.y);
	}
	// Evtl nach oben schieben, dass es über die UserInput berechnungen kommt um eine gute JUMP berechnung zu machen!
	
	for (APMap* map in maps) {
		[map calculateMapInteractionForChar:chr activeUserInput:activeUserInput];
	}
	chr.position = CGPointMake(chr.position.x + chr.speed.x, chr.position.y + chr.speed.y);
	
	if ([gameMode isEqualToString:@"std"]) {
		if (chr.position.x<0) {
			chr.position = CGPointMake(0, chr.position.y);
		}
		
		int allMapsWidth = 0;
		for (APMap* map in maps) {
			allMapsWidth += map.frame.size.width;
		}
		
		if (chr.position.x>allMapsWidth) {
			chr.position = CGPointMake(allMapsWidth, chr.position.y);
		}
	}
	
	if (activeUserInput && [self calculateUserInputTiming])
	{
		[[APAdapter single] sendPlayer:chr];
	}
}

- (BOOL)calculateUserInputTiming
{
	BOOL pass = TRUE;
	switch (inputSkipCounter) {
		case 0:
			break;
		case 1:
			pass = TRUE;
			inputSkipCounter = 0;
			break;
		case 2:
			
			break;
		default:
			break;
	}
	return pass;
}

- (void)addChar:(APChar *)chr
{
	[characters setObject:chr forKey:chr.chrID];
	if([characters objectForKey:chr.chrID])
	{
		[[APGameViewController single].contentView addSubview:chr];
	}
	[[APGameViewController single].statsView updateStats];
}

- (void)charDisconnected:(APChar *)chr
{
	[characters removeObjectForKey:chr.chrID];
	[chr removeFromSuperview];
	[[APGameViewController single].statsView updateStats];
}

- (void)spawnCharacter:(APChar *)chr
{
	if ([maps count]== 0) {
		return;
	}
	if ([self.gameMode isEqualToString:@"std"]) {
		APMap* map = [maps lastObject];
		
		char* freemap = malloc(map.mapWidth*map.mapHeight*sizeof(char));
		memcpy(freemap,map.mapCharacteristics,map.mapWidth*map.mapHeight*sizeof(char));
		
		APMapField* field = [APMapField new];
		
		for (int x = 0; x < map.mapWidth; x++) {
			for (int y = 0; y < map.mapHeight; y++) {
				CGRect fieldRect = CGRectMake(x*field.size.width, y*field.size.height, field.size.width, field.size.height);
				for (APChar* chr in [characters allValues]) {
					
					CGRect avoidRect = CGRectMake(chr.frame.origin.x-20, chr.frame.origin.y-80, chr.frame.size.width+40, 200);
					
					if (CGRectIntersectsRect(avoidRect,fieldRect )) {
						freemap[x+map.mapWidth*y]=1;
					}
				}
				
				if(CGRectIntersectsRect(player.frame,fieldRect))
				{
					freemap[x+map.mapWidth*y]=1;
				}
			}
		}
		NSMutableArray* freepos = [NSMutableArray array];
		for (int x = 0; x < map.mapWidth; x++) {
			for (int y = 0; y < map.mapHeight; y++) {
				if(freemap[x+map.mapWidth*y]==0)
				{
					[freepos addObject:[NSNumber numberWithInt:x+map.mapWidth*y]];
				}
			}
		}
		if ([freepos count]>0) {
			int randomPos = rand()*0.999/RAND_MAX * ([freepos count]-1);
			chr.position = CGPointMake(([[freepos objectAtIndex:randomPos] intValue]%map.mapWidth)*40+field.size.width/2, ([[freepos objectAtIndex:randomPos ] intValue]/map.mapWidth)*40+field.size.height/2);
		}
		
		[field release];
		free(freemap);
	}else if ([self.gameMode isEqualToString:@"run"]) {
		
		
		APMapField* field = [APMapField new];
		NSMutableArray* freepos = [NSMutableArray array];
		
		for (APMap* map in maps) {
			char* freemap = malloc(map.mapWidth*map.mapHeight*sizeof(char));
			memcpy(freemap,map.mapCharacteristics,map.mapWidth*map.mapHeight*sizeof(char));
			
			CGRect bounds = [APGameViewController single].contentView.bounds;
			bounds = CGRectMake(bounds.origin.x+200, bounds.origin.y, bounds.size.width-200, bounds.size.height);
			
			for (int x = 0; x < map.mapWidth; x++) {
				for (int y = 0; y < map.mapHeight; y++) {
					CGRect fieldRect = CGRectMake(x*field.size.width+map.frame.origin.x, y*field.size.height, field.size.width, field.size.height);
					for (APChar* chr in [characters allValues]) {
						
						CGRect avoidRect = CGRectMake(chr.frame.origin.x-20, chr.frame.origin.y-80, chr.frame.size.width+40, 200);
						
						if (CGRectIntersectsRect(avoidRect,fieldRect )) {
							freemap[x+map.mapWidth*y]=-1;
						}	
					}
					if(CGRectIntersectsRect(player.frame,fieldRect))
					{
						freemap[x+map.mapWidth*y]=-1;
					}
					
					if (!CGRectContainsRect(bounds, fieldRect)) {
						freemap[x+map.mapWidth*y]=-1;
					}
				}
			}
			
			for (int x = 0; x < map.mapWidth; x++) {
				for (int y = 0; y < map.mapHeight; y++) {
					BOOL solid = FALSE;
					for (int i = y; i < map.mapHeight; i++) {
						if (freemap[x+map.mapWidth*i]==1) {
							solid = TRUE;
						}
					}
					
					if(freemap[x+map.mapWidth*y]==0 && solid)
					{
						[freepos addObject:[NSNumber numberWithInt:x+map.mapWidth*y+1000000*[maps indexOfObject:map]]];
					}
				}
			}
			
			if ([freepos count]==0) {
				NSLog(@"empawga");
			}
			
			free(freemap);
		}
		
		int randomPos = rand()*0.999/RAND_MAX * ([freepos count]-1);
		APMap* map = [maps objectAtIndex:[[freepos objectAtIndex:randomPos] intValue]/1000000];
		int mapOrigin = map.frame.origin.x;
		float posx = (([[freepos objectAtIndex:randomPos] intValue]%1000000)%map.mapWidth)*40+field.size.width/2+mapOrigin;
		float posy = (([[freepos objectAtIndex:randomPos ] intValue]%1000000)/map.mapWidth)*40+field.size.height/2;
		chr.position = CGPointMake(posx,posy);
		[field release];
		NSLog(@"chr.position: %f     %f",chr.position.x,chr.position.y);
	}
	
}

- (void)playerKilledByChar:(APChar *)chr
{
	[[APAdapter single] playerKilledByChar:chr];
}

- (void)playerKilledChar:(APChar *)chr
{
	int playerKills = [[player getGameContentsForKey:@"PKILLS{}:"] intValue];
	[player setGameContents:[NSString stringWithFormat:@"%d",++playerKills] ForKey:@"PKILLS{}:"];
	[[APAdapter single] shoutPlayerGameContextChange:player];
	[[APGameViewController single] scoredOnPlayer:chr];
	[[APGameViewController single].statsView updateStats];
}

- (void)gameContextUpdateForChr:(APChar *)chr
{
	[[APGameViewController single].statsView updateStats];
}

- (void)setStopped:(BOOL)stop
{
	if (stop) {
		[self.characters removeAllObjects];
		self.player = nil;
	}else {
		if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selected_map"] hasPrefix:@"r"]) {
			self.gameMode = @"run";
		}else {
			self.gameMode = @"std";
		}

	}

	stopped = stop;
}

- (void)setGameMode:(NSString *)mode
{
	if ([mode isEqualToString:@"std"]) {
		self.mapVelocity = CGPointMake(0, 0);
		self.mapPosition = CGPointMake(0, 0);
	}else if ([mode isEqualToString:@"run"]) {
		self.mapVelocity = CGPointMake(2, 0);
		self.mapPosition = CGPointMake(0, 0);
	}
	
	if (gameMode) {
		[gameMode release];
	}
	
	gameMode = [[mode copy] retain];
}

- (void)setMapVelocity:(CGPoint)velocity
{
	if ([gameMode isEqualToString:@"run"]) {
		mapVelocity = velocity.x>8?CGPointMake(8, velocity.y):  velocity.x<1?CGPointMake(1, velocity.y):velocity;
	}else {
		mapVelocity = velocity.x>8?CGPointMake(8, velocity.y):  velocity.x<0?CGPointMake(0, velocity.y):velocity;
	}

	player.maxXSpeed = velocity.x<6?6:velocity.x+2;
}


@end
