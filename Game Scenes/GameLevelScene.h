//
//  GameLevelScene.h
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
//  Last Updated - 1/31/20101 @8PM - Alexander
//  - Began implementing tasks necessary to load
//  level files. Moved other tasks from GameScene
//  to this class such as collisions and health
//
//  Last Updated - 6/29/11 @5PM - James
//  - Paths for incoming ships are setup now. Partially.
//
//  Last Updated - 7/4/11 @4PM - Alexander
//  - Holding points for the enemies are now pre-determined
//  
//  Last Updated - 7/4/11 @8:30PM - Alexander
//  - Dialogue loading and current wave type (Dialoge vs fighting)
//
//  Last Updated - 7/18/11 @9PM - Alexander
//  - Fly off transition added
//
//  Last Updated - 7/19/11 @6PM - Alexander
//  - Cleaned up the update method to only do necessary tasks during
//  the appropriate wave type
//  - Cleaned up the collision update method to only do necessary tasks
//  during the appropriate wave type as well as added collision support
//  for player projectiles -> boss modules
//  - Boss ships now fly in after the waves have been completed
//
//  Last Updated - 7/28/11 @5:30PM - Alexander
//  - New delegate method for saving progress

#import <Foundation/Foundation.h>
#import "BossShip.h"
#import "BossShipAtlas.h"
#import "MiniBossGeneral.h"
#import "EnemyShip.h"
#import "PlayerShip.h"
#import "AbstractScene.h"
#import "AbstractProjectile.h"
#import "Collisions.h"
#import "BezierCurve.h"
#import "BossShipAstraeus.h"
#import "BossShipHelios.h"
#import "BossShipOceanus.h"
#import "BossShipHyperion.h"
#import "BossShipThemis.h"
#import "BossShipKronos.h"
#import "MiniBoss_OneOne.h"
#import "MiniBoss_OneTwo.h"
#import "MiniBoss_OneThree.h"
#import "MiniBoss_TwoTwo.h"
#import "MiniBoss_TwoThree.h"
#import "MiniBoss_ThreeOne.h"
#import "MiniBoss_ThreeThree.h"
#import "MiniBoss_ThreeTwo.h"
#import "MiniBoss_SixTwo.h"
#import "MiniBoss_FourTwo.h"
#import "MiniBoss_SixOne.h"
#import "MiniBoss_SevenThree.h"
#import "MiniBoss_FiveOne.h"
#import "MiniBoss_FiveTwo.h"
#import "MiniBoss_SevenOne.h"
#import "MiniBoss_FiveThree.h"
#import "MiniBoss_TwoOne.h"
#import "Drop.h"

@protocol GameLevelDelegate <NSObject>
@required
- (void)levelEnded:(NSDictionary *)stats;
- (void)playerReachedSavePoint:(NSString *)savePoint;
- (void)scoreChangedBy:(int)scoreChange;
- (void)playerHealthChangedBy:(int)healthChange;
- (void)creditAmountChangedBy:(int)creditChange;
- (void)powerUpPickedUp:(DropType)pickedUp;
- (void)clearAllPowerUpsPickedUp;
- (void)playerHasDied;
@end

typedef enum _LevelType {
    kLevelType_MiniBoss = 0,
    kLevelType_Boss,
    kLevelType_Cutscene
} LevelType;

typedef enum _DialogueSpeaker {
    kSpeaker_Player = 0,
    kSpeaker_General,
    kSpeaker_BossOne,
    kSpeaker_BossTwo,
    kSpeaker_BossThree,
    kSpeaker_BossFour,
    kSpeaker_BossFive,
    kSpeaker_BossSix,
    kSpeaker_BossSeven,
    kSpeaker_Kronos,
    kSpeaker_Singularity,
    kSpeaker_AlienSwarm
} DialogueSpeaker;

typedef enum _WaveType {
    kWaveType_Dialogue = 0,
    kWaveType_Enemy,
    kWaveType_Boss,
    kWaveType_Finished
} WaveType;

typedef enum _OutroAnimation {
    kOutroAnimation_Flyoff = 0,
    kOutroAnimation_Nuke,
    kOutroAnimation_Wormhole
} OutroAnimation;

@interface GameLevelScene : NSObject {
    id <GameLevelDelegate>  delegate;
    
    AngelCodeFont           *font;
    NSUserDefaults          *settingsDB;
    CGRect                  screenBounds;
    SoundManager            *soundManager;
    ParticleEmitter         *transitionParticleEmitter;
    
    NSString                *currentLevelFile;
    PlayerShip              *playerShip;
    BossShip                *bossShip;
    CGPoint                 bossShipDefaultLocation;
    BossShipID              bossShipID;
    BOOL                    bossShipIsDisplayed;
    float                   bossShipIntroAnimationTime;
    BOOL                    bossShipReadyToAnimate;
    Image                   *bossHealthBar;
    Image                   *bossHealthBarBackground;
    
    // Controlling the player ship
    BOOL                    touchOriginatedFromPlayerShip;
    BOOL                    touchFromSecondShip;
    
    // Storing objects in play
    NSMutableSet            *enemiesSet;
    
    NSMutableDictionary     *levelDictionary;
    LevelType               levelType;
    WaveType                currentWaveType;
    OutroAnimation          outroAnimationType;
    BOOL                    outroTransitionAnimating;
    float                   outroAnimationTime;

    // Dialogue Displaying
    NSArray                 *dialogue;
    DialogueSpeaker         currentDialogueSpeaker;
    NSMutableString         *dialogueBuffer;
    NSString                *dialogueLineOne;
    NSString                *dialogueLineTwo;
    NSString                *dialogueLineThree;
    NSString                *dialogueLineFour;
    NSString                *dialogueLineFive;
    NSString                *dialogueLineSix;
    NSMutableString         *dialogueLineOneBuffer;
    NSMutableString         *dialogueLineTwoBuffer;
    NSMutableString         *dialogueLineThreeBuffer;
    NSMutableString         *dialogueLineFourBuffer;
    NSMutableString         *dialogueLineFiveBuffer;
    NSMutableString         *dialogueLineSixBuffer;
    NSString                *remainderDialogue;
    BOOL                    dialogueNeedsContinue;
    BOOL                    dialogueIsTyping;
    int                     currentDialogueSpeakerIndex;
    int                     currentDialogueDisplayLine;
    int                     currentDialogueCharacterPosition;
    int                     dialogueFirstSectionLength;
    int                     currentNumberOfDialogueLinesToShow;
    float                   dialogueTypeTimeDelay;
    Image                   *dialogueBorder;
    Image                   *dialogueFastForwardButton;
    Image                   *speakerImage;
    
    int                     levelDifficulty;
    OutroAnimation          outroAnimation;
    GLfloat                 outroDelay;
    NSArray                 *wavesArray;
    int                     numWaves;
    int                     currentWave;
    
    BezierCurve             *initialPath;
    
    GLfloat                 holdingTimeBeforeAttack;
    GLfloat                 holdingTimeTarget;
    NSMutableSet            *attackingEnemies;
    
    //Drops stuff
    NSMutableSet            *droppedPowerUpSet;
    GLfloat                 powerUpTimer;
    GLfloat                 proximityDamageTimer;
    BOOL                    proximityShouldGiveDamage;
    BOOL                    shieldEnabled;
    BOOL                    damageMultiplierOn;
    BOOL                    scoreMultiplierOn;
    BOOL                    enemyRepelOn;
    BOOL                    powerUpMagnetActivated;
    BOOL                    slowmoActivated;
    BOOL                    proximityDamageActivated;
    BOOL                    nukeReadyForUse;
    Image                   *shieldImage;
    
    // Stats
    float                   levelTime;
    int                     scoreEarned;
    int                     numDropPickups;
    int                     enemiesKilled;
    
    //Gameover
    GLfloat                 gameOverTimer;
    BOOL                    gameIsOver;
}

@property (nonatomic, retain) id <GameLevelDelegate> delegate;
@property (readonly, retain) PlayerShip *playerShip;
@property (readonly) WaveType currentWaveType;

- (id)initWithLevelFile:(NSString *)levelFile withDelegate:(id <GameLevelDelegate>)del;

- (EnemyShipID)convertToEnemyEnum:(NSString *)enemyString;
- (DialogueSpeaker)convertToSpeakerEnum:(NSString *)speaker;

- (void)loadWave:(int)wave;
- (void)loadBoss;

- (void)update:(GLfloat)aDelta;
- (void)updateCollisions;
- (void)updateWithTouchLocationBegan:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView;
- (void)updateWithTouchLocationMoved:(NSSet *)touches withEvent:(UIEvent *)event view:(UIView *)aView;
- (void)render;
- (Vector2f)VectorRandomInRectWithVectors:(Vector2f)v1 v2:(Vector2f)v2;
- (void)skipToNewPageOfText;
- (void)nukeButtonPushed;
- (int)damageForWeaponType:(ProjectileID)projectileType;

- (void)addScoreForEnemyShipDeath:(EnemyShip *)enemy;
- (void)addScoreForBossShipDeath:(BossShip *)boss;


@end
