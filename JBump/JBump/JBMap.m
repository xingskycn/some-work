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

@synthesize name;
@synthesize ID;
@synthesize further;

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
@synthesize infoLocal;

-(id)initWithDictionary:(NSDictionary *)mapDict {
    self = [super init];
    
    if (self) {
        self.mapEntities = [NSMutableArray array];
        self.curves = [NSMutableArray array];
        
        self.name = [mapDict objectForKey:jbNAME];
        self.ID = [mapDict objectForKey:jbID];
        self.further = [mapDict objectForKey:jbFURTHER];
        
        self.backgroundImage = [mapDict objectForKey:jbBACKGROUNDIMAGE];
        self.backgroundImageLocal = [mapDict objectForKey:jbBACKGROUNDIMAGELOCATION];
        self.backgroundImageURL = [mapDict objectForKey:jbBACKGROUNDIMAGEURL];
        
        self.arenaImage = [mapDict objectForKey:jbARENAIMAGE];
        self.arenaImageLocal = [mapDict objectForKey:jbARENAIMAGELOCATION];
        self.arenaImageURL = [mapDict objectForKey:jbARENAIMAGEURL];
        
        self.overlayImage = [mapDict objectForKey:jbOVERLAYIMAGE];
        self.overlayImageLocal = [mapDict objectForKey:jbOVERLAYIMAGELOCATION];
        self.overlayImageURL = [mapDict objectForKey:jbOVERLAYIMAGEURL];
        
        self.thumbnail = [mapDict objectForKey:jbTHUMBNAIL];
        self.thumbnailLocal = [mapDict objectForKey:jbTHUMBNAILLOCATION];
        self.thumbnailURL = [mapDict objectForKey:jbTHUMBNAILURL];
        
        self.infoLocal = [mapDict objectForKey:jbINFOLOCATION];
        
        for (NSDictionary *dict in [mapDict objectForKey:jbENTITIES]) {
            JBEntity *aEntity = [JBEntityManager getEntityWithID:[dict objectForKey:jbID]];
            aEntity.position = CGPointFromString([dict objectForKey:jbPOSITION]);
            [self.mapEntities addObject:aEntity];
        }
        
        self.settings = [mapDict objectForKey:jbSETTINGS];
        
        self.curves = [mapDict objectForKey:jbCURVES]; 
    }
    
    if (!self.ID) {
        return nil;
    }
    
    return self;
}

@end
