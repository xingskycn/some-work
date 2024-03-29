//
//  HelloWorldLayer.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright ziehn.org 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@class LineSprite;
// HelloWorldLayer
@interface MapLayer : CCLayer
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    CGPoint cameraVelocity;
    
    
}

@property (nonatomic, retain) UISlider* magnifier;
@property (nonatomic, retain) NSMutableDictionary* userSelection;
@property (nonatomic, retain) NSMutableArray* history;


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;


@end
