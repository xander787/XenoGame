//
//  GameLevelScene.m
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
//  Last Updated - 7/9/2011 @9:10PM - James
//  - Added Bool dialogueIsTyping, and had that work with
//  the fast forward button to automatically show all text
//  instead of skipping ahead.
//
//  Last Updated - 7/9/2011 @9:20PM - Alexander
//  - Changed the bounding box for the fast forward button.
//
//  Last Updated - 7/9/2011 @9:40PM - Alexander
//  - Now storing the current speaker. Created a method to parse it
//  and figure out who the speaker is. We'll use this to display it's icon.
//
//  Last Updated - 7/9/2011 @10PM - James
//  - Added and ellipses to the end of dialogueLineSixbuffer when there is
//  another page of text to read
//
//  Last Updated - 7/18/11 @9PM - Alexander
//  - Fly off transition added
//
//  Last Updated - 7/19/11 @1PM - James
//  - Player stops shooting during fly-off transition
//
//  Last Updated - 7/20/11 @4:30PM - James
//  - Removed the hover code for enemies, done now in
//  enemy class
//
//  Last Updated - 7/19/11 @6PM - Alexander
//  - Cleaned up the update method to only do necessary tasks during
//  the appropriate wave type
//  - Cleaned up the collision update method to only do necessary tasks
//  during the appropriate wave type as well as added collision support
//  for player projectiles -> boss modules
//  - Boss ships now fly in after the waves have been completed
//
//  Last updated - 7/20/11 @8:15PM - James
//  - Fixed a crash on collision detection with boss
//
//  Last Updated - 7/20/11 @9PM - James
//  - Added plaership vs. boss module collision detection
//
//  Last Updated - 7/21/11 @4:40PM - James
//  - Added Attack paths to ships, every 4 second a ship gets
//  a half chance of attacking
//
//  Last Updated - 7/20/11 @7:30 PM - Alexander
//  - Player ship bullets dissapear when hitting boss modules,
//  but only when the modules are currently in line to be destroyed
//  thus eliminating the problem of modules inside of modules.
//
//  Last Updated - 7/21/11 @9PM - James
//  - Fixed bug where Enemies would momentarily appear in middle of screen,
//  stopped player bullets when boss flies onto screen, upgraded collision detection
//  to only detect when hitting living modules
//
//  Last Updated - 7/22/11 @9:30PM - James
//  - Improved enemy's attack code. Total number of concurrent attacking
//  enemies limited to 3, 50% chance of going left or right, timing improved.
//
//  Last updated - 7/23/11 @6PM - alexander
//  - Dialogue now displays icon of speaker
//
//  Last Updated - 7/23/11 @5:50PM - James
//  - Added basic functionality for drops and powerups,
//  50% chance of dropping a credit
//
//  Last Updated - 7/23/11 @11:45PM - James
//  - Added a quick template for drop types on player pickup,
//  made delegate call to add credits
//
//  Last Updated - 7/24/11 @2:20PM - James
//  - Added shield powerUp functionality
//
//  Last Updated - 7/24/11 @11PM - James
//  - Started implementation of more Drops, only shield and Magnet work
//
//  Last Updated - 7/25/11 @3:20PM - James
//  - Added first implementation of kamikaze attacks,
//  doens't go straight to player though
//
//  Last Updated - 7/26/11 @2:20PM - James
//  - Enemies now fire when attacking
//
//  Last Updated - 7/26/11 @7:20M - James
//  - Fixed bug where it'd prematurely show the stats scene
//
//  Last Updated - 7/27/11 @4:20PM - James
//  - Bug fixes mainly
//
//  Last Updated - 7/28/11 @5:30PM - Alexander
//  - New delegate method for saving progress
//
//  Last Updated - 7/30/11 @5PM - James
//  - Bug fixes, optimization, slightly trimmed down update:
//
//  Last Updated - 9/25/11 @6:30PM - James
//  - Fixed placement and touch responsive area of the skip button, 
//  now measures 40x40 resting at bottom right corner.
//
//  Last Updated - 9/26/11 @11:15PM - James
//  - Fixed bug where lag would make enemy ships skip over their holding
//  position, go on forever
//
//  Last Updated - 9/26/11 @11:30PM - James
//  - Made boss projectiles also hurt player.
//
//  Last Updated - 11/1/11 @9:15PM - James
//  - Tweaked drop pickup radius, made player ship able to
//  move past the edge of the screen instead of hitting edge.
//
//  Last Updated - 6/19/2012 @10:30PM - James
//  - Moved the render position of the "Game Over"
//  to be over all other objects


#import "GameLevelScene.h"

static const char *
NextWord(const char *input)
{
    static       char  buffer[1024];
    static const char *text = 0;
    
    char *endOfBuffer = buffer + sizeof(buffer) - 1;
    char *pBuffer     = buffer;
    
    if (input) {
        text = input;
    }
    
    if (text) {
        /* skip leading spaces */
        while (isspace(*text)) {
            ++text;
        }
        
        /* copy the word to our static buffer */
        while (*text && !isspace(*text) && pBuffer < endOfBuffer) {
            *(pBuffer++) = *(text++);
        }
    }
    
    *pBuffer = 0;
    
    return buffer;
}

const char *
WrapText( const char *text
         , int         maxWidth
         , const char *prefixFirst
         , const char *prefixRest)
{
    const char *prefix = 0;
    const char *s      = 0;
    char       *wrap   = 0;
    char       *w      = 0;
    
    int lineCount      = 0;
    int lenBuffer      = 0;
    int lenPrefixFirst = strlen(prefixFirst? prefixFirst: "");
    int lenPrefixRest  = strlen(prefixRest ? prefixRest : "");
    int spaceLeft      = maxWidth;
    
    if (maxWidth == 0) {
        maxWidth = 78;
    }
    if (lenPrefixFirst + 5 > maxWidth) {
        maxWidth = lenPrefixFirst + 5;
    }
    if (lenPrefixRest + 5 > maxWidth) {
        maxWidth = lenPrefixRest + 5;
    }
    
    /* two passes through the input. the first pass updates the buffer length.
     * the second pass creates and populates the buffer
     */
    while (wrap == 0) {
        lineCount = 0;
        
        if (lenBuffer) {
            /* second pass, so create the wrapped buffer */
            wrap = (char *)malloc(sizeof(char) * (lenBuffer + 1));
            if (wrap == 0) {
                break;
            }
        }
        w = wrap;
        
        /* for each Word in Text
         *   if Width(Word) > SpaceLeft
         *     insert line break before Word in Text
         *     SpaceLeft := LineWidth - Width(Word)
         *   else
         *     SpaceLeft := SpaceLeft - Width(Word) + SpaceWidth
         */
        s = NextWord(text);
        while (*s) {
            spaceLeft     = maxWidth;
            
            /* copy the prefix */
            prefix = lineCount ? prefixRest : prefixFirst;
            prefix = prefix ? prefix : "";
            while (*prefix) {
                if (w == 0) {
                    ++lenBuffer;
                } else {
                    *(w++) = *prefix == '\n' ? ' ' : *prefix;
                }
                --spaceLeft;
                ++prefix;
            }
            
            /* force the first word to always be completely copied */
            while (*s) {
                if (w == 0) {
                    ++lenBuffer;
                } else {
                    *(w++) = *s;
                }
                --spaceLeft;
                ++s;
            }
            if (!*s) {
                s = NextWord(0);
            }
            
            /* copy as many words as will fit onto the current line */
            while (*s && strlen(s) + 1 <= spaceLeft) {
                /* will fit so add a space between the words */
                if (w == 0) {
                    ++lenBuffer;
                } else {
                    *(w++) = ' ';
                }
                --spaceLeft;
                
                /* then copy the word */
                while (*s) {
                    if (w == 0) {
                        ++lenBuffer;
                    } else {
                        *(w++) = *s;
                    }
                    --spaceLeft;
                    ++s;
                }
                if (!*s) {
                    s = NextWord(0);
                }
            }
            if (!*s) {
                s = NextWord(0);
            }
            
            if (*s) {
                /* add a new line here */
                if (w == 0) {
                    ++lenBuffer;
                } else {
                    *(w++) = '\n';
                }
            }
            
            ++lineCount;
        }
        
        lenBuffer += 2;
        
        if (w) {
            *w = 0;
        }
    }
    
    return wrap;
}

@implementation GameLevelScene

@synthesize delegate, playerShip, currentWaveType;

- (id)initWithLevelFile:(NSString *)levelFile withDelegate:(id <GameLevelDelegate>)del {
    if((self = [super init])){		
        // Grab the bounds of the screen
		screenBounds = [[UIScreen mainScreen] bounds];
        
        settingsDB = [NSUserDefaults standardUserDefaults];
        
        delegate = del;
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:levelFile ofType:@"plist"]];
        levelDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [path release];
        
        soundManager = [SoundManager sharedSoundManager];
        
        // Load and save the level type for this level
        if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kMiniBossLevel"]) {
            levelType = kLevelType_MiniBoss;
            if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossOneOne"]){
                bossShipID = kMiniBoss_OneOne;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossOneTwo"]){
                bossShipID = kMiniBoss_OneTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossOneThree"]){
                bossShipID = kMiniBoss_OneThree;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossTwoTwo"]){
                bossShipID = kMiniBoss_TwoTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossTwoThree"]){
                bossShipID = kMiniBoss_TwoThree;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossThreeOne"]){
                bossShipID = kMiniBoss_ThreeOne;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossThreeTwo"]){
                bossShipID = kMiniBoss_ThreeTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossThreeThree"]){
                bossShipID = kMiniBoss_ThreeThree;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossSixTwo"]){
                bossShipID = kMiniBoss_SixTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossFourTwo"]){
                bossShipID = kMiniBoss_FourTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossSixOne"]){
                bossShipID = kMiniBoss_SixOne;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossSevenThree"]){
                bossShipID = kMiniBoss_SevenThree;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossFiveTwo"]){
                bossShipID = kMiniBoss_FiveTwo;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossSevenOne"]){
                bossShipID = kMiniBoss_SevenOne;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossFiveOne"]){
                bossShipID = kMiniBoss_FiveOne;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossFiveThree"]){
                bossShipID = kMiniBoss_FiveThree;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kMiniBossTwoOne"]){
                bossShipID = kMiniBoss_TwoOne;
            }
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kBossLevel"]) {
            levelType = kLevelType_Boss;
            if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossAtlas"]) {
                //bossShip = [[BossShipAtlas alloc] initWithLocation:CGPointMake(0.0f, 0.0f) andPlayerShipRef:playerShip];
                bossShipID = kBoss_Atlas;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossAstraeus"]) {
                bossShipID = kBoss_Astraeus;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossHelios"]) {
                bossShipID = kBoss_Helios;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossOceanus"]){
                bossShipID = kBoss_Oceanus;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossHyperion"]) {
                bossShipID = kBoss_Hyperion;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossThemis"]) {
                bossShipID = kBoss_Themis;
            }
            else if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossKronos"]) {
                bossShipID = kBoss_Kronos;
            }
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kCutsceneLevel"]) {
            levelType = kLevelType_Cutscene;
        }
        
        bossHealthBar = [[Image alloc] initWithImage:@"BossHealthBar.png" scale:Scale2fOne];
        bossHealthBarBackground = [[Image alloc] initWithImage:@"HealthBarBackground.png" scale:Scale2fOne];
        
        NSArray *bossDefaultLocationArray = [[NSArray alloc] initWithArray:[[levelDictionary objectForKey:@"kBossDefaultPoint"] componentsSeparatedByString:@","]];
        bossShipDefaultLocation = CGPointMake([[bossDefaultLocationArray objectAtIndex:0] floatValue], [[bossDefaultLocationArray objectAtIndex:1] floatValue]);
        [bossDefaultLocationArray release];
        
        bossShipIsDisplayed = NO;
        bossShipReadyToAnimate = NO;
        bossShipIntroAnimationTime = 0.0;
        
        // Load and save the outro transition for this level
        if([[levelDictionary objectForKey:@"kOutroTransition"] isEqualToString:@"kShipFlyOff"]) {
            outroAnimationType = kOutroAnimation_Flyoff;
        }
        if([[levelDictionary objectForKey:@"kOutroTransition"] isEqualToString:@"kNuke"]) {
            outroAnimationType = kOutroAnimation_Nuke;
            transitionParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                          position:Vector2fMake(160, 240)
                                                                            sourcePositionVariance:Vector2fZero
                                                                                             speed:0.8f
                                                                                     speedVariance:0.05f
                                                                                  particleLifeSpan:4.5f 
                                                                          particleLifespanVariance:0.5f 
                                                                                             angle:0.0f 
                                                                                     angleVariance:360.0f 
                                                                                           gravity:Vector2fZero
                                                                                        startColor:Color4fMake(0.1f, 0.0f, 0.7f, 1.0f)
                                                                                startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                                       finishColor:Color4fMake(0.03f, 0.11f, 0.0f, 0.5f)
                                                                               finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                                      maxParticles:1000 
                                                                                      particleSize:48.0f 
                                                                                finishParticleSize:48.0f 
                                                                              particleSizeVariance:16.0f 
                                                                                          duration:0.2f 
                                                                                     blendAdditive:YES];
        }
        if([[levelDictionary objectForKey:@"kOutroTransition"] isEqualToString:@"kWormhole"]) {
            outroAnimationType = kOutroAnimation_Wormhole;
            transitionParticleEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                          position:Vector2fMake(160.0f, 320.0f)
                                                                            sourcePositionVariance:Vector2fZero
                                                                                             speed:0.3f
                                                                                     speedVariance:0.05f
                                                                                  particleLifeSpan:0.9f
                                                                          particleLifespanVariance:0.3f
                                                                                             angle:0.0f
                                                                                     angleVariance:360.0f
                                                                                           gravity:Vector2fZero
                                                                                        startColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                                startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                                                       finishColor:Color4fMake(1.0f, 0.6f, 1.0f, 0.66f)
                                                                               finishColorVariance:Color4fMake(0.0f, 0.0f, 1.0f, 0.0f)
                                                                                      maxParticles:1500
                                                                                      particleSize:16
                                                                                finishParticleSize:16
                                                                              particleSizeVariance:0
                                                                                          duration:-1
                                                                                     blendAdditive:YES];
        }
        
        outroTransitionAnimating = NO;
        
        wavesArray = [levelDictionary objectForKey:@"kWaves"];
        numWaves = [wavesArray count];
        currentWave = 0;
        
        enemiesSet = [[NSMutableSet alloc] init];
        
        [self loadWave:currentWave];
        
        
        playerShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_XP750 andInitialLocation:CGPointMake(155, 40)];
        
        font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:(1.0/3.0) filter:GL_LINEAR];
        dialogueBorder = [[Image alloc] initWithImage:@"DialogueBoxBorder.png" scale:Scale2fOne];
        dialogueFastForwardButton = [[Image alloc] initWithImage:@"fastforward.png" scale:Scale2fOne];
        
        attackingEnemies = [[NSMutableSet alloc] init];
        droppedPowerUpSet = [[NSMutableSet alloc] init];
        shieldImage = [[Image alloc] initWithImage:@"PlayerShield.png" scale:Scale2fOne];
    }
    
    return self;
}

- (EnemyShipID)convertToEnemyEnum:(NSString *)enemyString {
    if([enemyString isEqualToString:@"kShipOneShot_One"]) {
        return kEnemyShip_OneShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipTwoShot_One"]) {
        return kEnemyShip_TwoShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipTwoShot_Two"]){
        return kEnemyShip_TwoShotLevelTwo;
    }
    else if([enemyString isEqualToString:@"kShipThreeShot_One"]){
        return kEnemyShip_ThreeShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipThreeShot_Three"]){
        return kEnemyShip_ThreeShotLevelThree;
    }
    else if([enemyString isEqualToString:@"kShipWaveShot_One"]){
        return kEnemyShip_WaveShotLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipWaveShot_Two"]){
        return kEnemyShip_WaveShotLevelTwo;
    }
    else if([enemyString isEqualToString:@"kShipWaveShot_Four"]){
        return kEnemyShip_WaveShotLevelFour;
    }
    else if([enemyString isEqualToString:@"kShipMissileBombShot_Three"]) {
        return kEnemyShip_MissileBombShotLevelThree;
    }
    else if([enemyString isEqualToString:@"kShipKamikaze_One"]){
        return kEnemyShip_KamikazeLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipKamikaze_Three"]){
        return kEnemyShip_KamikazeLevelThree;
    }
    
    
    return -1;
}

- (DialogueSpeaker)convertToSpeakerEnum:(NSString *)speaker {    
    if ([speaker isEqualToString:@"PLAYER"]) {
        return kSpeaker_Player;
    }
    else if([speaker isEqualToString:@"GENERAL"]) {
        return kSpeaker_General;
    }
    else if([speaker isEqualToString:@"BOSSONE"]) {
        return kSpeaker_BossOne;
    }
    else if([speaker isEqualToString:@"BOSSTWO"]) {
        return kSpeaker_BossTwo;
    }
    else if([speaker isEqualToString:@"BOSSTHREE"]) {
        return kSpeaker_BossThree;
    }
    else if([speaker isEqualToString:@"BOSSFOUR"]) {
        return kSpeaker_BossFour;
    }
    else if([speaker isEqualToString:@"BOSSFIVE"]) {
        return kSpeaker_BossFive;
    }
    else if([speaker isEqualToString:@"BOSSSIX"]) {
        return kSpeaker_BossSix;
    }
    else if([speaker isEqualToString:@"BOSSSEVEN"]) {
        return kSpeaker_BossSeven;
    }
    else if([speaker isEqualToString:@"KRONOS"]) {
        return kSpeaker_Kronos;
    }
    else if([speaker isEqualToString:@"SINGULARITY"]) {
        return kSpeaker_Singularity;
    }
    else if([speaker isEqualToString:@"ALIENSWARM"]) {
        return kSpeaker_AlienSwarm;
    }
    
    return -1;
}

- (void)loadWave:(int)wave {  
    [delegate playerReachedSavePoint:[NSString stringWithFormat:@"%d", wave]];
    
    if(![[wavesArray objectAtIndex:wave] respondsToSelector:@selector(setString:)]) {
        for(int i = 0; i < [[wavesArray objectAtIndex:wave] count]; ++i) {
            currentWaveType = kWaveType_Enemy;
            EnemyShip *enemy = [[EnemyShip alloc] initWithShipID:[self convertToEnemyEnum:[[[wavesArray objectAtIndex:wave] objectAtIndex:i] objectAtIndex:0]] initialLocation:CGPointMake(-50, 400) andPlayerShipRef:playerShip];
            enemy.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(0, 480) controlPoint1:Vector2fMake(320, 240) controlPoint2:Vector2fMake((5 * RANDOM_0_TO_1()), (240 + (10 * RANDOM_0_TO_1()))) endPoint:Vector2fMake(160, 100) segments:100];
            enemy.currentPathType = kPathType_Initial;
            
            //NSArray *enemyHoldingCoord = [[[[wavesArray objectAtIndex:wave] objectAtIndex:i] objectAtIndex:1] componentsSeparatedByString:@","];
            //enemy.holdingPositionPoint = CGPointMake([[enemyHoldingCoord objectAtIndex:0] intValue], [[enemyHoldingCoord objectAtIndex:1] intValue]);
            //[enemyHoldingCoord release];
            
            NSString *enemyHoldingCoordString = [[[wavesArray objectAtIndex:wave] objectAtIndex:i] objectAtIndex:1];
            NSArray *enemyHoldingCoordArray = [enemyHoldingCoordString componentsSeparatedByString:@","];
            enemy.holdingPositionPoint = CGPointMake([[enemyHoldingCoordArray objectAtIndex:0] intValue], [[enemyHoldingCoordArray objectAtIndex:1] intValue]);
            
            [enemiesSet addObject:enemy];
            outroDelay = 0;
            [enemy release];
        }
        holdingTimeTarget = (RANDOM_0_TO_1() * 4);
    }
    else {
        currentWaveType = kWaveType_Dialogue;
        dialogue = [[NSArray alloc] initWithArray:[[wavesArray objectAtIndex:wave] componentsSeparatedByString:@";"]];
        currentDialogueSpeaker = [self convertToSpeakerEnum:[[[dialogue objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:0]];
        currentDialogueSpeakerIndex = 0;
        currentDialogueDisplayLine = 1;
        currentDialogueCharacterPosition = 0;
        dialogueBuffer = [[NSMutableString alloc] init];
        dialogueLineOneBuffer = [[NSMutableString alloc] init];
        dialogueLineTwoBuffer = [[NSMutableString alloc] init];
        dialogueLineThreeBuffer = [[NSMutableString alloc] init];
        dialogueLineFourBuffer = [[NSMutableString alloc] init];
        dialogueLineFiveBuffer = [[NSMutableString alloc] init];
        dialogueLineSixBuffer = [[NSMutableString alloc] init];
                
        // Load speaker icon
        if (currentDialogueSpeaker == kSpeaker_Player) {
            speakerImage = [[Image alloc] initWithImage:@"PilotXIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_General) {
            speakerImage = [[Image alloc] initWithImage:@"GeneralAIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossOne) {
            speakerImage = [[Image alloc] initWithImage:@"BossOneIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossTwo) {
            speakerImage = [[Image alloc] initWithImage:@"BossTwoIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossThree) {
            speakerImage = [[Image alloc] initWithImage:@"BossThreeIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossFour) {
            speakerImage = [[Image alloc] initWithImage:@"BossFourIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossFive) {
            speakerImage = [[Image alloc] initWithImage:@"BossFiveIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossSix) {
            speakerImage = [[Image alloc] initWithImage:@"BossSixIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_BossSeven) {
            speakerImage = [[Image alloc] initWithImage:@"BossSevenIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_Kronos) {
            speakerImage = [[Image alloc] initWithImage:@"KronosIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_Singularity) {
            speakerImage = [[Image alloc] initWithImage:@"TheSingularityIcon.png" scale:Scale2fOne];
        }
        else if (currentDialogueSpeaker == kSpeaker_AlienSwarm) {
            speakerImage = [[Image alloc] initWithImage:@"AlienSwarmIcon.png" scale:Scale2fOne];
        }
        
        //What's going on here is It fills the necessary strings with the right text, strings 1-3 with 22 wrapped text,
        //4-6 with 28 wrapped. It has to go through all those if statement because not all dialogue wil take all 6 six lines.
        const char* wrappedText = WrapText([[[[dialogue objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] UTF8String], 22, "", "");
        NSMutableArray *wrappedTextArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:wrappedText encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
        //NSLog(@"%@", wrappedTextArray);
        dialogueLineOne = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:0]];
        currentNumberOfDialogueLinesToShow = 1;
        if([wrappedTextArray count] > 1){
            dialogueLineTwo = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:1]];
            currentNumberOfDialogueLinesToShow = 2;
            if([wrappedTextArray count] > 2){
                dialogueLineThree = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:2]];
                currentNumberOfDialogueLinesToShow = 3;
                if([wrappedTextArray count] > 3){
                    //Exceeding three lines, prep the stuff for a larger word wrap
                    [wrappedTextArray removeObject:dialogueLineOne];
                    [wrappedTextArray removeObject:dialogueLineTwo];
                    [wrappedTextArray removeObject:dialogueLineThree];
                    
                    NSString *secondHalfString = [[NSString alloc] initWithString:[wrappedTextArray componentsJoinedByString:@" "]];
                    //NSLog(@"joined:\n%@", secondHalfString);
                    const char* secondHalf = WrapText([secondHalfString UTF8String], 25, "", "");
                    NSMutableArray *secondWrappedArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:secondHalf encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
                    //NSLog(@"%@", secondWrappedArray);
                    dialogueLineFour = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:0]];
                    currentNumberOfDialogueLinesToShow = 4;
                    if([secondWrappedArray count] > 1){
                        dialogueLineFive = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:1]];
                        currentNumberOfDialogueLinesToShow = 5;
                        if([secondWrappedArray count] > 2){
                            dialogueLineSix = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:2]];
                            currentNumberOfDialogueLinesToShow = 6;
                            if([secondWrappedArray count] >3){
                                //Exceeds all six lines, fill the remainder string
                                [secondWrappedArray removeObject:dialogueLineFour];
                                [secondWrappedArray removeObject:dialogueLineFive];
                                [secondWrappedArray removeObject:dialogueLineSix];
                                
                                remainderDialogue = [[NSString alloc] initWithString:[secondWrappedArray componentsJoinedByString:@" "]];
                            }
                        }
                    }
                    [secondWrappedArray release];
                    [secondHalfString release];
                }
            }
        }
        [wrappedTextArray release];
        //NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n\n%@", dialogueLineOne, dialogueLineTwo, dialogueLineThree, dialogueLineFour, dialogueLineFive, dialogueLineSix, remainderDialogue);
    }
    
    int multiplier = 1;
    for(EnemyShip *enemyShip in enemiesSet){
        enemyShip.pathTime -= (multiplier * 0.3);
        multiplier++;
    }
}

- (void)loadBoss {
    if (bossShipID == kBoss_Atlas) {
        bossShip = [[BossShipAtlas alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kBoss_Astraeus) {
        bossShip = [[BossShipAstraeus alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kBoss_Helios) {
        bossShip = [[BossShipHelios alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kBoss_Oceanus) {
        bossShip = [[BossShipOceanus alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kBoss_Hyperion) {
        bossShip = [[BossShipHyperion alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayershipRef:playerShip];
    }
    else if(bossShipID == kBoss_Themis) {
        bossShip = [[BossShipThemis alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayershipRef:playerShip];
    }
    else if(bossShipID == kBoss_Kronos) {
        bossShip = [[BossShipKronos alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_OneOne) {
        bossShip = [[MiniBoss_OneOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_OneTwo) {
        bossShip = [[MiniBoss_OneTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_TwoTwo) {
        bossShip = [[MiniBoss_TwoTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_TwoThree) {
        bossShip = [[MiniBoss_TwoThree alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_ThreeOne) {
        bossShip = [[MiniBoss_ThreeOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_ThreeTwo) {
        bossShip = [[MiniBoss_ThreeTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_ThreeThree) {
        bossShip = [[MiniBoss_ThreeThree alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_SixTwo) {
        bossShip = [[MiniBoss_SixTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_OneThree) {
        bossShip = [[MiniBoss_OneThree alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_FourTwo) {
        bossShip = [[MiniBoss_FourTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_SixOne) {
        bossShip = [[MiniBoss_SixOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_SevenThree) {
        bossShip = [[MiniBoss_SevenThree alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_FiveTwo) {
        bossShip = [[MiniBoss_FiveTwo alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_SevenOne) {
        bossShip = [[MiniBoss_SevenOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_FiveOne) {
        bossShip = [[MiniBoss_FiveOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_FiveThree) {
        bossShip = [[MiniBoss_FiveThree alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    else if(bossShipID == kMiniBoss_TwoOne) {
        bossShip = [[MiniBoss_TwoOne alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    
    bossShipReadyToAnimate = YES;
    
    [soundManager fadeMusicVolumeFrom:[settingsDB floatForKey:kSetting_MusicVolume] toVolume:0.0f duration:2.0f stop:NO];
}

- (void)update:(GLfloat)aDelta {   
    if(gameIsOver) return;

    
    levelTime+= aDelta;
    
    if(currentWaveType == kWaveType_Enemy || currentWaveType == kWaveType_Boss || currentWaveType == kWaveType_Finished){
        [playerShip update:aDelta];
    }
    
    // We are currently in a "fighting" wave. Update accordingly.
    if (currentWaveType == kWaveType_Enemy || currentWaveType == kWaveType_Boss) {
        //Game over stuff
        if(playerShip.shipIsDead){
            gameOverTimer += aDelta;
            if(gameOverTimer >= 8.0){
                gameOverTimer = 0;
                gameIsOver = YES;
                [delegate playerHasDied];
            }
        }
        
        //Make sure that all of our ship objects get their update: called. Necessary.
        
        if(shieldEnabled || damageMultiplierOn || scoreMultiplierOn ||
           enemyRepelOn || powerUpMagnetActivated || slowmoActivated ||
           proximityDamageActivated){
            //If any powerups are picked up and enabled
            powerUpTimer += aDelta;
            if(powerUpTimer >= 8){
                //Reset timer and all power ups
                powerUpTimer = 0;
                shieldEnabled = NO;
                damageMultiplierOn = NO;
                scoreMultiplierOn = NO;
                enemyRepelOn = NO;
                powerUpMagnetActivated = NO;
                slowmoActivated = NO;
                proximityDamageActivated = NO;
                [delegate clearAllPowerUpsPickedUp];
            }
        }
        
        //Update the drops, as some enemies may appear in both enemy and boss waves
        NSMutableSet *dropsToBeRemoved = [[NSMutableSet alloc] init];
        for(Drop *drop in droppedPowerUpSet){
            [drop update:aDelta];
            if(drop.magnetActivated != powerUpMagnetActivated){
                drop.magnetActivated = powerUpMagnetActivated;
            }
            
            if(abs(drop.location.x - playerShip.currentLocation.x) < 36 &&
               abs(drop.location.y - playerShip.currentLocation.y) < 36){
                numDropPickups++;
                
                //Drop picked up
                switch (drop.dropType) {
                    case kDropType_Credit:
                    {
                        [delegate creditAmountChangedBy:100];
                        break;
                    }
                        
                    case kDropType_Shield:
                    {
                        shieldEnabled = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_Shield];
                        [delegate scoreChangedBy:kScore_ShieldBonus + (scoreMultiplierOn * kScore_ShieldBonus)];
                        break;
                    }
                        
                    case kDropType_DamageMultiplier:
                    {
                        damageMultiplierOn = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_DamageMultiplier];
                        [delegate scoreChangedBy:kScore_DoubleDamageBonus + (scoreMultiplierOn * kScore_DoubleDamageBonus)];
                        break;
                    }
                        
                    case kDropType_ScoreMultiplier:
                    {
                        scoreMultiplierOn = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_ScoreMultiplier];
                        break;
                    }
                        
                    case kDropType_EnemyRepel:
                    {
                        enemyRepelOn = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_EnemyRepel];
                        [delegate scoreChangedBy:kScore_EnemyRepelBonus + (scoreMultiplierOn * kScore_EnemyRepelBonus)];
                        break;
                    }
                        
                    case kDropType_DropsMagnet:
                    {
                        powerUpMagnetActivated = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_DropsMagnet];
                        [delegate scoreChangedBy:kScore_MagnetBonus + (scoreMultiplierOn * kScore_MagnetBonus)];
                        break;
                    }
                        
                    case kDropType_Slowmo:
                    {
                        slowmoActivated = YES;
                        powerUpTimer = 0;
                        [delegate powerUpPickedUp:kDropType_Slowmo];
                        [delegate scoreChangedBy:kScore_SlowmoBonus + (scoreMultiplierOn * kScore_SlowmoBonus)];
                        break;
                    }
                        
                    case kDropType_ProximityDamage:
                    {
                        proximityDamageActivated = YES;
                        [delegate powerUpPickedUp:kDropType_ProximityDamage];
                        [delegate scoreChangedBy:kScore_ProximityDamageBonus + (scoreMultiplierOn * kScore_ProximityDamageBonus)];
                        break;
                    }
                        
                    case kDropType_Health:
                    {
                        NSLog(@"More Health");
                        int oldHealth = playerShip.shipHealth;
                        playerShip.shipHealth += 10;
                        if(playerShip.shipHealth > playerShip.shipMaxHealth){
                            playerShip.shipHealth = playerShip.shipMaxHealth;
                        }
                        [delegate playerHealthChangedBy:playerShip.shipHealth - oldHealth];
                        [delegate scoreChangedBy:kScore_ExtraHealthBonus + (scoreMultiplierOn * kScore_ExtraHealthBonus)];
                        break;
                    }
                        
                    case kDropType_Nuke:
                    {
                        nukeReadyForUse = YES;
                        [delegate powerUpPickedUp:kDropType_Nuke];
                        [delegate scoreChangedBy:kScore_NukeBonus + (scoreMultiplierOn * kScore_NukeBonus)];
                        break;
                    }
                        
                    default:
                        break;
                }
                [dropsToBeRemoved addObject:drop];
            }
        }
        [droppedPowerUpSet minusSet:dropsToBeRemoved];
        [dropsToBeRemoved release];
        
        if (currentWaveType == kWaveType_Enemy) {
            //Affect the delta for slowmo
            if(slowmoActivated) aDelta *= 0.5;
            
            if(proximityDamageActivated){
                proximityDamageTimer += aDelta;
                proximityShouldGiveDamage = NO;
                if(proximityDamageTimer > 0.8){
                    proximityShouldGiveDamage = YES;
                    proximityDamageTimer = 0.0f;
                }
            }
            
            NSMutableSet *discardedEnemies = [[NSMutableSet alloc] init];
            //Update the enemies' movement paths
            for(EnemyShip *enemyShip in enemiesSet){
                
                //Main update for enemies
                [enemyShip update:aDelta];
                
                // Loop through our enemies and remove those that have died and whose
                // destruction animations have completed
                if(enemyShip.shipIsDead && enemyShip.deathAnimationEmitter.particleCount == 0) {
                    enemiesKilled++;
                    [discardedEnemies addObject:enemyShip];
                    if([attackingEnemies containsObject:enemyShip]){
                        [attackingEnemies removeObject:enemyShip];
                    }
                }
                
                if(enemyShip.shipHealth <= 0 && enemyShip.powerUpDropped == NO){
                    //Calculate which type of powerup to drop
                    if(TRUE){
                        //Drop a credit
                        Drop *tempCredit = [[Drop alloc] initWithDropType:MAX(0, (int)(RANDOM_0_TO_1()*10))
                                                                 position:Vector2fMake(enemyShip.currentLocation.x, enemyShip.currentLocation.y)
                                                         andPlayerShipRef:playerShip];
                        tempCredit.magnetActivated = powerUpMagnetActivated;
                        [droppedPowerUpSet addObject:tempCredit];
                        [tempCredit release];
                        enemyShip.powerUpDropped = YES;
                    }
                }
                
                //Proximity Damage calculations
                if(proximityDamageActivated && proximityShouldGiveDamage){
                    if(sqrt(pow(enemyShip.currentLocation.x - playerShip.currentLocation.x, 2) + pow(enemyShip.currentLocation.y - playerShip.currentLocation.y, 2)) < 64){
                        //If the enemy is less than 64 units away from the player, give damage to enemy
                        [enemyShip hitShipWithDamage:10];
                    }
                }
                
                if(enemyShip.shipIsDead == NO){
                    //Skip dead enemies, no need to waste cpu
                    
                    //Path updating:
                    if(enemyShip.currentPathType == kPathType_Initial){
                        [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/2].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/2].y)];
                    
//                        if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                        if(enemyShip.currentLocation.y <= enemyShip.currentPath.endPoint.y){
                            Vector2f oldEndPoint = enemyShip.currentPath.endPoint;
                            //Make a new path for ToHolding
                            [enemyShip makeNewPathFrom:Vector2fMake(oldEndPoint.x, oldEndPoint.y) controlPoint1:Vector2fMake(100, 100) controlPoint2:Vector2fMake(300, 300) toEndPoint:Vector2fMake(enemyShip.holdingPositionPoint.x, enemyShip.holdingPositionPoint.y) withPathType:kPathType_ToHolding];
                        }
                    }
                    else if(enemyShip.currentPathType == kPathType_ToHolding){
                        [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/2].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/2].y)];
                    
//                        if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                        if(enemyShip.currentLocation.y >= enemyShip.currentPath.endPoint.y){
                            Vector2f oldEndPoint = enemyShip.currentPath.endPoint;
                            [enemyShip resetPathWithNewPathType:kPathType_Holding];
                            enemyShip.desiredPosition = CGPointMake(oldEndPoint.x, oldEndPoint.y);
                        }
                    }
                    else if(enemyShip.currentPathType == kPathType_Holding){
                        holdingTimeBeforeAttack += (aDelta / [enemiesSet count]) * 2;
                        if(holdingTimeBeforeAttack >= holdingTimeTarget){
                            holdingTimeBeforeAttack = 0;
                            holdingTimeTarget = (RANDOM_0_TO_1() * 2);
                            if(RANDOM_0_TO_1() >= 0.5){
                                if([attackingEnemies count] < 3){
                                    [attackingEnemies addObject:enemyShip];
                                    enemyShip.currentPathType = kPathType_Attacking;
                                }
                            }
                        }
                    }
                    else if(enemyShip.currentPathType == kPathType_Attacking){
                        if(!enemyShip.currentPath){

                            //Differentiate between regular and kamikaze type attack paths
                            if([enemyShip isKamikazeShip] == NO){
                                if(RANDOM_0_TO_1() > 0.5){
                                    //Randomize the direction enemis will fly
                                    enemyShip.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y) 
                                                                                 controlPoint1:Vector2fMake((160 - 350), 50)
                                                                                 controlPoint2:Vector2fMake((160 + 350), 50)
                                                                                      endPoint:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y)
                                                                                      segments:50];
                                }
                                else {
                                    //Second direction
                                    enemyShip.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y) 
                                                                                 controlPoint1:Vector2fMake((160 + 350), 50)
                                                                                 controlPoint2:Vector2fMake((160 - 350), 50)
                                                                                      endPoint:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y)
                                                                                      segments:50];
                                }
                            }
                            else {
                                //Kamikaze attack pattern
                                enemyShip.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(enemyShip.currentLocation.x, enemyShip.currentLocation.y)
                                                                             controlPoint1:Vector2fMake(playerShip.currentLocation.x + 200, playerShip.currentLocation.y - 1000)
                                                                             controlPoint2:Vector2fMake(enemyShip.currentLocation.x - 1000, enemyShip.currentLocation.y)
                                                                                  endPoint:Vector2fMake(enemyShip.currentLocation.x, enemyShip.currentLocation.y)
                                                                                  segments:50];
                            }
                            [enemyShip playAllProjectiles];
                        }
                        
                        //Kamikaze paths need to go slower due to larger control points
                        if([enemyShip isKamikazeShip] == NO){
                            //Regular update speed
                            [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/4].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/4].y)];
                        }
                        else {
                            //Update more slowly for kamikaze pattern else it moves too fast
                            [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/6].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/6].y)];
                        }
                    
                        if(enemyShip.pathTime > 2){
//                            if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                            if([enemyShip isKamikazeShip]){
                                //Calculate position based on x for kamikaze(comes in from side,
                                //and calculate postion on y for regualr attacks, for they come up
                                
                                if(enemyShip.currentLocation.x >= enemyShip.currentPath.endPoint.x){
                                    //If it reached the end
                                    [enemyShip resetPathWithNewPathType:kPathType_Holding];
                                    [enemyShip stopAllProjectiles];
                                    [attackingEnemies removeObject:enemyShip];
                                }
                            }
                            else {
                                if(enemyShip.currentLocation.y >= enemyShip.currentPath.endPoint.y){
                                    //If it reached the end
                                    [enemyShip resetPathWithNewPathType:kPathType_Holding];
                                    [enemyShip stopAllProjectiles];
                                    [attackingEnemies removeObject:enemyShip];
                                }
                            }
                        }
                    }
                }
            }
            //For loop is done, discard any dead enemies
            [enemiesSet minusSet:discardedEnemies];
            [discardedEnemies release];
        }
        
        if (currentWaveType == kWaveType_Boss) {
            
            [bossHealthBar setScale:Scale2fMake((float)bossShip.shipHealth / (float)bossShip.shipMaxHealth, 1.0f)];

            // Animating the boss onto the screen
            if (!bossShipIsDisplayed && bossShipReadyToAnimate && bossShip) {
                [playerShip stopAllProjectiles];
                
                bossShipIntroAnimationTime += aDelta;
                if (bossShip.currentLocation.y > bossShipDefaultLocation.y) {
                    [bossShip setDesiredLocation:CGPointMake(bossShip.currentLocation.x, bossShip.currentLocation.y - (bossShipIntroAnimationTime))];
                }
                if (bossShip.currentLocation.x > bossShipDefaultLocation.x) {
                    [bossShip setDesiredLocation:CGPointMake(bossShip.currentLocation.x - (bossShipIntroAnimationTime), bossShip.currentLocation.y)];
                }
                if (bossShip.currentLocation.x < bossShipDefaultLocation.x) {
                    [bossShip setDesiredLocation:CGPointMake(bossShip.currentLocation.x + (bossShipIntroAnimationTime), bossShip.currentLocation.y)];
                }
                
                if (abs(bossShip.currentLocation.x - bossShipDefaultLocation.x) < 3 && abs(bossShip.currentLocation.y - bossShipDefaultLocation.y) < 3) {
                    bossShipIntroAnimationTime = 0.0;
                    bossShipIsDisplayed = YES;
                    bossShip.shipIsDeployed = YES;
                    [playerShip playAllProjectiles];
                    
                    [soundManager playMusicWithKey:@"boss_theme" timesToRepeat:10000];
                    [soundManager fadeMusicVolumeFrom:0.0f toVolume:[settingsDB floatForKey:kSetting_MusicVolume] duration:2.0f stop:NO];
                }
            }
            
            [bossShip update:aDelta];
            
            
            BOOL bossShipModulesAlive = NO;
            for (int i = 0; i < bossShip.numberOfModules; i++) {
                if (!bossShip.modularObjects[i].isDead) {
                    bossShipModulesAlive = YES;
                    break;
                }
            }
            
            if (!bossShipModulesAlive) {
                [self addScoreForBossShipDeath:bossShip];
                [delegate scoreChangedBy:kScore_TimeBonus(levelTime) + (scoreMultiplierOn * kScore_TimeBonus(levelTime))];
                enemiesKilled++;
                currentWaveType = kWaveType_Finished;
            }
        }
        
        // Need to update all collision objects on the screen
        [self updateCollisions];
    }
    
    // Level is ending and animating out
    if(outroTransitionAnimating) {
        outroAnimationTime+= aDelta;
        if (outroAnimationType == kOutroAnimation_Flyoff) {
            if (playerShip.currentLocation.y > 480.0f) {
                outroTransitionAnimating = NO;
                
                NSMutableDictionary *statsDict = [[NSMutableDictionary alloc] init];
                [statsDict setValue:[NSString stringWithFormat:@"%d", numDropPickups] forKey:@"DROPS"];
                [statsDict setValue:[NSString stringWithFormat:@"%d", enemiesKilled] forKey:@"ENEMIES"];
                [statsDict setValue:[NSString stringWithFormat:@"%f", levelTime] forKey:@"TIME"];
                [statsDict setValue:[NSString stringWithFormat:@"%d", scoreEarned] forKey:@"SCORE"];
                
                [delegate levelEnded:statsDict];
                
                [statsDict release];
            }
        }
        else if (outroAnimationType == kOutroAnimation_Nuke) {
            [transitionParticleEmitter update:aDelta];
            if (transitionParticleEmitter.active == NO) {
                outroDelay += aDelta;
                if(outroDelay > 3){
                    outroTransitionAnimating = NO;
                    
                    NSMutableDictionary *statsDict = [[NSMutableDictionary alloc] init];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", numDropPickups] forKey:@"DROPS"];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", enemiesKilled] forKey:@"ENEMIES"];
                    [statsDict setValue:[NSString stringWithFormat:@"%f", levelTime] forKey:@"TIME"];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", scoreEarned] forKey:@"SCORE"];
                    
                    [delegate levelEnded:statsDict];
                    
                    [statsDict release];
                }
            }
        }
        else if(outroAnimationType == kOutroAnimation_Wormhole){
            [transitionParticleEmitter update:aDelta];
            if(playerShip.currentLocation.y >= 320.0f){
                outroDelay += aDelta;
                if(outroDelay > 3){
                    outroTransitionAnimating = NO;
                
                    NSMutableDictionary *statsDict = [[NSMutableDictionary alloc] init];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", numDropPickups] forKey:@"DROPS"];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", enemiesKilled] forKey:@"ENEMIES"];
                    [statsDict setValue:[NSString stringWithFormat:@"%f", levelTime] forKey:@"TIME"];
                    [statsDict setValue:[NSString stringWithFormat:@"%d", scoreEarned] forKey:@"SCORE"];
                
                    [delegate levelEnded:statsDict];
                
                    [statsDict release];
                }
            }
        }
    }
     
    // We're out of enemies on the screen. Load next wave or boss level if none exists
    if(currentWaveType == kWaveType_Enemy && [enemiesSet count] == 0) {
        
        // More waves are available
        if(currentWave != (numWaves - 1)) {
            currentWave++;
            [self loadWave:currentWave];
        }
        
        // No waves available, boss level time.
        else if(currentWaveType != kWaveType_Boss && currentWaveType != kWaveType_Finished) {
            currentWaveType = kWaveType_Boss;
            [self loadBoss];
        }
    }
    
    if(currentWaveType == kWaveType_Finished) {
        [playerShip stopAllProjectiles];
        
        outroTransitionAnimating = YES;
        if (outroAnimationType == kOutroAnimation_Flyoff) {
            if (abs(playerShip.currentLocation.x - 160.0f) < 5) {
                [playerShip setDesiredLocation:CGPointMake(160.0f, playerShip.currentLocation.y + (outroAnimationTime * 40))];
            }
            else {
                if(playerShip.currentLocation.x < 160.0f) {
                    [playerShip setDesiredLocation:CGPointMake(playerShip.currentLocation.x + (outroAnimationTime * 20), playerShip.currentLocation.y + (outroAnimationTime * 40))];
                }
                else {
                    [playerShip setDesiredLocation:CGPointMake(playerShip.currentLocation.x - (outroAnimationTime * 20), playerShip.currentLocation.y + (outroAnimationTime * 40))];
                }
            }
        }
        else if (outroAnimationType == kOutroAnimation_Nuke) {
            [playerShip setDesiredLocation:CGPointMake(playerShip.currentLocation.x, -40)];
        }
        else if (outroAnimationType == kOutroAnimation_Wormhole) {
            if(playerShip.currentLocation.y < 320.0f){
                if (abs(playerShip.currentLocation.x - 160.0f) < 5) {
                    [playerShip setDesiredLocation:CGPointMake(160.0f, playerShip.currentLocation.y + (outroAnimationTime * 40))];
                }
                else {
                    if(playerShip.currentLocation.x < 160.0f) {
                        [playerShip setDesiredLocation:CGPointMake(playerShip.currentLocation.x + (outroAnimationTime * 20), playerShip.currentLocation.y + (outroAnimationTime * 40))];
                    }
                    else {
                        [playerShip setDesiredLocation:CGPointMake(playerShip.currentLocation.x - (outroAnimationTime * 20), playerShip.currentLocation.y + (outroAnimationTime * 40))];
                    }
                }
            }
        }
    }
    
    // This is a dialogue wave, display it.
    else {
        dialogueTypeTimeDelay += aDelta;
        if (dialogueTypeTimeDelay > 0.05) {               
            dialogueTypeTimeDelay = 0.0;
            NSRange characterRange = {currentDialogueCharacterPosition, 1};
            
            switch(currentDialogueDisplayLine){
                case 1:
                    if(currentNumberOfDialogueLinesToShow >= 1){
                        dialogueIsTyping = TRUE;
                        [dialogueLineOneBuffer appendString:[dialogueLineOne substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;                    
                        if([dialogueLineOne isEqualToString:dialogueLineOneBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                        }
                    }
                    break;
                    
                case 2:
                    if(currentNumberOfDialogueLinesToShow >= 2){
                        dialogueIsTyping = TRUE;
                        [dialogueLineTwoBuffer appendString:[dialogueLineTwo substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;
                        if([dialogueLineTwo isEqualToString:dialogueLineTwoBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                        }
                    }
                    break;
                    
                case 3:
                    if(currentNumberOfDialogueLinesToShow >= 3){
                        dialogueIsTyping = TRUE;
                        [dialogueLineThreeBuffer appendString:[dialogueLineThree substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;
                        if([dialogueLineThree isEqualToString:dialogueLineThreeBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                        }
                    }
                    break;
                    
                case 4:
                    if(currentNumberOfDialogueLinesToShow >= 4){
                        dialogueIsTyping = TRUE;
                        [dialogueLineFourBuffer appendString:[dialogueLineFour substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;
                        if([dialogueLineFour isEqualToString:dialogueLineFourBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                        }
                    }
                    break;
                    
                case 5:
                    if(currentNumberOfDialogueLinesToShow >= 5){
                        dialogueIsTyping = TRUE;
                        [dialogueLineFiveBuffer appendString:[dialogueLineFive substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;
                        if([dialogueLineFive isEqualToString:dialogueLineFiveBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                        }
                    }
                    break;
                    
                case 6:
                    if(currentNumberOfDialogueLinesToShow >= 6){
                        dialogueIsTyping = TRUE;
                        [dialogueLineSixBuffer appendString:[dialogueLineSix substringWithRange:characterRange]];
                        currentDialogueCharacterPosition++;
                        if([dialogueLineSix isEqualToString:dialogueLineSixBuffer]){
                            currentDialogueDisplayLine++;
                            currentDialogueCharacterPosition = 0;
                            dialogueIsTyping = FALSE;
                        }
                    }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)updateCollisions {
    
    // We are currently in a "fighting" wave so we must update collisions
    if (currentWaveType == kWaveType_Enemy || currentWaveType == kWaveType_Boss) {
        
        if (currentWaveType == kWaveType_Enemy) {
            
            EnemyShip *enemyShip;
            for (enemyShip in enemiesSet) {
                
                // For debugging levels, the player-ship acts as a god who destroys everything it touches by giving it an uncontrollable orgasm
                if (DEBUG) {
                    for(Polygon *playerLocalPolygon in playerShip.collisionPolygonArray){
                        PolygonCollisionResult result = [Collisions polygonCollision:playerLocalPolygon :enemyShip.collisionPolygon :Vector2fZero];
                        
                        if(result.intersect) [enemyShip killShip];
                    }
                }
                
                //Enemy bullet -> player ship collision
                for(AbstractProjectile *enemyProjectile in enemyShip.projectilesArray){
                    NSArray *enemyPolyArray;
                    for(int emitterPolyCount = 0; emitterPolyCount < [enemyProjectile.emitters count]; emitterPolyCount++){
                        enemyPolyArray = [[enemyProjectile polygons] objectAtIndex:emitterPolyCount];
                        
                        Polygon *enemyBulletPoly;
                        for(int i = 0; i < [enemyPolyArray count]; i++){
                            enemyBulletPoly = [enemyPolyArray objectAtIndex:i];
                            
                            for(Polygon *playerLocalPolygon in playerShip.collisionPolygonArray){
                                PolygonCollisionResult result2 = [Collisions polygonCollision:enemyBulletPoly :playerLocalPolygon :Vector2fZero];
                                
                                if(result2.intersect){
                                    if(!playerShip.shipIsDead && !shieldEnabled){
//                                      [playerShip hitShipWithDamage:30];
                                        [playerShip hitShipWithDamage:[self damageForWeaponType:[enemyProjectile projectileID]]];
                                        //Move it away
                                        [[[enemyProjectile emitters] objectAtIndex:emitterPolyCount] particles][i].position = Vector2fMake(500, 0);
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                //Player bullets->EnemyShip collision
                for(AbstractProjectile *playerProjectile in playerShip.projectilesArray){
                    NSArray *playerPolyArray;
                    for(int emitterPolyCount = 0; emitterPolyCount < [playerProjectile.emitters count]; emitterPolyCount++){
                        playerPolyArray = [[playerProjectile polygons] objectAtIndex:emitterPolyCount];
                        
                        Polygon *playerBulletPoly;
                        for(int i = 0; i < [playerPolyArray count]; i++){
                            playerBulletPoly = [playerPolyArray objectAtIndex:i];
                            
                            PolygonCollisionResult result2 = [Collisions polygonCollision:playerBulletPoly :enemyShip.collisionPolygon :Vector2fZero];
                            
                            if(result2.intersect){
                                if(!enemyShip.shipIsDead){
//                                    [enemyShip hitShipWithDamage:20 + (20 * (int)damageMultiplierOn)];
                                    [enemyShip hitShipWithDamage:[self damageForWeaponType:[playerProjectile projectileID]] + ([self damageForWeaponType:[playerProjectile projectileID]] * (int)damageMultiplierOn)];
                                    //Move it away
                                    [[[playerProjectile emitters] objectAtIndex:emitterPolyCount] particles][i].position = Vector2fMake(500, 50);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (currentWaveType == kWaveType_Boss) {
            for (int i = 0; i < bossShip.numberOfModules; i++) {
                if(bossShip.modularObjects[i].isDead == NO){
                    
                    //Player -> boss module
                    for(int k = 0; k < [bossShip.modularObjects[i].collisionPolygonArray count]; k++){
                        for(Polygon *playerLocalPolygon in playerShip.collisionPolygonArray){
                            PolygonCollisionResult playerShipResult = [Collisions polygonCollision:playerLocalPolygon
                                                                                              :[bossShip.modularObjects[i].collisionPolygonArray objectAtIndex:k]
                                                                                              :Vector2fZero];
                        
                            if(playerShipResult.intersect){
                                //[playerShip killShip];
                            }
                        }
                        
                        //Player bullet -> module collision
                        for(AbstractProjectile *playerProjectile in playerShip.projectilesArray){
                            NSArray *playerPolyArray;
                            for(int emitterPolyCount = 0; emitterPolyCount < [playerProjectile.emitters count]; emitterPolyCount++){
                                playerPolyArray = [[playerProjectile polygons] objectAtIndex:emitterPolyCount];
                                
                                Polygon *playerBulletPoly;
                                for(int j = 0; j < [playerPolyArray count]; j++){
                                    playerBulletPoly = [playerPolyArray objectAtIndex:j];
                                    
                                    PolygonCollisionResult result = [Collisions polygonCollision:playerBulletPoly 
                                                                                                 :[bossShip.modularObjects[i].collisionPolygonArray objectAtIndex:k] 
                                                                                                 :Vector2fZero];
                                    
                                    if(result.intersect){
                                        if(bossShipIsDisplayed){
                                            if(bossShip.modularObjects[i].shouldTakeDamage == YES){
                                                if (bossShip.modularObjects[i].destructionOrder == bossShip.currentDestructionOrder && bossShip.modularObjects[i].isDead == NO) {
//                                                    [bossShip hitModule:i withDamage:10];
                                                    [bossShip hitModule:i withDamage:[self damageForWeaponType:[playerProjectile projectileID]]];
                                                    [[[playerProjectile emitters] objectAtIndex:emitterPolyCount] particles][j].position = Vector2fMake(500, 50);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        //Boss bullet -> playership
                        if(bossShip.projectilesArray){
                            for(AbstractProjectile *bossProjectile in bossShip.projectilesArray){
                                NSArray *bossPolyArray;
                                for(int emitterPolyCount = 0; emitterPolyCount < [bossProjectile.emitters count]; emitterPolyCount++){
                                    bossPolyArray = [[bossProjectile polygons] objectAtIndex:emitterPolyCount];
                                    
                                    Polygon *bossBulletPoly;
                                    for(int i = 0; i < [bossPolyArray count]; i++){
                                        bossBulletPoly = [bossPolyArray objectAtIndex:i];
                                        
                                        for(Polygon *playerLocalPolygon in playerShip.collisionPolygonArray){
                                            PolygonCollisionResult result2 = [Collisions polygonCollision:bossBulletPoly :playerLocalPolygon :Vector2fZero];
                                    
                                            if(result2.intersect){
                                                if(!playerShip.shipIsDead){
//                                                  [playerShip hitShipWithDamage:1];
                                                    [playerShip hitShipWithDamage:[self damageForWeaponType:[bossProjectile projectileID]]];
                                                    [[[bossProjectile emitters] objectAtIndex:emitterPolyCount] particles][i].position = Vector2fMake(-1000, -500);
                                                }
                                                /*if(!enemyShip.shipIsDead){
                                                 [enemyShip hitShipWithDamage:20 + (20 * (int)damageMultiplierOn)];
                                                 //Move it away
                                                 [[[bossProjectile emitters] objectAtIndex:emitterPolyCount] particles][i].position = Vector2fMake(500, 50);
                                                 }*/
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }   
            }
        }
    }
}

- (void)skipToNewPageOfText {
    if(currentWaveType != kWaveType_Dialogue) return;
    
    if(dialogueIsTyping){
        //It's still typing, only fill the buffers
        if(dialogueLineOne) [dialogueLineOneBuffer setString:dialogueLineOne];
        if(dialogueLineTwo) [dialogueLineTwoBuffer setString:dialogueLineTwo];
        if(dialogueLineThree) [dialogueLineThreeBuffer setString:dialogueLineThree];
        if(dialogueLineFour) [dialogueLineFourBuffer setString:dialogueLineFour];
        if(dialogueLineFive) [dialogueLineFiveBuffer setString:dialogueLineFive];
        if(dialogueLineSix) [dialogueLineSixBuffer setString:dialogueLineSix];
        
        currentDialogueDisplayLine = 7;
        currentDialogueCharacterPosition = 0;
        dialogueIsTyping = FALSE;
        return;
    }
    
    currentDialogueDisplayLine = 1;
    currentDialogueCharacterPosition = 0;
    currentNumberOfDialogueLinesToShow = 0;
    
    [dialogueLineOneBuffer setString:@""];
    [dialogueLineTwoBuffer setString:@""];
    [dialogueLineThreeBuffer setString:@""];
    [dialogueLineFourBuffer setString:@""];
    [dialogueLineFiveBuffer setString:@""];
    [dialogueLineSixBuffer setString:@""];
    
    if(dialogueLineOne) [dialogueLineOne release];
    dialogueLineOne = nil;
    if(dialogueLineTwo) [dialogueLineTwo release];
    dialogueLineTwo = nil;
    if(dialogueLineThree) [dialogueLineThree release];
    dialogueLineThree = nil;
    if(dialogueLineFour) [dialogueLineFour release];
    dialogueLineFour = nil;
    if(dialogueLineFive) [dialogueLineFive release];
    dialogueLineFive = nil;
    if(dialogueLineSix) [dialogueLineSix release];
    dialogueLineSix = nil;
    
    if(remainderDialogue == nil){
        //If there is in fact no more dialogue for this wave
        //NSLog(@"END OF DIALOGUE");
        if(currentWave != (numWaves - 1)) {
            currentWave++;
            [self loadWave:currentWave];
        }
        else {
            NSMutableDictionary *statsDict = [[NSMutableDictionary alloc] init];
            [statsDict setValue:[NSString stringWithFormat:@"%d", numDropPickups] forKey:@"DROPS"];
            [statsDict setValue:[NSString stringWithFormat:@"%d", enemiesKilled] forKey:@"ENEMIES"];
            [statsDict setValue:[NSString stringWithFormat:@"%f", levelTime] forKey:@"TIME"];
            [statsDict setValue:[NSString stringWithFormat:@"%d", scoreEarned] forKey:@"SCORE"];
            
            [delegate levelEnded:statsDict];
            
            [statsDict release];
        }
    }
    else {
        const char* wrappedText = WrapText([remainderDialogue UTF8String], 22, "", "");
        NSMutableArray *wrappedTextArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:wrappedText encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
        
        if(remainderDialogue) [remainderDialogue release];
        remainderDialogue = nil;
        if([wrappedTextArray count] > 0){
            dialogueLineOne = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:0]];
            if([wrappedTextArray count] > 1){
                dialogueLineTwo = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:1]];
                currentNumberOfDialogueLinesToShow = 2;
                if([wrappedTextArray count] > 2){
                    dialogueLineThree = [[NSString alloc] initWithString:[wrappedTextArray objectAtIndex:2]];
                    currentNumberOfDialogueLinesToShow = 3;
                    if([wrappedTextArray count] > 3){
                        //Exceeding three lines, prep the stuff for a larger word wrap
                        [wrappedTextArray removeObject:dialogueLineOne];
                        [wrappedTextArray removeObject:dialogueLineTwo];
                        [wrappedTextArray removeObject:dialogueLineThree];
                        
                        NSString *secondHalfString = [[NSString alloc] initWithString:[wrappedTextArray componentsJoinedByString:@" "]];
                        //NSLog(@"joined:\n%@", secondHalfString);
                        const char* secondHalf = WrapText([secondHalfString UTF8String], 25, "", "");
                        NSMutableArray *secondWrappedArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:secondHalf encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
                        //NSLog(@"%@", secondWrappedArray);
                        dialogueLineFour = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:0]];
                        currentNumberOfDialogueLinesToShow = 4;
                        if([secondWrappedArray count] > 1){
                            dialogueLineFive = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:1]];
                            currentNumberOfDialogueLinesToShow = 5;
                            if([secondWrappedArray count] > 2){
                                dialogueLineSix = [[NSString alloc] initWithString:[secondWrappedArray objectAtIndex:2]];
                                currentNumberOfDialogueLinesToShow = 6;
                                if([secondWrappedArray count] >3){
                                    //Exceeds all six lines, fill the remainder string
                                    [secondWrappedArray removeObject:dialogueLineFour];
                                    [secondWrappedArray removeObject:dialogueLineFive];
                                    [secondWrappedArray removeObject:dialogueLineSix];
                                    
                                    remainderDialogue = [[NSString alloc] initWithString:[secondWrappedArray componentsJoinedByString:@" "]];
                                }
                            }
                        }
                        [secondWrappedArray release];
                        [secondHalfString release];
                    }
                }
            }
        }
        [wrappedTextArray release];
    }
}

- (void)nukeButtonPushed {
    for(EnemyShip *enemyShip in enemiesSet){
        [self addScoreForEnemyShipDeath:enemyShip];
        [enemyShip killShip];
    }
}

- (int)damageForWeaponType:(ProjectileID)projectileType {
    if(projectileType >= kPlayerProjectile_BulletLevelOne_Single && projectileType <= kPlayerProjectile_BulletLevelTen_Septuple) return 5;
    
    else if(projectileType >= kPlayerProjectile_WaveLevelOne_SingleSmall && projectileType <= kPlayerProjectile_WaveLevelTen_TripleBig) return 2;
    
    else if(projectileType >= kPlayerProjectile_MissileLevelOne_Single && projectileType <= kPlayerProjectile_MissileLevelTen_Sextuple) return 15;
    
    else if(projectileType >= kEnemyProjectile_BulletLevelOne_Single && projectileType <= kEnemyProjectile_BulletLevelTen_Septuple) return 3;
    
    else if(projectileType >= kEnemyProjectile_WaveLevelOne_SingleSmall && projectileType <= kEnemyProjectile_WaveLevelTen_TripleBig) return 1;
    
    else if(projectileType >= kEnemyProjectile_MissileLevelOne_Single && projectileType <= kEnemyProjectile_MissileLevelTen_Sextuple) return 10;
    
    else if(projectileType >= kPlayerParticle_Single && projectileType <= kPlayerParticle_Triple) return 25;
    
    else if(projectileType >= kEnemyParticle_Single && projectileType <= kEnemyParticle_Triple) return 25;
    
    else if(projectileType == kPlayerProjectile_HeatSeekingMissile) return 20;
    
    else if(projectileType == kEnemyProjectile_HeatSeekingMissile) return 15;
    
    else return 0;
}

- (void)addScoreForEnemyShipDeath:(EnemyShip *)enemy {
    EnemyShipID killedEnemyID = enemy.enemyID;
    if (killedEnemyID == kEnemyShip_OneShotLevelOne || killedEnemyID == kEnemyShip_TwoShotLevelOne || killedEnemyID == kEnemyShip_ThreeShotLevelOne || killedEnemyID == kEnemyShip_WaveShotLevelOne || killedEnemyID == kEnemyShip_MissileBombShotLevelOne || killedEnemyID == kEnemyShip_KamikazeLevelOne) {
        [delegate scoreChangedBy:kScore_EnemyLevelOneKill + (scoreMultiplierOn * kScore_EnemyLevelOneKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
    if (killedEnemyID == kEnemyShip_OneShotLevelTwo || killedEnemyID == kEnemyShip_TwoShotLevelTwo || killedEnemyID == kEnemyShip_ThreeShotLevelTwo || killedEnemyID == kEnemyShip_WaveShotLevelTwo || killedEnemyID == kEnemyShip_MissileBombShotLevelTwo || killedEnemyID == kEnemyShip_KamikazeLevelTwo) {
        [delegate scoreChangedBy:kScore_EnemyLevelTwoKill + (scoreMultiplierOn * kScore_EnemyLevelTwoKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
    if (killedEnemyID == kEnemyShip_OneShotLevelThree || killedEnemyID == kEnemyShip_TwoShotLevelThree || killedEnemyID == kEnemyShip_ThreeShotLevelThree || killedEnemyID == kEnemyShip_WaveShotLevelThree || killedEnemyID == kEnemyShip_MissileBombShotLevelThree || killedEnemyID == kEnemyShip_KamikazeLevelThree) {
        [delegate scoreChangedBy:kScore_EnemyLevelThreeKill + (scoreMultiplierOn * kScore_EnemyLevelThreeKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
    if (killedEnemyID == kEnemyShip_OneShotLevelFour|| killedEnemyID == kEnemyShip_TwoShotLevelFour || killedEnemyID == kEnemyShip_ThreeShotLevelFour || killedEnemyID == kEnemyShip_WaveShotLevelFour || killedEnemyID == kEnemyShip_MissileBombShotLevelFour || killedEnemyID == kEnemyShip_KamikazeLevelFour) {
        [delegate scoreChangedBy:kScore_EnemyLevelFourKill + (scoreMultiplierOn * kScore_EnemyLevelFourKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
    if (killedEnemyID == kEnemyShip_OneShotLevelFive || killedEnemyID == kEnemyShip_TwoShotLevelFive || killedEnemyID == kEnemyShip_ThreeShotLevelFive || killedEnemyID == kEnemyShip_WaveShotLevelFive || killedEnemyID == kEnemyShip_MissileBombShotLevelFive) {
        [delegate scoreChangedBy:kScore_EnemyLevelFiveKill + (scoreMultiplierOn * kScore_EnemyLevelFiveKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
    if (killedEnemyID == kEnemyShip_OneShotLevelSix || killedEnemyID == kEnemyShip_TwoShotLevelSix) {
        [delegate scoreChangedBy:kScore_EnemyLevelSixKill + (scoreMultiplierOn * kScore_EnemyLevelSixKill)];
        if (playerShip.shipCategory == kShipCategory_Attack || playerShip.shipCategory == kShipCategory_Speed || playerShip.shipCategory == kShipCategory_Stamina) {
            
            [delegate scoreChangedBy:kScore_AttackShipBonus + (scoreMultiplierOn * kScore_AttackShipBonus)];
        }
        if (playerShip.shipWeaponType == kPlayerWeapon_Wave) {
            [delegate scoreChangedBy:kScore_WavesWeaponBonus + (scoreMultiplierOn * kScore_WavesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Missile) {
            [delegate scoreChangedBy:kScore_MissilesWeaponBonus + (scoreMultiplierOn * kScore_MissilesWeaponBonus)];
        }
        else if (playerShip.shipWeaponType == kPlayerWeapon_Heatseeker) {
            [delegate scoreChangedBy:kScore_HeatseekersWeaponBonus + (scoreMultiplierOn * kScore_HeatseekersWeaponBonus)];
        }
    }
}

- (void)addScoreForBossShipDeath:(BossShip *)boss {
    BossShipID killedBossID = boss.bossID;
    
    switch (killedBossID) {
        case kBoss_Themis:
            [delegate scoreChangedBy:kScore_ThemisBonus + (scoreMultiplierOn * kScore_ThemisBonus)];
            break;
        case kBoss_Eos:
            [delegate scoreChangedBy:kScore_EosBonus + (scoreMultiplierOn * kScore_EosBonus)];
            break;
        case kBoss_Astraeus:
            [delegate scoreChangedBy:kScore_AstraeusBonus + (scoreMultiplierOn * kScore_AstraeusBonus)];
            break;
        case kBoss_Helios:
            [delegate scoreChangedBy:kScore_HeliosBonus + (scoreMultiplierOn * kScore_HeliosBonus)];
            break;
        case kBoss_Oceanus:
            [delegate scoreChangedBy:kScore_OceanusBonus + (scoreMultiplierOn * kScore_OceanusBonus)];
            break;
        case kBoss_Atlas:
            [delegate scoreChangedBy:kScore_AtlasBonus + (scoreMultiplierOn * kScore_AtlasBonus)];
            break;
        case kBoss_Hyperion:
            [delegate scoreChangedBy:kScore_HyperionBonus + (scoreMultiplierOn * kScore_HyperionBonus)];
            break;
        case kBoss_Kronos:
            [delegate scoreChangedBy:kScore_KronosBonus + (scoreMultiplierOn * kScore_KronosBonus)];
            break;
        case kBoss_AlphaWeapon:
            [delegate scoreChangedBy:kScore_AlphaWeaponBonus + (scoreMultiplierOn * kScore_AlphaWeaponBonus)];
            break;
            
        default:
            break;
    }
    
    if(killedBossID >= kMiniBoss_OneOne && killedBossID <= kMiniBoss_OneThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelOneBonus + (scoreMultiplierOn * kScore_MiniBossLevelOneBonus)];
    }
    else if(killedBossID >= kMiniBoss_TwoOne && killedBossID <= kMiniBoss_TwoThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelTwoBonus + (scoreMultiplierOn * kScore_MiniBossLevelTwoBonus)];
    }
    else if(killedBossID >= kMiniBoss_ThreeOne && killedBossID <= kMiniBoss_ThreeThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelThreeBonus + (scoreMultiplierOn * kScore_MiniBossLevelThreeBonus)];
    }
    else if(killedBossID >= kMiniBoss_FourOne && killedBossID <= kMiniBoss_FourTwo){
        [delegate scoreChangedBy:kScore_MiniBossLevelFourBonus + (scoreMultiplierOn * kScore_MiniBossLevelFourBonus)];
    }
    else if(killedBossID >= kMiniBoss_FiveOne && killedBossID <= kMiniBoss_FiveThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelFiveBonus + (scoreMultiplierOn * kScore_MiniBossLevelFiveBonus)];
    }
    else if(killedBossID >= kMiniBoss_SixOne && killedBossID <= kMiniBoss_SixThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelSixBonus + (scoreMultiplierOn * kScore_MiniBossLevelSixBonus)];
    }
    else if(killedBossID >= kMiniBoss_SevenOne && killedBossID <= kMiniBoss_SevenThree){
        [delegate scoreChangedBy:kScore_MiniBossLevelSevenBonus + (scoreMultiplierOn * kScore_MiniBossLevelSevenBonus)];
    }
}

- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    
    
    //Gets a frame of the first player ship, adding a bit of width and
    //30 pixels worth of height on the bottom half for ease of selection
    CGRect shipFrame = CGRectMake(playerShip.currentLocation.x - ((playerShip.shipWidth * 1.4) / 2),
                                  playerShip.currentLocation.y - (playerShip.shipHeight / 2) - 30,
                                  playerShip.shipWidth * 1.4,
                                  playerShip.shipHeight + 30);
    
    
    //If the ship was actually selected, set a Bool for the
    //updateWithTouchLocationMoved: method to allow the ship to move
    if(CGRectContainsPoint(shipFrame, location)){
        touchOriginatedFromPlayerShip = YES;
    }
    else {
        touchOriginatedFromPlayerShip = NO;
    }
    if(CGRectContainsPoint(CGRectMake(280, 0, 40, 40), location) && currentWaveType == kWaveType_Dialogue){
        [self skipToNewPageOfText];
    }
}

- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView {
	UITouch *touch = [[event touchesForView:aView] anyObject];
	CGPoint location;
	location = [touch locationInView:aView];
    
	// Flip the y location ready to check it against OpenGL coordinates
	location.y = 480-location.y;
    location.y += 30;
    if(touchOriginatedFromPlayerShip){
        //Checks the edges of the ship against the edges of the screen.
        //Note: we check one edge at a time because if we simply use CGRectContainsRect,
        //the ship would not be able to move along an edge once exiting
        if(location.x - ([playerShip shipWidth] / 2) < 0 - [playerShip shipWidth]){
            location.x = [playerShip shipWidth] / 2;
        }
        if(location.x + ([playerShip shipWidth] / 2) > screenBounds.size.width + [playerShip shipWidth]){
            location.x = screenBounds.size.width - ([playerShip shipWidth] / 2);
        }
        
        if(location.y - ([playerShip shipHeight] / 2) < 0){
            location.y = [playerShip shipHeight] / 2;
        }
        if(location.y + ([playerShip shipHeight] / 2) > screenBounds.size.height){
            location.y = screenBounds.size.height - ([playerShip shipHeight] / 2);
        }
        if(!outroTransitionAnimating){
            [playerShip setDesiredLocation:location];
        }
    }
}

-(Vector2f) VectorRandomInRectWithVectors:(Vector2f)v1 v2:(Vector2f)v2
{
    Vector2f randPoint;
    randPoint.x = RANDOM_0_TO_1() * abs(v1.x - v2.x);
    randPoint.y = RANDOM_0_TO_1() * abs(v1.y - v2.y) + 240;
    return randPoint;
    
    printf("%f %f", randPoint.x, randPoint.y);
}

- (void)render {
    
    for(Drop *drop in droppedPowerUpSet){
        [drop render];
    }
    if(shieldEnabled == TRUE){
        [shieldImage renderAtPoint:playerShip.currentLocation centerOfImage:YES];
    }
    
    if (currentWaveType == kWaveType_Enemy) {
        for (EnemyShip *enemyShip in enemiesSet) {
            [enemyShip render];
        }
    }
    
    if (currentWaveType == kWaveType_Boss) {
        [bossHealthBarBackground renderAtPoint:CGPointMake(254, 26.0) centerOfImage:NO];
        [bossHealthBar renderAtPoint:CGPointMake(255, 27.0) centerOfImage:NO];
        [bossShip render];
    }
    
    if(playerShip.shipIsDead){
        if(gameOverTimer <= 3){
            [font setScale:gameOverTimer/4];
        }
        else {
            [font setScale:0.75];
        }
        
        [font drawStringAt:CGPointMake(60.0f, 240.0f) text:@"Game Over"];
    }
        
    //Dialogue Related rendering
    if(currentWaveType == kWaveType_Dialogue) {
        [dialogueBorder renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];
        [speakerImage renderAtPoint:CGPointMake(4, 82) centerOfImage:NO];
        [dialogueFastForwardButton renderAtPoint:CGPointMake(303.0f, 15.0f) centerOfImage:YES];
        [font drawStringAt:CGPointMake(80.0f, 135.0f) text:dialogueLineOneBuffer];
        [font drawStringAt:CGPointMake(80.0f, 115.0f) text:dialogueLineTwoBuffer];
        [font drawStringAt:CGPointMake(80.0f, 95.0f) text:dialogueLineThreeBuffer];
        [font drawStringAt:CGPointMake(15.0f, 70.0f) text:dialogueLineFourBuffer];
        [font drawStringAt:CGPointMake(15.0f, 50.0f) text:dialogueLineFiveBuffer];
        if(!remainderDialogue){
            [font drawStringAt:CGPointMake(15.0f, 30.0f) text:dialogueLineSixBuffer];
        }
        else if(remainderDialogue && [dialogueLineSix isEqualToString:dialogueLineSixBuffer]){
            [font drawStringAt:CGPointMake(15.0f, 30.0f) text:[NSString stringWithFormat:@"%@...", dialogueLineSixBuffer]];
        }
        else if(remainderDialogue){
            [font drawStringAt:CGPointMake(15.0f, 30.0f) text:dialogueLineSixBuffer];
        }
    }
    else {
        // Must always be rendered last so that the player is foreground
        // to any other objects on the screen. Also not while dialogue is displayed.
//        if(!outroTransitionAnimating && outroAnimationType == kOutroAnimation_Nuke){
            [playerShip render];
//        }
    }
    
    if (outroTransitionAnimating) {
        [transitionParticleEmitter renderParticles];
    }
}

- (void)dealloc {
    [super dealloc];
    //Its crashing
    /*
    if(font) [font release];
    if(transitionParticleEmitter) [transitionParticleEmitter release];
    [currentLevelFile release];
    [playerShip release];
    if(bossShip) [bossShip release];
    if(enemiesSet) [enemiesSet release];
    
    if(dialogue) [dialogue release];
    if(dialogueBuffer) [dialogueBuffer release];
    if(dialogueLineOne) [dialogueLineOne release];
    if(dialogueLineTwo) [dialogueLineTwo release];
    if(dialogueLineThree) [dialogueLineThree release];
    if(dialogueLineFour) [dialogueLineFour release];
    if(dialogueLineFive) [dialogueLineFive release];
    if(dialogueLineSix) [dialogueLineSix release];
    if(dialogueLineOneBuffer) [dialogueLineOneBuffer release];
    if(dialogueLineTwoBuffer) [dialogueLineTwoBuffer release];
    if(dialogueLineThreeBuffer) [dialogueLineThreeBuffer release];
    if(dialogueLineFourBuffer) [dialogueLineFourBuffer release];
    if(dialogueLineFiveBuffer) [dialogueLineFiveBuffer release];
    if(dialogueLineSixBuffer) [dialogueLineSixBuffer release];
    if(remainderDialogue) [remainderDialogue release];
    
    if(dialogueBorder) [dialogueBorder release];
    if(dialogueFastForwardButton) [dialogueFastForwardButton release];
    if(speakerImage) [speakerImage release];
    if(wavesArray) [wavesArray release];
    if(initialPath) [initialPath release];
    if(attackingEnemies) [attackingEnemies release];
    [droppedPowerUpSet release];
    if(shieldImage) [shieldImage release];
     */
}

@end
    