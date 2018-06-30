/*
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
	packed_float2 position;

	// Floating-point RGBA colors
	packed_float4 color;
} AAPLVertex;


 typedef enum AAPLTextureIndex
	{
		AAPLTextureIndexBaseColor = 0,
		AAPLTextureIndexBaseColor2 = 1,
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

 typedef struct
  //  Vertex3d = record
  {
   packed_float3  position;// : array[3] of Single;
   packed_float3 normal;// : array[3] of Single;
   packed_float2 tex;// : array[2] of Single;
 } vertex3d;





//#ifndef METALFUNCS
// GLSL mod func for metal
	template <typename T, typename _E = typename enable_if<is_same<float, typename make_scalar<T>::type>::value>::type>
	METAL_FUNC T mod(T x, T y) {
		return x - y * floor(x/y);
	}

	METAL_FUNC float4 unpremultiply(float4 s) {
		return float4(s.rgb/max(s.a,0.00001), s.a);
	}

	METAL_FUNC float4 premultiply(float4 s) {
		return float4(s.rgb * s.a, s.a);
	}


//source over blend
	METAL_FUNC float4 normalBlend(float4 Cb, float4 Cs) {
		float4 dst = premultiply(Cb);
		float4 src = premultiply(Cs);
		return unpremultiply(src + dst * (1.0 - src.a));
	}
   // #endif

#endif /* AAPLShaderTypes_h */