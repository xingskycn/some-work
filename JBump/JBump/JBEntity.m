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

- (id)initWithEntityDictionary:(NSDictionary*)entityDict {
    self = [super init];
    
    if (self) {
        self.ID = [entityDict objectForKey:@"entityID"];
        self.image = [entityDict objectForKey:@"entityImage"];
        self.imageLocal = [entityDict objectForKey:@"imageLocation"];
        self.imageURL = [entityDict objectForKey:@"imageURL"];
        self.name = [entityDict objectForKey:@"name"];
        self.further = [entityDict objectForKey:@"further"];
        self.friction = [[entityDict objectForKey:@"friction"] floatValue];
        self.restitution = [[entityDict objectForKey:@"restitution"] floatValue];
        self.density = [[entityDict objectForKey:@"density"] floatValue];
        self.position =  CGPointFromString([entityDict objectForKey:@"position"]);
        self.size = CGSizeFromString([entityDict objectForKey:@"size"]);
        self.shape = [entityDict objectForKey:@"shape"];
    }
    return self;
}

@end
