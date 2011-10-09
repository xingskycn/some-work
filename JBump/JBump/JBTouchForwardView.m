//
//  JBTouchForwardView.m
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import "JBTouchForwardView.h"

@implementation JBTouchForwardView
@synthesize receiver;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* result = [super hitTest:point withEvent:event];
    if (result && result!=self && ![result isKindOfClass:[JBTouchForwardView class]]) {
        return result;
    }
    return nil;
    //return receiver;
}


@end
