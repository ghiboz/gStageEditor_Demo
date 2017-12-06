// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "shaderFisico 2"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.06
		_Albedo("Albedo", 2D) = "white" {}
		_Normalmap("Normal map", 2D) = "bump" {}
		_Specular_WetMap("Specular_WetMap", 2D) = "white" {}
		_Wet("Wet", Range( 0 , 0.96)) = 1
		_Displacement("Displacement", Range( -10 , 0)) = 0
		_GrooveMap("GrooveMap", 2D) = "white" {}
		_Groove("Groove", Range( 0 , 1)) = 0
		[Toggle]_UseGrooveTex("Use Groove Tex", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Specular_WetMap;
		uniform float4 _Specular_WetMap_ST;
		uniform float _Wet;
		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _UseGrooveTex;
		uniform sampler2D _GrooveMap;
		uniform float4 _GrooveMap_ST;
		uniform float _Groove;
		uniform float _Displacement;
		uniform float _Cutoff = 0.06;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( v.color.b * ase_vertexNormal * _Displacement );
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_Specular_WetMap = i.uv_texcoord * _Specular_WetMap_ST.xy + _Specular_WetMap_ST.zw;
			float4 tex2DNode3 = tex2D( _Specular_WetMap, uv_Specular_WetMap );
			float smoothstepResult24 = smoothstep( ( 1.0 - tex2DNode3.a ) , 1.0 , _Wet);
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normalmap, uv_Normalmap ) ,( 1.0 - smoothstepResult24 ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 _Color0 = float4(0,0,0,0);
			float2 uv_GrooveMap = i.uv_texcoord * _GrooveMap_ST.xy + _GrooveMap_ST.zw;
			float lerpResult64 = lerp( _Color0.g , i.vertexColor.g , _Groove);
			float4 lerpResult56 = lerp( tex2DNode1 , ( lerp(_Color0,tex2D( _GrooveMap, uv_GrooveMap ),_UseGrooveTex) * tex2DNode1 ) , lerpResult64);
			o.Albedo = lerpResult56.rgb;
			float clampResult47 = clamp( ( tex2DNode3.r + smoothstepResult24 ) , 0.0 , 1.0 );
			float3 temp_cast_1 = (clampResult47).xxx;
			o.Specular = temp_cast_1;
			float clampResult33 = clamp( ( ( tex2DNode1.a + smoothstepResult24 ) + ( _Wet / 2.0 ) ) , 0.0 , 1.0 );
			o.Smoothness = clampResult33;
			o.Alpha = 1;
			clip( tex2DNode3.g - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13903
1927;29;1877;1004;3189.157;583.6268;2.019995;True;True
Node;AmplifyShaderEditor.SamplerNode;3;-2223.008,201.3357;Float;True;Property;_Specular_WetMap;Specular_WetMap;3;0;Assets/Textures/road_clear_s_wetMap.tif;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;12;-1851.938,453.0134;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;5;-1909.474,618.0701;Float;False;Property;_Wet;Wet;4;0;1;0;0.96;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;8;-1821.013,766.269;Float;False;Constant;_Float1;Float 1;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-2133.5,-416.2746;Float;True;Property;_Albedo;Albedo;1;0;Assets/Textures/road_clear_d_smoothness.tif;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;61;-2136.639,-699.9518;Float;False;Constant;_Color0;Color 0;7;0;0,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;55;-2161.152,-952.2069;Float;True;Property;_GrooveMap;GrooveMap;6;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SmoothstepOpNode;24;-1466.803,394.1573;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-1167.691,731.4235;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;2.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-794.4315,631.7591;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.VertexColorNode;54;-1874.802,977.3089;Float;False;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;62;-1972.884,-57.07082;Float;False;Property;_Groove;Groove;7;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.ToggleSwitchNode;70;-1633.573,-830.0923;Float;False;Property;_UseGrooveTex;Use Groove Tex;8;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.NormalVertexDataNode;50;-1118.035,1265.171;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;52;-1850.993,1439.114;Float;False;Property;_Displacement;Displacement;5;0;0;-10;0;0;1;FLOAT
Node;AmplifyShaderEditor.OneMinusNode;45;-791.2285,58.12431;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-504.8837,608.61;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-479.8809,181.0737;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;64;-1164.587,-312.3904;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1142.479,-831.838;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-905.8868,-164.8707;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.LerpOp;56;-556.4253,-447.6256;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;2;-540.6932,-43.11484;Float;True;Property;_Normalmap;Normal map;2;0;Assets/Textures/road_clear_n.tif;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ClampOpNode;47;-176.1671,111.7834;Float;False;3;0;FLOAT;0,0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-822.4285,1284.116;Float;False;3;3;0;FLOAT;0.0;False;1;FLOAT3;0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.ClampOpNode;33;-238.8283,412.3126;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;485.9202,84.11005;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;shaderFisico 2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.06;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;20;3;10;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;3;4
WireConnection;24;0;5;0
WireConnection;24;1;12;0
WireConnection;24;2;8;0
WireConnection;48;0;5;0
WireConnection;7;0;1;4
WireConnection;7;1;24;0
WireConnection;70;0;61;0
WireConnection;70;1;55;0
WireConnection;45;0;24;0
WireConnection;34;0;7;0
WireConnection;34;1;48;0
WireConnection;25;0;3;1
WireConnection;25;1;24;0
WireConnection;64;0;61;2
WireConnection;64;1;54;2
WireConnection;64;2;62;0
WireConnection;66;0;70;0
WireConnection;66;1;1;0
WireConnection;63;0;54;2
WireConnection;63;1;62;0
WireConnection;56;0;1;0
WireConnection;56;1;66;0
WireConnection;56;2;64;0
WireConnection;2;5;45;0
WireConnection;47;0;25;0
WireConnection;51;0;54;3
WireConnection;51;1;50;0
WireConnection;51;2;52;0
WireConnection;33;0;34;0
WireConnection;0;0;56;0
WireConnection;0;1;2;0
WireConnection;0;3;47;0
WireConnection;0;4;33;0
WireConnection;0;10;3;2
WireConnection;0;11;51;0
ASEEND*/
//CHKSM=3E5355F87CF639855643ABB3A3EB1B5907E3AC4C