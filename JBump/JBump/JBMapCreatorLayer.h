//
//  JBMapCreatorLayer.h
//  JBump
//
//  Created by Nils Ziehn on 10/9/11.
//  Copyright (c) 2011 ziehn.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class JBMapItem;
@class JBMapCreatorViewController;

@interface JBMapCreatorLayer : CCLayer

@property (nonatomic, retain) UISlider* magnifier;
@property (nonatomic, retain) JBMapItem* userSelection;
@property (nonatomic, retain) NSMutableArray* history;
@property (nonatomic, assign) JBMapCreatorViewController* viewController;

+ (CCScene *)scene;

- (void)start;
- (void)insertCurves:(NSArray *)objects;
- (void)insertEntities:(NSArray *)objects;

@end
