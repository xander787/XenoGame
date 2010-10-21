//
//  Shader.fsh
//  Xenophobe
//
//  Created by Alexander on 10/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
