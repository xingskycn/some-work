//
//  AppDelegate.h
//  JBump
//
//  Created by Sebastian Pretscher on 06.10.11.
//  Copyright TU München 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
