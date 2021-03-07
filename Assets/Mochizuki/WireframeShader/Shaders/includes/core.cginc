/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

#include "UnityCG.cginc"
#include "AutoLight.cginc"

// UNITY_DECLARE_TEX2D(_MainTex);
// uniform float4    _MainTex_ST;
uniform float3    _Color;
uniform float     _Alpha;
uniform float     _UseVertexColor;

uniform int       _WireframeMode;
uniform float     _BorderThickness;
uniform float     _UseShaderScale;

uniform float     _Emission;
// UNITY_DECLARE_TEX2D(_EmissionMask);
// uniform float4    _EmissionMask_ST;

struct appdata
{
    float4 vertex   : POSITION;
    float3 normal   : NORMAL;
    fixed4 color    : COLOR;
    float2 texcoord : TEXCOORD0;
    float3 scale    : TEXCOORD1;
};

struct v2g
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    fixed4 color  : COLOR;
    float2 uv     : TEXCOORD0;
    float3 scale  : TEXCOORD1;
};

struct g2f
{
    float4 pos      : SV_POSITION;
    float3 normal   : NORMAL;
    fixed4 color    : COLOR;
    float2 uv       : TEXCOORD0;

#if defined(CALC_ON_FRAGMENT)
    float3 scale    : TEXCOORD1;
    float3 bary     : TEXCOORD2;
#endif
};

#include "vert.cginc"
#include "geom.cginc"
#include "frag.cginc"
