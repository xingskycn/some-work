//
//  AppDelegate.h
//  JBump
//
//  Created by Sebastian Pretscher on 08.10.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CCScene;

@class JBRootViewController;

@interface JBAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	JBRootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIStoryboard *menuStoryboard;
@property (nonatomic, retain) JBRootViewController *viewController;
@property (nonatomic, retain) CCScene *menuScene;
@property BOOL retina;


@end
