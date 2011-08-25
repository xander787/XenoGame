//
//  WaveProjectile.m
//  Xenophobe
//
//  Created by James Linnell on 8/5/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "WaveProjectile.h"

@implementation WaveProjectile

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation andAngle:(GLfloat)aAngle
{
    self = [super initWithProjectileID:aProjID location:aLocation andAngle:aAngle];
    if (self) {
        
        //Paths for main dictionary
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"Projectiles" ofType:@"plist"]];
        NSMutableDictionary *dictionaryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *projectileDictionary;
        [path release];
        
        switch (projectileID) {
            case kPlayerProjectile_WaveLevelOne_SingleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelOne_SingleSmall"]];
                break;
                
            case kPlayerProjectile_WaveLevelTwo_DoubleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelTwo_DoubleSmall"]];
                break;
                
            case kPlayerProjectile_WaveLevelThree_DoubleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelThree_DoubleSmall"]];
                break;
                
            case kPlayerProjectile_WaveLevelFour_SingleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelFour_SingleBig"]];
                break;
                
            case kPlayerProjectile_WaveLevelFive_SingleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelFive_SingeBig"]];
                break;
                
            case kPlayerProjectile_WaveLevelSix_DoubleMedium:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelSix_DoubleMedium"]];
                break;
                
            case kPlayerProjectile_WaveLevelSeven_DoubleMedium:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelSeven_DoubleMedium"]];
                break;
                
            case kPlayerProjectile_WaveLevelEight_DoubleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelEight_DoubleBig"]];
                break;
                
            case kPlayerProjectile_WaveLevelNine_DoubleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelNine_DoubleBig"]];
                break;
                
            case kPlayerProjectile_WaveLevelTen_TripleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kPlayerProjectile_WaveLevelTen_TripleBig"]];
                break;
                
                
            case kEnemyProjectile_WaveLevelOne_SingleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelOne_SingleSmall"]];
                break;
                
            case kEnemyProjectile_WaveLevelTwo_DoubleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelTwo_DoubleSmall"]];
                break;
                
            case kEnemyProjectile_WaveLevelThree_DoubleSmall:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelThree_DoubleSmall"]];
                break;
                
            case kEnemyProjectile_WaveLevelFour_SingleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelFour_SingleBig"]];
                break;
                
            case kEnemyProjectile_WaveLevelFive_SingleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelFive_SingleBig"]];
                break;
                
            case kEnemyProjectile_WaveLevelSix_DoubleMedium:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelSix_DoubleMedium"]];
                break;
                
            case kEnemyProjectile_WaveLevelSeven_DoubleMedium:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelSeven_DoubleMedium"]];
                break;
                
            case kEnemyProjectile_WaveLevelEight_DoubleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelEight_DoubleBig"]];
                break;
                
            case kEnemyProjectile_WaveLevelNine_DoubleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelNine_DoubleBig"]];
                break;
                
            case kEnemyProjectile_WaveLevelTen_TripleBig:
                projectileDictionary = [[NSMutableDictionary alloc] initWithDictionary:[dictionaryPlist objectForKey:@"kEnemyProjectile_WaveLevelTen_TripleBig"]];
                break;
                
            default:
                break;
        }
        
        speed = [[projectileDictionary objectForKey:@"kSpeed"] floatValue];
        rate = [[projectileDictionary objectForKey:@"kRate"] floatValue];
        
        //Loop through the collision points, put them in a C array
        collisionPointCount = 4;
        collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
        bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
        collisionPoints[0] = Vector2fMake(0, 4);
        collisionPoints[1] = Vector2fMake(4, 0);
        collisionPoints[2] = Vector2fMake(0, -4);
        collisionPoints[3] = Vector2fMake(-4, 0);
        
        
        switch (projectileID) {
            case kEnemyProjectile_WaveLevelOne_SingleSmall:
            case kPlayerProjectile_WaveLevelOne_SingleSmall:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:5];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelTwo_DoubleSmall:
            case kPlayerProjectile_WaveLevelTwo_DoubleSmall:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:5];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:5];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelThree_DoubleSmall:
            case kPlayerProjectile_WaveLevelThree_DoubleSmall:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:5];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:5];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelFour_SingleBig:
            case kPlayerProjectile_WaveLevelFour_SingleBig:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_WaveLevelFive_SingleBig:
            case kPlayerProjectile_WaveLevelFive_SingleBig:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            case kEnemyProjectile_WaveLevelSix_DoubleMedium:
            case kPlayerProjectile_WaveLevelSix_DoubleMedium:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:10];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:10];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelSeven_DoubleMedium:
            case kPlayerProjectile_WaveLevelSeven_DoubleMedium:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:10];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:10];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelEight_DoubleBig:
            case kPlayerProjectile_WaveLevelEight_DoubleBig:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelNine_DoubleBig:
            case kPlayerProjectile_WaveLevelNine_DoubleBig:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                
                break;
            }
                
            case kEnemyProjectile_WaveLevelTen_TripleBig:
            case kPlayerProjectile_WaveLevelTen_TripleBig:{
                ParticleEmitter *tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                tempEmitter = [self newWaveEmitterWithAngle:15];
                [emitters addObject:tempEmitter];
                [tempEmitter release];
                
                
                NSArray *tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:0] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:1] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                tempArray = [self newArrayOfPolygonsWithCount:[[emitters objectAtIndex:2] maxParticles]];
                [polygons addObject:tempArray];
                [tempArray release];
                break;
            }
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)update:(GLfloat)aDelta {
    [super update:aDelta];
    
    if(elapsedTime >= rate){
        for(ParticleEmitter *emitter in emitters){
            [emitter stopParticleEmitter];
            for(int k = 0; k < [emitter maxParticles]; k++){
                emitter.particles[k].timeToLive = emitter.particleLifespan;
                emitter.particles[k].position = emitter.sourcePosition;
                
                float newAngle = (GLfloat)DEGREES_TO_RADIANS(emitter.angle + emitter.angleVariance * RANDOM_MINUS_1_TO_1());
                Vector2f vector = Vector2fMake(cosf(newAngle), sinf(newAngle));
                float vectorSpeed = emitter.speed + emitter.speedVariance * RANDOM_MINUS_1_TO_1();
                emitter.particles[k].direction = Vector2fMultiply(vector, vectorSpeed);
            }
            emitter.active = YES;
            emitter.sourcePosition = location;
            emitter.angle = angle;
        }
        elapsedTime = 0;
        secondWaveTimer = 0;
        thirdWaveTimer = 0;
    }
    
    for(NSArray *polyArray in polygons){
        for(Polygon *poly in polyArray){
            [poly setPos:CGPointMake(-50, -50)];
        }
    }
    
    for(int i = 0; i < [emitters count]; i++){
        if(i == 0){
            [[emitters objectAtIndex:i] setAngle:angle];
            [[emitters objectAtIndex:i] setSourcePosition:location];
            [[emitters objectAtIndex:i] update:aDelta];
        }
        else if(i == 1){
            secondWaveTimer += aDelta;
            if(secondWaveTimer >= 0.2){
                [[emitters objectAtIndex:i] setAngle:angle];
                [[emitters objectAtIndex:i] setSourcePosition:location];
                [[emitters objectAtIndex:i] update:aDelta];
            }
        }
        else if(i == 2){
            thirdWaveTimer += aDelta;
            if(thirdWaveTimer >= 0.4){
                [[emitters objectAtIndex:i] setAngle:angle];
                [[emitters objectAtIndex:i] setSourcePosition:location];
                [[emitters objectAtIndex:i] update:aDelta];
            }
        }
        
        
        for(int k = 0; k < [[emitters objectAtIndex:i] particleIndex]; k++){
            [[[polygons objectAtIndex:i] objectAtIndex:k] setPos:CGPointMake([[emitters objectAtIndex:i] particles][k].position.x, [[emitters objectAtIndex:i] particles][k].position.y)];
        }
    }
}

- (ParticleEmitter *)newWaveEmitterWithAngle:(GLfloat)aAngle {
    ParticleEmitter *baseEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture.png"
                                                                                     position:location 
                                                                       sourcePositionVariance:Vector2fZero
                                                                                        speed:speed 
                                                                                speedVariance:0.0
                                                                             particleLifeSpan:4.0
                                                                     particleLifespanVariance:0.0
                                                                                        angle:angle
                                                                                angleVariance:aAngle
                                                                                      gravity:Vector2fZero
                                                                                   startColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                           startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                  finishColor:Color4fMake(1.0, 1.0, 1.0, 1.0)
                                                                          finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                 maxParticles:aAngle
                                                                                 particleSize:15.0
                                                                           finishParticleSize:15.0
                                                                         particleSizeVariance:0.0
                                                                                     duration:0.1
                                                                                blendAdditive:YES];
    baseEmitter.fastEmission = YES;
    baseEmitter.emissionRate = 500;
    
    if(projectileID >= kEnemyProjectile_WaveLevelOne_SingleSmall && projectileID <= kEnemyProjectile_WaveLevelTen_TripleBig){
        [baseEmitter setStartColor:Color4fMake(1.0, 0.0, 0.0, 1.0)];
        [baseEmitter setFinishColor:Color4fMake(1.0, 0.0, 0.0, 1.0)];
    }
    
    return  baseEmitter;
}

- (NSArray *)newArrayOfPolygonsWithCount:(int)count {
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    for(int i =0; i < count; i++){
        Polygon *tempPoly = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(location.x, location.y)];
        [firstArray addObject:tempPoly];
        [tempPoly release];
    }
    
    NSArray *lastArray = [[NSArray alloc] initWithArray:firstArray];
    [firstArray release];
    return lastArray;
}

- (void)playProjectile {
    [super playProjectile]; 
}

- (void)pauseProjectile {
    [super pauseProjectile];
}

- (void)stopProjectile {
    [super stopProjectile];
}

- (void)render {
    for(ParticleEmitter *emitter in emitters){
        [emitter renderParticles];
        [emitter renderParticles];
    }
    
    
    if(DEBUG) {
        for(NSArray *polyArray in polygons){
            for(Polygon *polygon in polyArray){
                glPushMatrix();
                
                glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
                
                //Loop through the all the lines except for the last
                for(int i = 0; i < (polygon.pointCount - 1); i++) {
                    GLfloat line[] = {
                        polygon.points[i].x, polygon.points[i].y,
                        polygon.points[i+1].x, polygon.points[i+1].y,
                    };
                    
                    glVertexPointer(2, GL_FLOAT, 0, line);
                    glEnableClientState(GL_VERTEX_ARRAY);
                    glDrawArrays(GL_LINES, 0, 2);
                }
                
                
                //Renders last line, we do this because of how arrays work.
                GLfloat lineEnd[] = {
                    polygon.points[([polygon pointCount] - 1)].x, polygon.points[([polygon pointCount] - 1)].y,
                    polygon.points[0].x, polygon.points[0].y,
                };
                
                glVertexPointer(2, GL_FLOAT, 0, lineEnd);
                glEnableClientState(GL_VERTEX_ARRAY);
                glDrawArrays(GL_LINES, 0, 2);
                
                glPopMatrix();
            }
        }
    }
}

@end
