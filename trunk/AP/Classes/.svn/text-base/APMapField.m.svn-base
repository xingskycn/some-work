//
//  APMapField.m
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import "APMapField.h"

#import "APChar.h"
#import "APRay.h"
#import "APMap.h"
#import "APPhysics.h"

@implementation APMapField

@synthesize pos,type,size,relativeChr;

- (id)init
{
	if(self = [super init])
	{
		self.size = CGSizeMake(40, 40);
	}else {
		NSLog(@"Can't initiate APMapField");
	}
	return self;
}

- (void)resetWithPos:(CGPoint)position type:(int)aType
{
	self.pos = position;
	self.type = aType;
}

- (CGPoint)getNewSpeedForChar:(APChar *)chr
{
	switch (type) {
		case 0:
			return chr.speed;
		case 1:
		{
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y, self.size.width, self.size.height);
			CGRect newChrFrame = CGRectMake(chr.position.x-chr.size.width/2+chr.speed.x, chr.position.y-chr.size.height/2+chr.speed.y, chr.size.width, chr.size.height);
			CGPoint newChrCenter = CGPointMake(chr.frame.origin.x+chr.frame.size.width/2, chr.frame.origin.y+chr.frame.size.height/2);
			if (CGRectIntersectsRect(fieldRect, newChrFrame)) {
				CGRect intersection = CGRectIntersection(fieldRect, newChrFrame);
				
				APRay* connector = [[APRay alloc] initFrom:newChrCenter to:CGPointMake(fieldRect.size.width/2+fieldRect.origin.x, fieldRect.size.height/2+fieldRect.origin.y)];
				int side = [connector intersectionSideToRect:fieldRect];
				[connector release];
				
				if (side==0) {
					chr.speed = CGPointMake(chr.speed.x-intersection.size.width, chr.speed.y);
				}
				if (side==1) {
					chr.speed = CGPointMake(chr.speed.x+intersection.size.width, chr.speed.y);
				}
				if (side==2) {
					
					chr.speed = CGPointMake(chr.speed.x, chr.speed.y-intersection.size.height);
					chr.onFloor = TRUE;
				}
				if (side==3) {
					chr.speed = CGPointMake(chr.speed.x, chr.speed.y+intersection.size.height);
				}
			}
			return chr.speed;
		}
		case 2:
		{
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y, self.size.width, self.size.height);
			CGRect newChrFrame = CGRectMake(chr.position.x-chr.size.width/2+chr.speed.x, chr.position.y-chr.size.height/2+chr.speed.y, chr.size.width, chr.size.height);
			//CGPoint newChrCenter = CGPointMake(newChrFrame.origin.x+newChrFrame.size.width/2, newChrFrame.origin.y+newChrFrame.size.height/2);
			if (CGRectIntersectsRect(fieldRect, newChrFrame)) {
				CGRect intersection = CGRectIntersection(fieldRect, newChrFrame);
				
				APRay* connector = [[APRay alloc] initFrom:chr.position to:CGPointMake(fieldRect.size.width/2+fieldRect.origin.x, fieldRect.size.height/2+fieldRect.origin.y)];
				int side = [connector intersectionSideToRect:fieldRect];
				[connector release];
				
				if (side==0) {
					chr.speed = CGPointMake(chr.speed.x-intersection.size.width, chr.speed.y);
				}
				if (side==1) {
					chr.speed = CGPointMake(chr.speed.x+intersection.size.width, chr.speed.y);
				}
				if (side==2) {
					if (chr.speed.y>0 && chr.speed.y < 4) {
						chr.speed = CGPointMake(chr.speed.x, -20);
					}else {
						chr.speed = CGPointMake(chr.speed.x, chr.speed.y-intersection.size.height);
						chr.onFloor = TRUE;
					}

					
				}
				if (side==3) {
					chr.speed = CGPointMake(chr.speed.x, chr.speed.y+intersection.size.height);
				}
			}
			return chr.speed;
		}
		case 3:
		{
			
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y+15, self.size.width, self.size.height);
			if (CGRectIntersectsRect(fieldRect, chr.frame)) 
			{
				chr.inWater = TRUE;
			}
			
			return chr.speed;
		}
		case 4:
		{
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y, self.size.width, self.size.height);
			CGRect newChrFrame = CGRectMake(chr.position.x-chr.size.width/2+chr.speed.x, chr.position.y-chr.size.height/2+chr.speed.y, chr.size.width, chr.size.height);
			CGPoint newChrCenter = CGPointMake(newChrFrame.origin.x+newChrFrame.size.width/2, newChrFrame.origin.y+newChrFrame.size.height/2);
			if (CGRectIntersectsRect(fieldRect, newChrFrame)) {
				
				APRay* connector = [[APRay alloc] initFrom:newChrCenter to:CGPointMake(fieldRect.size.width/2+fieldRect.origin.x, fieldRect.size.height/2+fieldRect.origin.y)];
				int side = [connector intersectionSideToRect:fieldRect];
				[connector release];
				
				if (side==0) {
					chr.speed = CGPointMake(-chr.speed.x, chr.speed.y-3);
				}
				if (side==1) {
					chr.speed = CGPointMake(-chr.speed.x, chr.speed.y+3);
				}
				if (side==2) {	
					chr.speed = CGPointMake(chr.speed.x, -chr.speed.y);
				}
				if (side==3) {
					chr.speed = CGPointMake(chr.speed.x, -chr.speed.y);
				}
			}
			return chr.speed;
		}
		case 5:
		{
			CGRect fieldRect = CGRectMake(self.pos.x+2, self.pos.y+2, self.size.width-4, self.size.height-4);
			if (CGRectIntersectsRect(fieldRect, chr.frame)) 
			{
				chr.onLadder = TRUE;
			}
			
			return chr.speed;
		}
		case 6:
		{
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y, self.size.width, self.size.height);
			if(CGRectContainsPoint(fieldRect, chr.position))
			{
				return chr.speed;   
			}
			
			CGRect newChrFrame = CGRectMake(chr.position.x-chr.size.width/2+chr.speed.x, chr.position.y-chr.size.height/2+chr.speed.y, chr.size.width, chr.size.height);
			//CGPoint newChrCenter = CGPointMake(newChrFrame.origin.x+newChrFrame.size.width/2, newChrFrame.origin.y+newChrFrame.size.height/2);
			if (CGRectIntersectsRect(fieldRect, newChrFrame)) {
				CGRect intersection = CGRectIntersection(fieldRect, newChrFrame);
				
				APRay* connector = [[APRay alloc] initFrom:chr.position   to:CGPointMake(fieldRect.size.width/2+fieldRect.origin.x, fieldRect.size.height/2+fieldRect.origin.y)];
				int side = [connector intersectionSideToRect:fieldRect];
				[connector release];
				
				if (side==2 && chr.speed.y > 0) {	
					chr.speed = CGPointMake(chr.speed.x, chr.speed.y-intersection.size.height);
					chr.onFloor = TRUE;
				}

			}
			return chr.speed;
		}
		case 7:
		{
			CGRect fieldRect = CGRectMake(self.pos.x+2, self.pos.y+2, self.size.width-4, self.size.height-4);
			if (CGRectIntersectsRect(fieldRect, chr.frame)) 
			{
				chr.dead = TRUE;
			}
			
			return chr.speed;
		}
		case 8:
		{
			
			CGRect fieldRect = CGRectMake(self.pos.x, self.pos.y+15, self.size.width, self.size.height);
			if (CGRectIntersectsRect(fieldRect, chr.frame)) 
			{
				chr.inWater = TRUE;
				
				APMap* map = [[[APPhysics single] maps] objectAtIndex:0];
				CGRect newChrFrame = CGRectMake(chr.position.x-chr.size.width/2+chr.speed.x, chr.position.y-chr.size.height/2+chr.speed.y+map.waterGravity.y, chr.size.width, chr.size.height);
				
				if (!CGRectIntersectsRect(fieldRect, newChrFrame)) 
				{
					chr.speed = CGPointMake(chr.speed.x, chr.speed.y-map.waterGravity.y*0.8);
				}
			}
			
			
			
			return chr.speed;
		}
			
		default:
			return chr.speed;
	}
}

- (NSComparisonResult )compareDistanceWithField:(APMapField *)field
{
	CGFloat thisDistance = (self.pos.x+self.size.width/2-relativeChr.position.x)*(self.pos.x+self.size.width/2-relativeChr.position.x)
								+(self.pos.y+self.size.height/2-relativeChr.position.y)*(self.pos.y+self.size.height/2-relativeChr.position.y);
	CGFloat otherDistance = (field.pos.x+field.size.width/2-relativeChr.position.x)*(field.pos.x+field.size.width/2-relativeChr.position.x)
								+(field.pos.y+field.size.height/2-relativeChr.position.y)*(field.pos.y+field.size.height/2-relativeChr.position.y);
	
	if (thisDistance > otherDistance) {
		return NSOrderedDescending;
	}
	if (thisDistance < otherDistance) {
		return NSOrderedAscending;
	}
	return NSOrderedSame;
}

- (NSString *)description
{
	CGFloat thisDistance = (self.pos.x+self.size.width/2-relativeChr.position.x)*(self.pos.x+self.size.width/2-relativeChr.position.x)
	+(self.pos.y+self.size.height/2-relativeChr.position.y)*(self.pos.y+self.size.height/2-relativeChr.position.y);

	return [NSString stringWithFormat:@"%p    pos: %f    %f dist:%f",self,self.pos.x,self.pos.y,thisDistance];
}
@end
