//
//  DELineSprite.m
//  Frapp
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "DELineSprite.h"

@implementation DELineSprite

@synthesize start,end,touchArray;

- (id)init{
    self = [super init];
    if (self) {
        touchArray = [NSMutableArray new];
    }
    return self;
}

-(void)draw
{
    /*glEnable(GL_LINE_SMOOTH);
    
    for(int i = 0; i < [touchArray count]; i+=2)
    {
        start = CGPointFromString([touchArray objectAtIndex:i]);
        end = CGPointFromString([touchArray objectAtIndex:i+1]);
        
        ccDrawLine(start, end);
    }*/
}

@end
