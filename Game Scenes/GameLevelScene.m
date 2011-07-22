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
//  Last Updated - 7/4/11 @8:30PM - Alexander
//  - Dialogue loading and current wave type (Dialoge vs fighting)
//
//  Last Updated - 7/5/2011 @10PM - James
//  - Small bug fix where enemies were getting removed
//  from the set too soon
//
//  Last Updated - 7/9/2011 @12:50AM - James
//  - Added initial dialogue initializing, updating, and rendering
//  code. Still has bugs like hud element rendering over dialogue
//  stuff, no animation yet.This was a hell of an update, ver hard
//  for both of us.
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
    int wordsThisLine  = 0;
    
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
            wordsThisLine = 0;
            
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
        
        settings = [NSUserDefaults standardUserDefaults];
        
        delegate = del;
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:levelFile ofType:@"plist"]];
        levelDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [bundle release];
        [path release];
        
        // Load and save the level type for this level
        if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kMiniBossLevel"]) {
            levelType = kLevelType_MiniBoss;
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kBossLevel"]) {
            levelType = kLevelType_Boss;
            if([[levelDictionary objectForKey:@"kBossShip"] isEqualToString:@"kBossAtlas"]) {
                //bossShip = [[BossShipAtlas alloc] initWithLocation:CGPointMake(0.0f, 0.0f) andPlayerShipRef:playerShip];
                bossShipID = kBoss_Atlas;
            }
        }
        else if([[levelDictionary objectForKey:@"kLevelType"] isEqualToString:@"kCutsceneLevel"]) {
            levelType = kLevelType_Cutscene;
        }
        
        NSArray *bossDefaultLocationArray = [[NSArray alloc] initWithArray:[[levelDictionary objectForKey:@"kBossDefaultPoint"] componentsSeparatedByString:@","]];
        bossShipDefaultLocation = CGPointMake([[bossDefaultLocationArray objectAtIndex:0] floatValue], [[bossDefaultLocationArray objectAtIndex:1] floatValue]);
        [bossDefaultLocationArray release];
        
        bossShipIsDisplayed = NO;
        bossShipReadyToAnimate = NO;
        bossShipIntroAnimationTime = 0.0;
        
        // Load and save the outro transition for this level
        if([[levelDictionary objectForKey:@"OutroTransition"] isEqualToString:@"kShipFlyOff"]) {
            outroAnimationType = kOutroAnimation_Flyoff;
        }
        if([[levelDictionary objectForKey:@"OutroTransition"] isEqualToString:@"kNuke"]) {
            outroAnimationType = kOutroAnimation_Nuke;
        }
        if([[levelDictionary objectForKey:@"OutroTransition"] isEqualToString:@"kWormhole"]) {
            outroAnimationType = kOutroAnimation_Wormhole;
        }
        
        outroTransitionAnimating = NO;
        
        wavesArray = [levelDictionary objectForKey:@"kWaves"];
        numWaves = [wavesArray count];
        currentWave = 0;
        
        enemiesSet = [[NSMutableSet alloc] init];
        
        [self loadWave:currentWave];
        
        playerShip = [[PlayerShip alloc] initWithShipID:kPlayerShip_Dev andInitialLocation:CGPointMake(155, 40)];
        
        font = [[AngelCodeFont alloc] initWithFontImageNamed:@"xenophobefont.png" controlFile:@"xenophobefont" scale:(1.0/3.0) filter:GL_LINEAR];
        dialogueBorder = [[Image alloc] initWithImage:@"DialogueBoxBorder.png" scale:Scale2fOne];
        dialogueFastForwardButton = [[Image alloc] initWithImage:@"fastforward.png" scale:Scale2fOne];
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
    else if([enemyString isEqualToString:@"kShipTwoShot_BossOne"]){
        return kEnemyShip_TwoShotkBossAfricaAssistOne;
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
    else if([enemyString isEqualToString:@"kShipMissileBombShot_BossTwo"]){
        return kEnemyShip_MissileBombShotkBossEuropeAssist;
    }
    else if([enemyString isEqualToString:@"kShipKamikaze_One"]){
        return kEnemyShip_KamikazeLevelOne;
    }
    else if([enemyString isEqualToString:@"kShipKamikaze_Three"]){
        return kEnemyShip_KamikazeLevelThree;
    }
    else if([enemyString isEqualToString:@"kShipKamikaze_BossTwo"]){
        return kEnemyShip_KamikazekBossNorthAmericaAssistTwo;
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
            
            NSLog(@"HOLD PTS: %f %f", enemy.holdingPositionPoint.x, enemy.holdingPositionPoint.y);
            
            [enemiesSet addObject:enemy];
        }
    }
    else {
        currentWaveType = kWaveType_Dialogue;
        dialogue = [[NSArray alloc] initWithArray:[[wavesArray objectAtIndex:wave] componentsSeparatedByString:@";"]];
        currentDialogueSpeaker = [self convertToSpeakerEnum:[dialogue objectAtIndex:0]];
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
        
        //What's going on here is It fills the necessary strings with the right text, strings 1-3 with 22 wrapped text,
        //4-6 with 28 wrapped. It has to go through all those if statement because not all dialogue wil take all 6 six lines.
        const char* wrappedText = WrapText([[[[dialogue objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] UTF8String], 22, "", "");
        NSMutableArray *wrappedTextArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:wrappedText encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
        NSLog(@"%@", wrappedTextArray);
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
                    NSLog(@"joined:\n%@", secondHalfString);
                    const char* secondHalf = WrapText([secondHalfString UTF8String], 25, "", "");
                    NSMutableArray *secondWrappedArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:secondHalf encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
                    NSLog(@"%@", secondWrappedArray);
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
                }
            }
        }
        [wrappedTextArray release];
        NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n\n%@", dialogueLineOne, dialogueLineTwo, dialogueLineThree, dialogueLineFour, dialogueLineFive, dialogueLineSix, remainderDialogue);
    }
    
    int multiplier = 1;
    for(EnemyShip *enemyShip in enemiesSet){
        enemyShip.pathTime -= (multiplier * 0.3);
        multiplier++;
    }
}

- (void)loadBoss {
    if (bossShipID == kBoss_Atlas) {
        NSLog(@"Loading Atlas");
        bossShip = [[BossShipAtlas alloc] initWithLocation:CGPointMake(160.0f, 600.0f) andPlayerShipRef:playerShip];
    }
    
    bossShipReadyToAnimate = YES;
    
    NSLog(@"Loaded Atlas");
}

- (void)update:(GLfloat)aDelta {    
    
    // We are currently in a "fighting" wave. Update accordingly.
    if (currentWaveType == kWaveType_Enemy || currentWaveType == kWaveType_Boss) {
        //Make sure that all of our ship objects get their update: called. Necessary.
        [playerShip update:aDelta];
        
        if (currentWaveType == kWaveType_Enemy) {
            // Loop through our enemies and remove those that have died and whose
            // destruction animations have completed
            NSMutableSet *discardedEnemies = [[NSMutableSet alloc] init];
            for(EnemyShip *enemyShip in enemiesSet){
                [enemyShip update:aDelta];
                if(enemyShip.shipIsDead && enemyShip.deathAnimationEmitter.particleCount == 0) {
                    [discardedEnemies addObject:enemyShip];
                }
            }
            [enemiesSet minusSet:discardedEnemies];
            [discardedEnemies release];
            
            //Update the enemies' movement paths
            for(EnemyShip *enemyShip in enemiesSet){        
                if(enemyShip.currentPathType == kPathType_Initial){
                    [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/2].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/2].y)];
                    
                    if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                        Vector2f oldEndPoint = enemyShip.currentPath.endPoint;
                        [[enemyShip currentPath] release];
                        enemyShip.currentPath = nil;
                        enemyShip.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake(oldEndPoint.x, oldEndPoint.y) controlPoint1:Vector2fMake(100, 100) controlPoint2:Vector2fMake(300, 300) endPoint:Vector2fMake(enemyShip.holdingPositionPoint.x, enemyShip.holdingPositionPoint.y) segments:100];
                        enemyShip.pathTime = 0;
                        
                        enemyShip.currentPathType = kPathType_ToHolding;
                    }
                }
                else if(enemyShip.currentPathType == kPathType_ToHolding){
                    [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/2].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/2].y)];
                    
                    if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                        Vector2f oldEndPoint = enemyShip.currentPath.endPoint;
                        [[enemyShip currentPath] release];
                        enemyShip.currentPath = nil;
                        enemyShip.pathTime = 0;
                        enemyShip.currentPathType = kPathType_Holding;
                        enemyShip.desiredPosition = CGPointMake(oldEndPoint.x, oldEndPoint.y);
                    }
                }
                else if(enemyShip.currentPathType == kPathType_Holding){
                    holdingTimeBeforeAttack += aDelta;
                    if(holdingTimeBeforeAttack >= 4){
                        holdingTimeBeforeAttack = 0;
                        if(RANDOM_0_TO_1() > 0.5){
                            if([attackingEnemies count] < 3){
                                [attackingEnemies addObject:enemyShip];
                                enemyShip.currentPathType = kPathType_Attacking;
                            }
                        }
                    }
                }
                else if(enemyShip.currentPathType == kPathType_Attacking){
                    if(!enemyShip.currentPath){
                        NSLog(@"Creating new attack path");
                        enemyShip.currentPath = [[BezierCurve alloc] initCurveFrom:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y) 
                                               controlPoint1:Vector2fMake(-50, 50)
                                               controlPoint2:Vector2fMake(370, 50)
                                                    endPoint:Vector2fMake([enemyShip currentLocation].x, [enemyShip currentLocation].y)
                                                                            segments:50];
                    }
                    [enemyShip setCurrentLocation:CGPointMake([enemyShip.currentPath getPointAt:enemyShip.pathTime/2].x, [enemyShip.currentPath getPointAt:enemyShip.pathTime/2].y)];
                    if(enemyShip.pathTime > 1){
                        if(abs(enemyShip.currentLocation.x - enemyShip.currentPath.endPoint.x) < 5 && abs(enemyShip.currentLocation.y - enemyShip.currentPath.endPoint.y) < 5){
                            [[enemyShip currentPath] release];
                            enemyShip.currentPath = nil;
                            enemyShip.pathTime = 0;
                            enemyShip.currentPathType = kPathType_Holding;
                            [attackingEnemies removeObject:enemyShip];
                        }
                    }
                }
            }
        }
        
        if (currentWaveType == kWaveType_Boss) {

            // Animating the boss onto the screen
            if (!bossShipIsDisplayed && bossShipReadyToAnimate && bossShip) {
                for(AbstractProjectile *tempProj in [playerShip projectilesArray]){
                    [tempProj stopProjectile];
                }
                NSLog(@"Animating Boss X: %f Y: %f", bossShip.currentLocation.x, bossShip.currentLocation.y);
                
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
                    for(AbstractProjectile *tempProj in [playerShip projectilesArray]){
                        [tempProj playProjectile];
                    }
                }
            }
            
            [bossShip update:aDelta];
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
                [delegate levelEnded];
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
        else if(currentWaveType != kWaveType_Boss) {
            currentWaveType = kWaveType_Boss;
            [self loadBoss];
        }
        
        // Boss is finished, end level time
        else if(currentWaveType == kWaveType_Finished) {
            for(AbstractProjectile *playerWeapon in playerShip.projectilesArray){
                [playerWeapon stopProjectile];
            }
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
        }
    }
    
    // This is a dialogue wave, display it.
    else {
        dialogueTypeTimeDelay += aDelta;
        if (dialogueTypeTimeDelay > 0.1) {               
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
                    PolygonCollisionResult result = [Collisions polygonCollision:playerShip.collisionPolygon :enemyShip.collisionPolygon :Vector2fZero];
                    
                    if(result.intersect) [enemyShip killShip];
                }
                
                //Enemy bullet -> player ship collision
                for(AbstractProjectile *enemyProjectile in enemyShip.projectilesArray){
                    Polygon *enemyBulletPoly;
                    for(int i = 0; i < [enemyProjectile.polygonArray count]; i++){
                        enemyBulletPoly = [enemyProjectile.polygonArray objectAtIndex:i];
                        PolygonCollisionResult result2 = [Collisions polygonCollision:enemyBulletPoly :playerShip.collisionPolygon :Vector2fZero];
                        
                        if(result2.intersect){
                            NSLog(@"Collision occured between enemy bullet and player ship");
                            if(!playerShip.shipIsDead){
                                [playerShip hitShipWithDamage:50];
                                enemyProjectile.emitter.particles[i].position = Vector2fMake(500, 0);
                            }
                        }
                    }
                }
                
                //Player Bullets->Enemy ship collision
                for(AbstractProjectile *playerShipProjectile in playerShip.projectilesArray){
                    Polygon *playerBulletPoly;
                    for(int i = 0; i < [playerShipProjectile.polygonArray count]; i++){
                        playerBulletPoly = [playerShipProjectile.polygonArray objectAtIndex:i];
                        PolygonCollisionResult result = [Collisions polygonCollision:playerBulletPoly :enemyShip.collisionPolygon :Vector2fZero];
                        
                        if(result.intersect){
                            NSLog(@"Collision occured between player bullet and enemy ship");
                            //Send damage to enemy ship
                            if(!enemyShip.shipIsDead){
                                [enemyShip hitShipWithDamage:50];
                                playerShipProjectile.emitter.particles[i].position = Vector2fMake(500, 50);
                            }
                        }
                    }
                }
            }
            [enemyShip release];
        }
        
        if (currentWaveType == kWaveType_Boss) {
            for (int i = 0; i < bossShip.numberOfModules; i++) {
                if(bossShip.modularObjects[i].isDead == NO){
                    PolygonCollisionResult playerShipResult = [Collisions polygonCollision:[playerShip collisionPolygon] :bossShip.modularObjects[i].collisionPolygon :Vector2fZero];
                    
                    if(playerShipResult.intersect){
                        NSLog(@"Collision occured between player ship and boss module");
                        [playerShip killShip];
                    }
                }
                
                //Player Bullets->Boss ship module collision
                for(AbstractProjectile *playerShipProjectile in playerShip.projectilesArray){
                    Polygon *playerBulletPoly;
                    for(int j = 0; j < [playerShipProjectile.polygonArray count]; j++){
                        playerBulletPoly = [playerShipProjectile.polygonArray objectAtIndex:j];
                        PolygonCollisionResult result = [Collisions polygonCollision:playerBulletPoly :bossShip.modularObjects[i].collisionPolygon :Vector2fZero];
                        
                        if(result.intersect){
                            
                            if (bossShip.modularObjects[i].destructionOrder == bossShip.currentDestructionOrder && bossShip.modularObjects[i].isDead == NO) {
                                NSLog(@"Module Order: %d Current Order: %d", bossShip.modularObjects[i].destructionOrder, bossShip.currentDestructionOrder);
                                [bossShip hitModule:i withDamage:500];
                                playerShipProjectile.emitter.particles[j].position = Vector2fMake(500, 50);
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
        NSLog(@"END OF DIALOGUE");
        if(currentWave != (numWaves - 1)) {
            currentWave++;
            [self loadWave:currentWave];
        }
        else {
            [delegate levelEnded];
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
                        NSLog(@"joined:\n%@", secondHalfString);
                        const char* secondHalf = WrapText([secondHalfString UTF8String], 25, "", "");
                        NSMutableArray *secondWrappedArray = [[NSMutableArray alloc] initWithArray:[[NSString stringWithCString:secondHalf encoding:NSASCIIStringEncoding] componentsSeparatedByString:@"\n"]];
                        NSLog(@"%@", secondWrappedArray);
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
                    }
                }
            }
        }
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
        NSLog(@"Touched on Ship :D");
        touchOriginatedFromPlayerShip = YES;
    }
    else {
        touchOriginatedFromPlayerShip = NO;
    }
    if(CGRectContainsPoint(CGRectMake(305, 1, 25, 22), location) && currentWaveType == kWaveType_Dialogue){
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
        if(location.x - ([playerShip shipWidth] / 2) < 0){
            location.x = [playerShip shipWidth] / 2;
        }
        if(location.x + ([playerShip shipWidth] / 2) > screenBounds.size.width){
            location.x = screenBounds.size.width - ([playerShip shipWidth] / 2);
        }
        
        if(location.y - ([playerShip shipHeight] / 2) < 0){
            location.y = [playerShip shipHeight] / 2;
        }
        if(location.y + ([playerShip shipHeight] / 2) > screenBounds.size.height){
            location.y = screenBounds.size.height - ([playerShip shipHeight] / 2);
        }
        [playerShip setDesiredLocation:location];
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
    
    if (currentWaveType == kWaveType_Enemy) {
        for (EnemyShip *enemyShip in enemiesSet) {
            [enemyShip render];
        }
    }
    
    if (currentWaveType == kWaveType_Boss) {
        [bossShip render];
    }
        
    //Dialogue Related rendering
    if(currentWaveType == kWaveType_Dialogue) {
        [dialogueBorder renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];
        [dialogueFastForwardButton renderAtPoint:CGPointMake(310.0f, 10.0f) centerOfImage:YES];
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
        [playerShip render];
    }
}

@end
    