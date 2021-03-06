//
//  GameScene.m
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
//  Last Updated - 6/13/11 @3PM - Alexander
//  - Added starry background, and score string. Both are currently
//  rendering
//
//  Last Updated - 6/13/11 @4PM - Alexander
//  - Added health bar imagery
//
//  Last updated - 6/15/2011 @4:45PM - James
//  - Made the health bar work with the actual player ship health
//
//  Last Updated - 6/17/11 @7:30PM - Alexander
//  - Added a health bar background image to let users know how much
//  health of theirs has diminished.
//
//  Last Updated - 6/20/11 @5PM - Alexander & James
//  - Began implementation of GameLevelScene and also
//  moved much of things from this class to that one.
//  Collisions, health, etc are all there now. Also delegated
//  this class to that one as well. This class now keeps a copy
//  of the index of level files in memory as well
//
//  Last Updated - 6/20/11 @5PM - Alexander & James
//  - Fixed small error with loading Image classes. Needed to include
//  scale parameter.
//
//  Last Updated - 6/22/11 @1PM - Alexander
//  - Updating game level scene with touch information when level is
//  in progress.
//
//  Last Updated - 7/5/2011 @ 9:20PM - James
//  - Initial pause screen code integrated
//
//  Last Updated - 6/5/11 @11PM - Alexander
//  - Removed playerScoreString because it was causing
//  memory corruption and crashes. The player score integer is now
//  directly accessed and rendered by the AngelCodeFont font instance
//
//  Last Updated - 6/7/11 @9:30AM - Alexander
//  - Changed the pause button position because the image is now smaller
//
//  Last Updated - 7/9/2011 @10PM - James
//  -  Health bar no longer renders during dialogue waves
//
//  Last Updated - 7/27/11 @4:20PM - James
//  - Implemented a sidebar for powerups that have been picked up,
//  nuke button, made stats scene fade in
//
//  Last Updated - 7/27/11 @9:30AM - Alexander
//  - Changing music based on if level is in progress or not
//
//  Last Updated - 7/28/11 @5:30PM - Alexander
//  - Game saving implemented

#import "GameScene.h"

@interface GameScene(Private)
- (void)initGameScene;
- (void)initSound;
- (void)updateCollisions;
@end

@implementation GameScene

@synthesize gameIsPaused;

- (id)init {
	if ((self = [super init])) {
        // Get an instance of the singleton classes
		_sharedDirector = [Director sharedDirector];
		_sharedResourceManager = [ResourceManager sharedResourceManager];
		_sharedSoundManager = [SoundManager sharedSoundManager];
		
        // Grab the bounds of the screen
		_screenBounds = [[UIScreen mainScreen] bounds];
        
        _sceneFadeSpeed = 1.0f;
        
        // Init
        [self initGameScene];
        [self loadLevelIndexFile];
        soundInitialized = NO;
        settingsDB = [NSUserDefaults standardUserDefaults];
        
    }
	
	return self;
}

- (void)initSound {
    soundManager = [SoundManager sharedSoundManager];
    [soundManager setMusicVolume:0.0f];
    [soundManager playMusicWithKey:@"game_theme" timesToRepeat:10000];
    [soundManager fadeMusicVolumeFrom:0.0f toVolume:[settingsDB floatForKey:kSetting_MusicVolume] duration:2.0f stop:NO];
    soundInitialized = YES;
}

- (void)loadLevelIndexFile {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"LevelsIndex" ofType:@"plist"]];
    NSMutableDictionary *levelFileIndexDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [path release];
    
    levelFileIndex = [[NSArray alloc] initWithArray:[levelFileIndexDict objectForKey:@"kLevelsFileIndex"]];
    
    [levelFileIndexDict release];
    
    currentLevel = [self convertToLevelEnum:[levelFileIndex objectAtIndex:0]];
    currentLevelIndex = 0;
    
    [self loadLevelForPlay:currentLevel];
}

- (void)initGameScene {
    // In-game graphics
    font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:(1.0/3.0) filter:GL_LINEAR];
    
    backgroundParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
																				  position:Vector2fMake(160.0, 259.76)
																	sourcePositionVariance:Vector2fMake(373.5, 240.0)
																					 speed:0.05
																			 speedVariance:0.01
																		  particleLifeSpan:5.0
																  particleLifespanVariance:2.0
																					 angle:200.0
																			 angleVariance:0.0
																				   gravity:Vector2fMake(0.0, 0.0)
																				startColor:Color4fMake(1.0, 1.0, 1.0, 0.58)
																		startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			   finishColor:Color4fMake(0.5, 0.5, 0.5, 0.34)
																	   finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
																			  maxParticles:1000
																			  particleSize:6.0
																		finishParticleSize:6.0
																	  particleSizeVariance:1.3
																				  duration:-1
																			 blendAdditive:NO];    
    healthBar = [[Image alloc] initWithImage:@"HealthBar.png" scale:Scale2fOne];
    healthBarBackground = [[Image alloc] initWithImage:@"HealthBarBackground.png" scale:Scale2fOne];
    
    pauseButton = [[MenuControl alloc] initWithImageNamed:@"pause.png" location:Vector2fMake(305, 465) centerOfImage:YES type:kControlType_Pause];
    pauseScreen = [[PauseMenuScene alloc] init];
    
    statsScene = [[GameStatsScene alloc] init];
    
    playerScore = [settingsDB integerForKey:kSetting_SaveGameScore];
    
    shieldImage = [[Image alloc] initWithImage:@"Shield.png" scale:Scale2fOne];
    damageMultiplierImage = [[Image alloc] initWithImage:@"DamageMultiplier.png" scale:Scale2fOne];
    scoreMultiplierImage = [[Image alloc] initWithImage:@"ScoreMultiplier.png" scale:Scale2fOne];
    enemyRepelImage = [[Image alloc] initWithImage:@"EnemyRepel.png" scale:Scale2fOne];
    magnetImage = [[Image alloc] initWithImage:@"Magnet.png" scale:Scale2fOne];
    slowmoImage = [[Image alloc] initWithImage:@"Slowmo.png" scale:Scale2fOne];
    proximityDamageImage = [[Image alloc] initWithImage:@"ProximityDamage.png" scale:Scale2fOne];
    nukeImage = [[Image alloc] initWithImage:@"Nuke.png" scale:Scale2fOne];
    nukePowerUpEnabled = YES;
    
    enabledPowerUpsArray = [[NSMutableArray alloc] init];
}

- (void)updateWithDelta:(GLfloat)aDelta {
	switch (sceneState) {
        case kSceneState_Running:
            break;
        case kSceneState_TransitionIn:
            sceneAlpha += _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
            if(sceneAlpha >= 1.0f) {
                sceneAlpha = 1.0f;
                sceneState = kSceneState_Running;
            }
            break;
        case kSceneState_TransitionOut:
			sceneAlpha -= _sceneFadeSpeed * aDelta;
            [_sharedDirector setGlobalAlpha:sceneAlpha];
			if(sceneAlpha < 0)
                // If the scene being transitioned to does not exist then transition
                // this scene back in
				if(![_sharedDirector setCurrentSceneToSceneWithKey:nextSceneKey])
                    sceneState = kSceneState_TransitionIn;
			break;
        default:
            break;
    }
    
    // In-game graphics updating
    [backgroundParticleEmitter update:aDelta];
    [healthBar setScale:Scale2fMake((GLfloat)gameLevel.playerShip.shipHealth / gameLevel.playerShip.shipMaxHealth, 1.0f)];
    
    if (levelInProgress && !soundInitialized) {
        [self initSound];
    }
    
    // Level
    if(levelInProgress && !gameIsPaused) {
        if(gameLevel) [gameLevel update:aDelta];
        if(gameLevel.currentWaveType == kWaveType_Boss){
            nukePowerUpEnabled = NO;
            [nukeImage setColourFilterRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        }
        else {
            nukePowerUpEnabled = YES;
            [nukeImage setColourFilterRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        }
        
        if(lastPlayPlayerDied){
            NSMutableDictionary *statsDict = [[NSMutableDictionary alloc] init];
            [statsDict setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"DROPS"];
            [statsDict setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"ENEMIES"];
            [statsDict setValue:[NSString stringWithFormat:@"%f", 0] forKey:@"TIME"];
            [statsDict setValue:[NSString stringWithFormat:@"%d", 0] forKey:@"SCORE"];
            [self levelEnded:statsDict];
        }
    }
    else if(showStatsScene){
        [_sharedDirector setGameSceneStatsSceneVisible:YES];
        [statsScene updateWithDelta:aDelta];
        if([statsScene continueGame] == YES){
            statsScene.continueGame = NO;
            [_sharedDirector setGameSceneStatsSceneVisible:NO];
            showStatsScene = NO;
            //Current Level ++
            if(lastPlayPlayerDied){
                lastPlayPlayerDied = NO;
            }
            else {
                currentLevel++;
            }
            [self loadLevelForPlay:currentLevel];
        }
    }
    [pauseButton updateWithDelta:[NSNumber numberWithFloat:aDelta]];
    if([pauseButton state] == kControl_Selected){
        //Pause stuff
        gameIsPaused = TRUE;
        [pauseButton setState:kControl_Idle];
    }
    if(gameIsPaused){
        [pauseScreen updateWithDelta:aDelta];
        if([pauseScreen returnToGame] == TRUE){
            gameIsPaused = FALSE;
            [pauseButton setState:kControl_Idle];
            [pauseScreen setReturnToGame:FALSE];
            [self setSceneState:kSceneState_Running];
        }
    }
}

- (void)setSceneState:(uint)theState {
	sceneState = theState;
	if(sceneState == kSceneState_TransitionOut)
		sceneAlpha = 1.0f;
	if(sceneState == kSceneState_TransitionIn)
		sceneAlpha = 0.0f;
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    if(levelInProgress) {
        if(gameLevel) [gameLevel updateWithTouchLocationBegan:touches withEvent:event view:aView];
        if(nukePowerUpReady && nukePowerUpEnabled){
            if(location.x < 40 && location.y < 55){
                [gameLevel nukeButtonPushed];
                nukePowerUpReady = NO;
            }
        }
    }
    if(gameIsPaused){
        [pauseScreen updateWithTouchLocationBegan:touches withEvent:event view:aView];
    }
    if(!gameIsPaused){
        [pauseButton updateWithLocation:NSStringFromCGPoint(location)];
    }
    if(showStatsScene){
        [statsScene updateWithTouchLocationBegan:touches withEvent:event view:aView];
    }
}

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
        
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    location.y += 30;
    
    if(levelInProgress) {
        if(gameLevel) [gameLevel updateWithTouchLocationMoved:touches withEvent:event view:aView];
    }
    if(gameIsPaused){
        [pauseScreen updateWithTouchLocationMoved:touches withEvent:event view:aView];
    }
    if(!gameIsPaused){
        [pauseButton updateWithLocation:NSStringFromCGPoint(location)];
    }
    if(showStatsScene){
        [statsScene updateWithTouchLocationMoved:touches withEvent:event view:aView];
    }
}

- (Level)convertToLevelEnum:(NSString *)received {
    if([received isEqualToString:@"Level_DevTest"]){
        return kLevel_DevTest;
    }
    else if([received isEqualToString:@"Level_OneOne"]){
        return kLevel_OneOne;
    }
    else if([received isEqualToString:@"Level_OneTwo"]){
        return kLevel_OneTwo;
    }
    else if([received isEqualToString:@"Level_OneThree"]){
        return kLevel_OneThree;
    }
    else if([received isEqualToString:@"Level_TwoOne"]){
        return kLevel_TwoOne;
    }
    else if([received isEqualToString:@"Level_TwoTwo"]){
        return kLevel_TwoTwo;
    }
    else if([received isEqualToString:@"Level_TwoThree"]){
        return kLevel_TwoThree;
    }
    else if([received isEqualToString:@"Level_ThreeOne"]){
        return kLevel_ThreeOne;
    }
    else if([received isEqualToString:@"Level_ThreeTwo"]){
        return kLevel_ThreeTwo;
    }
    else if([received isEqualToString:@"Level_ThreeThree"]){
        return kLevel_ThreeThree;
    }
    else if([received isEqualToString:@"Level_FourOne"]){
        return kLevel_FourOne;
    }
    else if([received isEqualToString:@"Level_FourTwo"]){
        return kLevel_FourTwo;
    }
    else if([received isEqualToString:@"Level_FiveOne"]){
        return kLevel_FiveOne;
    }
    else if([received isEqualToString:@"Level_FiveTwo"]){
        return kLevel_FiveTwo;
    }
    else if([received isEqualToString:@"Level_FiveThree"]){
        return kLevel_FiveThree;
    }
    else if([received isEqualToString:@"Level_SixOne"]){
        return kLevel_SixOne;
    }
    else if([received isEqualToString:@"Level_SixTwo"]){
        return kLevel_SixTwo;
    }
    else if([received isEqualToString:@"Level_SixThree"]){
        return kLevel_SixThree;
    }
    else if([received isEqualToString:@"Level_SevenOne"]){
        return kLevel_SevenOne;
    }
    else if([received isEqualToString:@"Level_SevenTwo"]){
        return kLevel_SevenTwo;
    }
    else if([received isEqualToString:@"Level_SevenThree"]){
        return kLevel_SevenThree;
    }
    
    return 0;
}

- (void)updateWithAccelerometer:(UIAcceleration *)aAcceleration {
    
}

- (void)loadLevelForPlay:(Level)level {
    //  We use [levelFileIndex objectAtIndex:level] because currentLevel is an enum value so
    //  it would (theoretically) correspond to the level it represents place in the levelFileIndex
    [soundManager setMusicVolume:0.0f];
    [soundManager playMusicWithKey:@"game_theme" timesToRepeat:10000];
    [soundManager fadeMusicVolumeFrom:0.0f toVolume:[settingsDB floatForKey:kSetting_MusicVolume] duration:2.0f stop:NO];
    gameLevel = [[GameLevelScene alloc] initWithLevelFile:[levelFileIndex objectAtIndex:level] withDelegate:self];
    levelInProgress = YES;
}

- (void)levelEnded:(NSDictionary *)stats {
    [soundManager setMusicVolume:0.0f];
    [soundManager playMusicWithKey:@"menu_theme" timesToRepeat:10000];
    [soundManager fadeMusicVolumeFrom:0.0f toVolume:[settingsDB floatForKey:kSetting_MusicVolume] duration:2.0f stop:NO];
    
    @try{
        if(gameLevel) [gameLevel release];
    }
    @catch (NSException *e) {
        NSLog(@"%e", e);
    }
    gameLevel = nil;
    showStatsScene = YES;
    [statsScene setSceneState:kSceneState_TransitionIn];
    levelInProgress = NO;
    [statsScene setStatsDictionary:stats];
    nukePowerUpReady = NO;
    
    // Save current score to settings
    [settingsDB setInteger:(int64_t)playerScore forKey:kSetting_SaveGameScore];
    
    [self reportScore:playerScore forCategory:@"xenophobeglobaleaderboard"];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // handle the reporting error
            NSLog(@"%@", error);
        }
        else {
            NSLog(@"SUCCESSSSSSSSSSS!!!!: %d", (int)score);
        }
    }];
}

- (void)playerHasDied {
    lastPlayPlayerDied = YES;
}

- (void)playerReachedSavePoint:(NSString *)savePoint {
    [settingsDB setValue:[NSString stringWithFormat:@"%d;%@", currentLevelIndex, savePoint] forKey:kSetting_SaveGameLevelProgress];
    [settingsDB setInteger:playerScore forKey:kSetting_SaveGameScore];
    [settingsDB setFloat:gameLevel.playerShip.shipHealth forKey:kSetting_SaveGameHealth];
    
    NSLog(@"%@", [settingsDB valueForKey:kSetting_SaveGameLevelProgress]);
}

- (void)scoreChangedBy:(int)scoreChange {
    playerScore += scoreChange;
}

- (void)playerHealthChangedBy:(int)healthChange {

}

- (void)creditAmountChangedBy:(int)creditChange {
    
}

- (void)powerUpPickedUp:(DropType)pickedUp {
    if([enabledPowerUpsArray containsObject:[NSNumber numberWithInt:pickedUp]] == NO && pickedUp != kDropType_Nuke){
        [enabledPowerUpsArray addObject:[NSNumber numberWithInt:pickedUp]];
    }
    if(pickedUp == kDropType_Nuke){
        nukePowerUpReady = YES;
    }
}

- (void)clearAllPowerUpsPickedUp {
    [enabledPowerUpsArray removeAllObjects];
}


- (void)transitionToSceneWithKey:(NSString *)aKey {
	sceneState = kSceneState_TransitionOut;
}

- (void)render {
    // In-game graphics rendered first
    [backgroundParticleEmitter renderParticles];
    if(!gameLevel.currentWaveType == kWaveType_Dialogue && !showStatsScene){
        [healthBarBackground renderAtPoint:CGPointMake(254, 14.0) centerOfImage:NO];
        [healthBar renderAtPoint:CGPointMake(255, 15.0) centerOfImage:NO];
    }
    
    // Level
    if(levelInProgress) {
        if(gameLevel) [gameLevel render];
    }
    
    if(!showStatsScene && levelInProgress){
        int powerUpNumberToRender = 0;
        for(NSNumber *powerUpTypeToRender in enabledPowerUpsArray){
            switch ([powerUpTypeToRender intValue]) {
                case kDropType_Shield:
                {
                    [shieldImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_DamageMultiplier:
                {
                    [damageMultiplierImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_ScoreMultiplier:
                {
                    [scoreMultiplierImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_EnemyRepel:
                {
                    [enemyRepelImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_DropsMagnet:
                {
                    [magnetImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_Slowmo:
                {
                    [slowmoImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                case kDropType_ProximityDamage:
                {
                    [proximityDamageImage renderAtPoint:CGPointMake(15, 200 - (powerUpNumberToRender * 20)) centerOfImage:YES];
                    powerUpNumberToRender++;
                    break;
                }
                    
                default:
                    break;
            }
        }
        if(nukePowerUpReady){
            [nukeImage renderAtPoint:CGPointMake(15, 30) centerOfImage:YES];
        }
    }
    
    if(gameIsPaused){
        [pauseScreen render];
    }
    if(!gameIsPaused && !showStatsScene){
        [pauseButton render];
    }
    if(showStatsScene){
        [statsScene render];
    }
    
    if(!showStatsScene){
        [font drawStringAt:CGPointMake(10.0, 465.0) text:[NSString stringWithFormat:@"%09d", playerScore]];
    }
    
    if(DEBUG) {
        
        //Draw some text at the bottom-left corner indicating the current FPS.
        [font drawStringAt:CGPointMake(15.0, 15.0) text:[NSString stringWithFormat:@"%.1f", [_sharedDirector framesPerSecond]]];
    }
}

- (void)dealloc {
    [backgroundParticleEmitter release];
    [healthBar release];
    [healthBarBackground release];
    [pauseScreen release];
    [pauseButton release];
    
    [shieldImage release];
    [damageMultiplierImage release];
    [scoreMultiplierImage release];
    [enemyRepelImage release];
    [magnetImage release];
    [slowmoImage release];
    [proximityDamageImage release];
    [nukeImage release];
    [enabledPowerUpsArray release];
    
    [font release];
    //[bulletTest release];
    [levelFileIndex release];
    if(statsScene) [statsScene release];
    if(gameLevel) [gameLevel release];
    [super dealloc];
}

@end
