//
//  JBHero.h
//  JBump
//
//  Created by Nils Ziehn on 10/7/11.
//  Copyright (c) 2011 TU München. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCSprite;
@class JBSkin;

@interface JBHero : NSObject

@property (nonatomic, strong) NSString* heroID;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* further;

@property (nonatomic, strong) JBSkin* skin;
@property (nonatomic, strong) CCSprite* sprite;


@end
