//
//  JBEntity.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBEntity.h"

@implementation JBEntity

@synthesize position;
@synthesize size;
@synthesize shape;
@synthesize density;
@synthesize bodyType;
@synthesize body;
@synthesize shootable;
@synthesize shottime;
@synthesize needsSend;

- (id)initWithEntityDictionary:(NSDictionary*)entityDict {
    self = [super init];
    
    if (self) {
        self.ID = [entityDict objectForKey:jbID];
        self.image = [entityDict objectForKey:jbIMAGE];
        self.imageLocal = [entityDict objectForKey:jbIMAGELOCATION];
        self.imageURL = [entityDict objectForKey:jbIMAGE];
        self.name = [entityDict objectForKey:jbNAME];
        self.further = [entityDict objectForKey:jbFURTHER];
        self.friction = [[entityDict objectForKey:jbFURTHER] floatValue];
        self.restitution = [[entityDict objectForKey:jbRESTITUTION] floatValue];
        self.density = [[entityDict objectForKey:jbDENSITY] floatValue];
        self.position =  CGPointFromString([entityDict objectForKey:jbPOSITION]);
        self.size = CGSizeFromString([entityDict objectForKey:jbSIZE]);
        self.shape = [entityDict objectForKey:jbSHAPE];
        self.bodyType = [entityDict objectForKey:jbBODYTYPE];
    }
    return self;
}

@end
