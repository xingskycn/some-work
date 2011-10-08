//
//  HelloWorldLayer.h
//  Frapp
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright ziehn.org 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Map.h"

@class DELineSprite;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    CCLabelTTF *label;
    Map* map;
    b2Body* player;
    
    BOOL drawLineEnabled;
    DELineSprite* activeLine;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
// adds a new sprite at a given coordinate
-(void) addNewSpriteWithCoords:(CGPoint)p;
- (void)addNewBallWithCoords:(CGPoint)p;

@end
