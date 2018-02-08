// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "test"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TransitionFalloff("Transition Falloff", Float) = 2
		_TransitionDistance("Transition Distance", Range( 1 , 150)) = 1
		_UVMultipliers("UV Multipliers", Vector) = (0,0,0,0)
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
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _TextureSample0;
		uniform float2 _UVMultipliers;
		uniform float _TransitionDistance;
		uniform float _TransitionFalloff;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord153 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float3 ase_worldPos = i.worldPos;
			float clampResult149 = clamp( pow( ( distance( _WorldSpaceCameraPos , ase_worldPos ) / _TransitionDistance ) , _TransitionFalloff ) , 0.0 , 1.0 );
			float4 lerpResult134 = lerp( tex2D( _TextureSample0, uv_TexCoord153 ) , tex2D( _TextureSample0, ( uv_TexCoord153 * _UVMultipliers ) ) , clampResult149);
			o.Albedo = ( lerpResult134 * float4( 0.5882353,0.5882353,0.5882353,0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14001
1978;74;1762;925;-1274.272;226.6127;1.179997;True;True
Node;AmplifyShaderEditor.WorldSpaceCameraPos;143;825.3947,61.24572;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;144;867.7436,295.5265;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;150;1329.617,336.0115;Float;False;Property;_TransitionDistance;Transition Distance;12;0;1;1;150;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;145;1339.995,164.5917;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;1637.358,336.1713;Float;False;Property;_TransitionFalloff;Transition Falloff;11;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;146;1611.198,168.0666;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;153;1734.425,-48.07858;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;157;1952.77,363.386;Float;False;Property;_UVMultipliers;UV Multipliers;13;0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;148;1854.873,160.8466;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;2183.556,327.7858;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;149;2120.208,182.5066;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;2405.308,-37.08282;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;137;2411.395,356.7247;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;None;True;0;False;white;Auto;False;Instance;100;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;134;2792.241,274.7057;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;190.1099,-44.76398;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1304.092,138.5712;Float;False;Property;_lenght;lenght;2;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;3191.503,322.4911;Float;False;2;2;0;COLOR;0.0;False;1;COLOR;0.5882353,0.5882353,0.5882353,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;124;1627.537,801.046;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;113;-591.3192,-187.2599;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;140;67.93152,686.1051;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;114;1024.34,995.4658;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;108;-1771.983,1164.741;Fixed;False;Constant;_Vector0;Vector 0;4;0;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;141;396.3761,599.4601;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;2;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;94;572.0043,-654.884;Float;False;Constant;_Color0;Color 0;1;0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;1750.397,623.4163;Float;False;Property;_smoothness;smoothness;8;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;99;-645.3311,119.5461;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-398.767,240.1358;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;95;355.6577,-499.4189;Float;False;Constant;_Color1;Color 1;1;0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;112;-790.5425,295.5548;Float;False;Property;_Float0;Float 0;6;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-605.1552,731.6298;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;96;873.8943,-245.4238;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-1319.707,270.4316;Float;False;Property;_offset;offset;1;0;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-1789.218,980.1776;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;133;60.19009,517.6651;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,0.05;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;120;1354.805,879.3965;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-1385.483,1043.8;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;679.7288,1001.176;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;142;799.3765,545.0551;Float;True;Property;_TextureSample2;Texture Sample 2;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;121;970.9097,1151.761;Float;False;Property;_minnew;min new;10;0;0;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;92;-910.2457,136.8361;Float;False;2;0;FLOAT;10.0;False;1;FLOAT;18.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-754.9985,897.0196;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;107;-1040.963,1012.88;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;132;413.1168,-103.6441;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;115;319.3786,1083.212;Fixed;False;Property;_Vector1;Vector 1;5;0;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;123;973.9996,1253.732;Float;False;Property;_maxnew;max new;9;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;102;-120.8327,871.8411;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.0,0;False;2;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1072.749,1126.904;Float;False;Property;_Float1;Float 1;7;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3440.246,328.5052;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Custom;0.681;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;20;3;10;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;145;0;143;0
WireConnection;145;1;144;0
WireConnection;146;0;145;0
WireConnection;146;1;150;0
WireConnection;148;0;146;0
WireConnection;148;1;151;0
WireConnection;154;0;153;0
WireConnection;154;1;157;0
WireConnection;149;0;148;0
WireConnection;100;1;153;0
WireConnection;137;1;154;0
WireConnection;134;0;100;0
WireConnection;134;1;137;0
WireConnection;134;2;149;0
WireConnection;130;0;110;0
WireConnection;130;1;127;0
WireConnection;152;0;134;0
WireConnection;124;0;120;0
WireConnection;114;0;116;0
WireConnection;141;0;140;0
WireConnection;141;1;133;0
WireConnection;141;2;99;0
WireConnection;99;0;92;0
WireConnection;110;0;99;0
WireConnection;110;1;112;0
WireConnection;125;0;101;0
WireConnection;125;1;127;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;96;2;132;0
WireConnection;120;0;114;0
WireConnection;120;3;121;0
WireConnection;120;4;123;0
WireConnection;109;0;101;0
WireConnection;109;1;108;0
WireConnection;116;0;115;0
WireConnection;142;1;141;0
WireConnection;92;0;97;0
WireConnection;92;1;98;0
WireConnection;127;0;107;0
WireConnection;127;1;128;0
WireConnection;107;0;109;0
WireConnection;132;0;130;0
WireConnection;102;0;125;0
WireConnection;102;1;107;0
WireConnection;102;2;110;0
WireConnection;0;0;152;0
ASEEND*/
//CHKSM=71ECFDD86CBFCDCE7C2408B78158295E63AFB142