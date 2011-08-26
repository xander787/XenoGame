//
//  HeatSeekingMissile.m
//  Xenophobe
//
//  Created by James Linnell on 8/25/11.
//  Copyright 2011 PDHS. All rights reserved.
//

#import "HeatSeekingMissile.h"

@implementation HeatSeekingMissile

- (id)initWithProjectileID:(ProjectileID)aProjID location:(Vector2f)aLocation angle:(GLfloat)aAngle speed:(GLfloat)aSpeed rate:(GLfloat)aRate andPlayerShipRef:(PlayerShip *)aPlayerShipRef {
    self = [super initWithProjectileID:aProjID location:aLocation andAngle:aAngle];
    if (self) {
        // Initialization code here.
        playerShipRef = aPlayerShipRef;
        rate = aRate;
        speed = aSpeed;
        
        switch (projectileID) {
            case kEnemyProjectile_HeatSeekingMissile:
            {
                ParticleEmitter *baseEmitter = [[ParticleEmitter alloc] initParticleEmitterWithImageNamed:@"texture-missile.png"
                                                                                                 position:Vector2fMake(location.x, location.y) 
                                                                                   sourcePositionVariance:Vector2fZero 
                                                                                                    speed:speed
                                                                                            speedVariance:0.0
                                                                                         particleLifeSpan:rate
                                                                                 particleLifespanVariance:0.0
                                                                                                    angle:angle
                                                                                            angleVariance:0.0
                                                                                                  gravity:Vector2fZero
                                                                                               startColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                                       startColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                              finishColor:Color4fMake(1.0, 0.0, 0.0, 1.0)
                                                                                      finishColorVariance:Color4fMake(0.0, 0.0, 0.0, 0.0)
                                                                                             maxParticles:1
                                                                                             particleSize:25.0
                                                                                       finishParticleSize:25.0
                                                                                     particleSizeVariance:0.0
                                                                                                 duration:-1.0
                                                                                            blendAdditive:NO];
                
                [emitters addObject:baseEmitter];
                
                
                collisionPointCount = 4;
                collisionPoints = malloc(sizeof(Vector2f) * collisionPointCount);
                bzero(collisionPoints, sizeof(Vector2f) * collisionPointCount);
                collisionPoints[0] = Vector2fMake(4, 6);
                collisionPoints[1] = Vector2fMake(4, -6);
                collisionPoints[2] = Vector2fMake(-4, -6);
                collisionPoints[3] = Vector2fMake(-4, 6);
                NSMutableArray *firstArray = [[NSMutableArray alloc] init];
                for(int i =0; i < [[emitters objectAtIndex:0] maxParticles]; i++){
                    Polygon *tempPoly = [[Polygon alloc] initWithPoints:collisionPoints andCount:collisionPointCount andShipPos:CGPointMake(location.x, location.y)];
                    [firstArray addObject:tempPoly];
                    [tempPoly release];
                }
                
                NSArray *lastArray = [[NSArray alloc] initWithArray:firstArray];
                [firstArray release];
                [polygons addObject:lastArray];
                [lastArray release];
                break;
            }
                
            default:
                break;
        }
    }
    
    return self;
}

- (void)update:(GLfloat)aDelta {
    
    float playerXPosition = [[emitters objectAtIndex:0] particles][0].position.x - playerShipRef.currentLocation.x;

    if(playerXPosition > 0) angle -= abs(playerXPosition * 1.5) * aDelta;
    else if(playerXPosition < 0) angle += abs(playerXPosition * 1.5) * aDelta;
    angle = MIN(angle, 300);
    angle = MAX(angle, 240);
    
    
    [[emitters objectAtIndex:0] setAngle:angle];
    [[emitters objectAtIndex:0] setSourcePosition:location];
    float newAngle = (GLfloat)DEGREES_TO_RADIANS([[emitters objectAtIndex:0] angle]);
    Vector2f vector = Vector2fMake(cosf(newAngle), sinf(newAngle));
    float vectorSpeed = [[emitters objectAtIndex:0] speed];
    [[emitters objectAtIndex:0] particles][0].direction = Vector2fMultiply(vector, vectorSpeed);
	

    
    for(Polygon *poly in [polygons objectAtIndex:0]){
        [poly setPos:CGPointMake(-50, -50)];
    }
    
    [[emitters objectAtIndex:0] update:aDelta];
    for(int k = 0; k < [[emitters objectAtIndex:0] particleIndex]; k++){
        [[[polygons objectAtIndex:0] objectAtIndex:k] setPos:CGPointMake([[emitters objectAtIndex:0] particles][k].position.x, [[emitters objectAtIndex:0] particles][k].position.y)];
    }
    
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
    [[emitters objectAtIndex:0] renderParticles];
    
    
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
