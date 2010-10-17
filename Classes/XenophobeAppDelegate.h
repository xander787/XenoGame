//
//  XenophobeAppDelegate.h
//  Xenophobe
//
//  Created by Alexander on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XenophobeViewController;

@interface XenophobeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    XenophobeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet XenophobeViewController *viewController;

@end

