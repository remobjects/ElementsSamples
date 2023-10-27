//
//  Shaders.metal
//  HelloMetal
//
//  Created by Andriy K. on 11/12/16.
//  Copyright © 2016 razeware. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Light
{
    float3 direction;
    float3 ambientColor;
    float3 diffuseColor;
    float3 specularColor;
};

constant Light light = {
    //.direction = { 0.13, 0.72, 0.68 },
    .direction = { 0.2, 0.2, 1.680 },
    //.ambientColor = { 0.05, 0.05, 0.05 },
    .ambientColor = { 0.05, 0.05, 0.05 },
    .diffuseColor = { 0.9, 0.9, 0.9 },
    .specularColor = { 1, 1, 1 }
};

struct Material
{
    float3 ambientColor;
    float3 diffuseColor;
    float3 specularColor;
    float specularPower;
};

constant Material material = {
    .ambientColor = { 0.1, 0.1, 0 },
    .diffuseColor = { 0.9, 0.1, 0 },
    .specularColor = { 1, 1, 1 },
    .specularPower = 100
};



// 1
struct VertexIn{
  packed_float3 position;
  packed_float3 norm;
  packed_float4 color;
  packed_float2 texCoord;
};

struct VertexOut{
  float4 position [[position]];
  float4 color;
  float3  normal;
  float3 eye;
 // float2 texCoord;
};

struct Uniforms{
  float4x4 modelMatrix;
  float4x4 projectionMatrix;
  float3x3 normalMatrix;
};

vertex VertexOut basic_vertex(
			      const device VertexIn* vertex_array [[ buffer(0) ]],
			      const device Uniforms&  uniforms    [[ buffer(1) ]],
			      unsigned int vid [[ vertex_id ]]) {

 // float4x4 mv_Matrix = uniforms.modelMatrix;
 // float4x4 proj_Matrix = uniforms.projectionMatrix;

  float4x4 ProjModell = uniforms.projectionMatrix * uniforms.modelMatrix;

  VertexIn VertexIn = vertex_array[vid];

  VertexOut VertexOut;
  VertexOut.position = ProjModell * float4(VertexIn.position,1);
  VertexOut.color = VertexIn.color;
  VertexOut.eye =  -(uniforms.modelMatrix * float4(VertexIn.position,1)).xyz;
  VertexOut.normal = (uniforms.projectionMatrix * float4(VertexIn.norm,1)).xyz;

  return VertexOut;
}

// 3
fragment float4 basic_fragment(VertexOut vert [[stage_in]]
//constant Uniforms &uniforms [[buffer(0)]]
) {
 float3 ambientTerm = light.ambientColor * material.ambientColor;

    float3 normal = normalize(vert.normal);
    float diffuseIntensity = saturate(dot(normal, normalize(light.direction)));
   // float3 diffuseTerm = light.diffuseColor * material.diffuseColor * diffuseIntensity;
    float3 diffuseTerm =  light.diffuseColor * vert.color.xyz * diffuseIntensity;

    float3 specularTerm(0);
    if (diffuseIntensity > 0)
    {
	float3 eyeDirection = normalize(vert.eye);
	float3 halfway = normalize(light.direction + eyeDirection);
	float specularFactor = pow(saturate(dot(normal, halfway)), material.specularPower);
	specularTerm = light.specularColor * material.specularColor * specularFactor;
    }

    return float4(ambientTerm + diffuseTerm + specularTerm, 1);
}