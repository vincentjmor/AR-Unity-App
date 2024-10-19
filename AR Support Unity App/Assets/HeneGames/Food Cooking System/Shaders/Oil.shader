// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeneGames/CookingSystem/Oil"
{
	Properties
	{
		_Normalmap("Normal map", 2D) = "bump" {}
		_Normalmaplerp("Normal map lerp", Range( 0 , 1)) = 0.5
		_Freshnelpower("Freshnel power", Range( 0 , 1)) = 0
		_Constant01("Constant 0.1", Float) = 0.1
		_OilColor("Oil Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting keepalpha 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 viewDir;
			half3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Normalmap;
		uniform half4 _Normalmap_ST;
		uniform half _Normalmaplerp;
		uniform half _Constant01;
		uniform half4 _OilColor;
		uniform half _Freshnelpower;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			half4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			half4 appendResult106 = (half4(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g , 0.0 , 0.0));
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			half2 panner124 = ( 0.1 * _Time.y * float2( 1,1 ) + i.uv_texcoord);
			half3 lerpResult115 = lerp( UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) ) , UnpackScaleNormal( tex2D( _Normalmap, panner124 ), 0.5 ) , _Normalmaplerp);
			half3 Normalmapping118 = lerpResult115;
			half4 screenUV113 = ( appendResult106 - half4( ( (Normalmapping118).xyz * _Constant01 ) , 0.0 ) );
			half4 screenColor120 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,screenUV113.xy);
			half3 ase_worldNormal = i.worldNormal;
			half3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			half2 appendResult137 = (half2(ase_vertexNormal.x , ase_vertexNormal.y));
			half3 appendResult141 = (half3(( half3( appendResult137 ,  0.0 ) - (Normalmapping118).xyz ).xy , ase_vertexNormal.z));
			half dotResult127 = dot( i.viewDir , appendResult141 );
			half Freshnel133 = pow( ( 1.0 - saturate( abs( dotResult127 ) ) ) , _Freshnelpower );
			half4 lerpResult134 = lerp( screenColor120 , _OilColor , Freshnel133);
			c.rgb = lerpResult134.rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.SimpleSubtractOpNode;109;-948.3893,-47.88398;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-1212.389,169.116;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-1213.389,-49.88398;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GrabScreenPosition;108;-1466.389,-14.88398;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;-1406.758,1064.962;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;114;-1811.011,999.9367;Inherit;True;Property;_Normalmap;Normal map;0;0;Create;True;0;0;0;False;0;False;-1;None;e89eba6ca0a0dd64885e81e144456194;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;111;-1474.389,158.116;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-1704.805,153.7503;Inherit;False;118;Normalmapping;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;-709.9775,-50.07892;Inherit;False;screenUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-1048.757,1061.962;Inherit;False;Normalmapping;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;120;-378.3137,254.7607;Inherit;False;Global;_GrabScreen0;Grab Screen 0;2;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;121;-575.3137,311.7607;Inherit;False;113;screenUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-1418.389,361.116;Inherit;False;Property;_Constant01;Constant 0.1;3;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-1821.758,1200.962;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;114;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.5;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;127;-933.9053,-468.8951;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;125;-1254.905,-580.8951;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;128;-763.9053,-462.8951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;129;-589.9053,-459.8951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;130;-449.9053,-451.8951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;131;-291.9053,-457.8951;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-86.21375,-439.9298;Inherit;False;Freshnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;134;-184.7206,379.4814;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;143.6,30;Half;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;HeneGames/CookingSystem/Oil;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-493.7206,653.4814;Inherit;False;133;Freshnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;122;-582.9563,440.6079;Inherit;False;Property;_OilColor;Oil Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4433962,0.2758909,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;117;-1762.758,1407.962;Inherit;False;Property;_Normalmaplerp;Normal map lerp;1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-662.9053,-341.8951;Inherit;False;Property;_Freshnelpower;Freshnel power;2;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;126;-1659.905,-440.8951;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;137;-1447.892,-439.7003;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-1725.892,-271.7003;Inherit;False;118;Normalmapping;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;139;-1514.892,-269.7003;Inherit;False;True;True;True;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;140;-1247.892,-338.7003;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-1089.892,-340.7003;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;124;-2217.084,1047.677;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;1,1;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;-2607.67,1026.216;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;109;0;106;0
WireConnection;109;1;110;0
WireConnection;110;0;111;0
WireConnection;110;1;112;0
WireConnection;106;0;108;1
WireConnection;106;1;108;2
WireConnection;115;0;114;0
WireConnection;115;1;116;0
WireConnection;115;2;117;0
WireConnection;111;0;119;0
WireConnection;113;0;109;0
WireConnection;118;0;115;0
WireConnection;120;0;121;0
WireConnection;116;1;124;0
WireConnection;127;0;125;0
WireConnection;127;1;141;0
WireConnection;128;0;127;0
WireConnection;129;0;128;0
WireConnection;130;0;129;0
WireConnection;131;0;130;0
WireConnection;131;1;132;0
WireConnection;133;0;131;0
WireConnection;134;0;120;0
WireConnection;134;1;122;0
WireConnection;134;2;135;0
WireConnection;0;13;134;0
WireConnection;137;0;126;1
WireConnection;137;1;126;2
WireConnection;139;0;138;0
WireConnection;140;0;137;0
WireConnection;140;1;139;0
WireConnection;141;0;140;0
WireConnection;141;2;126;3
WireConnection;124;0;142;0
ASEEND*/
//CHKSM=EEDB515F26DCA6C8C73468E445DFCA822090A68D