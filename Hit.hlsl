#include "Common.hlsl"

struct STriVertex
{ 
    float3 vertex; 
    float4 color;
};

// #DXR Extra: Per-Instance Data
cbuffer Colors : register(b0)
{ 
    float3 A[3]; 
    float3 B[3]; 
    float3 C[3];
}

StructuredBuffer<STriVertex> BTriVertex : register(t0);

[shader("closesthit")] 
void ClosestHit(inout HitInfo payload, Attributes attrib) 
{
    float3 barycentrics = float3(1.f - attrib.bary.x - attrib.bary.y, attrib.bary.x, attrib.bary.y); 
	const float3 A = float3(1, 0, 0); 
	const float3 B = float3(0, 1, 0); 
	const float3 C = float3(0, 0, 1); 
	uint vertId = 3 * PrimitiveIndex();
	
	// #DXR Extra: Per-Instance Data (Floor)
	float3 hitColor = float3(0.6, 0.7, 0.6);
	// Shade only the first 3 instances (triangles)
	if (InstanceID() < 3)
	{ 
		hitColor = A[InstanceID()] * barycentrics.x + B[InstanceID()] * barycentrics.y + C[InstanceID()] * barycentrics.z;
	}
	
	switch (InstanceID())
	{
	case 0:
		hitColor = BTriVertex[vertId + 0].color * barycentrics.x + BTriVertex[vertId + 1].color * barycentrics.y + BTriVertex[vertId + 2].color * barycentrics.z;
		break;
	case 1:
		hitColor = BTriVertex[vertId + 1].color * barycentrics.x + BTriVertex[vertId + 1].color * barycentrics.y + BTriVertex[vertId + 2].color * barycentrics.z;
		break;
	case 2:
		hitColor = BTriVertex[vertId + 2].color * barycentrics.x + BTriVertex[vertId + 1].color * barycentrics.y + BTriVertex[vertId + 2].color * barycentrics.z;
		break;
	}
	payload.colorAndDistance = float4(hitColor, RayTCurrent());
}
