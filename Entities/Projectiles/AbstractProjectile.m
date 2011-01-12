//
//  AbstractProjectile.m
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
//	Last Updated - 

#import "AbstractProjectile.h"


@implementation AbstractProjectile


- (id)initWithBulletID:(BulletID)aBulletID fromTurretPosition:(CGPoint)aPosition andAngle:(int)aAngle {
    if(self = [super init]){
        
        mainBulletID = aBulletID;
        turretPosition = aPosition;
        bulletAngle = aAngle;
        currentLocation = turretPosition;
        
        //Paths for main dictionary
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [[NSString alloc] initWithString:[bundle pathForResource:@"Bullets" ofType:@"plist"]];
        NSMutableDictionary *bulletsDictionaryPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSMutableDictionary *bulletDictionary;
        [bundle release];
        [path release];
        
        
        //Load from Plist appropriate bullet type information
        switch(mainBulletID){
            case kBulletID_Normal:
                bulletDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bulletsDictionaryPlist objectForKey:@"kBulletID_Normal"]];
                break;
            case kBulletID_Missile:
                bulletDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bulletsDictionaryPlist objectForKey:@"kBulletID_Missile"]];
                break;
            case kBulletID_Wave:
                bulletDictionary = [[NSMutableDictionary alloc] initWithDictionary:[bulletsDictionaryPlist objectForKey:@"kBulletID_Wave"]];
            default:
                break;
        }
        [bulletsDictionaryPlist release];
        
        
        bulletSpeed = [[bulletDictionary objectForKey:@"kBulletSpeed"] intValue];
        
        
        //Loop through the collision points, put them in a C array
        NSArray *tempCollisionPoints = [[NSArray alloc] initWithArray:[bulletDictionary objectForKey:@"kCollisionBoundingPoints"]];
        collisionPoints = malloc(sizeof(Vector2f) * [tempCollisionPoints count]);
        bzero(collisionPoints, sizeof(Vector2f) * [tempCollisionPoints count]);
        for(int i = 0; i < [tempCollisionPoints count]; i++){
            NSArray *coords = [[NSArray alloc] initWithArray:[[tempCollisionPoints objectAtIndex:i] componentsSeparatedByString:@","]];
            @try {
                collisionPoints[i] = Vector2fMake([[coords objectAtIndex:0] intValue], [[coords objectAtIndex:1] intValue]);
            }
            @catch (NSException * e) {
                NSLog(@"Exception thrown: %@", e);
            }
            @finally {
                NSLog(@"Bullet Coll Coord: %f, %f", collisionPoints[i].x, collisionPoints[i].y);
            }
            [coords release];
        }
        
        
        //Decides how to setup the particle emitter
        switch(mainBulletID){
            case kBulletID_Normal:
                emitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:[bulletDictionary objectForKey:@"kBulletImage"] 
                                                                            position:Vector2fMake(currentLocation.x, currentLocation.y) 
                                                              sourcePositionVariance:Vector2fZero 
                                                                               speed:0.5
                                                                       speedVariance:0.0 
                                                                    particleLifeSpan:0.01
                                                            particleLifespanVariance:0.1
                                                                               angle:bulletAngle 
                                                                       angleVariance:0.0 
                                                                             gravity:Vector2fZero 
                                                                          startColor:Color4fMake(0.0, 1.0, 1.0, 1.0) 
                                                                  startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0) 
                                                                         finishColor:Color4fMake(1.0, 1.0, 1.0, 1.0) 
                                                                 finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0) 
                                                                        maxParticles:100
                                                                        particleSize:10.0
                                                                  finishParticleSize:10.0
                                                                particleSizeVariance:0.0
                                                                            duration:-1.0
                                                                       blendAdditive:NO];
                break;
                
            case kBulletID_Missile:
                break;
                
            case kBulletID_Wave:
                break;
                
            default:
                break;
        }
        
        
        //Allocate polygon with previously made collision points
        polygon = [[Polygon alloc] initWithPoints:collisionPoints andCount:[tempCollisionPoints count] andShipPos:CGPointMake(turretPosition.x, turretPosition.y)];
        
        
        [tempCollisionPoints release];
        [bulletDictionary release];
    }
    
    return self;
}

- (void)update:(CGFloat)aDelta {
    
    //Moves the position to follow the angle of trajectory, mostly taken fomr the ParticleEmitter code
    float newAngle = (GLfloat)DEGREES_TO_RADIANS(bulletAngle);
    CGPoint vector = CGPointMake(cosf(newAngle), sinf(newAngle));
    currentLocation.x += (bulletSpeed * 10) * aDelta * vector.x;
    currentLocation.y += (bulletSpeed * 10) * aDelta * vector.y;
    [emitter setSourcePosition:Vector2fMake(currentLocation.x, currentLocation.y)];
    
    
    //Refresh the position of our polygon to move with the particle
    [polygon setPos:currentLocation];
    
    [emitter update:aDelta];
}

- (void)render {
    [emitter renderParticles];
    
    //From PlayerShip class
    if(DEBUG) {                
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

- (void)dealloc {
    [polygon release];
    free(collisionPoints);
    [super dealloc];
}

@end
