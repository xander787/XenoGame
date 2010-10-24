//
//  PreferencesManager.m
//  Xenophobe
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 10/23/2010 @ 6PM - Alexander
//	- Initial class creation

#import "PreferencesManager.h"
#import "SynthesizeSingleton.h"

@interface PreferencesManager(Private)
- (void)createWriteablePreferencesFile;
@end

@implementation PreferencesManager

SYNTHESIZE_SINGLETON_FOR_CLASS(PreferencesManager)

- (void)dealloc {
	[super dealloc];
}

- (id)init {
	return self;
}

- (void)createWriteablePreferencesFile {
	
}

- (NSString *)getPreferenceValueForKey:(NSString *)aKey {
	return nil;
}

- (BOOL)setPreferenceValue:(NSString *)aValue forKey:(NSString *)aKey {
	return NO;
}

@end
