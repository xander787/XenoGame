//
//  Transforms.m
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
//	- Initial Project Creation

#import <math.h>

#define	MAX_STACK_DEPTH			32

static float	m[MAX_STACK_DEPTH][9];

int		stackDepth = 0;

void LoadIdentity(void)
{
	int		d = stackDepth;
	
	m[d][0] = 1.0f; m[d][1] = 0.0f; m[d][2] = 0.0f;
	m[d][3] = 0.0f; m[d][4] = 1.0f; m[d][5] = 0.0f;
	m[d][6] = 0.0f; m[d][7] = 0.0f; m[d][8] = 1.0f;
}

void PushMatrix(void)
{
	int		c, d;
	
	if (stackDepth >= MAX_STACK_DEPTH)
		return;
	c = stackDepth;
	stackDepth++;
	d = stackDepth;
	m[d][0] = m[c][0];
	m[d][1] = m[c][1];
	m[d][2] = m[c][2];
	m[d][3] = m[c][3];
	m[d][4] = m[c][4];
	m[d][5] = m[c][5];
	m[d][6] = m[c][6];
	m[d][7] = m[c][7];
	m[d][8] = m[c][8];
}

void PopMatrix(void)
{
	if (stackDepth <= 0)
		return;
	stackDepth--;
}

void Translate(float dx, float dy)
{
	int		d = stackDepth;
	
	m[d][6] = dx * m[d][0] + dy * m[d][3] + m[d][6];
	m[d][7] = dx * m[d][1] + dy * m[d][4] + m[d][7];
	m[d][8] = dx * m[d][2] + dy * m[d][5] + m[d][8];
}

void Rotate(float radians)
{
	int		d = stackDepth;
	float	cosTheta = cos(radians);
	float	sinTheta = sin(radians);
	float	m0 = m[d][0], m1 = m[d][1], m2 = m[d][2],
    m3 = m[d][3], m4 = m[d][4], m5 = m[d][5]; 
	
	m[d][0] = cosTheta * m0 + sinTheta * m3;
	m[d][1] = cosTheta * m1 + sinTheta * m4;
	m[d][2] = cosTheta * m2 + sinTheta * m5;
	m[d][3] = -sinTheta * m0 + cosTheta * m3;
	m[d][4] = -sinTheta * m1 + cosTheta * m4;
	m[d][5] = -sinTheta * m2 + cosTheta * m5;
}

void Scale(float sx, float sy)
{
	int		d = stackDepth;
	
	m[d][0] *= sx;
	m[d][1] *= sx;
	m[d][2] *= sx;
	m[d][3] *= sy;
	m[d][4] *= sy;
	m[d][5] *= sy;
}

void TransformVerts(float *verts, float *transformedVerts, int count)
{
	int		d = stackDepth, i, ix, iy;
	float	x, y;
	float	m0 = m[d][0], m1 = m[d][1], m3 = m[d][3],
    m4 = m[d][4], m6 = m[d][6], m7 = m[d][7];
	
	for (i = 0; i < count; i++)
	{
		ix = i * 2;
		iy = ix + 1;
		x = verts[ix];
		y = verts[iy];
		transformedVerts[ix] = x * m0 + y * m3 + m6;
		transformedVerts[iy] = x * m1 + y * m4 + m7;
	}
}

void TransformVertsInPlace(float *verts, int count)
{
	int		d = stackDepth, i, ix, iy;
	float	x, y;
	float	m0 = m[d][0], m1 = m[d][1], m3 = m[d][3],
    m4 = m[d][4], m6 = m[d][6], m7 = m[d][7];
	
	for (i = 0; i < count; i++)
	{
		ix = i * 2;
		iy = ix + 1;
		x = verts[ix];
		y = verts[iy];
		verts[ix] = x * m0 + y * m3 + m6;
		verts[iy] = x * m1 + y * m4 + m7;
	}
}

//float	vertsSource[] = { -0.5f, -0.5f, 0.5f, -0.5f, -0.5f, 0.5f, 0.5f, 0.5f };
//float	vertsDestination[8];
//
//LoadIdentity();
//PushMatrix();
//Translate(200.0f, 240.0f);
//Rotate(34.0f);
//Scale(200.0f, 200.0f);
//TransformVerts(vertsSource, vertsDestination, 4);
//glVertexPointer(2, GL_FLOAT, 0, vertsDestination);
//glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
//PopMatrix();

