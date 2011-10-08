//
//  LineSprite.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LineSprite : CCSprite

@property (nonatomic,retain) NSMutableArray* pointArray;
@property BOOL visible;

@end
