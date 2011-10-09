//
//  JBBrush.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBBrush.h"

@implementation JBBrush

@synthesize friction;
@synthesize restitution;

@synthesize red, green, blue, alpha;

- (id)initWithBrushDict:(NSDictionary *)brushDict {
    self = [super init];
    
    if (self) {
        self.ID = [brushDict objectForKey:@"brushID"];
        self.name = [brushDict objectForKey:@"brushName"];
        self.further = [brushDict objectForKey:@"further"];
        
        self.image = [brushDict objectForKey:@"thumbnail"];
        self.imageLocal = [brushDict objectForKey:@"thumbnailLocation"];
        self.imageURL = [brushDict objectForKey:@"thumbnailURL"];
        
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
