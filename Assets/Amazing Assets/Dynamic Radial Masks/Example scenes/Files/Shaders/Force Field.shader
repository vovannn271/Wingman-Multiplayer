// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amazing Assets/Dynamic Radial Masks/Example/Force Field"
{
	Properties
	{
		[HDR]_BaseColor("Base Color", Color) = (0,0,0,0)
		_BaseMap("Base Map", 2D) = "white" {}
		_ScrollSpeed("Scroll Speed", Vector) = (1,1,0,0)
		_FresnelScale("Fresnel Scale", Float) = 0
		_FresnelBias("Fresnel Bias", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_IntersectionSize("Intersection Size", Float) = 2
		[HDR]_IntersectionColor("Intersection Color", Color) = (1,1,1,1)
		_VertexDisplaceStrength("Vertex Displace Strength", Float) = 0
		_RadialMaskNoise("Radial Mask Noise", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 0

		CGINCLUDE
		#pragma target 5.0
		ENDCG
		Blend One One
		AlphaToMask Off
		Cull Off
		ColorMask RGB
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/Torus/DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _RadialMaskNoise;
			uniform float4 _RadialMaskNoise_ST;
			uniform float _VertexDisplaceStrength;
			uniform float4 _BaseColor;
			uniform sampler2D _BaseMap;
			uniform float4 _BaseMap_ST;
			uniform float2 _ScrollSpeed;
			uniform float _FresnelBias;
			uniform float _FresnelScale;
			uniform float4 _EmissionColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _IntersectionSize;
			uniform float4 _IntersectionColor;
			inline float Read_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local( float3 WorldPosition , float Noise )
			{
				return DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local(WorldPosition, Noise);;
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 WorldPosition3_g2 = mul( unity_ObjectToWorld, v.ase_texcoord2 ).xyz;
				float2 uv_RadialMaskNoise = v.ase_texcoord.xy * _RadialMaskNoise_ST.xy + _RadialMaskNoise_ST.zw;
				float Noise3_g2 = tex2Dlod( _RadialMaskNoise, float4( uv_RadialMaskNoise, 0, 0.0) ).r;
				float localRead_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local3_g2 = Read_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local( WorldPosition3_g2 , Noise3_g2 );
				float temp_output_246_0 = pow( localRead_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local3_g2 , 2.0 );
				
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord3 = v.ase_texcoord2;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( v.ase_texcoord3.xyz * ( temp_output_246_0 * _VertexDisplaceStrength ) );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i , half ase_vface : VFACE) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float2 uv0_BaseMap = i.ase_texcoord1.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV238 = dot( ( ase_worldNormal * ase_vface ), ase_worldViewDir );
				float fresnelNode238 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV238, 5.0 ) );
				float3 WorldPosition3_g2 = mul( unity_ObjectToWorld, i.ase_texcoord3 ).xyz;
				float2 uv_RadialMaskNoise = i.ase_texcoord1.xy * _RadialMaskNoise_ST.xy + _RadialMaskNoise_ST.zw;
				float Noise3_g2 = tex2D( _RadialMaskNoise, uv_RadialMaskNoise ).r;
				float localRead_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local3_g2 = Read_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local( WorldPosition3_g2 , Noise3_g2 );
				float temp_output_246_0 = pow( localRead_DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local3_g2 , 2.0 );
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth228 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth228 = abs( ( screenDepth228 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _IntersectionSize ) );
				
				
				finalColor = ( ( ( _BaseColor * tex2D( _BaseMap, ( uv0_BaseMap + ( _Time.y * _ScrollSpeed ) ) ) ) * fresnelNode238 ) + ( _EmissionColor * temp_output_246_0 ) + ( ( 1.0 - saturate( distanceDepth228 ) ) * _IntersectionColor ) );
				return finalColor;
			}
			ENDCG
		}
	}
	
	
	
}
/*ASEBEGIN
Version=18301
1681;205;3014;1172;3552.84;1558.225;4.66161;True;False
Node;AmplifyShaderEditor.CommentaryNode;207;-144.5246,-2060.521;Inherit;False;1554.749;970.269;Base Map;9;220;256;247;258;250;257;259;214;221;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;257;250.2697,-1379.222;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;214;-33.40947,-1755.492;Float;True;Property;_BaseMap;Base Map;1;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;208;-3377.405,326.7899;Inherit;False;1235.405;692.198;Dynamic Radial Mask;5;245;225;212;211;210;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;259;286.9593,-1236.29;Inherit;False;Property;_ScrollSpeed;Scroll Speed;2;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;250;242.6566,-1496.968;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;258;478.2699,-1323.222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;227;515.254,860.4757;Float;False;Property;_IntersectionSize;Intersection Size;6;0;Create;True;0;0;False;0;False;2;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldMatrixNode;211;-3300.708,442.308;Inherit;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;210;-3293.22,558.0547;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;256;670.2903,-1493.625;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;228;780.3855,840.8635;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;235;903.0391,-764.0956;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-3056.706,493.3081;Inherit;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FaceVariableNode;233;970.0392,-582.0956;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;212;-3299.88,802.3376;Inherit;True;Property;_RadialMaskNoise;Radial Mask Noise;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;247;857.0307,-1755.879;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;245;-2787.988,494.2234;Inherit;False;DynamicRadialMasks_Torus_64_Advanced_Normalized_ID1_Local;-1;;2;9771835e935c0374782a807fba8f7f2c;0;2;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.RangedFloatNode;236;981.5382,-470.0216;Float;False;Property;_FresnelBias;Fresnel Bias;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;1115.037,-673.0956;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;209;386.2788,1661.577;Inherit;False;1134.741;351.4886;Vertex Offset;4;219;218;217;216;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;220;933.4027,-1975.555;Float;False;Property;_BaseColor;Base Color;0;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0.7171054,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;237;1075.124,-360.1885;Float;False;Property;_FresnelScale;Fresnel Scale;3;0;Create;True;0;0;False;0;False;0;39.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;229;1052.05,841.1276;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;246;-1442.929,491.4318;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;231;1167.097,946.5176;Float;False;Property;_IntersectionColor;Intersection Color;7;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;0,0.09869801,0.208,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;238;1322.807,-508.3826;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.25;False;2;FLOAT;20;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;447.4785,1898.93;Float;False;Property;_VertexDisplaceStrength;Vertex Displace Strength;8;0;Create;True;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;230;1215.603,842.5286;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;1255.054,-1771.032;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;223;1133.658,315.4594;Float;False;Property;_EmissionColor;Emission Color;5;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,2.117647,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;217;954.8044,1722.159;Inherit;False;3;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;1417.341,474.1497;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;730.3353,1881.01;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;1926.692,-517.2196;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;1418.448,871.2999;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;1354.039,1860.643;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;222;2156.047,444.4773;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;82;2831.887,433.9581;Float;False;True;-1;2;;0;1;Amazing Assets/Dynamic Radial Masks/Example/Force Field;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;True;True;True;True;False;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;7;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;250;2;214;0
WireConnection;258;0;257;2
WireConnection;258;1;259;0
WireConnection;256;0;250;0
WireConnection;256;1;258;0
WireConnection;228;0;227;0
WireConnection;225;0;211;0
WireConnection;225;1;210;0
WireConnection;247;0;214;0
WireConnection;247;1;256;0
WireConnection;245;4;225;0
WireConnection;245;5;212;1
WireConnection;234;0;235;0
WireConnection;234;1;233;0
WireConnection;229;0;228;0
WireConnection;246;0;245;6
WireConnection;238;0;234;0
WireConnection;238;1;236;0
WireConnection;238;2;237;0
WireConnection;230;0;229;0
WireConnection;221;0;220;0
WireConnection;221;1;247;0
WireConnection;224;0;223;0
WireConnection;224;1;246;0
WireConnection;218;0;246;0
WireConnection;218;1;216;0
WireConnection;226;0;221;0
WireConnection;226;1;238;0
WireConnection;232;0;230;0
WireConnection;232;1;231;0
WireConnection;219;0;217;0
WireConnection;219;1;218;0
WireConnection;222;0;226;0
WireConnection;222;1;224;0
WireConnection;222;2;232;0
WireConnection;82;0;222;0
WireConnection;82;1;219;0
ASEEND*/
//CHKSM=2C107B7B2F384BAF1C22DE272D222D53A25224AD