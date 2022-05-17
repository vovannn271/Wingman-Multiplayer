Shader "Amazing Assets/Dynamic Radial Masks/Example/Dissolve" 
{
	Properties 
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0

		[HDR]_EdgeEmission("Edge Emission", Color) = (1,1,1,1)
		_DissolveNoise("Dissolve Noise", 2D) = "white" {}
		[Toggle]_InvertDissolve("Invert Dissolve", Float) = 0
	}
	SubShader 
	{
		Tags 
		{ "RenderType"="TransparentCutout" }
		LOD 200
		CUll Off
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows addshadow

		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/HeightField/DynamicRadialMasks_HeightField_1_Advanced_Normalized_ID1_Global.cginc"

		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		half _Glossiness;
		half _Metallic;

		fixed4 _EdgeEmission;
		sampler2D _DissolveNoise;
		float _InvertDissolve;


		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_DissolveNoise;
			float3 worldPos;
		};

		
		


		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float noise = tex2D(_DissolveNoise, IN.uv_DissolveNoise).r;
			float mask = DynamicRadialMasks_HeightField_1_Advanced_Normalized_ID1_Global(IN.worldPos, noise);
			mask = lerp(mask, 1 - mask, _InvertDissolve); 

			float clipValue = mask > 0.5 ? -1 : 1;
			clip(clipValue);
			 
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;

			o.Emission = _EdgeEmission * mask;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
