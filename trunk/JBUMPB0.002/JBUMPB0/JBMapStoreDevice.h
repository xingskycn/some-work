//
//  JBMapStoreDevice.h
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/5/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JBMapStore.h"

@interface JBMapStoreDevice : JBMapStore

- (void)addMapIntoCategory:(int)categoryNr mapID:(NSString *)mapID info:(NSDictionary *)dict;

@end
