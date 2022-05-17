Shader "Custom/Bullet Holes"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		[NoScaleOffset]_Normal("Normal", 2D) = "bump" {}
		[HDR]_EmissionColor("Radial Emission Color", Color) = (0,0,0,0)
		_RadialMaskNoise("Radial Mask Noise", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="TransparentCutout" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows addshadow

		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/HeightField/DynamicRadialMasks_HeightField_64_Advanced_Additive_ID1_Local.cginc"


        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _Normal;
		half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		fixed4 _EmissionColor;
		sampler2D _RadialMaskNoise;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_RadialMaskNoise;
			float3 worldPos;
        };

        

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float noise = tex2D(_RadialMaskNoise, IN.uv_RadialMaskNoise).r;
			float mask = DynamicRadialMasks_HeightField_64_Advanced_Additive_ID1_Local(IN.worldPos, noise);


			clip((1 - saturate(mask)) - 0.5);


            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

			o.Emission = _EmissionColor.rgb * mask;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
