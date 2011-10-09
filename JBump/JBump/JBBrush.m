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

@synthesize friction;
@synthesize restitution;

@synthesize red, green, blue, alpha;

- (id)initWithBrushDict:(NSDictionary *)brushDict {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

@end
