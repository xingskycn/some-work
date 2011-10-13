//
//  JBLineSprite.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface JBLineSprite : CCSprite

@property (nonatomic,retain) NSMutableArray* pointArray;
@property BOOL visible;
@property float red;
@property float green;
@property float blue;
@property float alpha;
@property BOOL highLighted;
@property (nonatomic, assign) NSMutableDictionary* historyObj;

@end
