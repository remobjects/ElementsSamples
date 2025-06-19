﻿/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header containing types and enum constants shared between Metal shaders and C/ObjC source
*/

#ifndef AAPLShaderTypes_h
#define AAPLShaderTypes_h

#include <simd/simd.h>

// Buffer index values shared between shader and C code to ensure Metal shader buffer inputs match
//   Metal API buffer set calls
typedef enum AAPLVertexInputIndex
{
	AAPLVertexInputIndexVertices     = 0,
	AAPLVertexInputIndexViewportSize = 1,
} AAPLVertexInputIndex;

//  This structure defines the layout of each vertex in the array of vertices set as an input to our
//    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
//    we can be sure that the layout of the vertex array in our C code matches the layout that
//    our .metal vertex shader expects
typedef struct
{
	// Positions in pixel space
	// (e.g. a value of 100 indicates 100 pixels from the center)
	vector_float2 position;

	// Floating-point RGBA colors
	vector_float4 color;
} AAPLVertex;


 typedef enum AAPLTextureIndex
    {
        AAPLTextureIndexBaseColor = 0,
        } AAPLTextureIndex;
        
        //  This structure defines the layout of each vertex in the array of vertices set as an input to our
        //    Metal vertex shader.  Since this header is shared between our .metal shader and C code,
        //    we can be sure that the layout of the vertex array in the code matches the layout that
        //    our vertex shader expects
        typedef struct
        {
            // Positions in pixel space (i.e. a value of 100 indicates 100 pixels from the origin/center)
            vector_float2 position;
            
            // 2D texture coordinate
            vector_float2 textureCoordinate;
        } AAPLVertexTex;

#endif /* AAPLShaderTypes_h */