/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

inline float getTruncateDistance(float a, float b, float c)
{
    if (a > b && a > c) return a;
    if (b > a && b > c) return b;
    if (c > a && a > b) return c;

    return 0;
}

inline float3 getVertex(float3 center, float3 offset)
{
    return center + mul(unity_ObjectToWorld, float4(offset, 0)).xyz;
}

inline g2f getStreamData(float3 vertex, float3 normal, fixed4 color, float2 uv)
{
    g2f o;
    o.pos      = UnityWorldToClipPos(vertex);
    o.normal   = normal;
    o.color    = color;
    o.uv       = uv;
    o.worldPos = mul(unity_ObjectToWorld, vertex);

    return o;
}

[maxvertexcount(24)]
void gs(triangle v2g i[3], uint id : SV_PRIMITIVEID, inout TriangleStream<g2f> stream)
{
    const float  thickness = _BorderThickness * 0.5 * (_UseShaderScale ? i[0].scale.x : 1);
    const float  epsilon   = 0.0001;
    const float3 origin    = float3(0, 0, 0);
    
    float truncate = 0;

    if (_WireframeMode == 1)
    {
        const float distanceAB = distance(i[0].vertex.xyz, i[1].vertex.xyz);
        const float distanceAC = distance(i[0].vertex.xyz, i[2].vertex.xyz);
        const float distanceBC = distance(i[1].vertex.xyz, i[2].vertex.xyz);

        truncate = getTruncateDistance(distanceAB, distanceAC, distanceBC);
    }

    [unroll]
    for (int j = 0; j < 3; j++)
    {
        const v2g vert1 = i[(j + 0) % 3];
        const v2g vert2 = i[(j + 1) % 3];
        const v2g vert3 = i[(j + 2) % 3];

        const bool isTruncate = _WireframeMode == 1 ? abs(distance(vert2.vertex.xyz, vert3.vertex.xyz) - truncate) < epsilon : false;

        stream.Append(getStreamData(vert2.vertex.xyz, vert2.normal, vert2.color, vert2.uv));
        stream.Append(getStreamData(vert3.vertex.xyz, vert3.normal, vert3.color, vert3.uv));
        
        const float3 vec1  = normalize((vert1.vertex.xyz + vert3.vertex.xyz) * 0.5 - vert2.vertex.xyz) * thickness;
        const float3 vert4 = getVertex(vert2.vertex.xyz, isTruncate ? origin : vec1);
        stream.Append(getStreamData(vert4, vert2.normal, vert2.color, vert2.uv));

        const float3 vec2  = normalize((vert1.vertex.xyz + vert2.vertex.xyz) * 0.5 - vert3.vertex.xyz) * thickness;
        const float3 vert5 = getVertex(vert3.vertex.xyz, isTruncate ? origin : vec2);
        stream.Append(getStreamData(vert5, vert3.normal, vert3.color, vert3.uv));

        stream.RestartStrip();
    }

    stream.RestartStrip();
}
