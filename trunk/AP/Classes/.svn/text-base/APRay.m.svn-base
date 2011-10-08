//
//  APRay.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APRay.h"


@implementation APRay

@synthesize origin;
@synthesize direction;

- (id)initFrom:(CGPoint)start to:(CGPoint)end
{
	if (self = [super init]) {
		origin = start;
		direction = CGPointMake(end.x-start.x, end.y-start.y);
		[self normalize];
	}
	return self;
}

- (CGFloat)length
{
	return sqrt(direction.x*direction.x+direction.y*direction.y);
}

- (void)normalize
{
	CGFloat length = [self length];
	if (length != 0) {
		direction = CGPointMake(direction.x/length,direction.y/length);
	}
}

- (int)intersectionSideToRect:(CGRect)rect  // positives left = 0 right=1 up= 2 bottom=3 || negatives left = 4 right=5 up= 6 bottom=7 
{
	CGFloat borderleft = rect.origin.x+0.02;
	CGFloat borderright = rect.origin.x+rect.size.width-0.02;
	CGFloat borderup = rect.origin.y+0.02;
	CGFloat borderdown = rect.origin.y+rect.size.height-0.02;
	
	CGFloat t = (borderleft-origin.x)/direction.x;
	CGFloat t2 = (borderright-origin.x)/direction.x;
	if (t2<t && t2>0) {
		t = t2;
	}
	BOOL noXIntersection = FALSE;
	CGPoint vborderIntersection = CGPointMake(origin.x+direction.x*t, origin.y+direction.y*t);
	if (!CGRectContainsPoint(rect, vborderIntersection) || t<0) {
		noXIntersection = TRUE;
	}
	
	CGFloat t3 = (borderup-origin.y)/direction.y;
	CGFloat t4 = (borderdown-origin.y)/direction.y;
	if (t4<t3 && t4>0) {
		t3 = t4;
	}
	BOOL noYIntersection = FALSE;
	CGPoint hborderIntersection = CGPointMake(origin.x+direction.x*t3, origin.y+direction.y*t3);
	if (!CGRectContainsPoint(rect, hborderIntersection)  || t3<0) {
		noYIntersection = TRUE;
	}
	
	if (!noXIntersection && !noYIntersection) {
		if (t<t3) {
			if (t==t2) {
				return 1;
			}
			return 0;
		}
		if (t3==t4) {
			return 3;
		}
		return 2;
	}
	
	if (noXIntersection) {
		if (t3==t4) {
			
			return 3;
		}
		return 2;
	}
	
	if (noYIntersection) {
		if (t==t2) {
			
			return 1;
		}
		return 0;
	}
	
	return 5;
}

@end
