//
//  LineSprite.m
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "LineSprite.h"

@implementation LineSprite

@synthesize pointArray;
@synthesize visible;

- (id)init{
    self = [super init];
    if (self) {
        pointArray = [NSMutableArray new];
    }
    return self;
}

-(void)draw
{
    glEnable(GL_LINE_SMOOTH);
    
    if (visible) {
        for(int i = 0; i < [pointArray count]; i+=2)
        {
            CGPoint start = CGPointFromString([pointArray objectAtIndex:i]);
            CGPoint end = CGPointFromString([pointArray objectAtIndex:i+1]);
            
            ccDrawLine(start, end);
        }
    }
}



@end
