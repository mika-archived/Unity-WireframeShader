/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

inline float getTruncateDistance(float a, float b, float c)
{
    /*
    if (a > b && a > c) return a;
    if (b > a && b > c) return b;
    if (c > a && a > b) return c;

    return 0;
    */

    return (a > b && a > c) ? a : (b > a && b > c) ? b : (c > a && a > c) ? c : 0;
}

inline bool isEqualsTo(float4 a, float4 b, float truncate)
{
    const float epsilon = 0.0001;
    return abs(distance(a.xyz, b.xyz) - truncate) < epsilon;
}

inline float3 getDiagonalVector(float4 a, float4 b, float4 c, float3 distance)
{
    const float3 nearest = isEqualsTo(a, b, distance) ? b : isEqualsTo(a, c, distance) ? c : float3(0, 0, 0);
    return any(nearest) ? normalize(nearest * 0.5 - a.xyz) : normalize((b.xyz + c.xyz) * 0.5 - a.xyz);
}

inline g2f getStreamData(float3 vertex, float3 normal, fixed4 color, float2 uv)
{
    g2f o;
    o.pos      = UnityObjectToClipPos(vertex);
    o.normal   = normal;
    o.color    = color;
    o.uv       = uv;
    // o.worldPos = mul(unity_ObjectToWorld, vertex);

    return o;
}

[maxvertexcount(21)]
void gs(triangle v2g i[3], uint id : SV_PRIMITIVEID, inout TriangleStream<g2f> stream)
{
    const float  thickness = _BorderThickness * 0.5; // * (_UseShaderScale ? i[0].scale.x : 1);
    const float3 origin    = float3(0, 0, 0);
    
    const float distanceAB = distance(i[0].vertex.xyz, i[1].vertex.xyz);
    const float distanceAC = distance(i[0].vertex.xyz, i[2].vertex.xyz);
    const float distanceBC = distance(i[1].vertex.xyz, i[2].vertex.xyz);
    const float truncate   = getTruncateDistance(distanceAB, distanceAC, distanceBC);

    [unroll]
    for (int j = 0; j < 3; j++)
    {
        const v2g vert1 = i[(j + 0) % 3];
        const v2g vert2 = i[(j + 1) % 3];
        const v2g vert3 = i[(j + 2) % 3];

        if (_WireframeMode == 0)
        {
            const float3 vec1  = normalize((vert1.vertex.xyz + vert3.vertex.xyz) * 0.5 - vert2.vertex.xyz) * thickness;
            const float3 vert4 = vert2.vertex.xyz + vec1;

            const float3 vec2  = normalize((vert1.vertex.xyz + vert2.vertex.xyz) * 0.5 - vert3.vertex.xyz) * thickness;
            const float3 vert5 = vert3.vertex.xyz + vec2;

            stream.Append(getStreamData(vert2.vertex.xyz, vert2.normal, vert2.color, vert2.uv));
            stream.Append(getStreamData(vert3.vertex.xyz, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert4, vert2.normal, vert2.color, vert2.uv));
            stream.RestartStrip();

            stream.Append(getStreamData(vert3.vertex.xyz, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert5, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert4, vert2.normal, vert2.color, vert2.uv));
            stream.RestartStrip();
        }
        else if (_WireframeMode == 1)
        {
            const bool isDiagonal = isEqualsTo(vert2.vertex, vert3.vertex, truncate);

            const float3 vec1  = getDiagonalVector(vert2.vertex, vert1.vertex, vert3.vertex, truncate) * thickness;
            const float3 vert4 = vert2.vertex.xyz + (isDiagonal ? origin : vec1);

            const float3 vec2  = getDiagonalVector(vert3.vertex, vert1.vertex, vert2.vertex, truncate) * thickness;
            const float3 vert5 = vert3.vertex.xyz + (isDiagonal ? origin : vec2);

            stream.Append(getStreamData(vert2.vertex.xyz, vert2.normal, vert2.color, vert2.uv));
            stream.Append(getStreamData(vert3.vertex.xyz, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert4, vert2.normal, vert2.color, vert2.uv));
            stream.RestartStrip();

            stream.Append(getStreamData(vert3.vertex.xyz, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert5, vert3.normal, vert3.color, vert3.uv));
            stream.Append(getStreamData(vert4, vert2.normal, vert2.color, vert2.uv));
            stream.RestartStrip();
        }
    }
}
