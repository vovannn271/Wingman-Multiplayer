// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Amazing Assets/Dynamic Radial Masks/Example/Tree Leaves"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Diffuse("Diffuse", 2D) = "white" {}
		_Bump("Bump", 2D) = "bump" {}
		[HDR]_SonarEmission("Sonar Emission", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/HeightField/DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global.cginc"
		#include "Assets/Amazing Assets/Dynamic Radial Masks/Shaders/CGINC/Torus/DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global.cginc"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Bump;
		uniform float4 _Bump_ST;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float4 _SonarEmission;
		uniform float _Cutoff = 0.5;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline float Read_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global( float3 WorldPosition , float Noise )
		{
			return DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global(WorldPosition, Noise);;
		}


		inline float Read_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global( float3 WorldPosition , float Noise )
		{
			return DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global(WorldPosition, Noise);;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Bump = i.uv_texcoord * _Bump_ST.xy + _Bump_ST.zw;
			o.Normal = tex2D( _Bump, uv_Bump ).rgb;
			float4 transform14 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float4 tex2DNode1 = tex2D( _Diffuse, uv_Diffuse );
			float4 color8 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float3 ase_worldPos = i.worldPos;
			float3 WorldPosition3_g2 = ase_worldPos;
			float Noise3_g2 = 0.0;
			float localRead_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global3_g2 = Read_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global( WorldPosition3_g2 , Noise3_g2 );
			float4 lerpResult7 = lerp( CalculateContrast((0.8 + (frac( ( transform14.x + transform14.z ) ) - 0.0) * (1.2 - 0.8) / (1.0 - 0.0)),tex2DNode1) , color8 , localRead_DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global3_g2);
			o.Albedo = lerpResult7.rgb;
			float3 WorldPosition3_g3 = ase_worldPos;
			float Noise3_g3 = 0.0;
			float localRead_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global3_g3 = Read_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global( WorldPosition3_g3 , Noise3_g3 );
			o.Emission = ( _SonarEmission * localRead_DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global3_g3 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=18301
1572;202;1837;1090;1464.04;239.8126;1.3;True;False
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;14;-2418.993,-719.9178;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-2212.993,-693.9178;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;12;-2070.503,-699.7953;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1941.574,96.37408;Inherit;True;Property;_Diffuse;Diffuse;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;16;-1103.709,825.235;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCRemapNode;13;-1889.502,-707.1067;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.8;False;4;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-1309.067,-278.1767;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;27;-1045.86,-276.8228;Inherit;False;DynamicRadialMasks_HeightField_4_Advanced_Normalized_ID1_Global;-1;;2;70b91d0998346ef4f8c26f9809806dea;0;2;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.FunctionNode;28;-762.0399,823.5875;Inherit;False;DynamicRadialMasks_Torus_4_Advanced_Additive_ID1_Global;-1;;3;b43d281215ae1fa46b30d0cfb43c1cbd;0;2;4;FLOAT3;0,0,0;False;5;FLOAT;0;False;1;FLOAT;6
Node;AmplifyShaderEditor.SimpleContrastOpNode;10;-1558.858,-741.4513;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-365.3658,525.5538;Float;False;Property;_SonarEmission;Sonar Emission;3;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-705.1702,-645.1712;Float;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-338.9402,-735.9969;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-25.94227,679.0162;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-168.7148,-27.9551;Inherit;True;Property;_Bump;Bump;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;723.7768,-45.13086;Float;False;True;-1;2;;0;0;Standard;Amazing Assets/Dynamic Radial Masks/Example/Tree Leaves;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;14;1
WireConnection;15;1;14;3
WireConnection;12;0;15;0
WireConnection;13;0;12;0
WireConnection;27;4;5;0
WireConnection;28;4;16;0
WireConnection;10;1;1;0
WireConnection;10;0;13;0
WireConnection;7;0;10;0
WireConnection;7;1;8;0
WireConnection;7;2;27;6
WireConnection;19;0;18;0
WireConnection;19;1;28;6
WireConnection;0;0;7;0
WireConnection;0;1;3;0
WireConnection;0;2;19;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=4EC62525E88B0DBA2A09E24233BF0A098934360A