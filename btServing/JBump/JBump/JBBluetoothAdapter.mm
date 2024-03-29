//
//  JBBluetoothAdapter.m
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBBluetoothAdapter.h"
#import "JBPreGameViewController.h"
#import "JBHero.h"
#import "SBJson.h"
#import "JBTavern.h"
#import "JBMapManager.h"
#import "JBMap.h"


@implementation JBBluetoothAdapter

@synthesize gameSession;
@synthesize activePeer;
@synthesize preGameDelegate;
@synthesize jsonWriter;
@synthesize jsonParser;
@synthesize activeDataTransfers;


- (id)init
{
    self = [super init];
    if (self) {
        self.jsonParser = [[SBJsonParser new] autorelease];
        self.jsonWriter = [[SBJsonWriter new] autorelease];
        self.activeDataTransfers = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)setupConnectionForPreGameViewController:(JBPreGameViewController*)aPreGameDelegate
{
	self.preGameDelegate = aPreGameDelegate;
	GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	
	
	[picker show];
}

#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state) {
		case GKPeerStateAvailable:
			NSLog(@"session status: GKPeerStateAvailable");
			break;
		case GKPeerStateUnavailable:
			NSLog(@"session status: GKPeerStateUnavailable");
			break;
		case GKPeerStateConnected:
			NSLog(@"session status: GKPeerStateConnected");
			if (session == gameSession) {
				self.activePeer = peerID;
                [self announcePlayerWithNewID:YES];
                session.delegate = self;
			}
			
			break;
		case GKPeerStateDisconnected:
			NSLog(@"session status: GKPeerStateDisconnected");
			break;
		case GKPeerStateConnecting:
			NSLog(@"session status: GKPeerStateConnecting");
			break;
			
		default:
			break;
	}

}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
     NSLog(@"Connection with Peer did Fail With Error %@", error);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
    NSLog(@"Session did Fail With Error %@", error);
}

#pragma mark GKPeerPickerControllerDelegate

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
    if (type == GKPeerPickerConnectionTypeOnline) {
        picker.delegate = nil;
        [picker dismiss];
        [picker autorelease];
    }
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
	int randomPos = rand()*0.999/RAND_MAX * (3000);
    GKSession* session = [[GKSession alloc] initWithSessionID:[NSString stringWithFormat:@"1",randomPos] displayName:@"jBump" sessionMode:GKSessionModePeer];
    [session autorelease];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    self.gameSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	
    picker.delegate = nil;
    // The controller dismisses the dialog automatically.
    [picker autorelease];
}

#pragma OUTGOING

- (void)sendPlayerReadyChange:(BOOL)ready
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|PRC:%d|%d",
     self.tavern.localPlayer.playerID,ready]; 
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}

}

- (void)announcePlayerWithNewID:(BOOL)newIDRequest
{
	if (newIDRequest) {
        char randomID = rand()*0.999/RAND_MAX * (255);
		while(randomID == '|'){
            randomID = rand()*0.999/RAND_MAX * (255);
        }
		self.tavern.localPlayer.playerID = randomID;
        [self.tavern exchangeLocalPlayer];
	}
    NSString* sendString = 
	[NSString stringWithFormat:	@"|NPA:%d|%@|%@",
     self.tavern.localPlayer.playerID,
     self.tavern.localPlayer.name,
     [jsonWriter stringWithObject:self.tavern.localPlayer.gameContext]]; 
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)disconnectPlayer
{
	//Player DisCoNnected
	NSString* sendString = 
	[NSString stringWithFormat:	@"|DCN:%d",
        self.tavern.localPlayer.playerID,
        self.tavern.localPlayer.name]; 
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
	[self.gameSession disconnectFromAllPeers];
	self.activePeer = nil;
}

- (void)requestForPlayerAnnouncement:(NSString *)playerID
{
	//Player Announcement Request
	NSString* sendString = 
	[NSString stringWithFormat:	@"|PAR:%d",[playerID intValue]];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)shoutPlayerGameContextChange:(JBHero*)aHero 
{	
	NSString* sendString = 
	[NSString stringWithFormat:	@"|PGC:%d|%@",
     aHero.playerID,
     [jsonWriter stringWithObject:aHero.gameContext]];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)shoutMapChangeToMap:(NSString *)mapID
{	
	NSString* sendString = 
	[NSString stringWithFormat:	@"|MCG:%@",mapID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)player:(JBHero*)killedPlayer KilledByChar:(JBHero *)player
{
	// Player Killed by Char
	// 1st Killer
	// 2nd Killed
	
	NSString* sendString = 
	[NSString stringWithFormat:	@"|PKC:%d|%d",
     killedPlayer.playerID,
     player.playerID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendUserInput:(NSString *)inputs
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|SUI:%d|%@",
     self.tavern.localPlayer.playerID,inputs];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendPlayer
{
    int length = [self.tavern.heroesInTavern allKeys].count*(3*sizeof(float)+sizeof(int)+sizeof(int)+sizeof(int))+
                  self.tavern.entitiesInTavern.count*(3*sizeof(float)+sizeof(int)+sizeof(int)+sizeof(int))+sizeof(int);
    void* sendField = malloc(length);
    int packageNr = self.tavern.localPlayer.packageNr = self.tavern.localPlayer.packageNr+2;
 	((int*)sendField)[0]=packageNr<<8;
    int index = 1;
    NSArray *allHeroes = [[[self.tavern.heroesInTavern allValues] retain] autorelease];
    for (JBHero* hero in allHeroes) {
        ((short*)sendField)[2*index]=hero.playerID;
        ((short*)sendField)[2*index+1]=hero.sprite.flipX;
        index++;
        ((float*)sendField)[index]=hero.sprite.position.x;
        index++;
        ((float*)sendField)[index]=hero.sprite.position.y;
        index++;
        ((float*)sendField)[index]=hero.sprite.rotation;
        index++;
        ((int*)sendField)[index]=0;
        index++;
        ((int*)sendField)[index]=0;
        index++;
    }
    
    for (JBEntity* entity in self.tavern.entitiesInTavern) {
        ((short*)sendField)[2*index]=0;
        ((short*)sendField)[2*index+1]=entity.sprite.flipX;
        index++;
        ((float*)sendField)[index]=entity.sprite.position.x;
        index++;
        ((float*)sendField)[index]=entity.sprite.position.y;
        index++;
        ((float*)sendField)[index]=entity.sprite.rotation;
        index++;
        ((int*)sendField)[index]=[entity.ID hash];
        index++;
        ((int*)sendField)[index]=[self.tavern.entitiesInTavern indexOfObject:entity];
        index++;
    }
    
	NSData* sendData = [NSData dataWithBytesNoCopy:sendField length:length freeWhenDone:YES];
	
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendBall
{
    JBEntity* ball = self.tavern.ball;
    
	void* sendField = malloc(sizeof(int)+sizeof(short)*2+sizeof(char)*2);
    int packageNr = self.tavern.ball.packageNr++;
 	((int*)sendField)[0]=packageNr<<8;
	((char*)sendField)[0]= [@"ball" hash];
	((short *)sendField)[2]=ball.body->GetWorldCenter().x*PTM_RATIO;
	((short *)sendField)[3]=ball.body->GetWorldCenter().y*PTM_RATIO;
	((char *)sendField)[8]=ball.body->GetLinearVelocity().x*126.f/HERO_MAXIMUMSPEED;
	((char *)sendField)[9]=ball.body->GetLinearVelocity().y*126.f/HERO_MAXIMUMSPEED;
    
	NSData* sendData = [NSData dataWithBytesNoCopy:sendField length:5*sizeof(float) freeWhenDone:YES];
	
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendData:(NSData *)data 
            info:(NSDictionary *)info 
        selector:(SEL)sel 
  finishDelegate:(id)fDelegate
progressDelegate:(id<JBProgressDelegate>)pDelegate
{    
    NSString* transferID = [NSString stringWithFormat:@"%05d",1];
    NSString* transferSize = [NSString stringWithFormat:@"%08d",data.length];
    
    
    NSData* infoData = [jsonWriter dataWithObject:info];
    NSString* sendString = [NSString stringWithFormat:@"|ISR:%@%@",transferID,transferSize];
    NSMutableData* sendData = [[sendString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [sendData appendData:infoData];
    
    if (self.activePeer) {
        NSError* error = nil;
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataReliable 
							 error:&error];
    }
    
    
    
    [self.activeDataTransfers setObject:data forKey:transferID];
    [self.activeDataTransfers setObject:@"0" forKey:[NSString stringWithFormat:@"%@pos",transferID]];
    [self.activeDataTransfers setObject:NSStringFromSelector(sel) forKey:[NSString stringWithFormat:@"%@sel",transferID]];
    [self.activeDataTransfers setObject:fDelegate forKey:[NSString stringWithFormat:@"%@fdel",transferID]];
    [self.activeDataTransfers setObject:pDelegate forKey:[NSString stringWithFormat:@"%@pdel",transferID]];
}

- (void)continueDataTransfer:(NSString *)transferID
{
    NSData* data = [self.activeDataTransfers objectForKey:transferID];
    int pos = [[self.activeDataTransfers objectForKey:[NSString stringWithFormat:@"%@pos",transferID]] intValue];
    id<JBProgressDelegate> pDelegate = [self.activeDataTransfers objectForKey:
                                        [NSString stringWithFormat:@"%@pdel",transferID]];
    [pDelegate transferWithID:transferID updatedProgress:((float)pos)/data.length];
    
    int length = data.length -pos<2000?data.length -pos:2000;
    NSString* sendString = [NSString stringWithFormat:@"|IDS:%@",transferID];
    NSMutableData* sendData = [[sendString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [sendData appendData:[data subdataWithRange:NSMakeRange(pos, length)]];
    
    if (data.length == length+pos) {
        NSLog(@"transfer finished");
        SEL sel = NSSelectorFromString([self.activeDataTransfers objectForKey:[NSString stringWithFormat:@"%@sel",transferID]]);
        id delegate = [self.activeDataTransfers objectForKey:[NSString stringWithFormat:@"%@fdel",transferID]];
        
        [delegate performSelector:sel];
    }
    
    if (self.activePeer) {
        NSError* error = nil;
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:&error];
    }
    [self.activeDataTransfers setObject:data forKey:transferID];
    [self.activeDataTransfers setObject:[NSString stringWithFormat:@"%d",pos+length]
                                  forKey:[NSString stringWithFormat:@"%@pos",transferID]];
}

- (void)aboardDataTransferWithID:(NSString *)transferID
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|IAT:%@",transferID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable
							 error:nil];
	}
}

- (void)askForNextDataTransferWithID:(NSString *)transferID
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|IND:%@",transferID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable
							 error:nil];
	}
}

- (void)askForMapWithID:(NSString *)mapID
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|MDR:%@",mapID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable
							 error:nil];
	}
}

- (void)sendMapForID:(NSString *)mapID progrossDelegate:(id<JBProgressDelegate>)delegate
{
    
    JBMap* map = [JBMapManager getMapWithID:mapID];
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    [info setObject:jbBT_TRANSFERTYPE_MAP forKey:jbBT_TRANSFERTYPE];
    [info setObject:mapID forKey:jbID];
    
    
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:map.infoLocal];
    NSData* infoData = [jsonWriter dataWithObject:dict];
    NSData* arenaImageData = [NSData dataWithContentsOfFile:map.arenaImageLocal];
    NSData* thumbnailData = [NSData dataWithContentsOfFile:map.thumbnailLocal];
    
    [info setObject:[NSNumber numberWithInt:infoData.length] forKey:@"infoLength"];
    [info setObject:[NSNumber numberWithInt:arenaImageData.length] forKey:@"arenaImageLength"];
    [info setObject:[NSNumber numberWithInt:thumbnailData.length] forKey:@"thumbnailLength"];
    
    NSMutableData* sendData = [NSMutableData dataWithData:infoData];
    [sendData appendData:arenaImageData];
    [sendData appendData:thumbnailData];
    
    [self sendData:sendData info:info selector:@selector(mapTransferCompleted) finishDelegate:preGameDelegate progressDelegate:delegate];
}

#pragma mark --- INCOMMING MESSSAGES ---

- (BOOL)handlePlayerAnnouncement:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|NPA:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        char playerID = [[parts objectAtIndex:0] intValue];
        NSString* playerName = [parts objectAtIndex:1];
        NSDictionary* gameContext = [jsonParser objectWithString:[parts objectAtIndex:2]];
        JBHero* player = [[[JBHero alloc] initWithPlayerId:playerID playerName:playerName gameContext:gameContext] autorelease];
        [self.tavern addNewPlayer:player];
		[self.preGameDelegate newPlayerAnnounced:nil];
        return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handlePlayerReadyChange:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PRC:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        BOOL ready = [[parts objectAtIndex:1] boolValue];
        
        [preGameDelegate player:[parts objectAtIndex:0] didReadyChange:ready];
    
        return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleDisconnectedPlayer:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|DCN:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        char playerID = [announcement intValue];
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handleRequestForPlayerAnnouncement:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PAR:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        char playerID = [announcement intValue];
        
        return TRUE;
    }else{
        return FALSE;
    }
}


- (BOOL)handlePlayerGameContextChange:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PGC:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        char playerID = [[parts objectAtIndex:0] intValue];
        NSDictionary* gameContext = [jsonParser objectWithString:[parts objectAtIndex:1]];
        
        [self.tavern player:playerID didChangeContext:gameContext];
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handlePlayerKilledByPlayer:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PKC:"]) {
        NSLog(@"received a killcount");
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        char killedPlayerID = [[parts objectAtIndex:0] intValue];
        char killingPlayerID = [[parts objectAtIndex:1] intValue];
        
        [self.tavern receivedAKill:killingPlayerID forKilledPlayer:killedPlayerID];
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handleMapChange:(NSString *)inputString
{
    if ([inputString hasPrefix:@"|MCG:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        [preGameDelegate mapChangeToID:announcement];
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handleMapRequest:(NSString *)inputString
{
    if ([inputString hasPrefix:@"|MDR:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        [preGameDelegate mapRequestReceivedForID:announcement];
        return TRUE;
    }else{
        return FALSE;
    }
}

- (void)handlePlayerPositionUpdates:(NSData *)data
{
    int packackgeNr = ((int *)[data bytes])[0]>>8;
    int length = ([data length] -4)/24;
    
    NSMutableArray* heroes = [NSMutableArray array];
    NSMutableArray* entities = [NSMutableArray array];
    for (int i=0;i<length;i++)
    {
        if (((short *)[data bytes])[2+12*i]) {
            NSMutableDictionary* heroDict = [NSMutableDictionary dictionary];
            [heroDict setObject:[NSNumber numberWithInt:((short *)[data bytes])[2+12*i]] forKey:jbID];
            [heroDict setObject:[NSNumber numberWithInt:((short *)[data bytes])[3+12*i]] forKey:jbFLIPX];
            float posX = ((float *)[data bytes])[2+6*i];
            float posY = ((float *)[data bytes])[3+6*i];
            CGPoint pos = CGPointMake(posX, posY);
            [heroDict setObject:NSStringFromCGPoint(pos) forKey:jbPOSITION];
            [heroDict setObject:[NSNumber numberWithFloat:((float *)[data bytes])[4+6*i]] forKey:jbROTATION];
            [heroes addObject:heroDict];
        }else{
            NSMutableDictionary* entityDict = [NSMutableDictionary dictionary];
            [entityDict setObject:[NSNumber numberWithInt:((short *)[data bytes])[3+12*i]] forKey:jbFLIPX];
            float posX = ((float *)[data bytes])[2+6*i];
            float posY = ((float *)[data bytes])[3+6*i];
            CGPoint pos = CGPointMake(posX, posY);
            [entityDict setObject:NSStringFromCGPoint(pos) forKey:jbPOSITION];
            [entityDict setObject:[NSNumber numberWithFloat:((float *)[data bytes])[4+6*i]] forKey:jbROTATION];
            [entityDict setObject:[NSNumber numberWithInt:((int *)[data bytes])[5+6*i]] forKey:@"id_hash"];
            [entityDict setObject:[NSNumber numberWithInt:((int *)[data bytes])[6+6*i]] forKey:@"index"];
            [entities addObject:entityDict];
        }
        
    }
    
    [self.tavern setAllHeroSpritesInWorld:heroes withPackageNumber:packackgeNr++];
    [self.tavern setAllEntitiesInWorld:entities withPackageNumber:packackgeNr];
    
    /*
	unsigned char playerID = ((char *)[data bytes])[0];
	int packageNr = ((int *)[data bytes])[0]>>8;
	CGPoint position = CGPointMake(((short *)[data bytes])[2]/PTM_RATIO, ((short *)[data bytes])[3]/PTM_RATIO);
    float velocityX = ((char *)[data bytes])[8]*HERO_MAXIMUMSPEED/126.f;
    float velocityY = ((char *)[data bytes])[9]*HERO_MAXIMUMSPEED/126.f;
    float forceX = ((short *)[data bytes])[5]/15.;
    float forceY = ((short *)[data bytes])[6]/15.;
    
    if (playerID == (unsigned char)[@"ball" hash]) {
        [self.tavern updateBallWithPositionx:position velocityX:velocityX andVelocityY:velocityY];
    }else{
        [self.tavern player:playerID changedPosition:position velocityX:velocityX velocityY:velocityY forceX:(float)forceX forceY:(float)forceY withPackageNR:packageNr];
    }
     */
    
}

- (BOOL)handleDataSendRequestIncomming:(NSString*)inputString
{
    if ([inputString hasPrefix:@"|ISR:"]) {
        NSString* transferID = [inputString substringWithRange:NSMakeRange(5, 5)];
        NSString* transferSize = [inputString substringWithRange:NSMakeRange(10, 8)];
        if ([self.activeDataTransfers objectForKey:transferID]) {
            [self aboardDataTransferWithID:(NSString *)transferID];
        }
        else{
            [self.activeDataTransfers setObject:transferSize forKey:transferID];
            [self askForNextDataTransferWithID:transferID];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:transferID];
            [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
            NSDictionary* info = [jsonParser objectWithString:[inputString substringFromIndex:18]];
            [self.activeDataTransfers setObject:info forKey:[NSString stringWithFormat:@"%@info",transferID]];
        }
        return TRUE;
    }
    return FALSE;
}

- (BOOL)handleNextDataRequestIncomming:(NSString *)inputString
{
    if ([inputString hasPrefix:@"|IND:"]) {
        NSString* transerID = [inputString substringWithRange:NSMakeRange(5, 5)];
        [self continueDataTransfer:transerID];
        return TRUE;
    }
    return FALSE;
}

- (BOOL)handleAboardTransferRequest:(NSString *)inputString
{
    if ([inputString hasPrefix:@"|IAT:"]) {
        NSString* transerID = [inputString substringWithRange:NSMakeRange(5, 5)];
        [self.activeDataTransfers removeObjectForKey:transerID];
        [self.activeDataTransfers removeObjectForKey:[NSString stringWithFormat:@"%@pos",transerID]];
        return TRUE;
    }
    return FALSE;
}

- (BOOL)handleTransferDataIncomming:(NSData *)data
{
    NSString* inputString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 5)] encoding:NSUTF8StringEncoding];
    if (inputString) {
        if ([inputString isEqualToString:@"|IDS:"]) {
            [data retain];
            [inputString release];
            NSString* transferID = [[[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, 5)] encoding:NSUTF8StringEncoding] autorelease];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* path = [[paths objectAtIndex:0] stringByAppendingPathComponent:transferID];
            NSFileHandle* file = [NSFileHandle fileHandleForWritingAtPath:path];
            [file seekToEndOfFile];
            [file writeData:[data subdataWithRange:NSMakeRange(10, data.length-10)]];
            [file offsetInFile];
            id<JBProgressDelegate> delegate = [preGameDelegate newMapReceiving];
            [delegate transferWithID:transferID updatedProgress:((float)[file offsetInFile])/[[self.activeDataTransfers objectForKey:transferID] intValue]];
            
            NSLog(@"imageDataLength:%d",(int)[file offsetInFile]);
            if ([file offsetInFile] == [[self.activeDataTransfers objectForKey:transferID] intValue]) {
                NSDictionary* info = [self.activeDataTransfers objectForKey:[NSString stringWithFormat:@"%@info",transferID]];
                if ([[info objectForKey:jbBT_TRANSFERTYPE] isEqualToString:jbBT_TRANSFERTYPE_MAP]) {
                    NSData* mapData = [NSData dataWithContentsOfFile:path];
                    NSRange infoRange = NSMakeRange(0,[[info objectForKey:@"infoLength"] intValue]);
                    NSRange arenaRange = NSMakeRange(infoRange.length+infoRange.location,
                                                    [[info objectForKey:@"arenaImageLength"] intValue]);
                    NSRange thumbnailRange = NSMakeRange(arenaRange.length+arenaRange.location,
                                                    [[info objectForKey:@"thumbnailLength"] intValue]);
                    NSDictionary* mapInfo = [jsonParser objectWithData:[mapData subdataWithRange:infoRange]];
                    NSData* mapArena = [mapData subdataWithRange:arenaRange];
                    NSData* mapThumbnail = [mapData subdataWithRange:thumbnailRange];
                    NSString* mapID = [info objectForKey:jbID];
                    [JBMapManager storeNewMapWithID:mapID infoData:mapInfo arenaImageData:mapArena thumbnailImageData:mapThumbnail];
                    [preGameDelegate mapChangeToID:mapID];
                }
                
                
            }else{
                [self askForNextDataTransferWithID:transferID];
            }
            return TRUE;
        }else{
            [inputString release];
            return FALSE;
        }
    }else{
        return FALSE;
    }
}


- (BOOL)handlePregame:(NSString *)inputString
{
    if (![self handleMapRequest:inputString]) {
        if (![self handleMapChange:inputString]) {
            if (![self handlePlayerReadyChange:inputString]) {
                if (![self handlePlayerAnnouncement:inputString]) {
                    return FALSE;
                }
            }
        }
    }
    return TRUE;
}

- (BOOL)handleReceiveUserInput:(NSString *)inputString
{
    if ([inputString hasPrefix:@"|SUI:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        int playerID = [[parts objectAtIndex:0] intValue];
        NSString* inputs = [parts objectAtIndex:1];
        JBHero* hero = [self.tavern getPlayerWithReference:playerID];
        
        if ([[hero.userInput substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"J"]
            &&[[inputs substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"X"]) {
            hero.jumpTouched = NO;
        }
        hero.userInput = inputs;
        
        return TRUE;
	}else {
		return FALSE;
	}
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSString* inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (inputString) {
        if (![self handleReceiveUserInput:inputString]) {
            if (![self handlePregame:inputString]) {
                if (![self handleDisconnectedPlayer:inputString]) {
                    if (![self handleRequestForPlayerAnnouncement:inputString]) {
                        if (![self handlePlayerGameContextChange:inputString]) {
                            if (![self handlePlayerKilledByPlayer:inputString]) {
                                if (![self handleDataSendRequestIncomming:inputString]) {
                                    if (![self handleNextDataRequestIncomming:inputString]) {
                                        if (![self handleAboardTransferRequest:inputString]) {
                                            if (![self handleTransferDataIncomming:data]) {
                                                [self handlePlayerPositionUpdates:data];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }else
    {
        if (![self handleTransferDataIncomming:data]) {
            [self handlePlayerPositionUpdates:data];
        }
    }
}



@end
