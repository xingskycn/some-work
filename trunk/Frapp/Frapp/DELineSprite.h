//
//  DELineSprite.h
//  Frapp
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface DELineSprite : CCSprite

@property CGPoint start;
@property CGPoint end;
@property (nonatomic,retain) NSMutableArray* touchArray;

@end
