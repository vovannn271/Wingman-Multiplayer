Shader "Amazing Assets/Dynamic Radial Masks/Example/Standard Tube 128 Advanced Addative ID1 Local (Tessellation and Vertex Displace)"
{
    Properties
    {
        _Tessellation ("Tessellation", Range(1,32)) = 4
        _TessMin("Min", Float) = 10
        _TessMax("Max", Float) = 50
        _Displace("Displace", Float) = 1

        _Color ("Base Color", Color) = (1,1,1,1)  
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        
        _NormalCoef("Normal Coef", float) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "DisableBatching"="True" }
        LOD 200
        Cull Off

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow tessellate:TessellationDistance

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 5.0
        #include "Tessellation.cginc"

        
		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/Torus/DynamicRadialMasks_Torus_128_Advanced_Additive_ID1_Local.cginc"



        float _Tessellation;
        float _TessMin;
        float _TessMax;
        float _Displace;

		sampler2D _MainTex;
        fixed4 _Color;
        half _Glossiness;
        half _Metallic; 
        
        float _NormalCoef;


        struct appdata 
        {
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			float2 texcoord2 : TEXCOORD2;
        };

        struct Input
        {
			float2 uv_MainTex;
            float3 worldPos;
            float3 worldNormal;
        };
        
        float4 TessellationDistance (appdata v0, appdata v1, appdata v2)
        {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _Tessellation);
        }
        
        void vert (inout appdata v)
        {
            float4 v1 = v.vertex + float4(_NormalCoef, 0, 0, 0);
            float3 worldPos = mul(unity_ObjectToWorld, v1).xyz;
            float mask = DynamicRadialMasks_Torus_128_Advanced_Additive_ID1_Local(worldPos, 0);
            v1.xyz += v.normal * mask * _Displace;


            float4 v2 = v.vertex + float4(0, 0, _NormalCoef, 0);
            worldPos = mul(unity_ObjectToWorld, v2).xyz;
            mask = DynamicRadialMasks_Torus_128_Advanced_Additive_ID1_Local(worldPos, 0);
            v2.xyz += v.normal * mask * _Displace;


            worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            mask = DynamicRadialMasks_Torus_128_Advanced_Additive_ID1_Local(worldPos, 0);
            v.vertex.xyz += v.normal * mask * _Displace;


            v.normal = cross(normalize(v2 - v.vertex.xyz), normalize(v1 - v.vertex.xyz));           
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color; 
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a; 

        }
        ENDCG
    }
    FallBack "Diffuse"
}
