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
	}
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

- (void)shoutPlayerWantsMapChange
{	
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
 	((int*)sendField)[0]=player.packageNr++<<8;
	((char*)sendField)[0]=player.playerID;
	((short *)sendField)[2]=player.body->GetWorldCenter().x*32;
	((short *)sendField)[3]=player.body->GetWorldCenter().y*32;
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

- (void)sendData:(NSData *)data info:(NSDictionary *)info
{
    info  = [NSMutableDictionary dictionary];
    [info setValue:@"ASDDDSA" forKey:@"ASA"];
    
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
					  withDataMode:GKSendDataUnreliable 
							 error:&error];
    }
    
    [self.activeDataTransfers setObject:data forKey:transferID];
    [self.activeDataTransfers setObject:@"0" forKey:[NSString stringWithFormat:@"%@pos",transferID]];
}

- (void)continueDataTransfer:(NSString *)transferID
{
    NSData* data = [self.activeDataTransfers objectForKey:transferID];
    int pos = [[self.activeDataTransfers objectForKey:[NSString stringWithFormat:@"%@pos",transferID]] intValue];
    int length = data.length -pos<2000?data.length -pos:2000;
    NSString* sendString = [NSString stringWithFormat:@"|IDS:%@",transferID];
    NSMutableData* sendData = [[sendString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [sendData appendData:[data subdataWithRange:NSMakeRange(pos, length)]];
    
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

#pragma mark --- INCOMMING MESSSAGES ---

- (BOOL)handlePlayerAnnouncement:(NSString *)inputString
{
	if ([inputString hasPrefix:@"|NPA:"]) {
        NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
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
        NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
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
		NSString* announcement = [inputString substringWithRange:NSMakeRange(4,inputString.length-4)];
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
	CGPoint position = CGPointMake(((short *)[data bytes])[2]/32.0f, ((short *)[data bytes])[3]/32.0f);
    float velocityX = ((char *)[data bytes])[8]*20.f/255.f;
    float velocityY = ((char *)[data bytes])[9]*20.f/255.f;
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

- (BOOL)handleImgAboardTransferRequest:(NSString *)inputString
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
            
            NSLog(@"imageDataLength:%d",(int)[file offsetInFile]);
            if ([file offsetInFile] == [[self.activeDataTransfers objectForKey:transferID] intValue]) {
                NSLog(@"finished img!");
                
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

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
    NSString* inputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (inputString) {
        if (![self handlePlayerReadyChange:inputString]) {
            if (![self handlePlayerAnnouncement:inputString]) {
                if (![self handleDisconnectedPlayer:inputString]) {
                    if (![self handleRequestForPlayerAnnouncement:inputString]) {
                        if (![self handlePlayerGameContextChange:inputString]) {
                            if (![self handlePlayerKilledByPlayer:inputString]) {
                                if (![self handleDataSendRequestIncomming:inputString]) {
                                    if (![self handleNextDataRequestIncomming:inputString]) {
                                        if (![self handleImgAboardTransferRequest:inputString]) {
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
