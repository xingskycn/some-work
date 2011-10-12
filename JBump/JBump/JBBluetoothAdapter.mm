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


@implementation JBBluetoothAdapter

@synthesize gameSession;
@synthesize activePeer;
@synthesize preGameDelegate;
@synthesize jsonWriter;
@synthesize jsonParser;


- (id)init
{
    self = [super init];
    if (self) {
        self.jsonParser = [[SBJsonParser new] autorelease];
        self.jsonWriter = [[SBJsonWriter new] autorelease];
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

#pragma GAME SETUP --- INCOMMING

- (void)sendPlayerReadyChange:(BOOL)ready
{
    NSString* sendString = 
	[NSString stringWithFormat:	@"|PRC:%d|%d",
     super.tavern.localPlayer.playerID,ready]; 
	
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
		super.tavern.localPlayer.playerID = randomID;
        [super.tavern exchangeLocalPlayer];
	}
	
	// New Player Announcement
	// 1st Position for chrID
	// 2nd Position to provide GameContext
	// 3rd Position to send playername
	NSString* sendString = 
	[NSString stringWithFormat:	@"|NPA:%d|%@|%@",
     super.tavern.localPlayer.playerID,
     super.tavern.localPlayer.name,
     [jsonWriter stringWithObject:super.tavern.localPlayer.gameContext]]; 
	
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
        super.tavern.localPlayer.playerID,
        super.tavern.localPlayer.name]; 
	
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

- (void)shoutPlayerGameContextChange
{
	// Player Gamecontext Change
	// 1st chrID
	// 2nd new gamecontext
	
	NSString* sendString = 
	[NSString stringWithFormat:	@"|PGC:%d|%@",
     super.tavern.localPlayer.playerID,
     super.tavern.localPlayer.gameContext];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}


- (void)playerKilledByChar:(JBHero *)player
{
	// Player Killed by Char
	// 1st Killer
	// 2nd Killed
	
	NSString* sendString = 
	[NSString stringWithFormat:	@"|PKC:%d|%d",
     super.tavern.localPlayer.playerID,
     player.playerID];
	
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
    JBHero* player = super.tavern.localPlayer;
    
	void* sendField = malloc(sizeof(int)+sizeof(short)*2+sizeof(char)*2);
    int packageNr = super.tavern.localPlayer.packageNr++;
 	((int*)sendField)[0]=packageNr<<8;
	((char*)sendField)[0]= super.tavern.localPlayer.playerID;
	((short *)sendField)[2]=player.body->GetWorldCenter().x*PTM_RATIO;
	((short *)sendField)[3]=player.body->GetWorldCenter().y*PTM_RATIO;
	((char *)sendField)[8]=player.body->GetLinearVelocity().x*255.f/HERO_MAXIMUMSPEED;
	((char *)sendField)[9]=player.body->GetLinearVelocity().y*255.f/HERO_MAXIMUMSPEED;
    
	NSData* sendData = [NSData dataWithBytesNoCopy:sendField length:5*sizeof(float) freeWhenDone:YES];
	
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendImage:(UIImage *)image info:(NSDictionary *)info
{
    image = [UIImage imageNamed:@"brush_1.png"];
    info  = [NSMutableDictionary dictionary];
    [info setValue:@"ASDDDSA" forKey:@"ASA"];
    
    NSData* infoData = [jsonWriter dataWithObject:info];
    NSString* sendString = [NSString stringWithFormat:@"|IMG:%08d",infoData.length];
    NSMutableData* sendData = [[sendString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [sendData appendData:infoData];
    [sendData appendData:UIImagePNGRepresentation(image)];
    
    if (self.activePeer) {
        NSError* error;
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataReliable 
							 error:&error];
        NSLog(@"NSERROR IN SEND: %@",error);
	}
    
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
        [super.tavern addNewPlayer:player];
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
        char playerID = [[parts objectAtIndex:0] charValue];
        NSDictionary* gameContext = [jsonParser objectWithString:[parts objectAtIndex:1]];
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handlePlayerKilledByPlayer:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PGC:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(5,inputString.length-5)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        char killedPlayerID = [[parts objectAtIndex:0] charValue];
        char killingPlayerID = [[parts objectAtIndex:1] charValue];
        
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (void)handlePlayerPositionUpdates:(NSData *)data
{
	unsigned char playerID = ((char *)[data bytes])[0];
	int packageNr = ((char *)[data bytes])[0]>>8;
	CGPoint position = CGPointMake(((short *)[data bytes])[2]/PTM_RATIO, ((short *)[data bytes])[3]/PTM_RATIO);
    float velocityX = ((char *)[data bytes])[8]*HERO_MAXIMUMSPEED/255.f;
    float velocityY = ((char *)[data bytes])[9]*HERO_MAXIMUMSPEED/255.f;
    
    [self.tavern player:playerID changedPosition:position velocityX:velocityX velocityY:velocityY withPackageNR:packageNr];
}

- (BOOL)handleImgDataIncomming:(NSData *)data
{
    NSString* inputString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 5)] encoding:NSUTF8StringEncoding];
    if ([inputString isEqualToString:@"|IMG:"]) {
        [data retain];
        [inputString release];
        inputString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(5, 8)] encoding:NSUTF8StringEncoding];
        int infoLength = [inputString intValue];
        [inputString release];
        inputString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(13, infoLength)] encoding:NSUTF8StringEncoding];
        NSDictionary* info = [jsonParser objectWithString:inputString];
        [inputString release];
        UIImage* image = [UIImage imageWithData:[data subdataWithRange:NSMakeRange(13+infoLength, data.length-13-infoLength)]];
        
        NSLog(@"info:%@",info);
        NSLog(@"imagesize:%@",NSStringFromCGSize(image.size));
        
        
        [inputString release];
        return TRUE;
    }else{
        [inputString release];
        return FALSE;
    }
    
    
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSString* inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (inputString) {
        if (![self handlePlayerReadyChange:inputString]) {
            if (![self handlePlayerAnnouncement:inputString]) {
                if (![self handleDisconnectedPlayer:inputString]) {
                    if (![self handleRequestForPlayerAnnouncement:inputString]) {
                        if (![self handlePlayerGameContextChange:inputString]) {
                            if (![self handlePlayerKilledByPlayer:inputString]) {
                                if (![self handleImgDataIncomming:data]) {
                                    [self handlePlayerPositionUpdates:data];
                                }
                            }
                        }
                    }
                }
            }
        }
    }else
    {
        if (![self handleImgDataIncomming:data]) {
            [self handlePlayerPositionUpdates:data];
        }
    }
}



@end
