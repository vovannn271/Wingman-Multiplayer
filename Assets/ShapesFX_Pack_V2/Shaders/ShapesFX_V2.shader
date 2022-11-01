// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ShapesFX_V2"
{
	Properties
	{
		_Mask_map("| Animation Mask Map |", 2D) = "white" {}
		[HDR]_LinesColor("| Wires Color", Color) = (1.329802,0.06266081,0,0)
		[HDR]_MaskColor("| Mask Color", Color) = (0.5773503,0.5773503,0.5773503,0)
		_AberationChromMult("| HueVariationMult [Lines]", Range( 0 , 1)) = 0.2
		_AberationChromMultSurface("| HueVariationMult [Surface] ", Range( 0 , 1)) = 0.2
		_LinesColorMult("| Wires Color Mult", Range( 0 , 100)) = 1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[NoScaleOffset]_Diffuse_map("|  Diffuse Map |", 2D) = "white" {}
		_Lines_Push("| Wires_Push", Range( 0 , 40)) = 1
		_InteriorColorMult("| Interior Color Mult", Float) = 5
		_SlicesRotationMult("| Slices Rotation Mult", Range( 0 , 5)) = 1
		[Toggle]_ActivateLines("|| Activate Wires", Float) = 0
		[Toggle]_SlicesDisplacement("|| Slices Displacement", Float) = 1
		[Toggle]_DisplacementSmoothHard("|| Displacement [Smooth / Hard ]", Float) = 1
		[Toggle]_SlicesRotation("|| Slices Rotation ", Float) = 1
		_Panner_X("| Panner_X", Range( 0 , 2)) = 1
		_Panner_Y("| Panner_Y", Range( 0 , 2)) = 1
		_MaskTling("| Mask Tiling", Range( 0 , 4)) = 1
		_DiffuseColorMult("| Diffuse Color Mult", Color) = (1,1,1,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldNormal;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
		};

		uniform float _SlicesRotation;
		uniform sampler2D _Mask_map;
		uniform float _Panner_X;
		uniform float _Panner_Y;
		uniform float _MaskTling;
		uniform float _DisplacementSmoothHard;
		uniform float _SlicesDisplacement;
		uniform float _Lines_Push;
		uniform float _SlicesRotationMult;
		uniform sampler2D _Diffuse_map;
		uniform float4 _DiffuseColorMult;
		uniform float _InteriorColorMult;
		uniform float4 _MaskColor;
		uniform float4 _LinesColor;
		uniform float _LinesColorMult;
		uniform float _AberationChromMultSurface;
		uniform float _AberationChromMult;
		uniform float _ActivateLines;
		uniform float _Cutoff = 0.5;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		float2 MyCustomExpression88( float3 normal )
		{
			float2 uv_matcap = normal *0.5 + float2(0.5,0.5); float2(0.5,0.5);
			return uv_matcap;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult163 = (float2(_Panner_X , _Panner_Y));
			float2 appendResult10 = (float2(v.texcoord1.xy.y , v.texcoord1.xy.x));
			float2 panner8 = ( 1.0 * _Time.y * appendResult163 + ( appendResult10 * _MaskTling ));
			float4 tex2DNode7 = tex2Dlod( _Mask_map, float4( panner8, 0, 0.0) );
			float clampResult104 = clamp( ( tex2DNode7.r * (( _DisplacementSmoothHard )?( 5.0 ):( 1.0 )) ) , 0.1 , 0.4 );
			float3 _Vector0 = float3(-1,1,1);
			float clampResult61 = clamp( ( abs( sin( ( _Time.y + v.color.g + tex2DNode7.r ) ) ) * 1.0 * v.color.b ) , 0.0 , 0.2 );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_44_0 = ( ( clampResult104 * _Vector0 * (( _SlicesDisplacement )?( 1.0 ):( 0.0 )) ) + ( clampResult61 * ase_vertexNormal * ( _Lines_Push * tex2DNode7.r ) ) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 normalizeResult140 = normalize( _Vector0 );
			float3 appendResult132 = (float3(( v.texcoord2.xy.x * -1.0 ) , v.texcoord2.xy.y , v.texcoord3.xy.x));
			float3 rotatedValue110 = RotateAroundAxis( ( appendResult132 / 50.0 ), ase_vertex3Pos, normalizeResult140, ( tex2DNode7.r * _SlicesRotationMult ) );
			v.vertex.xyz += (( _SlicesRotation )?( ( temp_output_44_0 + ( ase_vertex3Pos - rotatedValue110 ) ) ):( temp_output_44_0 ));
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 objToViewDir86 = mul( UNITY_MATRIX_IT_MV, float4( ase_vertexNormal, 0 ) ).xyz;
			float3 normalizeResult87 = normalize( objToViewDir86 );
			float3 normal88 = normalizeResult87;
			float2 localMyCustomExpression88 = MyCustomExpression88( normal88 );
			float2 appendResult163 = (float2(_Panner_X , _Panner_Y));
			float2 appendResult10 = (float2(i.uv2_texcoord2.y , i.uv2_texcoord2.x));
			float2 panner8 = ( 1.0 * _Time.y * appendResult163 + ( appendResult10 * _MaskTling ));
			float4 tex2DNode7 = tex2D( _Mask_map, panner8 );
			float4 temp_output_98_0 = ( ( ( i.vertexColor.b * ( _LinesColor * _LinesColorMult ) ) * tex2DNode7.r ) + ( ( 1.0 - i.vertexColor.b ) * tex2DNode7.r * _MaskColor ) );
			float3 lerpResult154 = lerp( ( ase_vertexNormal * _AberationChromMultSurface * 0.3 ) , ( ase_vertexNormal * _AberationChromMult * 0.3 ) , i.vertexColor.b);
			o.Emission = ( ( tex2D( _Diffuse_map, localMyCustomExpression88 ) * _DiffuseColorMult ) + ( ( i.vertexColor.r * _InteriorColorMult * _MaskColor * tex2DNode7.r ) + ( ( ( temp_output_98_0 * float4( lerpResult154 , 0.0 ) ) + ( temp_output_98_0 * 0.4 ) ) * 1.0 ) ) ).rgb;
			o.Alpha = 1;
			clip( (( _ActivateLines )?( 1.0 ):( ( 1.0 - i.vertexColor.b ) )) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "UI_ShapesFX_V2"
}
/*ASEBEGIN
Version=18909
-2560;0;2560;1379;1462.334;1075.409;1.138999;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1703,122.4891;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1453,141.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-1552.384,-139.6079;Inherit;False;Property;_Panner_X;| Panner_X;15;0;Create;False;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1551.384,-19.60791;Inherit;False;Property;_Panner_Y;| Panner_Y;16;0;Create;False;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-1525.141,327.8127;Inherit;False;Property;_MaskTling;| Mask Tiling;17;0;Create;False;0;0;0;False;0;False;1;3;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;163;-1245.384,-94.60791;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-1209.141,141.8127;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-467.4449,2367.131;Inherit;False;Constant;_Float6;Float 6;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-992,-33.5;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.4,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;54;-180.011,2524.781;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;55;-196.4449,2371.131;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-738.3024,-64.24158;Inherit;True;Property;_Mask_map;| Animation Mask Map |;0;0;Create;False;0;0;0;False;0;False;-1;0fc8bf4d13e7b2c44872d87a42008190;0fc8bf4d13e7b2c44872d87a42008190;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-482.3832,-806.0328;Inherit;False;Property;_LinesColor;| Wires Color;1;1;[HDR];Create;False;0;0;0;False;0;False;1.329802,0.06266081,0,0;1.329802,0.06266081,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-480.0944,-631.6996;Inherit;False;Property;_LinesColorMult;| Wires Color Mult;5;0;Create;False;0;0;0;False;0;False;1;20;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;112.6071,2369.672;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-178.3276,-771.0489;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;11;-711.1293,-562.4313;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;167;-609.5303,1685.104;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-614.5303,1585.104;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;57;251.5551,2366.131;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;332.6259,2570.809;Inherit;False;Constant;_Float7;Float 7;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;83;394.9999,2363.627;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;176;90.40982,34.88933;Inherit;False;Property;_MaskColor;| Mask Color;2;1;[HDR];Create;False;0;0;0;False;0;False;0.5773503,0.5773503,0.5773503,0;0.9988917,0.04706818,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;0.42608,-692.1665;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;165;-437.5303,1625.104;Inherit;False;Property;_DisplacementSmoothHard;|| Displacement [Smooth / Hard ];13;0;Create;False;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;134;1313.497,2161.8;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;66;-668.5941,775.0082;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;84;931.3535,-2678.09;Inherit;False;828.1869;614.2216;MatcapUv;4;88;87;86;85;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;96;30.90047,-86.65923;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-134.9472,891.0187;Inherit;False;Property;_AberationChromMult;| HueVariationMult [Lines];3;0;Create;False;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-136.401,723.3706;Inherit;False;Property;_AberationChromMultSurface;| HueVariationMult [Surface] ;4;0;Create;False;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-15.59747,987.4097;Inherit;False;Constant;_Float13;Float 13;12;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;278.3337,-691.535;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;198.599,611.3706;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;106;41.45422,1292.464;Inherit;False;Constant;_Float11;Float 11;7;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;40;237.1962,1481.645;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;-1,1,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;85;981.3535,-2463.044;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;500.6451,2806.204;Inherit;False;Constant;_Float9;Float 9;1;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;39.45422,1201.464;Inherit;False;Constant;_9;.9;7;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-9.19696,1823.437;Inherit;False;Constant;_Float3;Float 3;16;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-4.19696,1923.437;Inherit;False;Constant;_Float10;Float 10;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;0.9471436,1457.735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;325.5095,3221.29;Inherit;False;Property;_Lines_Push;| Wires_Push;8;0;Create;False;0;0;0;False;0;False;1;2;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;502.6451,2707.204;Inherit;False;Constant;_Float8;Float 8;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;549.6451,2553.204;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;1567.712,2102.567;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;200.0528,779.0187;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;371.004,-90.40388;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;1308.507,2330.512;Inherit;False;3;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;132;1738.073,2315.894;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;86;1219.873,-2268.822;Inherit;False;Object;View;False;Fast;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;115;1804.586,1246.291;Inherit;False;Property;_SlicesRotationMult;| Slices Rotation Mult;10;0;Create;False;0;0;0;False;0;False;1;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;154;436.0686,755.6209;Inherit;False;3;0;FLOAT3;1,1,1;False;1;FLOAT3;1,1,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;93;1089.439,430.9107;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;1791.704,2494.385;Inherit;False;Constant;_Float14;Float 14;12;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;65;614.0569,2934.793;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;633.8655,3223.493;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;98;710.6041,-165.1305;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;142;624.2241,1903.947;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;170;167.803,1863.437;Inherit;False;Property;_SlicesDisplacement;|| Slices Displacement;12;0;Create;False;0;0;0;False;0;False;1;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;104;248.4542,1364.464;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;61;700.6451,2632.204;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1012.192,736.9028;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;889.6451,2744.204;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;140;1825.399,1911.484;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;87;1471.873,-2262.164;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;476.2584,1464.322;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;118;1996.249,2614.138;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;2099.905,1144.012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1244.27,277.1344;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;133;1968.182,2318.279;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;100;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomExpressionNode;88;1593.489,-2456.668;Float;False;float2 uv_matcap = normal *0.5 + float2(0.5,0.5)@ float2(0.5,0.5)@$$return uv_matcap@;2;Create;1;True;normal;FLOAT3;0,0,0;In;;Float;False;My Custom Expression;True;False;0;;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;99;1722.875,-1034.631;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;1472.386,736.5995;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;74;1713.442,176.302;Inherit;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;110;2318.022,1915.87;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1026.385,1466.061;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;101;1734.921,-710.7133;Inherit;False;Property;_InteriorColorMult;| Interior Color Mult;9;0;Create;False;0;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;130;2723.236,2612.345;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;178;2027.884,-2124.474;Inherit;False;Property;_DiffuseColorMult;| Diffuse Color Mult;18;0;Create;False;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;143;2893.51,1508.399;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;1936.032,-867.4558;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1882.164,242.8337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;89;1988.799,-2483.377;Inherit;True;Property;_Diffuse_map;|  Diffuse Map |;7;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;-1;d8cfe409d2fb65842a7151f63c8307c5;d8cfe409d2fb65842a7151f63c8307c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;147;2605.11,1121.127;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;102;2181.058,216.7421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;2453.183,-545.3168;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;149;2760.11,1189.127;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;2767.11,1361.127;Inherit;False;Constant;_Float5;Float 5;13;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;144;3062.222,1477.446;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;148;2895.11,1280.127;Inherit;False;Property;_ActivateLines;|| Activate Wires;11;0;Create;False;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;145;-850.7479,799.9709;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;2464.847,210.5808;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;173;3209.95,1753.6;Inherit;False;Property;_SlicesRotation;|| Slices Rotation ;14;0;Create;False;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;77;-1064.985,682.7596;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;171;3032.95,1713.6;Inherit;False;Constant;_Float12;Float 12;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-384.4926,1006.227;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.AbsOpNode;177;-433.2255,773.104;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;172;3037.95,1813.6;Inherit;False;Constant;_Float15;Float 15;16;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;24;3331.812,1209.621;Float;False;True;-1;2;UI_ShapesFX_V2;0;0;Unlit;ShapesFX_V2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Opaque;;AlphaTest;ForwardOnly;16;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;6;2
WireConnection;10;1;6;1
WireConnection;163;0;161;0
WireConnection;163;1;162;0
WireConnection;174;0;10;0
WireConnection;174;1;175;0
WireConnection;8;0;174;0
WireConnection;8;2;163;0
WireConnection;55;0;56;0
WireConnection;7;1;8;0
WireConnection;53;0;55;0
WireConnection;53;1;54;2
WireConnection;53;2;7;1
WireConnection;94;0;15;0
WireConnection;94;1;29;0
WireConnection;57;0;53;0
WireConnection;83;0;57;0
WireConnection;17;0;11;3
WireConnection;17;1;94;0
WireConnection;165;0;166;0
WireConnection;165;1;167;0
WireConnection;96;0;11;3
WireConnection;95;0;17;0
WireConnection;95;1;7;1
WireConnection;156;0;66;0
WireConnection;156;1;155;0
WireConnection;156;2;153;0
WireConnection;33;0;7;1
WireConnection;33;1;165;0
WireConnection;60;0;83;0
WireConnection;60;1;59;0
WireConnection;60;2;54;3
WireConnection;131;0;134;1
WireConnection;20;0;66;0
WireConnection;20;1;21;0
WireConnection;20;2;153;0
WireConnection;97;0;96;0
WireConnection;97;1;7;1
WireConnection;97;2;176;0
WireConnection;132;0;131;0
WireConnection;132;1;134;2
WireConnection;132;2;135;1
WireConnection;86;0;85;0
WireConnection;154;0;156;0
WireConnection;154;1;20;0
WireConnection;154;2;11;3
WireConnection;151;0;108;0
WireConnection;151;1;7;1
WireConnection;98;0;95;0
WireConnection;98;1;97;0
WireConnection;142;0;40;0
WireConnection;170;0;168;0
WireConnection;170;1;169;0
WireConnection;104;0;33;0
WireConnection;104;1;105;0
WireConnection;104;2;106;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;61;2;63;0
WireConnection;28;0;98;0
WireConnection;28;1;154;0
WireConnection;64;0;61;0
WireConnection;64;1;65;0
WireConnection;64;2;151;0
WireConnection;140;0;142;0
WireConnection;87;0;86;0
WireConnection;38;0;104;0
WireConnection;38;1;40;0
WireConnection;38;2;170;0
WireConnection;117;0;7;1
WireConnection;117;1;115;0
WireConnection;92;0;98;0
WireConnection;92;1;93;0
WireConnection;133;0;132;0
WireConnection;133;1;136;0
WireConnection;88;0;87;0
WireConnection;22;0;28;0
WireConnection;22;1;92;0
WireConnection;110;0;140;0
WireConnection;110;1;117;0
WireConnection;110;2;133;0
WireConnection;110;3;118;0
WireConnection;44;0;38;0
WireConnection;44;1;64;0
WireConnection;130;0;118;0
WireConnection;130;1;110;0
WireConnection;143;0;44;0
WireConnection;100;0;99;1
WireConnection;100;1;101;0
WireConnection;100;2;176;0
WireConnection;100;3;7;1
WireConnection;75;0;22;0
WireConnection;75;1;74;0
WireConnection;89;1;88;0
WireConnection;102;0;100;0
WireConnection;102;1;75;0
WireConnection;179;0;89;0
WireConnection;179;1;178;0
WireConnection;149;0;147;3
WireConnection;144;0;143;0
WireConnection;144;1;130;0
WireConnection;148;0;149;0
WireConnection;148;1;150;0
WireConnection;145;0;77;0
WireConnection;91;0;179;0
WireConnection;91;1;102;0
WireConnection;173;0;44;0
WireConnection;173;1;144;0
WireConnection;107;0;66;0
WireConnection;107;1;77;0
WireConnection;177;0;66;0
WireConnection;24;2;91;0
WireConnection;24;10;148;0
WireConnection;24;11;173;0
ASEEND*/
//CHKSM=90D4661D81426800001D8C834013A6057DD2A939