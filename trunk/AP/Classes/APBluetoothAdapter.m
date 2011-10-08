//
//  APBluetoothAdapter.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APBluetoothAdapter.h"

#import "APSkinDict.h"

@implementation APBluetoothAdapter

@synthesize gameSession;
@synthesize uploadString;
@synthesize activePeer;

static id single;

#pragma mark *ADAPTER SETUP 

+ (id)single
{
	if (!single) {
		single = [APBluetoothAdapter new];
	}
	return single;
}

- (void)setupConnectionForSender:(id)sender callback:(SEL)aSelector;
{
	creator = sender;
	selector = aSelector;
	GKPeerPickerController* picker = [[GKPeerPickerController alloc] init];
	picker.delegate = self;
	picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
	
	
	[picker show];
}



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
	// Use a retaining property to take ownership of the session.
    self.gameSession = session;
	// Assumes our object will also become the session's delegate.
    session.delegate = self;
    [session setDataReceiveHandler: self withContext:nil];
	// Remove the picker.
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

#pragma mark *SESSION HANDLING

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
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
				[self sendSkinInfo:nil];
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

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSLog(@"session connection Request");
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
	NSLog(@"session peer fail");
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
	NSLog(@"session fail with error");
}

#pragma mark *RECEIVEDATA

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	if (![self dataForGameSetup:data]) {
		NSString* inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		if (![self handleChrAnnouncement:inputString]) {
			if (![self handleDisconnectedPlayer:inputString]) {
				if (![self handleRequestForPlayerAnnouncement:inputString]) {
					if (![self handleChrKilledByPlayer:inputString]) {
						if (![self handleChrGameContextChange:inputString]) {
							[self handlePlayerPositionUpdates:data];
						}
					}
				}
			}
			
		}
		[inputString release];
	} 
}
	
- (BOOL)dataForGameSetup:(NSData *)data
{
	NSString* inputString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 4)] encoding:NSUTF8StringEncoding];
	
	if ([inputString hasPrefix:@"GSU:"]) {
		if(![self handleSkinImageData:data])
		{
			inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSArray* stringArray = [inputString componentsSeparatedByString:@"GSU:"];
			inputString = [stringArray objectAtIndex:1];
			if (![self handleSkinInfo:inputString]) {
				if (![self handleSkinRequest:inputString]) {
					if (![self handleNewMapSelesction:inputString]) {
						if (![self handlePlayerReadyChange:inputString]) {
							if (![self handleGameStartedByPlayer:inputString]) {
								
							}
						}
					}
				}
			}  
		}
			
		return YES;
	}else {
		return NO;
	}
}



#pragma mark ---- GAME SETUP INFORMATION EXCHANGE ----

#pragma mark *SEND METHODS

- (void)sendGameStartedByPlayer:(NSString *)playerName
{
	// Setup : Game Started
	// 1st player name
	NSString* sendString = [NSString stringWithFormat:@"GSU:SGS:%@",playerName];
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendNewMapID:(NSString *)mapID
{
	// Setup : New Map
	// 1st map ID
	NSString* sendString = [NSString stringWithFormat:@"GSU:SNM:%@",mapID];
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}


- (void)sendSkinInfo:(NSString *)info
{
	// Setup : Skin Request
	// 1st skin ID
	// 2nd skin name
	// 3rd skin playerName
	if (!info) {
		
		NSString* skinID = [[NSUserDefaults standardUserDefaults] objectForKey:@"skin_ID"];
		NSString* skinName = [[APSkinDict single] nameForSkinID:skinID];
		NSString* playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
		NSString* ready = @"not_ready";
		info = [NSString stringWithFormat:	@"GSU:SSI:%@SSI:%@SSI:%@SSI:%@",skinID,skinName,playerName,ready];
	}
	
	
	NSData* sendData = [info dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendPlayer:(NSString *)playerName readyChange:(NSString *)ready
{
	// Setup : Ready Change
	// 1st player name
	// 2nd ready
	if (!playerName) {
		playerName = [[NSUserDefaults standardUserDefaults] objectForKey:@"player_name"];
	}
	
	NSString* sendString = [NSString stringWithFormat:	@"GSU:SRC:%@SRC:%@",playerName,ready];
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendSkinRequest:(NSString *)skinID
{
	// Setup : Skin Request
	// 1st skin ID
	NSString* sendString = 
	[NSString stringWithFormat:	@"SSR:%@",skinID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

#pragma mark *INCOMMING MESSAGES

- (BOOL)handleGameStartedByPlayer:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"SGS:"];
	if ([stringArray count]==2) {
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		[dict setObject:[stringArray objectAtIndex:1] forKey:@"player_name"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"connection_incomming_SGS" object:nil userInfo:dict];
		
		return YES;
	}
	else {
		return FALSE;
	}

}


- (BOOL)handlePlayerReadyChange:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"SRC:"];
	if ([stringArray count]==3) {
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		[dict setObject:[stringArray objectAtIndex:1] forKey:@"player_name"];
		[dict setObject:[stringArray objectAtIndex:2] forKey:@"ready"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"connection_incomming_SRC" object:nil userInfo:dict];
		
		return TRUE;
	}else {
		return FALSE;
	}
}


- (BOOL)handleNewMapSelesction:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"SNM:"];
	if ([stringArray count]==2) {
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		[dict setObject:[stringArray objectAtIndex:1] forKey:@"map_ID"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"connection_incomming_SNM" object:nil userInfo:dict];
		
		return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleSkinInfo:(NSString *)input
{
	NSArray* stringArray = [input componentsSeparatedByString:@"SSI:"];
	if ([stringArray count]==5) {
		
		NSMutableDictionary* playerInitDict = [NSMutableDictionary new];
		
		if (![[APSkinDict single] skinLoadedForID:[stringArray objectAtIndex:1]]) {
			[self sendSkinRequest:[stringArray objectAtIndex:1]];
		}else {
			UIImage* image = [[APSkinDict single] imageForSkinID:[stringArray objectAtIndex:1]];
			[playerInitDict setObject:image forKey:@"image"];
		}

		[playerInitDict setObject:[stringArray objectAtIndex:1] forKey:@"skin_ID"];
		[playerInitDict setObject:[stringArray objectAtIndex:2] forKey:@"skin_name"];
		[playerInitDict setObject:[stringArray objectAtIndex:3] forKey:@"player_name"];
		[playerInitDict setObject:[stringArray objectAtIndex:4] forKey:@"game_context"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"connection_incomming_ISI" object:nil userInfo:playerInitDict];
		
		[playerInitDict release];
		
		return YES;
	} else {
		return NO;
	}	
}

- (BOOL)handleSkinRequest:(NSString *)input
{
	NSArray* stringArray = [input componentsSeparatedByString:@"SSR:"];
	if ([stringArray count]==2) {
		
		// Setup : Image Data
		// 1st skin ID
		// 2nd binary image data
		NSString* skinID = [stringArray objectAtIndex:1];
		NSString* skinName = [[APSkinDict single] nameForSkinID:skinID];
		NSData* imageData = UIImagePNGRepresentation([[APSkinDict single] imageForSkinID:skinID]);
		
		
		NSString* infoString = 
		[NSString stringWithFormat:@"GSU:SID:%@SID:%@SID:",skinID,skinName];
		
		NSString* sendString = @"                                                  ";   // 50chars
		sendString = [sendString stringByReplacingCharactersInRange:NSMakeRange(0,[infoString length]) withString:infoString];
		
		NSLog(@"sendString:%@",sendString);
		
		NSData* infoData = [sendString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
		NSMutableData* sendData = [infoData mutableCopy];
		[sendData appendData:imageData];
		
		NSError* error;
		
		if (self.activePeer) {
			if (![self.gameSession sendData:sendData
									toPeers:[NSArray arrayWithObject:self.activePeer] 
							   withDataMode:GKSendDataUnreliable 
									  error:&error]) {
				NSLog(@"ERROR SENDING: %@",error);
			}
		}

 		
		
		return YES;
	} else {
		return NO;
	}	
}

- (BOOL)handleSkinImageData:(NSData *)data
{	
	if ([data length]>50) {
		NSString* infoString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 49)] encoding:NSUTF8StringEncoding];
		
		NSArray* stringArray = [infoString componentsSeparatedByString:@"SID:"];
		if ([stringArray count]==4) {
			NSString* skinID = [stringArray objectAtIndex:1];
			NSString* skinName = [stringArray objectAtIndex:2];
			
			UIImage* image = [UIImage imageWithData:[data subdataWithRange:NSMakeRange(50, [data length]-51)]];
			
			NSMutableDictionary* dict = [NSMutableDictionary dictionary];
			[dict setObject:image forKey:@"image"];
			[dict setObject:skinID forKey:@"skin_ID"];
			[dict setObject:skinName forKey:@"skin_name"];
			
			[[APSkinDict single] skinLoaded:dict];
			
			return TRUE;
		}		
	}
	return FALSE;
}

#pragma mark ---- INGAME CONNECTION ----

#pragma mark *SEND METHODS
	 
- (void)announcePlayerWithNewID:(BOOL)newIDRequest
{
	if (newIDRequest) {
		int randomID = rand()*0.999/RAND_MAX * (255);
		[APPhysics single].player.chrID = [NSString stringWithFormat:@"%d",randomID];
	}
	
	// New Player Announcement
	// 1st Position for chrID
	// 2nd Position to provide GameContext
	// 3rd Position to send playername
	NSString* sendString = 
	[NSString stringWithFormat:	@"NPA:%@NPA:%@NPA:%@",
								[APPhysics single].player.chrID,
								[APPhysics single].player.gameContext,
								[APPhysics single].player.nameLabel.text]; 
	
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
	[NSString stringWithFormat:	@"DCN:%DCN:%DCN:%@",
	 [APPhysics single].player.chrID,
	 [APPhysics single].player.gameContext,
	 [APPhysics single].player.nameLabel.text]; 
	
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

- (void)requestForPlayerAnnouncement:(NSString *)chrID
{
	//Player Announcement Request
	NSString* sendString = 
	[NSString stringWithFormat:	@"PAR:%@",chrID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)shoutPlayerGameContextChange:(APChar *)chr
{
	// Player Gamecontext Change
	// 1st chrID
	// 2nd new gamecontext
	
	NSString* sendString = 
	[NSString stringWithFormat:	@"PGC:%@PGC:%@",chr.chrID,chr.gameContext];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}


- (void)playerKilledByChar:(APChar *)chr
{
	// Player Killed by Char
	// 1st Killer
	// 2nd Killed
	
	NSString* sendString = 
	[NSString stringWithFormat:	@"PKC:%@PKC:%@",chr.chrID,[APPhysics single].player.chrID];
	
	NSData* sendData = [sendString dataUsingEncoding:NSUTF8StringEncoding];
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

- (void)sendPlayer:(APChar *)chr
{
	void* sendField = malloc(sizeof(int)+sizeof(short)*2+sizeof(char)*2);
 	((int*)sendField)[0]=chr.packageNumber++;
	char chrIDNr = [chr.chrID intValue];
	((char*)sendField)[3]=chrIDNr;
	((short *)sendField)[2]=chr.position.x;
	((short *)sendField)[3]=chr.position.y;
	((char *)sendField)[8]=chr.speed.x;
	((char *)sendField)[9]=chr.speed.y;
	NSData* sendData = [NSData dataWithBytesNoCopy:sendField length:5*sizeof(float) freeWhenDone:YES];
	
	if (self.activePeer) {
		[self.gameSession sendData:sendData
						   toPeers:[NSArray arrayWithObject:self.activePeer] 
					  withDataMode:GKSendDataUnreliable 
							 error:nil];
	}
}

#pragma mark *INCOMMING MESSAGES

- (BOOL)handleChrAnnouncement:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"NPA:"];
	if ([stringArray count]==4) {
		
		if (![APGameViewController single]) {
			return TRUE;
		}
		
		NSString* chrID = [stringArray objectAtIndex:1];
		
		// chrID is in the network twice
		if([[APPhysics single].player.chrID isEqualToString:chrID])
		{
			[self disconnectPlayer];
			[self announcePlayerWithNewID:YES];
		}
		
		APChar* chr;
		
		if (chr=[[APPhysics single].characters objectForKey:chrID]) {
			chr.gameContext = [stringArray objectAtIndex:2];
			chr.nameLabel.text = [stringArray objectAtIndex:3];
		}else {
			NSString* gameContext = [stringArray objectAtIndex:2];
			NSString* playerName = [stringArray objectAtIndex:3];
			NSMutableDictionary* playerInitDict = [NSMutableDictionary new];
			
			[playerInitDict setObject:@"bunny_1" forKey:@"char_name"];
			[playerInitDict setObject:[APGameViewController single] forKey:@"game_view"];
			[playerInitDict setObject:chrID forKey:@"chr_ID"];
			[playerInitDict setObject:playerName forKey:@"player_name"];
			[playerInitDict setObject:gameContext forKey:@"game_context"];
			chr = [[APChar alloc] initWithDict:playerInitDict];
			[[APPhysics single] addChar:chr];
			
			
			[playerInitDict release];
			[chr release];
		}
		return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleDisconnectedPlayer:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"DCN:"];
	if ([stringArray count]==4) {
		NSLog(@"APBluetoothAdapter:PlayerDisconnectedID:%@ Name:%@",[stringArray objectAtIndex:1],[stringArray objectAtIndex:3]);
		[[APPhysics single] charDisconnected:[[APPhysics single].characters objectForKey:[stringArray objectAtIndex:1]]];
		return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleRequestForPlayerAnnouncement:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"PAR:"];
	if ([stringArray count]==2) {
		if ([[stringArray objectAtIndex:1] isEqualToString:[APPhysics single].player.chrID]) {
			[self announcePlayerWithNewID:NO];
		}
		return TRUE;
	}else {
		return FALSE;
	}
}

- (BOOL)handleChrGameContextChange:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"PGC:"];
	if ([stringArray count]==3) {
		APChar* chr = [[APPhysics single].characters objectForKey:[stringArray objectAtIndex:1]];
		chr.gameContext = [stringArray objectAtIndex:2];
		[[APPhysics single] gameContextUpdateForChr:chr];
		return TRUE;
	} else {
		return FALSE;
	}
}

- (BOOL)handleChrKilledByPlayer:(NSString *)inputString
{
	NSArray* stringArray = [inputString componentsSeparatedByString:@"PKC:"];
	if ([stringArray count]==3) {
		if ([[stringArray objectAtIndex:1] isEqualToString:[APPhysics single].player.chrID]) {
			[[APPhysics single] playerKilledChar:[[APPhysics single].characters objectForKey:[stringArray objectAtIndex:2]]];
		}
		return TRUE;
	} else {
		return FALSE;
	}
}

- (void)handlePlayerPositionUpdates:(NSData *)data
{
	unsigned char chrIDNr = ((char *)[data bytes])[3];
	NSString* chrID = [NSString stringWithFormat:@"%d",chrIDNr];
	((char *)[data bytes])[3] = 0;
	
	APChar* chr =[[APPhysics single].characters objectForKey:chrID];
	if (!chr) {
		[self requestForPlayerAnnouncement:chrID];
		return;
	}
	
	if (chr.packageNumber < ((int *)[data bytes])[0]) {
		chr.packageNumber = ((int *)[data bytes])[0];
		
		chr.position = CGPointMake(((short *)[data bytes])[2], ((short *)[data bytes])[3]);
		chr.speed = CGPointMake(((char *)[data bytes])[8], ((char *)[data bytes])[9]);
		[self.charUpdates setObject:chr forKey:chr.chrID];
		
	}
	chr.timeToLive = 120;
}



@end
