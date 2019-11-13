// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASE/shd_UVanimatedMaskAdditiveCull"
{
	Properties
	{
		[NoScaleOffset]_Diffuse01("Diffuse01", 2D) = "black" {}
		_Diffuse02("Diffuse02", 2D) = "white" {}
		_TilingSpeed("Tiling / Speed", Vector) = (1,1,1,0)
		_TilingSpeed02("Tiling / Speed 02", Vector) = (1,1,1,0)
		_Color("Color", Color) = (0,0,0,0)
		_Fade01("Fade01", Range( 0 , 2)) = 1
		_Fade02("Fade02", Range( 0 , 2)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		Blend One One
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform half4 _Color;
		uniform sampler2D _Diffuse01;
		uniform half4 _TilingSpeed;
		uniform half _Fade01;
		uniform sampler2D _Diffuse02;
		uniform half4 _TilingSpeed02;
		uniform half _Fade02;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			half2 appendResult4 = (half2(_TilingSpeed.z , _TilingSpeed.w));
			half2 appendResult2 = (half2(_TilingSpeed.x , _TilingSpeed.y));
			float2 uv_TexCoord5 = i.uv_texcoord * appendResult2;
			half2 panner6 = ( 0.1 * _Time.y * appendResult4 + uv_TexCoord5);
			half4 temp_output_12_0 = ( tex2D( _Diffuse01, panner6 ) * _Fade01 );
			half2 appendResult16 = (half2(_TilingSpeed02.z , _TilingSpeed02.w));
			half2 appendResult15 = (half2(_TilingSpeed02.x , _TilingSpeed02.y));
			float2 uv_TexCoord17 = i.uv_texcoord * appendResult15;
			half2 panner18 = ( 0.1 * _Time.y * appendResult16 + uv_TexCoord17);
			half4 temp_output_22_0 = ( tex2D( _Diffuse02, panner18 ) * _Fade02 );
			half4 blendOpSrc23 = temp_output_12_0;
			half4 blendOpDest23 = temp_output_22_0;
			o.Emission = ( ( _Color * ( saturate( (( blendOpDest23 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest23 ) * ( 1.0 - blendOpSrc23 ) ) : ( 2.0 * blendOpDest23 * blendOpSrc23 ) ) )) ) * i.vertexColor.a ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
1920;0;1920;1029;1263.755;253.0249;1;True;False
Node;AmplifyShaderEditor.Vector4Node;1;-2189.919,34.7632;Half;False;Property;_TilingSpeed;Tiling / Speed;2;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;14;-2189.359,456.8374;Half;False;Property;_TilingSpeed02;Tiling / Speed 02;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;2;-1911.62,19.7599;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-1911.06,441.8342;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-1911.319,126.4649;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1708.967,-46.34171;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1708.407,375.7325;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1910.759,548.5391;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;6;-1440.818,83.8555;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;18;-1440.258,505.9296;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;9;-1214.278,463.3434;Inherit;True;Property;_Diffuse02;Diffuse02;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1218.403,65.82837;Inherit;True;Property;_Diffuse01;Diffuse01;0;1;[NoScaleOffset];Create;True;0;0;False;0;None;c60cb50bf342e484d80c68c42cab12d9;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-912.5548,161.2849;Inherit;False;Property;_Fade01;Fade01;6;0;Create;True;0;0;False;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-984.6496,702.4006;Inherit;False;Property;_Fade02;Fade02;7;0;Create;True;0;0;False;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-705.5157,521.0345;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-598.4537,67.71152;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;10;-372.3096,-160.632;Inherit;False;Property;_Color;Color;5;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;23;-358.37,127.1303;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;20;-124.5778,471.4423;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-76.06548,27.93909;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-383.8963,305.9492;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;128.345,95.45709;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;300.7029,5.471804;Half;False;True;2;ASEMaterialInspector;0;0;Unlit;ASE/shd_UVanimatedMaskAdditiveCull;False;False;False;False;True;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;2
WireConnection;15;0;14;1
WireConnection;15;1;14;2
WireConnection;4;0;1;3
WireConnection;4;1;1;4
WireConnection;5;0;2;0
WireConnection;17;0;15;0
WireConnection;16;0;14;3
WireConnection;16;1;14;4
WireConnection;6;0;5;0
WireConnection;6;2;4;0
WireConnection;18;0;17;0
WireConnection;18;2;16;0
WireConnection;9;1;18;0
WireConnection;7;1;6;0
WireConnection;22;0;9;0
WireConnection;22;1;21;0
WireConnection;12;0;7;0
WireConnection;12;1;13;0
WireConnection;23;0;12;0
WireConnection;23;1;22;0
WireConnection;11;0;10;0
WireConnection;11;1;23;0
WireConnection;8;0;12;0
WireConnection;8;1;22;0
WireConnection;24;0;11;0
WireConnection;24;1;20;4
WireConnection;0;2;24;0
ASEEND*/
//CHKSM=E2C369D52234414DC1D619F26ED2D673C3AD837C