// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "gRally/Phys Road v2 by Antonio"
{
	Properties
	{
		_AlbedowithSmoothnessMap("Albedo (with Smoothness Map)", 2D) = "white" {}
		_Normalmap("Normal map", 2D) = "bump" {}
		_RSpecGTransparencyBAOAWetMap("(R)Spec-(G)Transparency-(B)AO -(A)WetMap", 2D) = "white" {}
		_TilingMainTextures("Tiling Main Textures", Vector) = (1,1,0,0)
		_OffsetMainTextures("Offset Main Textures", Vector) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.681
		_MaxDisplacementmeters("Max Displacement (meters)", Range( -1 , 0)) = 0
		[Toggle]_UseGrooveTex("Use Groove Tex", Float) = 0
		_GrooveMap("GrooveMap", 2D) = "white" {}
		_PuddlesTexture("Puddles Texture", 2D) = "white" {}
		_PuddlesSize("Puddles Size", Float) = 0
		_TransitionFalloff("Transition Falloff", Float) = 6
		_TransitionDistance("Transition Distance (in meters)", Range( 1 , 150)) = 30
		_UVMultipliers("Tiling Multipliers for far texture", Vector) = (1,0.2,0,0)
		_PhysicalTexture("Physical Texture", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 4.6
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _RSpecGTransparencyBAOAWetMap;
		uniform float2 _TilingMainTextures;
		uniform float2 _OffsetMainTextures;
		uniform float2 _UVMultipliers;
		uniform float _TransitionDistance;
		uniform float _TransitionFalloff;
		uniform sampler2D _PuddlesTexture;
		uniform float _PuddlesSize;
		uniform float _GR_WetSurf;
		uniform sampler2D _Normalmap;
		uniform sampler2D _PhysicalTexture;
		uniform float4 _PhysicalTexture_ST;
		uniform sampler2D _AlbedowithSmoothnessMap;
		uniform float _UseGrooveTex;
		uniform sampler2D _GrooveMap;
		uniform float4 _GrooveMap_ST;
		uniform float _GR_Groove;
		uniform float _GR_PhysDebug;
		uniform float _MaxDisplacementmeters;
		uniform float _GR_Displacement;
		uniform float _Cutoff = 0.681;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VertexOffset222 = ( v.color.b * ase_vertexNormal * _MaxDisplacementmeters * _GR_Displacement );
			v.vertex.xyz += VertexOffset222;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord138 = i.uv_texcoord * _TilingMainTextures + _OffsetMainTextures;
			float2 UVTexture212 = uv_TexCoord138;
			float4 tex2DNode3 = tex2D( _RSpecGTransparencyBAOAWetMap, UVTexture212 );
			float2 UVTexTim217 = ( uv_TexCoord138 * _UVMultipliers );
			float4 tex2DNode146 = tex2D( _RSpecGTransparencyBAOAWetMap, UVTexTim217 );
			float3 ase_worldPos = i.worldPos;
			float clampResult142 = clamp( pow( ( distance( _WorldSpaceCameraPos , ase_worldPos ) / _TransitionDistance ) , _TransitionFalloff ) , 0.0 , 1.0 );
			float TransitionPower207 = clampResult142;
			float lerpResult150 = lerp( tex2DNode3.a , tex2DNode146.a , TransitionPower207);
			float2 appendResult172 = (float2(ase_worldPos.x , ase_worldPos.z));
			float4 tex2DNode178 = tex2D( _PuddlesTexture, ( appendResult172 / _PuddlesSize ) );
			float temp_output_174_0 = step( frac( ( ( ase_worldPos.x / _PuddlesSize ) * 0.5 ) ) , 0.5 );
			float temp_output_173_0 = step( frac( ( ( ase_worldPos.z / _PuddlesSize ) * 0.5 ) ) , 0.5 );
			float temp_output_176_0 = ( 1.0 - temp_output_173_0 );
			float temp_output_177_0 = ( 1.0 - temp_output_174_0 );
			float clampResult201 = clamp( ( lerpResult150 + ( tex2DNode178.r * ( temp_output_174_0 * temp_output_173_0 ) ) + ( tex2DNode178.g * ( temp_output_174_0 * temp_output_176_0 ) ) + ( tex2DNode178.b * ( temp_output_177_0 * temp_output_173_0 ) ) + ( tex2DNode178.a * ( temp_output_177_0 * temp_output_176_0 ) ) ) , 0.0 , 1.0 );
			float temp_output_206_0 = ( clampResult201 * _GR_WetSurf );
			float temp_output_81_0 = ( 1.0 - temp_output_206_0 );
			float3 lerpResult152 = lerp( UnpackScaleNormal( tex2D( _Normalmap, UVTexture212 ) ,temp_output_81_0 ) , UnpackScaleNormal( tex2D( _Normalmap, UVTexTim217 ) ,temp_output_81_0 ) , TransitionPower207);
			float3 Normal227 = lerpResult152;
			o.Normal = Normal227;
			float2 uv_PhysicalTexture = i.uv_texcoord * _PhysicalTexture_ST.xy + _PhysicalTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _AlbedowithSmoothnessMap, UVTexture212 );
			float4 tex2DNode144 = tex2D( _AlbedowithSmoothnessMap, UVTexTim217 );
			float4 lerpResult145 = lerp( tex2DNode1 , tex2DNode144 , TransitionPower207);
			float4 _Color0 = float4(0,0,0,0);
			float2 uv_GrooveMap = i.uv_texcoord * _GrooveMap_ST.xy + _GrooveMap_ST.zw;
			float lerpResult64 = lerp( _Color0.g , i.vertexColor.g , _GR_Groove);
			float4 lerpResult56 = lerp( lerpResult145 , ( lerp(_Color0,tex2D( _GrooveMap, uv_GrooveMap ),_UseGrooveTex) * lerpResult145 ) , lerpResult64);
			float clampResult90 = clamp( ( 1.0 - _GR_WetSurf ) , 0.2 , 1.0 );
			float4 lerpResult83 = lerp( tex2D( _PhysicalTexture, uv_PhysicalTexture ) , ( lerpResult56 * clampResult90 ) , ( 1.0 - _GR_PhysDebug ));
			float4 Albedo235 = lerpResult83;
			o.Albedo = Albedo235.rgb;
			float lerpResult147 = lerp( tex2DNode3.r , tex2DNode146.r , TransitionPower207);
			float clampResult47 = clamp( ( lerpResult147 + temp_output_206_0 ) , 0.0 , 1.0 );
			float Specular233 = clampResult47;
			float3 temp_cast_1 = (Specular233).xxx;
			o.Specular = temp_cast_1;
			float lerpResult143 = lerp( tex2DNode1.a , tex2DNode144.a , TransitionPower207);
			float clampResult33 = clamp( ( ( lerpResult143 + temp_output_206_0 ) + ( _GR_WetSurf / 2.0 ) ) , 0.0 , 1.0 );
			float Smppthnes229 = clampResult33;
			o.Smoothness = Smppthnes229;
			float lerpResult149 = lerp( tex2DNode3.b , tex2DNode146.b , TransitionPower207);
			float AO231 = ( lerpResult149 + _GR_WetSurf );
			o.Occlusion = AO231;
			o.Alpha = 1;
			float lerpResult148 = lerp( tex2DNode3.g , tex2DNode146.g , TransitionPower207);
			float OpacityMask225 = lerpResult148;
			clip( OpacityMask225 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
2807;63;922;925;-2357.518;3647.754;7.7237;True;False
Node;AmplifyShaderEditor.RangedFloatNode;165;-5468.566,617.5628;Float;False;Property;_PuddlesSize;Puddles Size;10;0;Create;True;0;1.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;164;-5484.576,206.4814;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;166;-4837.441,869.0663;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;167;-4838.894,603.1854;Float;False;2;0;FLOAT;0,0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;133;-8182.442,342.5614;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;132;-8224.791,108.2815;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-4616.277,834.3033;Float;True;2;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;153;-8218.781,-1376.054;Float;False;Property;_TilingMainTextures;Tiling Main Textures;3;0;Create;True;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;134;-8156.953,619.8607;Float;False;Property;_TransitionDistance;Transition Distance (in meters);12;0;Create;False;30;21.7;1;150;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;163;-8166.587,-1110.743;Float;False;Property;_OffsetMainTextures;Offset Main Textures;4;0;Create;True;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DistanceOpNode;135;-7710.189,211.6266;Float;False;2;0;FLOAT3;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-4624.735,558.9138;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;171;-4401.903,560.5529;Float;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;170;-4383.653,836.1284;Float;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-8099.562,862.2091;Float;False;Property;_TransitionFalloff;Transition Falloff;11;0;Create;True;6;5.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;137;-7371.933,140.8691;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;138;-7707.593,-1247.085;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;139;-8175.3,-869.5203;Float;False;Property;_UVMultipliers;Tiling Multipliers for far texture;13;0;Create;False;1,0.2;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;173;-4166.663,823.3531;Float;True;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;140;-7289.466,523.0756;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-7541.668,-881.5291;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;172;-5087.907,226.5712;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;174;-4179.437,549.6039;Float;True;2;0;FLOAT;0.5;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;177;-3934.172,662.7542;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;175;-4517.898,289.0777;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-4642.46,-747.5553;Float;False;212;0;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;176;-3920.102,958.403;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;-7155.876,-1201.151;Float;False;UVTexture;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;217;-7117.24,-930.2856;Float;False;UVTexTim;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;-4675.432,-958.4763;Float;False;217;0;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;142;-6946.705,447.3294;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;146;-4391.051,-1013.141;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;None;None;True;0;False;white;Auto;False;Instance;3;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;210;-4453.232,-435.7211;Float;False;207;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;-3622.626,837.9541;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;178;-3656.103,52.02406;Float;True;Property;_PuddlesTexture;Puddles Texture;9;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-3631.751,348.8557;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-4457.794,-779.4114;Float;True;Property;_RSpecGTransparencyBAOAWetMap;(R)Spec-(G)Transparency-(B)AO -(A)WetMap;2;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-6583.942,507.2906;Float;False;TransitionPower;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-3613.501,1084.329;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-3626.276,589.7542;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;150;-2625.556,-215.3761;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;-3004.226,853.6685;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-3002.311,298.3196;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-2994.651,1102.62;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-2990.821,579.8231;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;-3580.724,-1808.592;Float;False;217;0;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;216;-3589.356,-2266.944;Float;False;212;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;200;-2319.007,154.951;Float;False;5;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;144;-3150.99,-1838.831;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;55;-1714.35,-3145.027;Float;True;Property;_GrooveMap;GrooveMap;8;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;61;-1936.583,-2321.794;Float;False;Constant;_Color0;Color 0;7;0;Create;True;0,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-3152.569,-2401.75;Float;True;Property;_AlbedowithSmoothnessMap;Albedo (with Smoothness Map);0;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;209;-2186.785,-1525.093;Float;False;207;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1940.856,585.7797;Float;False;Global;_GR_WetSurf;_GR_WetSurf;6;0;Create;True;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1780.702,-1433.729;Float;False;Global;_GR_Groove;_GR_Groove;8;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;70;-1345.864,-2966.221;Float;False;Property;_UseGrooveTex;Use Groove Tex;7;0;Create;True;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;54;-2329.284,988.3264;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;145;-1911.028,-1867.338;Float;True;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;201;-2095.796,155.2407;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;143;-2553.536,-1477.96;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1040.299,-2844.851;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;-1538.174,161.7106;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;89;1128.665,-871.2339;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;64;-1083.449,-1632.17;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-1167.691,731.4235;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;220;-605.4619,-687.1863;Float;False;217;0;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;81;-1160.666,-64.4267;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-822.4315,599.7591;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;147;-2522.31,-1229.53;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1623.125,-1234.363;Float;False;Global;_GR_PhysDebug;_GR_PhysDebug;6;0;Create;True;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;90;1339.117,-797.1045;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.2;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-1371.437,-1100.228;Float;False;212;0;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;56;-526.2119,-1789.525;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-373.7558,-1158.061;Float;True;Property;_Normalmap;Normal map;1;0;Create;True;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-479.8809,181.0737;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;151;-301.5608,-799.371;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;None;None;True;0;True;bump;Auto;True;Instance;2;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;50;-1423.484,1271.131;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-504.8837,608.61;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1827.797,1451.395;Float;False;Property;_MaxDisplacementmeters;Max Displacement (meters);6;0;Create;True;0;-0.924;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;71;1213.056,-1527.001;Float;True;Property;_PhysicalTexture;Physical Texture;14;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;84;1921.034,-1137.864;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1608.537,-990.3509;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;149;-2525.873,-511.5167;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;167.1224,-588.9587;Float;False;207;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1657.665,1597.289;Float;False;Global;_GR_Displacement;_GR_Displacement;6;0;Create;True;0;0;-1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;33;-526.255,1016.746;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-1291.542,560.3725;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;47;-120.1303,164.2037;Float;False;3;0;FLOAT;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;152;460.7161,-833.7089;Float;False;3;0;FLOAT3;0.0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0.0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-822.4285,1284.116;Float;False;4;4;0;FLOAT;0.0;False;1;FLOAT3;0;False;2;FLOAT;0.0,0,0;False;3;FLOAT;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;148;-2550.342,-760.063;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;2054.407,-977.0455;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-4842.266,739.489;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-4566.491,164.7914;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;233;99.05371,335.6467;Float;False;Specular;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;234;3566.925,178.1998;Float;False;233;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;2348.161,-1010.184;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;228;3461.617,66.64679;Float;False;227;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-4846.291,476.9939;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-599.0568,1412.04;Float;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;3726.729,405.6185;Float;False;225;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;-277.3359,1155.052;Float;False;Smppthnes;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;236;3668.008,-174.7009;Float;False;235;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;223;3658.517,501.8047;Float;False;222;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;-1154.581,631.3002;Float;False;AO;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-2207.424,-603.1295;Float;False;OpacityMask;-1;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;230;3580.044,264.6921;Float;False;229;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;232;3725.419,315.3002;Float;False;231;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;227;614.3506,-1038.419;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4387.941,51.43749;Float;False;True;6;Float;ASEMaterialInspector;0;0;StandardSpecular;gRally/Phys Road v2 by Antonio;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Custom;0.681;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;20;3;10;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;166;0;164;3
WireConnection;166;1;165;0
WireConnection;167;0;164;1
WireConnection;167;1;165;0
WireConnection;169;0;166;0
WireConnection;135;0;132;0
WireConnection;135;1;133;0
WireConnection;168;0;167;0
WireConnection;171;0;168;0
WireConnection;170;0;169;0
WireConnection;137;0;135;0
WireConnection;137;1;134;0
WireConnection;138;0;153;0
WireConnection;138;1;163;0
WireConnection;173;0;170;0
WireConnection;140;0;137;0
WireConnection;140;1;136;0
WireConnection;141;0;138;0
WireConnection;141;1;139;0
WireConnection;172;0;164;1
WireConnection;172;1;164;3
WireConnection;174;0;171;0
WireConnection;177;0;174;0
WireConnection;175;0;172;0
WireConnection;175;1;165;0
WireConnection;176;0;173;0
WireConnection;212;0;138;0
WireConnection;217;0;141;0
WireConnection;142;0;140;0
WireConnection;146;1;221;0
WireConnection;186;0;177;0
WireConnection;186;1;173;0
WireConnection;178;1;175;0
WireConnection;181;0;174;0
WireConnection;181;1;173;0
WireConnection;3;1;214;0
WireConnection;207;0;142;0
WireConnection;179;0;177;0
WireConnection;179;1;176;0
WireConnection;184;0;174;0
WireConnection;184;1;176;0
WireConnection;150;0;3;4
WireConnection;150;1;146;4
WireConnection;150;2;210;0
WireConnection;189;0;178;3
WireConnection;189;1;186;0
WireConnection;190;0;178;1
WireConnection;190;1;181;0
WireConnection;187;0;178;4
WireConnection;187;1;179;0
WireConnection;188;0;178;2
WireConnection;188;1;184;0
WireConnection;200;0;150;0
WireConnection;200;1;190;0
WireConnection;200;2;188;0
WireConnection;200;3;189;0
WireConnection;200;4;187;0
WireConnection;144;1;218;0
WireConnection;1;1;216;0
WireConnection;70;0;61;0
WireConnection;70;1;55;0
WireConnection;145;0;1;0
WireConnection;145;1;144;0
WireConnection;145;2;209;0
WireConnection;201;0;200;0
WireConnection;143;0;1;4
WireConnection;143;1;144;4
WireConnection;143;2;210;0
WireConnection;66;0;70;0
WireConnection;66;1;145;0
WireConnection;206;0;201;0
WireConnection;206;1;5;0
WireConnection;89;0;5;0
WireConnection;64;0;61;2
WireConnection;64;1;54;2
WireConnection;64;2;62;0
WireConnection;48;0;5;0
WireConnection;81;0;206;0
WireConnection;7;0;143;0
WireConnection;7;1;206;0
WireConnection;147;0;3;1
WireConnection;147;1;146;1
WireConnection;147;2;210;0
WireConnection;90;0;89;0
WireConnection;56;0;145;0
WireConnection;56;1;66;0
WireConnection;56;2;64;0
WireConnection;2;1;213;0
WireConnection;2;5;81;0
WireConnection;25;0;147;0
WireConnection;25;1;206;0
WireConnection;151;1;220;0
WireConnection;151;5;81;0
WireConnection;34;0;7;0
WireConnection;34;1;48;0
WireConnection;84;0;82;0
WireConnection;88;0;56;0
WireConnection;88;1;90;0
WireConnection;149;0;3;3
WireConnection;149;1;146;3
WireConnection;149;2;210;0
WireConnection;33;0;34;0
WireConnection;77;0;149;0
WireConnection;77;1;5;0
WireConnection;47;0;25;0
WireConnection;152;0;2;0
WireConnection;152;1;151;0
WireConnection;152;2;211;0
WireConnection;51;0;54;3
WireConnection;51;1;50;0
WireConnection;51;2;52;0
WireConnection;51;3;85;0
WireConnection;148;0;3;2
WireConnection;148;1;146;2
WireConnection;148;2;210;0
WireConnection;83;0;71;0
WireConnection;83;1;88;0
WireConnection;83;2;84;0
WireConnection;196;0;164;3
WireConnection;196;1;165;0
WireConnection;195;0;172;0
WireConnection;195;1;165;0
WireConnection;233;0;47;0
WireConnection;235;0;83;0
WireConnection;197;0;164;1
WireConnection;197;1;165;0
WireConnection;222;0;51;0
WireConnection;229;0;33;0
WireConnection;231;0;77;0
WireConnection;225;0;148;0
WireConnection;227;0;152;0
WireConnection;0;0;236;0
WireConnection;0;1;228;0
WireConnection;0;3;234;0
WireConnection;0;4;230;0
WireConnection;0;5;232;0
WireConnection;0;10;226;0
WireConnection;0;11;223;0
ASEEND*/
//CHKSM=941101C6E1D22F97AB7B0BA70598D45CD1665637