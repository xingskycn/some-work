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
@synthesize visible,red,green,blue,alpha,historyObj,highLighted;

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
        if (pointArray.count) {
            if (highLighted) {
                glColor4f(1.f, 1.f, 1.f , 1.f);
                glLineWidth(5.5f);
            }else{
                glColor4f(red, green, blue , alpha);
                glLineWidth(4.0f);
            }
            
            
            CGPoint start = CGPointFromString([pointArray objectAtIndex:0]);
            for(int i = 1; i < [pointArray count]; i+=2)
            {
                CGPoint end = CGPointFromString([pointArray objectAtIndex:i]);
                ccDrawLine(start, end);
                start = end;
            }
        }
    }
}


@end
