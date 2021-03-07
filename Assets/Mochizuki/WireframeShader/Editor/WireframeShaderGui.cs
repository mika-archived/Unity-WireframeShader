/*-------------------------------------------------------------------------------------------
 * Copyright (c) Natsuneko. All rights reserved.
 * Licensed under the MIT License. See LICENSE in the project root for license information.
 *------------------------------------------------------------------------------------------*/

using System;

using UnityEditor;

using UnityEngine;

namespace Mochizuki.WireframeShader
{
    public enum WireframeMode
    {
        Normal,

        NoDiagonal,
    }

    public class WireframeShaderGui : ShaderGUI
    {
        private const int VersionMajor = 1;
        private const int VersionMinor = 1;
        private const int VersionPatch = 0;

        private static readonly int MajorVersion = Shader.PropertyToID("_MajorVersion");
        private static readonly int MinorVersion = Shader.PropertyToID("_MinorVersion");
        private static readonly int PatchVersion = Shader.PropertyToID("_PatchVersion");

        private bool _isInitialized;
        private bool _isTransparent;

        public override void OnGUI(MaterialEditor me, MaterialProperty[] properties)
        {
            var material = (Material) me.target;

            _Alpha = FindProperty(nameof(_Alpha), properties, false);
            _BorderThickness = FindProperty(nameof(_BorderThickness), properties, false);
            _Color = FindProperty(nameof(_Color), properties, false);
            _Culling = FindProperty(nameof(_Culling), properties, false);
            _Emission = FindProperty(nameof(_Emission), properties, false);
            // _EmissionMask = FindProperty(nameof(_EmissionMask), properties, false);
            // _MainTex = FindProperty(nameof(_MainTex), properties, false);
            _UseVertexColor = FindProperty(nameof(_UseVertexColor), properties, false);
            _WireframeMode = FindProperty(nameof(_WireframeMode), properties, false);
            _ZWrite = FindProperty(nameof(_ZWrite), properties, false);

            _isTransparent = material.shader.name.Contains("Transparent");

            OnInitialize(material);

            OnMainGui(me);
            OnOthersGui(me);
        }

        private void OnInitialize(Material material)
        {
            if (_isInitialized)
                return;
            _isInitialized = true;

            foreach (var keyword in material.shaderKeywords)
                material.DisableKeyword(keyword);

            material.SetInt(MajorVersion, VersionMajor);
            material.SetInt(MinorVersion, VersionMinor);
            material.SetInt(PatchVersion, VersionPatch);
        }

        private void OnMainGui(MaterialEditor me)
        {
            using (new Section("Main"))
            {
                GUILayout.Label("Main Color & Texture", EditorStyles.boldLabel);

                // me.TexturePropertySingleLine(new GUIContent("Main Texture"), _MainTex);
                // me.TextureScaleOffsetProperty(_MainTex);
                me.ColorProperty(_Color, "Color");

                if (_isTransparent)
                    me.ShaderProperty(_Alpha, "Alpha");

                me.ShaderProperty(_UseVertexColor, "Use Vertex Color");
            }
        }

        private void OnOthersGui(MaterialEditor me)
        {
            using (new Section("Others"))
            {
                GUILayout.Label("Shader Settings", EditorStyles.boldLabel);

                me.ShaderProperty(_Culling, "Culling");
                me.ShaderProperty(_ZWrite, "ZWrite");
                me.RenderQueueField();
            }
        }

        private static bool IsEqualsTo(MaterialProperty a, int b)
        {
            return b - 0.5 < a.floatValue && a.floatValue <= b + 0.5;
        }

        private static bool IsEqualsTo(MaterialProperty a, bool b)
        {
            return IsEqualsTo(a, b ? 1 : 0);
        }

        private class Section : IDisposable
        {
            private readonly IDisposable _disposable;

            public Section(string title)
            {
                GUILayout.Label(title, EditorStyles.boldLabel);
                _disposable = new EditorGUILayout.VerticalScope(GUI.skin.box);
            }

            public void Dispose()
            {
                _disposable.Dispose();
            }
        }

        #region Material Properties

        private MaterialProperty _Alpha;
        private MaterialProperty _BorderThickness;
        private MaterialProperty _Color;
        private MaterialProperty _Culling;
        private MaterialProperty _Emission;
        // private MaterialProperty _EmissionMask;
        // private MaterialProperty _MainTex;
        private MaterialProperty _UseVertexColor;
        private MaterialProperty _WireframeMode;
        private MaterialProperty _ZWrite;

        #endregion
    }

    public class WsToggleWithoutKeywordDrawer : MaterialPropertyDrawer
    {
        public override void OnGUI(Rect position, MaterialProperty prop, GUIContent label, MaterialEditor editor)
        {
            EditorGUI.BeginChangeCheck();

            var value = EditorGUI.Toggle(position, label, prop.floatValue >= 0.5f);

            if (EditorGUI.EndChangeCheck())
                prop.floatValue = value ? 1.0f : 0.0f;
        }
    }
}