//
//  JBEntity.m
//  JBump
//
//  Created by Sebastian Pretscher on 09.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBEntity.h"

@implementation JBEntity

@synthesize entityID;
@synthesize entityImage;
@synthesize localImage;
@synthesize imageURL;
@synthesize name;
@synthesize further;
@synthesize friction;
@synthesize restitution;
@synthesize position;
@synthesize size;

- (id)initWithEntityDictionary:(NSDictionary*)entityDict {
    self = [super init];
    
    if (self) {
        self.entityID = [entityDict objectForKey:@"entityID"];
        self.entityImage = [entityDict objectForKey:@"entityImage"];
        self.localImage = [entityDict objectForKey:@"imageLocation"];
        self.imageURL = [entityDict objectForKey:@"imageURL"];
        self.name = [entityDict objectForKey:@"name"];
        self.further = [entityDict objectForKey:@"further"];
        self.friction = [[entityDict objectForKey:@"friction"] floatValue];
        self.restitution = [[entityDict objectForKey:@"restitution"] floatValue];
        self.position =  CGPointFromString([entityDict objectForKey:@"position"]);
        self.size = CGSizeFromString([entityDict objectForKey:@"size"]);
    }
    return self;
}

@end
