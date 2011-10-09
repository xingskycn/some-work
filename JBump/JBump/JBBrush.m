//
//  JBBrush.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBBrush.h"

@implementation JBBrush
@synthesize type;
@synthesize brushID;
@synthesize brushName;
@synthesize further;

@synthesize thumbnail;
@synthesize thumbnailLocation;
@synthesize thumbnailURL;

@synthesize friction;
@synthesize restitution;

@synthesize red, green, blue, alpha;

- (id)initWithBrushDict:(NSDictionary *)brushDict {
    self = [super init];
    
    if (self) {
        self.type = [brushDict objectForKey:@"type"];
        self.brushID = [brushDict objectForKey:@"brushID"];
        self.brushName = [brushDict objectForKey:@"brushName"];
        self.further = [brushDict objectForKey:@"further"];
        
        self.thumbnail = [brushDict objectForKey:@"thumbnail"];
        self.thumbnailLocation = [brushDict objectForKey:@"thumbnailLocation"];
        self.thumbnailURL = [brushDict objectForKey:@"thumbnailURL"];
        
        self.friction = [[brushDict objectForKey:@"friction"] floatValue];
        self.restitution = [[brushDict objectForKey:@"restitution"] floatValue];
        
        self.red = [[brushDict objectForKey:@"red"] floatValue];
        self.green = [[brushDict objectForKey:@"green"] floatValue];
        self.blue = [[brushDict objectForKey:@"blue"] floatValue];
        self.alpha = [[brushDict objectForKey:@"alpha"] floatValue];
    }
    
    return self;
}

@end
