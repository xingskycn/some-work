//
//  JBMapCreatorLayer.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface JBMapCreatorLayer : CCLayer

@property (nonatomic, assign) UISlider* magnifier;
@property (nonatomic, retain) NSMutableDictionary* userSelection;
@property (nonatomic, retain) NSMutableArray* history;

+ (CCScene *)scene;

@end
