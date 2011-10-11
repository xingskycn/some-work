//
//  JBMap.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBMap.h"
#import "JBEntity.h"
#import "JBEntityManager.h"

@implementation JBMap

@synthesize mapName;
@synthesize mapID;
@synthesize mapFurther;

@synthesize backgroundImage;
@synthesize backgroundImageLocal;
@synthesize backgroundImageURL;

@synthesize arenaImage;
@synthesize arenaImageLocal;
@synthesize arenaImageURL;

@synthesize overlayImage;
@synthesize overlayImageLocal;
@synthesize overlayImageURL;

@synthesize thumbnail;
@synthesize thumbnailLocal;
@synthesize thumbnailURL;

@synthesize mapEntities;
@synthesize curves;

@synthesize settings;

-(id)initWithDictionary:(NSDictionary *)mapDict {
    self = [super init];
    
    if (self) {
        self.mapEntities = [NSMutableArray array];
        self.curves = [NSMutableArray array];
        
        self.mapName = [mapDict objectForKey:@"mapName"];
        self.mapID = [mapDict objectForKey:@"mapID"];
        self.mapFurther = [mapDict objectForKey:@"mapFurther"];
        
        self.backgroundImage = [mapDict objectForKey:@"backgroundImage"];
        self.backgroundImageLocal = [mapDict objectForKey:@"backgroundImageLocal"];
        self.backgroundImageURL = [mapDict objectForKey:@"backgroundImageURL"];
        
        self.arenaImage = [mapDict objectForKey:@"arenaImage"];
        self.arenaImageLocal = [mapDict objectForKey:@"arenaImageLocal"];
        self.arenaImageURL = [mapDict objectForKey:@"arenaImageURL"];
        
        self.overlayImage = [mapDict objectForKey:@"overlayImage"];
        self.overlayImageLocal = [mapDict objectForKey:@"overlayImageLocal"];
        self.overlayImageURL = [mapDict objectForKey:@"overlayImageURL"];
        
        for (NSDictionary *dict in [mapDict objectForKey:@"mapEntities"]) {
            JBEntity *aEntity = [JBEntityManager getEntityWithID:[dict objectForKey:@"entityID"]];
            aEntity.position = CGPointFromString([dict objectForKey:@"position"]);
            [self.mapEntities addObject:aEntity];
        }
        
        self.settings = [mapDict objectForKey:@"settings"];
        
        self.curves = [mapDict objectForKey:@"curves"]; 
    }
    
    return self;
}

@end
