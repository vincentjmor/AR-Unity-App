// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeneGames/CookingSystem/Cooking shader vertex colors"
{
	Properties
	{
		_RawBaseColor("Raw Base Color", 2D) = "white" {}
		_Rawcolortint("Raw color tint", Color) = (1,1,1,0)
		_CookedBaseColor("Cooked Base Color", 2D) = "white" {}
		_Cookedcolortint("Cooked color tint", Color) = (1,1,1,0)
		_Cookedcolorbrightness("Cooked color brightness", Range( 0 , 2)) = 0
		_BurnBaseColor("Burn Base Color", 2D) = "white" {}
		_Burncolortint("Burn color tint", Color) = (1,1,1,0)
		_RawNormal1("Raw Normal", 2D) = "bump" {}
		_CookedNormal("Cooked Normal", 2D) = "bump" {}
		_BurnedNormal("Burned Normal", 2D) = "bump" {}
		_RawRoughnessMetallicSmoothness("Raw Roughness/Metallic Smoothness", 2D) = "gray" {}
		[Toggle]_RawMetallicSmoothness("Raw Metallic Smoothness", Float) = 0
		_Rawsmoothnessadjust("Raw smoothness adjust", Range( 0 , 2)) = 1
		_CookedRoughnessMetallicSmoothness("Cooked Roughness/Metallic Smoothness", 2D) = "white" {}
		[Toggle]_CookedMetallicSmoothness("Cooked Metallic Smoothness", Float) = 0
		_Cookedsmoothnessadjust("Cooked smoothness adjust", Range( 0 , 2)) = 1
		_BurnedRoughnessMetallicSmoothness("Burned Roughness/Metallic Smoothness", 2D) = "white" {}
		[Toggle]_BurnedMetallicSmoothness("Burned Metallic Smoothness", Float) = 0
		_Burnedsmoothnessadjust("Burned smoothness adjust", Range( 0 , 2)) = 1
		_Deepfrybasecolor("Deep fry basecolor", 2D) = "white" {}
		_Deepfrynormalmap("Deep fry normalmap", 2D) = "white" {}
		_DeepFrySmoothness("Deep Fry Smoothness", Range( 0 , 1)) = 0.5
		_DeepFryTextureScale("DeepFryTextureScale", Float) = 0
		[Toggle]_Usecookedroughnessfordeepfry("Use cooked roughness for deep fry", Float) = 1
		[Toggle]_Usecookedbasecolorfordeepfry("Use cooked basecolor for deep fry", Float) = 1
		[Toggle]_Usecookednormalfordeepfry("Use cooked normal for deep fry", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _RawNormal1;
		uniform float4 _RawNormal1_ST;
		uniform sampler2D _CookedNormal;
		uniform float4 _CookedNormal_ST;
		uniform sampler2D _BurnedNormal;
		uniform float4 _BurnedNormal_ST;
		uniform float _Usecookednormalfordeepfry;
		uniform sampler2D _Deepfrynormalmap;
		uniform float _DeepFryTextureScale;
		uniform sampler2D _RawBaseColor;
		uniform float4 _RawBaseColor_ST;
		uniform float4 _Rawcolortint;
		uniform sampler2D _CookedBaseColor;
		uniform float4 _CookedBaseColor_ST;
		uniform float4 _Cookedcolortint;
		uniform float _Cookedcolorbrightness;
		uniform sampler2D _BurnBaseColor;
		uniform float4 _BurnBaseColor_ST;
		uniform float4 _Burncolortint;
		uniform float _Usecookedbasecolorfordeepfry;
		uniform sampler2D _Deepfrybasecolor;
		uniform float _RawMetallicSmoothness;
		uniform sampler2D _RawRoughnessMetallicSmoothness;
		uniform float4 _RawRoughnessMetallicSmoothness_ST;
		uniform float _Rawsmoothnessadjust;
		uniform float _CookedMetallicSmoothness;
		uniform sampler2D _CookedRoughnessMetallicSmoothness;
		uniform float4 _CookedRoughnessMetallicSmoothness_ST;
		uniform float _Cookedsmoothnessadjust;
		uniform float _BurnedMetallicSmoothness;
		uniform sampler2D _BurnedRoughnessMetallicSmoothness;
		uniform float4 _BurnedRoughnessMetallicSmoothness_ST;
		uniform float _Burnedsmoothnessadjust;
		uniform float _Usecookedroughnessfordeepfry;
		uniform float _DeepFrySmoothness;


		inline float3 TriplanarSampling245( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			xNorm.xyz  = half3( UnpackNormal( xNorm ).xy * float2(  nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz  = half3( UnpackNormal( yNorm ).xy * float2(  nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz  = half3( UnpackNormal( zNorm ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSampling239( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_RawNormal1 = i.uv_texcoord * _RawNormal1_ST.xy + _RawNormal1_ST.zw;
			float2 uv_CookedNormal = i.uv_texcoord * _CookedNormal_ST.xy + _CookedNormal_ST.zw;
			float3 tex2DNode279 = UnpackNormal( tex2D( _CookedNormal, uv_CookedNormal ) );
			float RawOrCookedMask195 = i.vertexColor.r;
			float3 lerpResult266 = lerp( UnpackNormal( tex2D( _RawNormal1, uv_RawNormal1 ) ) , tex2DNode279 , ( 1.0 - RawOrCookedMask195 ));
			float2 uv_BurnedNormal = i.uv_texcoord * _BurnedNormal_ST.xy + _BurnedNormal_ST.zw;
			float BurnedMask216 = i.vertexColor.a;
			float3 lerpResult269 = lerp( lerpResult266 , UnpackNormal( tex2D( _BurnedNormal, uv_BurnedNormal ) ) , ( 1.0 - BurnedMask216 ));
			float2 temp_cast_0 = (_DeepFryTextureScale).xx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float4 ase_vertexTangent = mul( unity_WorldToObject, float4( ase_worldTangent, 0 ) );
			ase_vertexTangent = normalize( ase_vertexTangent );
			float3 ase_vertexBitangent = mul( unity_WorldToObject, float4( ase_worldBitangent, 0 ) );
			ase_vertexBitangent = normalize( ase_vertexBitangent );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3x3 objectToTangent = float3x3(ase_vertexTangent.xyz, ase_vertexBitangent, ase_vertexNormal);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 triplanar245 = TriplanarSampling245( _Deepfrynormalmap, ase_vertex3Pos, ase_vertexNormal, 1.0, temp_cast_0, 1.0, 0 );
			float3 tanTriplanarNormal245 = mul( objectToTangent, triplanar245 );
			float3 DeepFryNormal247 = tanTriplanarNormal245;
			float DeepFryeMask234 = i.vertexColor.g;
			float3 lerpResult268 = lerp( lerpResult269 , (( _Usecookednormalfordeepfry )?( tex2DNode279 ):( DeepFryNormal247 )) , ( 1.0 - DeepFryeMask234 ));
			o.Normal = lerpResult268;
			float2 uv_RawBaseColor = i.uv_texcoord * _RawBaseColor_ST.xy + _RawBaseColor_ST.zw;
			float4 Rawbasecolor105 = ( tex2D( _RawBaseColor, uv_RawBaseColor ) * _Rawcolortint );
			float2 uv_CookedBaseColor = i.uv_texcoord * _CookedBaseColor_ST.xy + _CookedBaseColor_ST.zw;
			float4 Cookedbasecolor108 = ( ( tex2D( _CookedBaseColor, uv_CookedBaseColor ) * _Cookedcolortint ) * _Cookedcolorbrightness );
			float4 lerpResult180 = lerp( Rawbasecolor105 , Cookedbasecolor108 , ( 1.0 - RawOrCookedMask195 ));
			float2 uv_BurnBaseColor = i.uv_texcoord * _BurnBaseColor_ST.xy + _BurnBaseColor_ST.zw;
			float4 Burnedbasecolor112 = ( tex2D( _BurnBaseColor, uv_BurnBaseColor ) * _Burncolortint );
			float4 lerpResult77 = lerp( lerpResult180 , Burnedbasecolor112 , ( 1.0 - BurnedMask216 ));
			float2 temp_cast_1 = (_DeepFryTextureScale).xx;
			float4 triplanar239 = TriplanarSampling239( _Deepfrybasecolor, ase_vertex3Pos, ase_vertexNormal, 1.0, temp_cast_1, 1.0, 0 );
			float4 DeepFryBasecolor240 = triplanar239;
			float4 lerpResult233 = lerp( lerpResult77 , (( _Usecookedbasecolorfordeepfry )?( Cookedbasecolor108 ):( DeepFryBasecolor240 )) , ( 1.0 - DeepFryeMask234 ));
			o.Albedo = lerpResult233.rgb;
			float2 uv_RawRoughnessMetallicSmoothness = i.uv_texcoord * _RawRoughnessMetallicSmoothness_ST.xy + _RawRoughnessMetallicSmoothness_ST.zw;
			float4 tex2DNode5 = tex2D( _RawRoughnessMetallicSmoothness, uv_RawRoughnessMetallicSmoothness );
			float4 temp_cast_4 = (tex2DNode5.a).xxxx;
			float4 SmoothnessRaw153 = (( _RawMetallicSmoothness )?( temp_cast_4 ):( ( 1.0 - tex2DNode5 ) ));
			float2 uv_CookedRoughnessMetallicSmoothness = i.uv_texcoord * _CookedRoughnessMetallicSmoothness_ST.xy + _CookedRoughnessMetallicSmoothness_ST.zw;
			float4 tex2DNode305 = tex2D( _CookedRoughnessMetallicSmoothness, uv_CookedRoughnessMetallicSmoothness );
			float4 temp_cast_5 = (tex2DNode305.a).xxxx;
			float4 SmoothnessCooked307 = (( _CookedMetallicSmoothness )?( temp_cast_5 ):( ( 1.0 - tex2DNode305 ) ));
			float4 temp_output_312_0 = ( SmoothnessCooked307 * _Cookedsmoothnessadjust );
			float4 lerpResult283 = lerp( ( SmoothnessRaw153 * _Rawsmoothnessadjust ) , temp_output_312_0 , ( 1.0 - RawOrCookedMask195 ));
			float2 uv_BurnedRoughnessMetallicSmoothness = i.uv_texcoord * _BurnedRoughnessMetallicSmoothness_ST.xy + _BurnedRoughnessMetallicSmoothness_ST.zw;
			float4 tex2DNode311 = tex2D( _BurnedRoughnessMetallicSmoothness, uv_BurnedRoughnessMetallicSmoothness );
			float4 temp_cast_6 = (tex2DNode311.a).xxxx;
			float4 SmoothnessBurned310 = (( _BurnedMetallicSmoothness )?( temp_cast_6 ):( ( 1.0 - tex2DNode311 ) ));
			float4 lerpResult286 = lerp( lerpResult283 , ( SmoothnessBurned310 * _Burnedsmoothnessadjust ) , ( 1.0 - BurnedMask216 ));
			float4 temp_cast_7 = (_DeepFrySmoothness).xxxx;
			float4 lerpResult285 = lerp( lerpResult286 , (( _Usecookedroughnessfordeepfry )?( temp_output_312_0 ):( temp_cast_7 )) , ( 1.0 - DeepFryeMask234 ));
			o.Smoothness = lerpResult285.r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;342;-1291.09,1399.783;Inherit;False;1282.957;893.859;Metallic smoothness or roughness maps;12;257;153;5;327;306;307;305;325;309;310;311;326;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;341;-2247.215,465.6237;Inherit;False;608.3015;424.2721;Vertex masks;4;173;234;195;216;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;340;-888.611,874.6564;Inherit;False;872.4778;494.614;Raw basecolor;4;2;105;260;263;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;339;-1153.394,345.6483;Inherit;False;1134.993;502.7232;Cooked base color;6;225;10;231;230;108;227;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;338;-1036.626,-167.0743;Inherit;False;1002.135;467.1762;Burned base color;4;30;259;258;112;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;337;-1241.834,-776.6802;Inherit;False;1194.675;582.535;Deep frying triplanar basecolor and normal;7;239;247;245;240;249;246;238;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;321;588.2633,1625.161;Inherit;False;2233.761;919.2097;Smoothness;20;336;335;294;334;322;314;284;313;293;317;312;315;295;316;287;292;286;288;283;285;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;320;704.066,129.1122;Inherit;False;1934.565;909.6399;Normals;14;266;280;279;268;269;271;276;277;281;275;278;331;332;333;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;318;698.0668,-870.4931;Inherit;False;1437.613;901.7849;Basecolor;15;218;110;241;254;255;235;114;180;196;175;77;233;328;329;330;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3538.784,321.8036;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HeneGames/CookingSystem/Cooking shader vertex colors;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.LerpOp;233;1953.682,-351.513;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;180;1154.736,-772.5312;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;1163.567,-126.075;Inherit;False;108;Cookedbasecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;254;1398.833,-209.3985;Inherit;False;Property;_Usecookedbasecolorfordeepfry;Use cooked basecolor for deep fry;24;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;241;1160.711,-219.101;Inherit;False;240;DeepFryBasecolor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;77;1613.082,-572.701;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;235;1445.469,-56.83936;Inherit;False;234;DeepFryeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;1298.485,-563.1742;Inherit;False;112;Burnedbasecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;266;1337.58,344.3331;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;268;2456.632,790.3093;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;269;1934.03,553.1208;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;1940.461,922.7521;Inherit;False;234;DeepFryeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;275;1552.819,827.1929;Inherit;False;Property;_Usecookednormalfordeepfry;Use cooked normal for deep fry;25;0;Create;True;0;0;0;False;0;False;1;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;278;752.9307,224.5379;Inherit;True;Property;_RawNormal1;Raw Normal;7;0;Create;True;0;0;0;False;0;False;-1;None;301f7c0c4d0adc44497eb0551ff90b34;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;279;757.7526,434.1122;Inherit;True;Property;_CookedNormal;Cooked Normal;8;0;Create;True;0;0;0;False;0;False;-1;None;301f7c0c4d0adc44497eb0551ff90b34;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;276;890.273,699.8459;Inherit;False;195;RawOrCookedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;280;1418.066,537.5515;Inherit;True;Property;_BurnedNormal;Burned Normal;9;0;Create;True;0;0;0;False;0;False;-1;None;301f7c0c4d0adc44497eb0551ff90b34;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;281;1256.209,827.7356;Inherit;False;247;DeepFryNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;285;2640.024,2276.109;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;283;1520.977,1830.141;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;2123.855,2408.551;Inherit;False;234;DeepFryeMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;2014.424,1967.927;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;292;1736.215,2312.992;Inherit;False;Property;_Usecookedroughnessfordeepfry;Use cooked roughness for deep fry;23;0;Create;True;0;0;0;False;0;False;1;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;729.1468,1674.285;Inherit;False;153;SmoothnessRaw;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;1057.804,1698.721;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;704.1569,1842.161;Inherit;False;307;SmoothnessCooked;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;315;686.0208,1918.743;Inherit;False;Property;_Cookedsmoothnessadjust;Cooked smoothness adjust;15;0;Create;True;0;0;0;False;0;False;1;0.7;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;312;1144.093,1891.894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;317;691.4762,1759.973;Inherit;False;Property;_Rawsmoothnessadjust;Raw smoothness adjust;12;0;Create;True;0;0;0;False;0;False;1;0.3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;885.6698,2037.651;Inherit;False;195;RawOrCookedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;1352.02,2095.741;Inherit;False;Property;_Burnedsmoothnessadjust;Burned smoothness adjust;18;0;Create;True;0;0;0;False;0;False;1;0.3;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;1361.729,2025.498;Inherit;False;310;SmoothnessBurned;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;1687.02,1998.744;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;322;1283.1,2312.377;Inherit;False;Property;_DeepFrySmoothness;Deep Fry Smoothness;21;0;Create;True;0;0;0;False;0;False;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;774.8027,-792.3427;Inherit;False;105;Rawbasecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;769.1368,-704.4931;Inherit;False;108;Cookedbasecolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;328;1723.93,-86.09082;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;218;1213.942,-412.1871;Inherit;False;216;BurnedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;709.3124,-531.2091;Inherit;False;195;RawOrCookedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;330;972.2037,-549.2759;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;329;1434.402,-409.4197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;331;1169.306,594.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;1580.787,744.678;Inherit;False;216;BurnedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;332;1765.306,709.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;333;2202.306,917.147;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;334;1144.14,1996.632;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;1642.185,2169.48;Inherit;False;216;BurnedMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;335;1839.14,2172.628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;336;2351.14,2390.627;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;239;-751.9708,-726.6802;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;247;-308.1357,-376.6591;Inherit;False;DeepFryNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TriplanarNode;245;-740.9933,-419.1442;Inherit;True;Spherical;Object;True;Top Texture 1;_TopTexture1;bump;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;-289.1601,-699.5511;Inherit;False;DeepFryBasecolor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-995.53,-512.196;Inherit;False;Property;_DeepFryTextureScale;DeepFryTextureScale;22;0;Create;True;0;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;246;-1191.834,-429.9395;Inherit;True;Property;_Deepfrynormalmap;Deep fry normalmap;20;0;Create;True;0;0;0;False;0;False;None;04065173de01f364caa87c562c3e2a6d;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;238;-1182.675,-726.2122;Inherit;True;Property;_Deepfrybasecolor;Deep fry basecolor;19;0;Create;True;0;0;0;False;0;False;None;52cb27f314c2548419b9784ad827a607;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;30;-986.6271,-117.0743;Inherit;True;Property;_BurnBaseColor;Burn Base Color;5;0;Create;True;0;0;0;False;0;False;-1;None;24a1d67dcf551b5499276865a2a808ee;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;-496.2788,-4.494594;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;258;-754.8798,88.1021;Inherit;False;Property;_Burncolortint;Burn color tint;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-270.4927,45.48291;Inherit;False;Burnedbasecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;-479.3411,527.5751;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;10;-1103.394,395.6483;Inherit;True;Property;_CookedBaseColor;Cooked Base Color;2;0;Create;True;0;0;0;False;0;False;-1;None;347d55f45475de24b99a6237b82d556b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;-690.8079,507.9253;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;230;-1083.891,636.3709;Inherit;False;Property;_Cookedcolortint;Cooked color tint;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;227;-840.7112,698.5536;Inherit;False;Property;_Cookedcolorbrightness;Cooked color brightness;4;0;Create;True;0;0;0;False;0;False;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-838.6118,932.7589;Inherit;True;Property;_RawBaseColor;Raw Base Color;0;0;Create;True;0;0;0;False;0;False;-1;None;eaea8b370a9c3b84a9ad42967ee0d2a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-240.1326,924.6564;Inherit;False;Rawbasecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;260;-461.4607,933.2706;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;263;-782.4613,1157.272;Inherit;False;Property;_Rawcolortint;Raw color tint;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;173;-2197.214,515.6237;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;-1894.877,660.7748;Inherit;False;DeepFryeMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;195;-1923.218,530.0667;Inherit;False;RawOrCookedMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;216;-1862.911,773.8959;Inherit;False;BurnedMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1217.654,1449.783;Inherit;True;Property;_RawRoughnessMetallicSmoothness;Raw Roughness/Metallic Smoothness;10;0;Create;True;0;0;0;False;0;False;2;None;ffbb4d5e8d9f5374aae1f99dbb2ceb92;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;327;-822.4216,1465.615;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;306;-589.8845,1802.939;Inherit;False;Property;_CookedMetallicSmoothness;Cooked Metallic Smoothness;14;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;307;-262.1339,1811.258;Inherit;False;SmoothnessCooked;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;305;-1235.734,1763.075;Inherit;True;Property;_CookedRoughnessMetallicSmoothness;Cooked Roughness/Metallic Smoothness;13;0;Create;True;0;0;0;False;0;False;-1;None;ffbb4d5e8d9f5374aae1f99dbb2ceb92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;325;-828.6384,1787.12;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;309;-634.8577,2071.489;Inherit;False;Property;_BurnedMetallicSmoothness;Burned Metallic Smoothness;17;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-302.7824,2075.557;Inherit;False;SmoothnessBurned;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;311;-1241.09,2063.648;Inherit;True;Property;_BurnedRoughnessMetallicSmoothness;Burned Roughness/Metallic Smoothness;16;0;Create;True;0;0;0;False;0;False;-1;None;ffbb4d5e8d9f5374aae1f99dbb2ceb92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;326;-837.09,2059.628;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;257;-564.0089,1491.474;Inherit;False;Property;_RawMetallicSmoothness;Raw Metallic Smoothness;11;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;-248.9881,1489.688;Inherit;False;SmoothnessRaw;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-257.402,526.3621;Inherit;False;Cookedbasecolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
WireConnection;0;0;233;0
WireConnection;0;1;268;0
WireConnection;0;4;285;0
WireConnection;233;0;77;0
WireConnection;233;1;254;0
WireConnection;233;2;328;0
WireConnection;180;0;175;0
WireConnection;180;1;110;0
WireConnection;180;2;330;0
WireConnection;254;0;241;0
WireConnection;254;1;255;0
WireConnection;77;0;180;0
WireConnection;77;1;114;0
WireConnection;77;2;329;0
WireConnection;266;0;278;0
WireConnection;266;1;279;0
WireConnection;266;2;331;0
WireConnection;268;0;269;0
WireConnection;268;1;275;0
WireConnection;268;2;333;0
WireConnection;269;0;266;0
WireConnection;269;1;280;0
WireConnection;269;2;332;0
WireConnection;275;0;281;0
WireConnection;275;1;279;0
WireConnection;285;0;286;0
WireConnection;285;1;292;0
WireConnection;285;2;336;0
WireConnection;283;0;316;0
WireConnection;283;1;312;0
WireConnection;283;2;334;0
WireConnection;286;0;283;0
WireConnection;286;1;314;0
WireConnection;286;2;335;0
WireConnection;292;0;322;0
WireConnection;292;1;312;0
WireConnection;316;0;287;0
WireConnection;316;1;317;0
WireConnection;312;0;295;0
WireConnection;312;1;315;0
WireConnection;314;0;284;0
WireConnection;314;1;313;0
WireConnection;328;0;235;0
WireConnection;330;0;196;0
WireConnection;329;0;218;0
WireConnection;331;0;276;0
WireConnection;332;0;277;0
WireConnection;333;0;271;0
WireConnection;334;0;293;0
WireConnection;335;0;294;0
WireConnection;336;0;288;0
WireConnection;239;0;238;0
WireConnection;239;3;249;0
WireConnection;247;0;245;0
WireConnection;245;0;246;0
WireConnection;245;3;249;0
WireConnection;240;0;239;0
WireConnection;259;0;30;0
WireConnection;259;1;258;0
WireConnection;112;0;259;0
WireConnection;225;0;231;0
WireConnection;225;1;227;0
WireConnection;231;0;10;0
WireConnection;231;1;230;0
WireConnection;105;0;260;0
WireConnection;260;0;2;0
WireConnection;260;1;263;0
WireConnection;234;0;173;2
WireConnection;195;0;173;1
WireConnection;216;0;173;4
WireConnection;327;0;5;0
WireConnection;306;0;325;0
WireConnection;306;1;305;4
WireConnection;307;0;306;0
WireConnection;325;0;305;0
WireConnection;309;0;326;0
WireConnection;309;1;311;4
WireConnection;310;0;309;0
WireConnection;326;0;311;0
WireConnection;257;0;327;0
WireConnection;257;1;5;4
WireConnection;153;0;257;0
WireConnection;108;0;225;0
ASEEND*/
//CHKSM=DA5546F6F6FC4A679DC87B4016CA268347F2C5E7