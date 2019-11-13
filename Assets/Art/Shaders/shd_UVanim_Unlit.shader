// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/shd_UVanim_Unlit"
{
	Properties
	{
		_Strength("Strength", Float) = 1
		_Color_Bright("Color_Bright", Color) = (1,1,1,0)
		_Color_Dark("Color_Dark", Color) = (0,0,0,0)
		[NoScaleOffset]_Texture("Texture", 2D) = "black" {}
		_TilingSpeed("Tiling / Speed", Vector) = (1,1,1,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Unlit keepalpha noshadow nodirlightmap 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform half _Strength;
		uniform half4 _Color_Dark;
		uniform half4 _Color_Bright;
		uniform sampler2D _Texture;
		uniform half4 _TilingSpeed;
		uniform half2 _Offset;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult86 = (float2(_TilingSpeed.z , _TilingSpeed.w));
			float2 appendResult85 = (float2(_TilingSpeed.x , _TilingSpeed.y));
			float2 uv_TexCoord11 = i.uv_texcoord * appendResult85 + _Offset;
			float2 panner9 = ( 0.1 * _Time.y * appendResult86 + uv_TexCoord11);
			float4 lerpResult88 = lerp( _Color_Dark , _Color_Bright , tex2D( _Texture, panner9 ));
			o.Emission = ( _Strength * lerpResult88 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
0;0;1920;1149;2812.19;1325.354;1.672225;True;False
Node;AmplifyShaderEditor.Vector4Node;84;-1591.814,-206.8856;Half;False;Property;_TilingSpeed;Tiling / Speed;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;85;-1313.516,-221.8889;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;92;-1312.2,28.84827;Half;False;Property;_Offset;Offset;5;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;86;-1313.215,-115.1839;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1110.863,-287.9905;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-842.7133,-157.7933;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;89;-515.4802,-576.3235;Half;False;Property;_Color_Dark;Color_Dark;2;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;78;-517.7972,-392.5476;Half;False;Property;_Color_Bright;Color_Bright;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-508.1513,-185.2565;Inherit;True;Property;_Texture;Texture;3;1;[NoScaleOffset];Create;True;0;0;False;0;None;c60cb50bf342e484d80c68c42cab12d9;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;88;-56.76056,-224.7827;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;0.8140869,-449.0986;Half;False;Property;_Strength;Strength;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;226.3173,-271.2056;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;82;513.1149,-194.5464;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;ASE/shd_UVanim_Unlit;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;True;Opaque;;Geometry;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;0;False;-1;2;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;85;0;84;1
WireConnection;85;1;84;2
WireConnection;86;0;84;3
WireConnection;86;1;84;4
WireConnection;11;0;85;0
WireConnection;11;1;92;0
WireConnection;9;0;11;0
WireConnection;9;2;86;0
WireConnection;4;1;9;0
WireConnection;88;0;89;0
WireConnection;88;1;78;0
WireConnection;88;2;4;0
WireConnection;91;0;90;0
WireConnection;91;1;88;0
WireConnection;82;2;91;0
ASEEND*/
//CHKSM=561485BCFE03660EEF4B4D274154DAB0EE9D7D55