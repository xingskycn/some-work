//
//  APMapField.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APChar;

@interface APMapField : NSObject {
	CGPoint pos;
	int type;
	CGSize size;
}

@property (nonatomic, assign) APChar* relativeChr;
@property (readwrite) CGPoint pos;
@property (readwrite) int type;
@property (readwrite) CGSize size;



- (void)resetWithPos:(CGPoint)position type:(int)aType;
- (CGPoint)getNewSpeedForChar:(APChar *)chr;

@end
