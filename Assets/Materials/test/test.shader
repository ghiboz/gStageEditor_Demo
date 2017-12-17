// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "test"
{
	Properties
	{
		_offset("offset", Range( 0 , 100)) = 0
		_lenght("lenght", Range( 0 , 100)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float eyeDepth;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _lenght;
		uniform float _offset;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float cameraDepthFade92 = (( i.eyeDepth -_ProjectionParams.y - _offset ) / _lenght);
			float clampResult99 = clamp( cameraDepthFade92 , 0.0 , 1.0 );
			float4 lerpResult134 = lerp( tex2D( _TextureSample0, uv_TextureSample0 ) , tex2D( _TextureSample1, uv_TextureSample1 ) , clampResult99);
			o.Albedo = lerpResult134.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14001
1927;29;1906;1004;691.7234;752.6036;2.014999;True;True
Node;AmplifyShaderEditor.RangedFloatNode;97;-1304.092,138.5712;Float;False;Property;_lenght;lenght;2;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-1319.707,270.4316;Float;False;Property;_offset;offset;1;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;92;-910.2457,136.8361;Float;False;2;0;FLOAT;10.0;False;1;FLOAT;18.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;763.113,-53.5031;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;769.1999,234.7447;Float;True;Property;_TextureSample1;Texture Sample 1;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;99;-645.3311,119.5461;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-398.767,240.1358;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;124;1627.537,801.046;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-605.1552,731.6298;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;679.7288,1001.176;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;120;1354.805,879.3965;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;115;319.3786,1083.212;Fixed;False;Property;_Vector1;Vector 1;6;0;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;102;-120.8327,871.8411;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;2;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-754.9985,897.0196;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;973.9996,1253.732;Float;False;Property;_maxnew;max new;10;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;113;-591.3192,-187.2599;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;121;970.9097,1151.761;Float;False;Property;_minnew;min new;11;0;0;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;1750.397,623.4163;Float;False;Property;_smoothness;smoothness;9;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;107;-1040.963,1012.88;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;114;1024.34,995.4658;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-790.5425,295.5548;Float;False;Property;_Float0;Float 0;7;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-1789.218,980.1776;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;108;-1771.983,1164.741;Fixed;False;Constant;_Vector0;Vector 0;4;0;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;128;-1072.749,1126.904;Float;False;Property;_Float1;Float 1;8;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;95;355.6577,-499.4189;Float;False;Constant;_Color1;Color 1;1;0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;67.93152,686.1051;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;133;60.19009,517.6651;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.05;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;141;396.3761,599.4601;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;2;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;132;413.1168,-103.6441;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;190.1099,-44.76398;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1385.483,1043.8;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;96;873.8943,-245.4238;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;94;572.0043,-654.884;Float;False;Constant;_Color0;Color 0;1;0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;134;1151.93,152.7256;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;142;799.3765,545.0551;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2269.012,342.4552;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.681;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;20;3;10;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;92;0;97;0
WireConnection;92;1;98;0
WireConnection;99;0;92;0
WireConnection;110;0;99;0
WireConnection;110;1;112;0
WireConnection;124;0;120;0
WireConnection;125;0;101;0
WireConnection;125;1;127;0
WireConnection;116;0;115;0
WireConnection;120;0;114;0
WireConnection;120;3;121;0
WireConnection;120;4;123;0
WireConnection;102;0;125;0
WireConnection;102;1;107;0
WireConnection;102;2;110;0
WireConnection;127;0;107;0
WireConnection;127;1;128;0
WireConnection;107;0;109;0
WireConnection;114;0;116;0
WireConnection;141;0;140;0
WireConnection;141;1;133;0
WireConnection;141;2;99;0
WireConnection;132;0;130;0
WireConnection;130;0;110;0
WireConnection;130;1;127;0
WireConnection;109;0;101;0
WireConnection;109;1;108;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;96;2;132;0
WireConnection;134;0;100;0
WireConnection;134;1;137;0
WireConnection;134;2;99;0
WireConnection;142;1;141;0
WireConnection;0;0;134;0
ASEEND*/
//CHKSM=BE332DE72175AF894E8195BC9C5EA728E14E074E