//
//  Director.m
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
//  
//  Team:
//  Alexander Nabavi-Noori - Software Engineer, Game Architect
//	James Linnell - Software Engineer, Creative Design, Art Producer
//	Tyler Newcomb - Creative Design, Art Producer
//
//	Last Updated - 10/20/2010 @ 6PM - Alexander
//	- Initial Project Creation
//
//  Last Updated - 7/27/11 @ 8PM - Alexander
//  - Added ability to switch to last used scene key

#import "Director.h"
#import "AbstractScene.h"

@implementation Director

@synthesize currentlyBoundTexture;
@synthesize currentGameState;
@synthesize currentScene;
@synthesize globalAlpha;
@synthesize framesPerSecond;
@synthesize gameSceneStatsSceneVisible;

// Make this class a singleton class
SYNTHESIZE_SINGLETON_FOR_CLASS(Director);


- (id)init {
	// Initialize the arrays to be used within the state manager
	_scenes = [[NSMutableDictionary alloc] init];
	currentScene = nil;
    currentSceneKey = nil;
    lastSceneKey = nil;
	globalAlpha = 1.0f;
    
    soundManager = [SoundManager sharedSoundManager];
    
    gameSceneStatsSceneVisible = NO;
    
	return self;
}


- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene {
	[_scenes setObject:aScene forKey:aSceneKey];
}


- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey {
	if(![_scenes objectForKey:aSceneKey]) {
		if(DEBUG) NSLog(@"ERROR: Scene with key '%@' not found.", aSceneKey);
        return NO;
    }
    
    lastSceneKey = currentSceneKey;
    
    currentScene = [_scenes objectForKey:aSceneKey];
    currentSceneKey = aSceneKey;
	[currentScene setSceneAlpha:0.0f];
	[currentScene setSceneState:kSceneState_TransitionIn];
    
    if ([currentScene respondsToSelector:@selector(sceneIsBecomingActive)]) {
        [currentScene sceneIsBecomingActive];
    }
    
    if ([aSceneKey isEqualToString:@"menu"] || [aSceneKey isEqualToString:@"settings"] || [aSceneKey isEqualToString:@"about"] || [aSceneKey isEqualToString:@"highscores"]) {
        if (![soundManager.currentPlayingMusicName isEqualToString:@"menu_theme"]) {
            [soundManager playMusicWithKey:@"menu_theme" timesToRepeat:10000];
        }
    }
    
    if ([aSceneKey isEqualToString:@"game"]) {
        if (![soundManager.currentPlayingMusicName isEqualToString:@"game_theme"]) {
            if (gameSceneStatsSceneVisible) {
                if (![soundManager.currentPlayingMusicName isEqualToString:@"menu_theme"]) {
                    [soundManager playMusicWithKey:@"menu_theme" timesToRepeat:10000];
                }
            }
            else {
                [soundManager playMusicWithKey:@"game_theme" timesToRepeat:10000];
            }
        }
    }
    
    return YES;
}

- (NSString *)getLastSceneUsed {
    return lastSceneKey;
}

- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey {
	
	// If the scene key exists then tell the current scene to transition to that
    // scene and return YES
    if([_scenes objectForKey:aSceneKey]) {
        [currentScene transitionToSceneWithKey:aSceneKey];
        return YES;
    }
    
    // If the scene does not exist then return NO;
    return NO;
}


- (void)dealloc {
	[_scenes release];
	[super dealloc];
}

@end
