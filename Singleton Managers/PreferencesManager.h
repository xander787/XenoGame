//
//  PreferencesManager.h
//  Xenophobe
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 10/23/2010 @ 6PM - Alexander
//	- Initial class creation

#import <Foundation/Foundation.h>
#import "sqlite3.h"


@interface PreferencesManager : NSObject {
	
}

+ (PreferencesManager *)sharedPreferencesManager;
- (NSString *)getPreferenceValueForKey:(NSString *)aKey;
- (BOOL)setPreferenceValue:(NSString *)aValue forKey:(NSString *)aKey;

@end
