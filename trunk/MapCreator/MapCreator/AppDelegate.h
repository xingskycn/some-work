//
//  AppDelegate.h
//  MapCreator
//
//  Created by Nils Ziehn on 10/8/11.
//  Copyright ziehn.org 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
