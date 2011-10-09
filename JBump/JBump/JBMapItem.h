//
//  JBMapItem.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

@interface JBMapItem : NSObject

@property (nonatomic, retain)NSString *ID;
@property (nonatomic, retain)UIImage *image;
@property (nonatomic, retain)NSString *imageLocal;
@property (nonatomic, retain)NSString *imageURL;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *further;
@property (assign)float friction;
@property (assign)float restitution;
@property (nonatomic,assign) CCSprite* sprite;

@end
