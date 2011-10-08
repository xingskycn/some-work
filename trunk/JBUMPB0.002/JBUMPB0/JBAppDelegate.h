//
//  JBAppDelegate.h
//  JBUMPB0
//
//  Created by Nils Ziehn on 10/5/11.
//  Copyright (c) 2011 TU Munich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBMapStoreDevice;


@interface JBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JBMapStoreDevice* mapStoreDevice;

@end
