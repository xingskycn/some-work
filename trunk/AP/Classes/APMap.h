//
//  APMap.h
//  AP
//
//  Created by Ziehn Nils on 6/18/11.
//  Copyright 2011 TU Munich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class APChar;

@interface APMap : UIImageView {
	int mapWidth;
	int mapHeight;
	char* mapCharacteristics;
	NSString* mapID;
	
	CGPoint gravity;
	CGPoint waterGravity;
}

+ (APMap *)mapForMapID:(NSString *)mapID;

@property (readonly) int mapWidth;
@property (readonly) int mapHeight;
@property (readonly) char* mapCharacteristics;
@property (nonatomic, copy)NSString* mapID;
@property (readwrite) CGPoint gravity;
@property (readwrite) CGPoint waterGravity;

- (id)initWithImage:(UIImage *)anImage width:(int)width height:(int)height matrix:(char *)initMatrix;
- (void)calculateMapInteractionForChar:(APChar *)chr activeUserInput:(BOOL)activeUserInput;
- (void)getPathForNode:(struct Path*)node height:(int)heightDiff;
@end

struct Path {
	int x;
	int y;
	int weight;
	struct Path* sameDepth;
	struct Path* deeper;
	struct Path* parent;
};
