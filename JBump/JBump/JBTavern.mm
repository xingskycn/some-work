//
//  JBTavern.m
//  JBump
//
//  Created by Sebastian Pretscher on 11.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBTavern.h"

@implementation JBTavern

@synthesize players;

- (id)init {
    self = [super init];
    
    if (self) {
        self.players = [NSMutableArray array];
    }
    
    return self;
}

- (void)addNewPlayer:(JBHero *)aPlayer {
    [self.players addObject:aPlayer];
}

@end
