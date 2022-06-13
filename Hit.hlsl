#include "Common.hlsl"

struct STriVertex
{ 
    float3 vertex; 
    float4 color;
};

// #DXR Extra: Per-Instance Data
cbuffer Colors : register(b0)
{ 
    float3 A;
    float3 B;
    float3 C;
}

StructuredBuffer<STriVertex> BTriVertex : register(t0);

StructuredBuffer<int> indices: register(t1);

[shader("closesthit")] 
void ClosestHit(inout HitInfo payload, Attributes attrib) 
{
    float3 barycentrics = float3(1.f - attrib.bary.x - attrib.bary.y, attrib.bary.x, attrib.bary.y); 

	
	// #DXR Extra: Per-Instance Data
	uint vertId = 3 * PrimitiveIndex();
	float3 hitColor = BTriVertex[indices[vertId + 0]].color * barycentrics.x + BTriVertex[indices[vertId + 1]].color * barycentrics.y + BTriVertex[indices[vertId + 2]].color * barycentrics.z;
	
	payload.colorAndDistance = float4(hitColor, RayTCurrent());
}

// #DXR Extra: Per-Instance Data
[shader("closesthit")]
void PlaneClosestHit(inout HitInfo payload, Attributes attrib)
{ 
    float3 barycentrics = float3(1.f - attrib.bary.x - attrib.bary.y, attrib.bary.x, attrib.bary.y); 
    float3 hitColor = float3(0.7, 0.7, 0.3); 
    payload.colorAndDistance = float4(hitColor, RayTCurrent());
}
