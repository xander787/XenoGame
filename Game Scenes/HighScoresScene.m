//
//  HighScoresScene.m
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
//	Last Updated - 10/26/2010 @ 12AM - Alexander
//	- Initial creation of the scene
//
//	Last Updated - 11/5/2010 @ 9:20PM - alexander
//	- Fixed problem causing the alpha for the scene to
//	be set to 0 causing nothing to appear to render to the screen
//
//	Last Updated - 12/19/2010 @ 3:20PM - Alexander
//	- Fixed problem where using GKLeaderboard was causing crash
//  (we weren't importing the GKLeaderboard.h file from GameKit).
//
//  Last Updated - 12/29/2010 @ 12PM - Alexander
//  - Fixed a very small memory leak issue in the highscore leaderboard
//  loading code.
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system

#import "HighScoresScene.h"

@interface HighScoresScene(Private)
- (void)initHighScores;
- (void)todayButtonPressed;
- (void)weekButtonPressed;
- (void)allTimeButtonPressed;
@end

@implementation HighScoresScene

#pragma mark -
#pragma mark Initializations

- (id)init {
	if (self = [super init]) {
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
		_sceneFadeSpeed = 1.5f;
//		sceneAlpha = 0.0f;
//		_origin = CGPointMake(0, 0);
//		[_sharedDirector setGlobalAlpha:sceneAlpha];
		
//		[self setSceneState:kSceneState_TransitionIn];
//		nextSceneKey = nil;
        
        selectedButtonIndex = 0;
		
		[self initHighScores];
	}
	
	return self;
    
}

- (void)initHighScores {
	leaderboardsTitle  = [[Image alloc] initWithImage:[NSString stringWithString:@"leaderboardstitle.png"]];
    highscoresTable    = [[Image alloc] initWithImage:[NSString stringWithString:@"highscorestable.png"]];
    todayButton        = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttontoday.png"]];
    todayButtonGlow    = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttontodayglow.png"]];
    thisWeekButton     = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttonweek.png"]];
    thisWeekButtonGlow = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttonweekglow.png"]];
    allTimeButton      = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttonalltime.png"]];
    allTimeButtonGlow  = [[Image alloc] initWithImage:[NSString stringWithString:@"highscoresbuttonalltimeglow.png"]];
    backButton         = [[Image alloc] initWithImage:[NSString stringWithString:@"backbutton.png"] scale:Scale2fMake(0.5f, 0.5f)];
    previousButton     = [[Image alloc] initWithImage:[NSString stringWithString:@"backbutton.png"] scale:Scale2fMake(0.5f, 0.5f)];
    nextButton         = [[Image alloc] initWithImage:[NSString stringWithString:@"forwardbutton.png"] scale:Scale2fMake(0.5f, 0.5f)];
}

#pragma mark -
#pragma mark Update Scene

- (void)updateWithDelta:(GLfloat)aDelta {
	switch (sceneState) {
		case kSceneState_Running:
			break;
			
		case kSceneState_TransitionOut:
			sceneAlpha-= _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha <= 0.0f)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = kSceneState_TransitionIn;
			break;
			
		case kSceneState_TransitionIn:
			sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha >= 1.0f) {
				sceneState = kSceneState_Running;
			}
			break;
		default:
			break;
	}
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
    
	// Flip the y location ready to check it against OpenGL coordinates
	NSLog(@"%f %f", location.x, location.y);
	location.y = 480-location.y;
	NSLog(@"%f %f", location.x, location.y);
    
    
    if(CGRectContainsPoint(CGRectMake(15, 440, backButton.imageWidth, backButton.imageHeight), location)){
        sceneState = kSceneState_TransitionOut;
        nextSceneKey = @"menu";
    }
    if(CGRectContainsPoint(CGRectMake(12, 395, todayButton.imageWidth, todayButton.imageHeight), location)){
        [self todayButtonPressed];
    }
    if(CGRectContainsPoint(CGRectMake(115, 395, thisWeekButton.imageWidth, thisWeekButton.imageHeight), location)){
        [self weekButtonPressed];
    }
    if(CGRectContainsPoint(CGRectMake(218, 395, allTimeButton.imageWidth, allTimeButton.imageHeight), location)){
        [self allTimeButtonPressed];
    }
}

- (void)updateWithMovedLocation:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
}

- (void)todayButtonPressed {
    NSLog(@"Today");
    selectedButtonIndex = 0;
        
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    if (leaderboardRequest != nil)
    {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.range = NSMakeRange(1,10);
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeToday;
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil)
            {
                // handle the error.
                NSLog(@"Error: %@", error);
            }
            if (scores != nil)
            {
                // process the score information.
                NSLog(@"Scores: %@", scores);
            }
        }];
    }
    [leaderboardRequest release];
}

- (void)weekButtonPressed {
    NSLog(@"Week");
    selectedButtonIndex = 1;
}

- (void)allTimeButtonPressed {
    NSLog(@"All Time");
    selectedButtonIndex = 2;
}

#pragma mark -
#pragma mark Rendering

- (void)transitionToSceneWithKey:(NSString *)aKey {
	
}

- (void)render {
	[leaderboardsTitle renderAtPoint:CGPointMake(160, 455) centerOfImage:YES];
    if(selectedButtonIndex == 0){
        [todayButtonGlow renderAtPoint:CGPointMake(12, 395) centerOfImage:NO];
    }
    else {
        [todayButton renderAtPoint:CGPointMake(12, 395) centerOfImage:NO];
    }
    if(selectedButtonIndex == 1){
        [thisWeekButtonGlow renderAtPoint:CGPointMake(115, 395) centerOfImage:NO];
    }
    else {
        [thisWeekButton renderAtPoint:CGPointMake(115, 395) centerOfImage:NO];
    }
    if(selectedButtonIndex == 2){
        [allTimeButtonGlow renderAtPoint:CGPointMake(218, 395) centerOfImage:NO];
    }
    else {
        [allTimeButton renderAtPoint:CGPointMake(218, 395) centerOfImage:NO];
    }
    [backButton renderAtPoint:CGPointMake(15, 440) centerOfImage:NO];
    [highscoresTable renderAtPoint:CGPointMake(16, 45) centerOfImage:NO];
    [previousButton renderAtPoint:CGPointMake(25, 10) centerOfImage:NO];
    [nextButton renderAtPoint:CGPointMake(260, 10) centerOfImage:NO];
    
}

@end
