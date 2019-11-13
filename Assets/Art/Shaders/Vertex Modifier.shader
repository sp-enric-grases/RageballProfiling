// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Vertex Modifier" {
	Properties{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Amount("Height Adjustment", Range(0,1)) = 1.0
		_Color("Color", Color) = (1, 1, 1, 1)
	}

		SubShader{
			Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
			LOD 100

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			Pass {
				CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
                    #pragma multi_compile_instancing
					#pragma multi_compile_fog

					#include "UnityCG.cginc"

					struct appdata_t {
						float4 vertex : POSITION;
						float2 texcoord : TEXCOORD0;
						UNITY_VERTEX_INPUT_INSTANCE_ID
					};

					struct v2f {
						float4 vertex : SV_POSITION;
						half2 texcoord : TEXCOORD0;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
						UNITY_FOG_COORDS(1)
					};

					sampler2D _MainTex;
					float4 _MainTex_ST;

					UNITY_INSTANCING_BUFFER_START(Props)
						UNITY_DEFINE_INSTANCED_PROP(float, _Amount)
						UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
					UNITY_INSTANCING_BUFFER_END(Props)
					v2f vert(appdata_t v)
					{
						v2f o;

                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_TRANSFER_INSTANCE_ID(v, o); // necessary only if you want to access instanced properties in the fragment Shader.

						v.vertex.x *= UNITY_ACCESS_INSTANCED_PROP(Props, _Amount);
						o.vertex = UnityObjectToClipPos(v.vertex);
						v.texcoord.x *= UNITY_ACCESS_INSTANCED_PROP(Props, _Amount);
						o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
						UNITY_TRANSFER_FOG(o,o.vertex);
						return o;
					}

					fixed4 frag(v2f i) : SV_Target
					{
                        UNITY_SETUP_INSTANCE_ID(i);
						fixed4 col = tex2D(_MainTex, i.texcoord) * UNITY_ACCESS_INSTANCED_PROP(Props, _Color);
						UNITY_APPLY_FOG(i.fogCoord, col);
						return col;
					}
				ENDCG
			}
	}
}