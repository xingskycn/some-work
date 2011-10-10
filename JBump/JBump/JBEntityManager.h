//
//  JBEntityManager.h
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JBEntity;

@interface JBEntityManager : NSObject

+ (NSMutableArray*)getAllEntities;
+ (bool)saveNewEntity:(NSMutableDictionary*)entityDict entityImage:(UIImage*)image;
+ (JBEntity*)getEntityWithID:(NSString*)entityID;
+ (NSArray*)getAllEntityIDs;
+ (void)saveRessourceEntities;

@end
