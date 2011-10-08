//
//  APRay.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface APRay : NSObject {
	CGPoint origin;
	CGPoint direction;
}

@property (readwrite) CGPoint origin;
@property (readwrite) CGPoint direction;

- (id)initFrom:(CGPoint)start to:(CGPoint)end;
- (CGFloat)length;
- (void)normalize;
- (int)intersectionSideToRect:(CGRect)rect;

@end
