/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

Shader "Mochizuki/Wireframe Shader/Transparent"
{
    Properties
    {
        // Main
        _MainTex         ("Main Texture",                     2D) = "white" {}
        _Color           ("Color",                         Color) = (0, 0, 0)
        _Alpha           ("Alpha",               Range(0.0, 1.0)) = 1.0
        [MaterialToggle]
        _UseVertexColor  ("Use Vertex Color",              Float) = 0

        // Wireframe
        [Enum(Mochizuki.WireframeShader.WireframeMode)]
        _WireframeMode   ("Wireframe Mode",                  Int) = 0
        _BorderThickness ("Border Thickness",        Range(0, 2)) = 1.0
        [MaterialToggle]
        _UseShaderScale  ("Use Shader Scale",              Float) = 1.0

        // Emissive
        _Emission        ("Emission Intensity",  Range(0.0, 5.0)) = 1.0
        [NoScaleOffset]
        _EmissionMask    ("Emission Mask",                    2D) = "white" {}

        // Advanced
        [Enum(UnityEngine.Rendering.CullMode)]
        _Culling         ("Culling",                         Int) = 0
        [Enum(Off,0,On,1)]
        _ZWrite          ("ZWrite",                          Int) = 0
    }

    SubShader
    {
        LOD 0

        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
            "IgnoreProjector" = "False"
        }

        Pass
        {
            Cull   [_Culling]
            ZWrite [_ZWrite]
            Blend  SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma require  geometry

            #pragma vertex   vs
            #pragma geometry gs
            #pragma fragment fs

            #pragma target   4.5

            #define TRANSPARENT

            #include "includes/core.cginc"
            ENDCG
        }
    }
}