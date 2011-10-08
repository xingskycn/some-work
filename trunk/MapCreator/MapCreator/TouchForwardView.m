//
//  TouchForwardView.m
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "TouchForwardView.h"

@implementation TouchForwardView
@synthesize receiver;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    if (result && result!=self && ![result isKindOfClass:[TouchForwardView class]]) {
        return result;
    }
    return nil;
    //return receiver;
}

@end
