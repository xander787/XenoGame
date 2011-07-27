//
//  ParticleEmitter.m
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
//	- Particle emitter now uses a delta size in the 
//	particle struct to implement a finish size for each particle
//
//  Last Updated - 1/17/11 - James
//  - Changed the rate from 0.1f/emissionRate to us 1.0f
//  because it was making particles way too fast
//
//	Last Updated - 6/15/2011 @ 3:30PM - Alexander
//	- Support for new Scale2f vector scaling system


#import "ParticleEmitter.h"


@implementation ParticleEmitter

@synthesize texture;
@synthesize sourcePosition;
@synthesize sourcePositionVariance;
@synthesize angle;
@synthesize angleVariance;
@synthesize maxParticles;
@synthesize speed;
@synthesize speedVariance;
@synthesize gravity;
@synthesize particleLifespan;
@synthesize particleLifespanVariance;
@synthesize startColor;
@synthesize startColorVariance;
@synthesize finishColor;
@synthesize finishColorVariance;
@synthesize particleSize;
@synthesize finishParticleSize;
@synthesize particleSizeVariance;
@synthesize active;
@synthesize particleCount;
@synthesize emissionRate;
@synthesize emitCounter;
@synthesize duration;
@synthesize blendAdditive;
@synthesize fastEmission;
@synthesize particleIndex;

@synthesize particles;

- (id)initParticleEmitterWithImageNamed:(NSString*)inTextureName
							   position:(Vector2f)inPosition 
				 sourcePositionVariance:(Vector2f)inSourcePositionVariance
								  speed:(GLfloat)inSpeed
						  speedVariance:(GLfloat)inSpeedVariance 
					   particleLifeSpan:(GLfloat)inParticleLifeSpan
			   particleLifespanVariance:(GLfloat)inParticleLifeSpanVariance 
								  angle:(GLfloat)inAngle 
						  angleVariance:(GLfloat)inAngleVariance 
								gravity:(Vector2f)inGravity
							 startColor:(Color4f)inStartColor 
					 startColorVariance:(Color4f)inStartColorVariance
							finishColor:(Color4f)inFinishColor 
					finishColorVariance:(Color4f)inFinishColorVariance
						   maxParticles:(GLuint)inMaxParticles 
						   particleSize:(GLfloat)inParticleSize
					 finishParticleSize:(GLfloat)inFinishParticleSize
				   particleSizeVariance:(GLfloat)inParticleSizeVariance
							   duration:(GLfloat)inDuration
						  blendAdditive:(BOOL)inBlendAdditive
{
	self = [super init];
	if (self != nil) {
		
		sharedGameState = [Director sharedDirector];
		
		// If the texture name is not nil then allocate the texture for the points.  If the texture name is nil
		// and we do not assign a texture, then a quad will be drawn instead
		if(inTextureName) {		
			// Create a new texture which is going to be used as the texture for the point sprites
			texture = [[Image alloc] initWithImage:inTextureName scale:Scale2fOne filter:GL_NEAREST];
		}
		
		// Take the parameters which have been passed into this particle emitter and set the emitters
		// properties
		sourcePosition = inPosition;
		sourcePositionVariance = inSourcePositionVariance;
		speed = inSpeed;
		speedVariance = inSpeedVariance;
		particleLifespan = inParticleLifeSpan;
		particleLifespanVariance = inParticleLifeSpanVariance;
		angle = inAngle;
		angleVariance = inAngleVariance;
		gravity = inGravity;
		startColor = inStartColor;
		startColorVariance = inStartColorVariance;
		finishColor = inFinishColor;
		finishColorVariance = inFinishColorVariance;
		maxParticles = inMaxParticles;
		particleSize = inParticleSize;
		finishParticleSize = inFinishParticleSize;
		particleSizeVariance = inParticleSizeVariance;
		emissionRate = maxParticles/particleLifespan;
		duration = inDuration;
		blendAdditive = inBlendAdditive;
        
        fastEmission = NO;
		
		// Allocate the memory necessary for the particle emitter arrays
		particles = malloc( sizeof(Particle) * maxParticles);
		vertices = malloc( sizeof(PointSprite) * maxParticles);
		colors = malloc( sizeof(Color4f) * maxParticles);
		
		// If one of the arrays cannot be allocated, then report a warning and return nil
		if(!(particles && vertices && colors)) {
			if(DEBUG) NSLog(@"WARNING: ParticleEmitter - Not enough memory");
			if(particles)
				free(particles);
			if(vertices)
				free(vertices);
			if(colors)
				free(colors);
			return nil;
		}
		
		// Reset the memory used for the particles array using zeros
		bzero( particles, sizeof(Particle) * maxParticles);
		bzero( vertices, sizeof(PointSprite) * maxParticles);
		bzero( colors, sizeof(Color4f) * maxParticles);
		
		// Generate the VBO's
		glGenBuffers(1, &verticesID);
		glGenBuffers(1, &colorsID);
		
		// By default the particle emitter is active when created
		active = YES;
		
		// Set the particle count to zero
		particleCount = 0;
		
		// Reset the elapsed time
		elapsedTime = 0;
	}
	return self;
}


- (BOOL)addParticle {
	
	// If we have already reached the maximum number of particles then do nothing
	if(particleCount == maxParticles)
		return NO;
	
	// Take the next particle out of the particle pool we have created and initialize it
	Particle *particle = &particles[particleCount];
	[self initParticle:particle];
	
	// Increment the particle count
	particleCount++;
	
	// Return YES to show that a particle has been created
	return YES;
}


- (void)initParticle:(Particle*)particle {
	
	// Init the position of the particle.  This is based on the source position of the particle emitter
	// plus a configured variance.  The RANDOM_MINUS_1_TO_1 macro allows the number to be both positive
	// and negative
	particle->position.x = sourcePosition.x + sourcePositionVariance.x * RANDOM_MINUS_1_TO_1();
	particle->position.y = sourcePosition.y + sourcePositionVariance.y * RANDOM_MINUS_1_TO_1();
	
	// Init the direction of the particle.  The newAngle is calculated using the angle passed in and the
	// angle variance.
	float newAngle = (GLfloat)DEGREES_TO_RADIANS(angle + angleVariance * RANDOM_MINUS_1_TO_1());
	
	// Create a new Vector2f using the newAngle
	Vector2f vector = Vector2fMake(cosf(newAngle), sinf(newAngle));
	
	// Calculate the vectorSpeed using the speed and speedVariance which has been passed in
	float vectorSpeed = speed + speedVariance * RANDOM_MINUS_1_TO_1();
	
	// The particles direction vector is calculated by taking the vector calculated above and
	// multiplying that by the speed
	particle->direction = Vector2fMultiply(vector, vectorSpeed);
	
	// Calculate the particle size using the particleSize and variance passed in
	// Also do the work to calculate the delta for the finish size
	particle->particleSize = particleSize + particleSizeVariance * RANDOM_MINUS_1_TO_1();
	if (finishParticleSize == particleSize)
		particle->deltaSize = 0;
	else {
		float endS = finishParticleSize;
		endS = MAX(0, endS);
		particle->deltaSize = (endS - particleSize) / particle->timeToLive;
	}

	
	// Calculate the particles life span using the life span and variance passed in
	particle->timeToLive = particleLifespan + particleLifespanVariance * RANDOM_MINUS_1_TO_1();
	
	// Calculate the color the particle should have when it starts its life.  All the elements
	// of the start color passed in along with the variance as used to calculate the star color
	Color4f start = {0, 0, 0, 0};
	start.red = startColor.red + startColorVariance.red * RANDOM_MINUS_1_TO_1();
	start.green = startColor.green + startColorVariance.green * RANDOM_MINUS_1_TO_1();
	start.blue = startColor.blue + startColorVariance.blue * RANDOM_MINUS_1_TO_1();
	start.alpha = startColor.alpha + startColorVariance.alpha * RANDOM_MINUS_1_TO_1();
	
	// Calculate the color the particle should be when its life is over.  This is done the same
	// way as the start color above
	Color4f end = {0, 0, 0, 0};
	end.red = finishColor.red + finishColorVariance.red * RANDOM_MINUS_1_TO_1();
	end.green = finishColor.green + finishColorVariance.green * RANDOM_MINUS_1_TO_1();
	end.blue = finishColor.blue + finishColorVariance.blue * RANDOM_MINUS_1_TO_1();
	end.alpha = finishColor.alpha + finishColorVariance.alpha * RANDOM_MINUS_1_TO_1();
	
	// Calculate the delta which is to be applied to the particles color during each cycle of its
	// life.  The delta calculation uses the life space of the particle to make sure that the 
	// particles color will transition from the start to end color during its life time.
	particle->color = start;
	particle->deltaColor.red = (end.red - start.red) / particle->timeToLive;
	particle->deltaColor.green = (end.green - start.green) / particle->timeToLive;
	particle->deltaColor.blue = (end.blue - start.blue) / particle->timeToLive;
	particle->deltaColor.alpha= (end.alpha - start.alpha) / particle->timeToLive;
}

- (void)update:(GLfloat)delta {
	
	// If the emitter is active and the emission rate is greater than zero then emit
	// particles
	if(active && emissionRate) {
        float rate;
        if(fastEmission == YES){
            rate = 0.1f/emissionRate;
        }
        else {
            rate = 1.0f/emissionRate;
		}
        emitCounter += delta;
		while(particleCount < maxParticles && emitCounter > rate) {
			[self addParticle];
			emitCounter -= rate;
		}
		
		elapsedTime += delta;
		if(duration != -1 && duration < elapsedTime)
			[self stopParticleEmitter];
	}
	
	// Reset the particle index before updating the particles in this emitter
	particleIndex = 0;
	
	// Loop through all the particles updating their location and color
	while(particleIndex < particleCount) {
		
		// Get the particle for the current particle index
		Particle *currentParticle = &particles[particleIndex];
		
		// If the current particle is alive then update it
		if(currentParticle->timeToLive > 0) {
			
			// Calculate the new direction based on gravity
			currentParticle->direction = Vector2fAdd(currentParticle->direction, gravity);
			//currentParticle->direction = Vector2fMultiply(currentParticle->direction, delta);
			currentParticle->position = Vector2fAdd(currentParticle->position, currentParticle->direction);
			
			// Reduce the life span of the particle
			currentParticle->timeToLive -= delta;
			
			// Place the position of the current particle into the vertices array
			vertices[particleIndex].x = currentParticle->position.x;
			vertices[particleIndex].y = currentParticle->position.y;
			
			// Place the size of the current particle in the size array
			vertices[particleIndex].size = currentParticle->particleSize;
			
			//Update the particle size
			currentParticle->particleSize += (currentParticle->deltaSize * delta);
			currentParticle->particleSize = MAX(0, currentParticle->particleSize);
			
			// Update the particles color
			currentParticle->color.red += (currentParticle->deltaColor.red * delta);
			currentParticle->color.green += (currentParticle->deltaColor.green * delta);
			currentParticle->color.blue += (currentParticle->deltaColor.blue * delta);
			currentParticle->color.alpha += (currentParticle->deltaColor.alpha * delta);
			
			// Place the color of the current particle into the color array
			colors[particleIndex] = currentParticle->color;
			
			// Update the particle counter
			particleIndex++;
		} else {
			
			// As the particle is not alive anymore replace it with the last active particle 
			// in the array and reduce the count of particles by one.  This causes all active particles
			// to be packed together at the start of the array so that a particle which has run out of
			// life will only drop into this clause once
			if(particleIndex != particleCount-1)
				particles[particleIndex] = particles[particleCount-1];
			particleCount--;
		}
	}
	
	// Now we have updated all the particles, update the VBOs with the arrays we have just updated
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(PointSprite)*maxParticles, vertices, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(Color4f)*maxParticles, colors, GL_DYNAMIC_DRAW);
	glBindBuffer(GL_ARRAY_BUFFER, 0);

}


- (void)stopParticleEmitter {
	active = NO;
	elapsedTime = 0;
	emitCounter = 0;
}

- (void)renderParticles {
	
	// Enable texturing
	glEnable(GL_TEXTURE_2D);
	
	// Enable texturing and bind the texture to be used as the point sprite
	if(texture && [sharedGameState currentlyBoundTexture] != [[texture texture] name]) {
		glBindTexture(GL_TEXTURE_2D, [[texture texture] name]);
		[sharedGameState setCurrentlyBoundTexture:[[texture texture] name]];
	}
	
	// Enable and configure blending
	glEnable(GL_BLEND);
	
	// Change the blend function used if blendAdditive has been set
	if(blendAdditive) {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE);
	} else {
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	
	// Enable and configure point sprites which we are going to use for our particles
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvi( GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE );
	
	// Enable vertex arrays and bind to the vertices VBO which has been created
	glEnableClientState(GL_VERTEX_ARRAY);
	glBindBuffer(GL_ARRAY_BUFFER, verticesID);
	
	// Configure the vertex pointer which will use the vertices VBO
	glVertexPointer(2, GL_FLOAT, sizeof(PointSprite), 0);
	
	// Enable the point size array
	glEnableClientState(GL_POINT_SIZE_ARRAY_OES);
	
	// Configure the point size pointer which will use the currently bound VBO.  PointSprite contains
	// both the location of the point as well as its size, so the config below tells the point size
	// pointer where in the currently bound VBO it can find the size for each point
	glPointSizePointerOES(GL_FLOAT,sizeof(PointSprite),(GLvoid*) (sizeof(GL_FLOAT)*2));
	
	// Enable the use of the color array
	glEnableClientState(GL_COLOR_ARRAY);
	
	// Bind to the color VBO which has been created
	glBindBuffer(GL_ARRAY_BUFFER, colorsID);
	
	// Configure the color pointer specifying how many values there are for each color and their type
	glColorPointer(4,GL_FLOAT,0,0);
	
	// Now that all of the VBOs have been used to configure the vertices, pointer size and color
	// use glDrawArrays to draw the points
	glDrawArrays(GL_POINTS, 0, particleIndex);
	
	// Unbind the current VBO
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	
	// Disable the client states which have been used incase the next draw function does 
	// not need or use them
	glDisableClientState(GL_POINT_SPRITE_OES);
	glDisableClientState(GL_POINT_SIZE_ARRAY_OES);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisable(GL_TEXTURE_2D);
	glDisable(GL_POINT_SPRITE_OES);
}


- (void)dealloc {
	
	// Release the memory we are using for our vertex and particle arrays etc
	free(vertices);
	free(colors);
	free(particles);
	glDeleteBuffers(1, &verticesID);
	glDeleteBuffers(1, &colorsID);
	if(texture)
		[texture release];
	[super dealloc];
}

@end
