/*
 *  Common.h
 *  Xenophobe
 *
 *  Created by Alexander on 10/20/10.
 *  Copyright 2010 Alexander Nabavi-Noori, XanderNet Inc. All rights reserved.
 *
 *	Team:
 *	Alexander Nabavi-Noori - Software Engineer, Game Architect
 *	James Linnell - Software Engineer, Creative Design, Art Producer
 *	Tyler Newcomb - Creative Design, Art Producer
 *
 *	Last Updated - 10/27/2010 @ 12AM - Alexander
 *	- Changed the particle structure to include delta size
 *	for the ability to set a finish particle size
 *
 *  Last Updated - 12/19/2010 @ 5:20PM - James
 *  - Added inline func for collisions. Takes 5 variables:
 *  object1's bounding box, it's position
 *  object2's boundingbox, it's position, and then the tolerance
 *
 *  Last Updated - 12/27/2010 @ 6:50PM - James
 *  - Added circular collision detection function
 *  using the positions and radiuses
 *
 *  Last Updated - 12/29/2010 @ 12:30AM - James
 *  - Added function to change NSArrays to
 *  regular C Arrays, mainly for use in Ship classes
 *  to shorten init functions.
 *
 *  Last Updated - 12/29/2010 @ 11:50PM - James
 *  - Added function to retrieve the number of
 *  objects in a array of Vector2f's, for
 *  use in the PolygonCollision.
 *
 *  Last Updated - 12/30/2010 @ 4:20PM - James
 *  - Added Vec2f->CGPt, bug in length
 *
 *  Last Updated - 12/30/2010 @ 5PM - James
 *  - Removed collide functions and to-CGPoint 
 *  conversions and length function.
 *
 *  Last Updated - 12/31/2010 @ 7:30PM - Alexander
 *  - Memory management
 *
 *  Last Updated - 6/15/2011 @ 3:30PM - Alexander
 *  - Added structures and methods for new Scale2f
 *  vector for scaling images
 *
 *  Last Updated - 7/4/2011 @ 6:45PM - James
 *  - Added kControlType_MainMenu et al to the enum
 */

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <math.h>

#pragma mark -
#pragma mark Debug

#define DEBUG 1

#pragma mark -
#pragma mark Macros

// Macro which returns a random value between -1 and 1
#define RANDOM_MINUS_1_TO_1() ((random() / (GLfloat)0x3fffffff )-1.0f)

// Macro which returns a random number between 0 and 1
#define RANDOM_0_TO_1() ((random() / (GLfloat)0x7fffffff ))

// Macro which converts degrees into radians
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

// Macro which converts radians to degrees
#define RADIANS_TO_DEGREES(__RAD__) ((__RAD__)*180.0/M_PI)

// Macro which converts coordinate rise / run to particle emitter angle
// ;#define SLOPE_TO_DEGREES(__SLOPE__) (DEGREES_TO_RADIANS(atan(__SLOPE__)))

// Settings keys
#define kSetting_SoundVolume @"xeno_sound_volume"
#define kSetting_MusicVolume @"xeno_music_volume"
#define kSetting_ControlType @"xeno_control_type"
#define kSetting_TactileFeedback @"xeno_tactile_feedback"
#define kSetting_TwitterCredentials @"xeno_twitter_credentials"
#define kSetting_FirstTimeRun @"xeno_has_run_before"
#define kSetting_SaveGameLevelProgress @"xeno_game_level_progress"
#define kSetting_SaveGameScore @"xeno_game_score"
#define kSetting_SaveGameHealth @"xeno_game_health"
#define kSetting_SaveGameNukeHold @"xeno_game_nuke_hold"
#define kSetting_SaveGameShip @"xeno_game_ship"
#define kSetting_SaveGameWeapon @"xeno_game_weapon"
#define kSetting_SaveGameCredits @"xeno_game_credits"
#define kSetting_SaveGameUnlockedWeapons @"xeno_game_unlocked_weapons"
#define kSetting_SaveGameUnlockedShips @"xeno_game_unlocked_ships"
#define kSetting_SaveGameEquippedWeapon @"xeno_game_equipped_weapon"
#define kSetting_SaveGameEquippedShip @"xeno_game_equipped_ship"
#define kSetting_ResetStoreVarsFromDataClear @"xeno_reset_store_vars_from_data_clear"

#define kSettingValue_ControlType_Touch @"TOUCH"
#define kSettingValue_ControlType_Accelerometer @"ACCEL"



//Universal Scores
#define kScore_EnemyLevelOneKill 5
#define kScore_EnemyLevelTwoKill 10
#define kScore_EnemyLevelThreeKill 15
#define kScore_EnemyLevelFourKill 20
#define kScore_EnemyLevelFiveKill 25
#define kScore_EnemyLevelSixKill 30

#define kScore_NukeBonus 500
#define kScore_DoubleDamageBonus 100
#define kScore_SlowmoBonus 100
#define kScore_ExtraHealthBonus 50
#define kScore_ShieldBonus 150
#define kScore_EnemyRepelBonus 100
#define kScore_MagnetBonus 200
#define kScore_ProximityDamageBonus 100

#define kScore_ThemisBonus 10000
#define kScore_EosBonus 20000
#define kScore_AstraeusBonus 30000
#define kScore_HeliosBonus 40000
#define kScore_OceanusBonus 50000
#define kScore_AtlasBonus 60000
#define kScore_HyperionBonus 70000
#define kScore_KronosBonus 80000
#define kScore_AlphaWeaponBonus 100000
#define kScore_MiniBossLevelOneBonus 2000
#define kScore_MiniBossLevelTwoBonus 3000
#define kScore_MiniBossLevelThreeBonus 4000
#define kScore_MiniBossLevelFourBonus 5000
#define kScore_MiniBossLevelFiveBonus 6000
#define kScore_MiniBossLevelSixBonus 7000
#define kScore_MiniBossLevelSevenBonus 8000

#define kScore_WavesWeaponBonus 5
#define kScore_MissilesWeaponBonus 10
#define kScore_HeatseekersWeaponBonus 25

#define kScore_AttackShipBonus 10
#define kScore_DefenseShipBonus 10
#define kScore_SpeedShipBonus 10

#define kScore_TimeBonusConstant 15000
#define kScore_TimeBonus(__TIME__) (kScore_TimeBonusConstant / (__TIME__))



#define kXP750_Price 0
#define kXP751_Price 100
#define kXPA368_Price 300
#define kXPA600_Price 1000
#define kXPA617_Price 1800
#define kXPA652_Price 2700
#define kXPA679_Price 3750
#define kXPD900_Price 300
#define kXPD909_Price 1000
#define kXPD924_Price 1800
#define kXPD945_Price 2700
#define kXPD968_Price 3750
#define kXPS400_Price 200
#define kXPS424_Price 1000
#define kXPS447_Price 1800
#define kXPS463_Price 2700
#define kXPS485_Price 3750

#define kShipTypeBase @"kShipTypeBase"
#define kShipTypeAttack @"kShipTypeAttack"
#define kShipTypeSpeed @"kShipTypeSpeed"
#define kShipTypeDefense @"kShipTypeDefense"
#define kXP750 @"kShipXP750"
#define kXP751 @"kShipXP751"
#define kXPA368 @"kShipXPA368"
#define kXPA600 @"kShipXPA600"
#define kXPA617 @"kShipXPA617"
#define kXPA652 @"kShipXPA652"
#define kXPA679 @"kShipXPA679"
#define kXPD900 @"kShipXPD900"
#define kXPD909 @"kShipXPD909"
#define kXPD924 @"kShipXPD924"
#define kXPD945 @"kShipXPD945"
#define kXPD968 @"kShipXPD968"
#define kXPS400 @"kShipXPS400"
#define kXPS424 @"kShipXPS424"
#define kXPS447 @"kShipXPS447"
#define kXPS463 @"kShipXPS463"
#define kXPS485 @"kShipXPS485"

#define kXP750_Attributes @"1;1;1"
#define kXP751_Attributes @"2;2;2"
#define kXPA368_Attributes @"7;3;4"
#define kXPA600_Attributes @"4;2;3"
#define kXPA617_Attributes @"5;2;3"
#define kXPA652_Attributes @"8;4;5"
#define kXPA679_Attributes @"10;5;7"
#define kXPD900_Attributes @"3;4;2"
#define kXPD909_Attributes @"3:5;2"
#define kXPD924_Attributes @"4;7;3"
#define kXPD945_Attributes @"5;8;4"
#define kXPD968_Attributes @"7;10;5"
#define kXPS400_Attributes @"3;2;4"
#define kXPS424_Attributes @"3;2;5"
#define kXPS447_Attributes @"4;3;7"
#define kXPS463_Attributes @"5;4;8"
#define kXPS485_Attributes @"7;5;10"


#define kBulletLevelOne_Price 0
#define kBulletLevelTwo_Price 50
#define kBulletLevelThree_Price 300
#define kBulletLevelFour_Price 700
#define kBulletLevelFive_Price 1000
#define kBulletLevelSix_Price 1400
#define kBulletLevelSeven_Price 1800
#define kBulletLevelEight_Price 2300
#define kBulletLevelNine_Price 2800
#define kBulletLevelTen_Price 3450

#define kWaveLevelOne_Price 100
#define kWaveLevelTwo_Price 300
#define kWaveLevelThree_Price 600
#define kWaveLevelFour_Price 950
#define kWaveLevelFive_Price 1100
#define kWaveLevelSix_Price 1300
#define kWaveLevelSeven_Price 1700
#define kWaveLevelEight_Price 2100
#define kWaveLevelNine_Price 2400
#define kWaveLevelTen_Price 2700

#define kMissileLevelOne_Price 250
#define kMissileLevelTwo_Price 500
#define kMissileLevelThree_Price 750
#define kMissileLevelFour_Price 1000
#define kMissileLevelFive_Price 1200
#define kMissileLevelSix_Price 1500
#define kMissileLevelSeven_Price 1900
#define kMissileLevelEight_Price 2500
#define kMissileLevelNine_Price 3000
#define kMissileLevelTen_Price 3600

#define kHeatseekerLevelOne_Price 2000


#define kWeaponTypeBullet @"kWeaponTypeBullet"
#define kWeaponBulletLevelOne @"kBulletLevelOne"
#define kWeaponBulletLevelTwo @"kBulletLevelTwo"
#define kWeaponBulletLevelThree @"kBulletLevelThree"
#define kWeaponBulletLevelFour @"kBulletLevelFour"
#define kWeaponBulletLevelFive @"kBulletLevelFive"
#define kWeaponBulletLevelSix @"kBulletLevelSix"
#define kWeaponBulletLevelSeven @"kBulletLevelSeven"
#define kWeaponBulletLevelEight @"kBulletLevelEight"
#define kWeaponBulletLevelNine @"kBulletLevelNine"
#define kWeaponBulletLevelTen @"kBulletLevelTen"

#define kWeaponTypeWave @"kWeaponTypeWave"
#define kWeaponWaveLevelOne @"kWaveLevelOne"
#define kWeaponWaveLevelTwo @"kWaveLevelTwo"
#define kWeaponWaveLevelThree @"kWaveLevelThree"
#define kWeaponWaveLevelFour @"kWaveLevelFour"
#define kWeaponWaveLevelFive @"kWaveLevelFive"
#define kWeaponWaveLevelSix @"kWaveLevelSix"
#define kWeaponWaveLevelSeven @"kWaveLevelSeven"
#define kWeaponWaveLevelEight @"kWaveLevelEight"
#define kWeaponWaveLevelNine @"kWaveLevelNine"
#define kWeaponWaveLevelTen @"kWaveLevelTen"

#define kWeaponTypeMissile @"kWeaponTypeMissile"
#define kWeaponMissileLevelOne @"kMissileLevelOne"
#define kWeaponMissileLevelTwo @"kMissileLevelTwo"
#define kWeaponMissileLevelThree @"kMissileLevelThree"
#define kWeaponMissileLevelFour @"kMissileLevelFour"
#define kWeaponMissileLevelFive @"kMissileLevelFive"
#define kWeaponMissileLevelSix @"kMissileLevelSix"
#define kWeaponMissileLevelSeven @"kMissileLevelSeven"
#define kWeaponMissileLevelEight @"kMissileLevelEight"
#define kWeaponMissileLevelNine @"kMissileLevelNine"
#define kWeaponMissileLevelTen @"kMissileLevelTen"

#define kWeaponTypeHeatseeking @"kWeaponTypeHeatseeking"
#define kWeaponHeatseekingLevelOne @"kHeatseekerLevelOne"

#pragma mark -
#pragma mark Enumerations

enum {
	kControlType_NewGame,
	kControlType_Settings,
	kControlType_About,
	kControlType_HighScores,
    kControlType_MainMenu,
    kControlType_ReturnToGame,
    kControlType_Shop,
    kControlType_Pause,
	kControl_Idle,
	kControl_Scaling,
	kControl_Selected,
	kGameState_Running,
	kGameState_Paused,
	kGameState_Loading,
	kSceneState_Idle,
	kSceneState_TransitionIn,
	kSceneState_TransitionOut,
	kSceneState_Running,
	kSceneState_Paused
};


#pragma mark -
#pragma mark Types

typedef struct _TileVert {
	GLfloat v[2];
	GLfloat uv[2];
} TileVert;

typedef struct _Color4f {
	GLfloat red;
	GLfloat green;
	GLfloat blue;
	GLfloat alpha;
} Color4f;

typedef struct _Vector2f {
	GLfloat x;
	GLfloat y;
} Vector2f;

typedef struct _Scale2f {
    GLfloat x;
    GLfloat y;
} Scale2f;

typedef struct _Quad2f {
	GLfloat bl_x, bl_y;
	GLfloat br_x, br_y;
	GLfloat tl_x, tl_y;
	GLfloat tr_x, tr_y;
} Quad2f;

typedef struct _Particle {
	Vector2f position;
	Vector2f direction;
	Color4f color;
	Color4f deltaColor;
	GLfloat particleSize;
	GLfloat timeToLive;
	GLfloat	deltaSize;
} Particle;


typedef struct _PointSprite {
	GLfloat x;
	GLfloat y;
	GLfloat size;
} PointSprite;

typedef enum _KamikazeState{
    kKamikaze_Idle = 0,
    kKamikaze_LeftAttack,
    kKamikaze_LeftReturn,
    kKamikaze_RightAttack,
    kKamikaze_RightReturn,
    kKamikaze_TopLeftAttack,
    kKamikaze_TopLeftReturn,
    kKamikaze_TopRightAttack,
    kKamikaze_TopRightReturn
} KamikazeState;

#pragma mark -
#pragma mark Inline Functions

static const Color4f Color4fInit = {1.0f, 1.0f, 1.0f, 1.0f};

static const Vector2f Vector2fZero = {0.0f, 0.0f};

static const Scale2f Scale2fOne = {1.0f, 1.0f};

static inline Vector2f Vector2fMake(GLfloat x, GLfloat y)
{
	return (Vector2f) {x, y};
}

static inline Scale2f Scale2fMake(GLfloat x, GLfloat y)
{
    return (Scale2f) {x, y};
}

static inline Color4f Color4fMake(GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha)
{
	return (Color4f) {red, green, blue, alpha};
}

static inline Vector2f Vector2fMultiply(Vector2f v, GLfloat s)
{
	return (Vector2f) {v.x * s, v.y * s};
}

static inline Vector2f Vector2fAdd(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x + v2.x, v1.y + v2.y};
}

static inline Vector2f Vector2fSub(Vector2f v1, Vector2f v2)
{
	return (Vector2f) {v1.x - v2.x, v1.y - v2.y};
}

static inline GLfloat Vector2fDot(Vector2f v1, Vector2f v2)
{
	return (GLfloat) v1.x * v2.x + v1.y * v2.y;
}

static inline GLfloat Vector2fLength(Vector2f v)
{
	return (GLfloat) sqrtf(Vector2fDot(v, v));
}

static inline Vector2f Vector2fNormalize(Vector2f v)
{
	return Vector2fMultiply(v, 1.0f/Vector2fLength(v));
}

