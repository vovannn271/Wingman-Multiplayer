// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amazing Assets/Dynamic Radial Masks/Example/Snow (Standard)"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_BaseAlbedo("Base Albedo", 2D) = "white" {}
		_BaseNormal("Base Normal", 2D) = "bump" {}
		_BaseSpecular("Base Specular", 2D) = "black" {}
		_SnowAlbedo("Snow Albedo", 2D) = "white" {}
		_SnowNormal("Snow Normal", 2D) = "bump" {}
		_SnowSpecular("Snow Specular", 2D) = "black" {}
		[HDR]_SonarEmission("Sonar Emission", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/Torus/DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global.cginc"
		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/HeightField/DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global.cginc"
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _BaseNormal;
		uniform float4 _BaseNormal_ST;
		uniform sampler2D _SnowNormal;
		uniform float4 _SnowNormal_ST;
		uniform float4 _BaseColor;
		uniform sampler2D _BaseAlbedo;
		uniform float4 _BaseAlbedo_ST;
		uniform sampler2D _SnowAlbedo;
		uniform float4 _SnowAlbedo_ST;
		uniform float4 _SonarEmission;
		uniform sampler2D _BaseSpecular;
		uniform float4 _BaseSpecular_ST;
		uniform sampler2D _SnowSpecular;
		uniform float4 _SnowSpecular_ST;


		inline float Read_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global( float3 WorldPosition , float Noise )
		{
			return DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global(WorldPosition, Noise);;
		}


		inline float Read_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global( float3 WorldPosition , float Noise )
		{
			return DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global(WorldPosition, Noise);;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_BaseNormal = i.uv_texcoord * _BaseNormal_ST.xy + _BaseNormal_ST.zw;
			float2 uv_SnowNormal = i.uv_texcoord * _SnowNormal_ST.xy + _SnowNormal_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 WorldPosition3_g6 = ase_worldPos;
			float Noise3_g6 = 0.0;
			float localRead_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global3_g6 = Read_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global( WorldPosition3_g6 , Noise3_g6 );
			float temp_output_25_0 = ( localRead_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global3_g6 * 2.0 );
			float3 lerpResult15 = lerp( UnpackNormal( tex2D( _BaseNormal, uv_BaseNormal ) ) , UnpackNormal( tex2D( _SnowNormal, uv_SnowNormal ) ) , saturate( ( ase_worldNormal.y * temp_output_25_0 ) ));
			o.Normal = lerpResult15;
			float2 uv_BaseAlbedo = i.uv_texcoord * _BaseAlbedo_ST.xy + _BaseAlbedo_ST.zw;
			float2 uv_SnowAlbedo = i.uv_texcoord * _SnowAlbedo_ST.xy + _SnowAlbedo_ST.zw;
			float temp_output_18_0 = saturate( ( (WorldNormalVector( i , lerpResult15 )).y * temp_output_25_0 ) );
			float4 lerpResult10 = lerp( ( _BaseColor * tex2D( _BaseAlbedo, uv_BaseAlbedo ) ) , tex2D( _SnowAlbedo, uv_SnowAlbedo ) , temp_output_18_0);
			o.Albedo = lerpResult10.rgb;
			float3 WorldPosition3_g5 = ase_worldPos;
			float Noise3_g5 = 0.0;
			float localRead_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global3_g5 = Read_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global( WorldPosition3_g5 , Noise3_g5 );
			o.Emission = ( _SonarEmission * localRead_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global3_g5 ).rgb;
			float2 uv_BaseSpecular = i.uv_texcoord * _BaseSpecular_ST.xy + _BaseSpecular_ST.zw;
			float2 uv_SnowSpecular = i.uv_texcoord * _SnowSpecular_ST.xy + _SnowSpecular_ST.zw;
			float4 lerpResult17 = lerp( tex2D( _BaseSpecular, uv_BaseSpecular ) , tex2D( _SnowSpecular, uv_SnowSpecular ) , temp_output_18_0);
			o.Specular = lerpResult17.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18301
1572;202;1837;1090;3297.681;637.1894;1;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;23;-3065.177,-106.3112;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;42;-2746.681,-104.1894;Inherit;False;DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global;-1;;6;70b91d0998346ef4f8c26f9809806dea;0;2;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1969.157,-104.3854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;20;-1817.105,513.8049;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1575.704,560.7048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-1415.005,569.1049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1548.101,72.7999;Inherit;True;Property;_BaseNormal;Base Normal;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;14;-1548.101,267.1998;Inherit;True;Property;_SnowNormal;Snow Normal;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;15;-1067.3,73.59992;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;19;-865.5047,-194.2967;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-651.7996,-116.3;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-684.2598,-945.8498;Float;False;Property;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;29;224.1288,909.2874;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1;-736.093,-751.8188;Inherit;True;Property;_BaseAlbedo;Base Albedo;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-704.8019,470.7009;Inherit;True;Property;_SnowSpecular;Snow Specular;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;18;-496.7049,-110.1974;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;41;481.635,898.9739;Inherit;False;DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global;-1;;5;b43d281215ae1fa46b30d0cfb43c1cbd;0;2;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.ColorNode;30;726.1556,661.0479;Float;False;Property;_SonarEmission;Sonar Emission;7;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-693.0005,253.9001;Inherit;True;Property;_BaseSpecular;Base Specular;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-360.9514,-810.9047;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;9;-720.8,-470.0002;Inherit;True;Property;_SnowAlbedo;Snow Albedo;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;10;-127.1,-308.6001;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;1065.579,814.5102;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;17;-223.4019,317.8009;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1839.944,60.11739;Float;False;True;-1;2;;0;0;StandardSpecular;Amazing Assets/Dynamic Radial Masks/Example/Snow (Standard);False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;0;4;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;4;23;0
WireConnection;25;0;42;6
WireConnection;21;0;20;2
WireConnection;21;1;25;0
WireConnection;22;0;21;0
WireConnection;15;0;4;0
WireConnection;15;1;14;0
WireConnection;15;2;22;0
WireConnection;19;0;15;0
WireConnection;11;0;19;2
WireConnection;11;1;25;0
WireConnection;18;0;11;0
WireConnection;41;4;29;0
WireConnection;27;0;26;0
WireConnection;27;1;1;0
WireConnection;10;0;27;0
WireConnection;10;1;9;0
WireConnection;10;2;18;0
WireConnection;31;0;30;0
WireConnection;31;1;41;6
WireConnection;17;0;2;0
WireConnection;17;1;16;0
WireConnection;17;2;18;0
WireConnection;0;0;10;0
WireConnection;0;1;15;0
WireConnection;0;2;31;0
WireConnection;0;3;17;0
ASEEND*/
//CHKSM=5B4207F6C79A801C7CC800522D1F90B509517326