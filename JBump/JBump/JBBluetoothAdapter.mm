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


@implementation JBBluetoothAdapter

@synthesize gameSession;
@synthesize activePeer;
@synthesize preGameDelegate;
@synthesize jsonWriter;
@synthesize jsonParser;


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
				//[self sendSkinInfo:nil];
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

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession: (GKSession *) session {
    self.gameSession = session;
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
    picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
	
	[creator performSelector:selector];
	
	
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	
    picker.delegate = nil;
    // The controller dismisses the dialog automatically.
    [picker autorelease];
}

#pragma mark ?

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSLog(@"RECEIVED DATA...");
}


#pragma GAME SETUP --- INCOMMING


- (void)announcePlayerWithNewID:(BOOL)newIDRequest
{
	if (newIDRequest) {
		char randomID = rand()*0.999/RAND_MAX * (255);
		super.tavern.localPlayer.reference = randomID;
	}
	
	// New Player Announcement
	// 1st Position for chrID
	// 2nd Position to provide GameContext
	// 3rd Position to send playername
	NSString* sendString = 
	[NSString stringWithFormat:	@"|NPA:%03d|%@|%@",
     super.tavern.localPlayer.reference,
     [jsonWriter stringWithObject:super.tavern.localPlayer.gameContext],
     super.tavern.localPlayer.name]; 
	
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
	[NSString stringWithFormat:	@"|DCN:%03d",
        super.tavern.localPlayer.reference,
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
	[NSString stringWithFormat:	@"|PAR:%03d",[playerID intValue]];
	
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
	[NSString stringWithFormat:	@"|PGC:%03d|%@",
     super.tavern.localPlayer.reference,
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
	[NSString stringWithFormat:	@"|PKC:%03d|%03d",
     super.tavern.localPlayer.reference,
     player.reference];
	
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
 	((int*)sendField)[0]=player.packageNr++<<8;
	((char*)sendField)[0]=player.reference;
	((short *)sendField)[2]=player.body->GetWorldCenter().x;
	((short *)sendField)[3]=player.body->GetWorldCenter().y;
	((char *)sendField)[8]=player.body->GetLinearVelocity().x*255./20.;
	((char *)sendField)[9]=player.body->GetLinearVelocity().y*255./20.;
    
	NSData* sendData = [NSData dataWithBytesNoCopy:sendField length:5*sizeof(float) freeWhenDone:YES];
	
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

#pragma mark --- INCOMMING MESSSAGES ---

- (BOOL)handlePlayerAnnouncement:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|NPA:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
        NSArray* parts = [announcement componentsSeparatedByString:@"|"];
        char playerID = [[parts objectAtIndex:0] charValue];
        NSString* playerName = [parts objectAtIndex:1];
        NSDictionary* gameContext = [jsonParser objectWithString:[parts objectAtIndex:2]];
        
		[self.preGameDelegate newPlayerAnnounced:nil];
        return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleDisconnectedPlayer:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|DCN:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
        char playerID = [announcement intValue];
        
        return TRUE;
    }else{
        return FALSE;
    }
}

- (BOOL)handleRequestForPlayerAnnouncement:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PAR:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
        char playerID = [announcement intValue];
        
        return TRUE;
    }else{
        return FALSE;
    }
}


- (BOOL)handlePlayerGameContextChange:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|PGC:"]) {
		NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
        char playerID = [announcement intValue];
        
        return TRUE;
    }else{
        return FALSE;
    }
}




@end
