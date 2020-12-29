/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

// #include "core.cginc"

fixed4 fs(const g2f i) : SV_TARGET
{
    fixed4 color = _UseVertexColor ? fixed4(i.color, 1) : tex2D(_MainTex, i.uv) * fixed4(_Color, 1);

    const fixed4 emission  = tex2D(_EmissionMask, i.uv);
    const fixed  intensity = any(emission) ? _Emission : 1;

    color.rgb *= pow(2, intensity);

    return color;
}