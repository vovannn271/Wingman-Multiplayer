Shader "Amazing Assets/Dynamic Radial Masks/Example/Shockwave 64"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

		[HDR]_MaskColor("Mask Color", color) = (1, 1, 1, 1)
		_NoiseTex ("Noise", 2D) = "black" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0


		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/Shockwave/DynamicRadialMasks_Shockwave_64_Advanced_Additive_ID1_Local.cginc"



        sampler2D _MainTex;
		half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		fixed4 _MaskColor;
		sampler2D _NoiseTex;


        struct Input
        {
            float2 uv_MainTex;
			float2 uv_NoiseTex;
			float3 worldPos;
        };
		
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;


			float noise = tex2D(_NoiseTex, IN.uv_NoiseTex).r;
			float mask = DynamicRadialMasks_Shockwave_64_Advanced_Additive_ID1_Local(IN.worldPos, noise);

			o.Emission = _MaskColor.rgb * mask;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
