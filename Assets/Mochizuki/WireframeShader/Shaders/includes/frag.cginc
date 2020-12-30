/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

inline fixed4 getColor(const g2f i)
{
#if defined(TRANSPARENT)
    return _UseVertexColor ? i.color : tex2D(_MainTex, i.uv) * fixed4(_Color, _Alpha);
#else
    return _UseVertexColor ? i.color : tex2D(_MainTex, i.uv) * fixed4(_Color, 1);
#endif
}

fixed4 fs(const g2f i) : SV_TARGET
{
    fixed4 color = getColor(i);

    const fixed4 emission  = tex2D(_EmissionMask, i.uv);
    const fixed  intensity = any(emission) ? _Emission : 1;

    color.rgb *= pow(2, intensity);

#if defined(CALC_ON_FRAGMENT)
    const float3 deltas = fwidth(i.bary) * i.scale.x * _BorderThickness;
    const float3 baries = smoothstep(deltas, 2 * deltas, i.bary);
    const float  bary   = min(baries.x, min(baries.y, baries.z));

    clip(bary > 0.5 ? -1 : 0);
#endif

    return color;
}