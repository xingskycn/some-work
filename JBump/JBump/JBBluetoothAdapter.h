//
//  JBBluetoothAdapter.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBMultiplayerAdapter.h"
#import <GameKit/GameKit.h>

@interface JBBluetoothAdapter : JBMultiplayerAdapter <GKPeerPickerControllerDelegate,GKSessionDelegate>

@end
