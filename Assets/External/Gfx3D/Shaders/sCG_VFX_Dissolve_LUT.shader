
Shader "socialPointCG/sCG_VFX_Dissolve_LUT" {
Properties {
    [Header(Diffuse)]
                        _MainTex ("(A)Texture (G)Emissive (B)DetailMap (A)Alpha", 2D) = "white" {}
                        _EmissiveColor ("Emissive Color", Color) = (0, 0, 0, 1)
                        _EmissiveMul ("Emissive Multiplier", Float) = 0
[Space]                        
    [Header(LUT)]
    [Toggle(USE_LUT)]   _UseLUT ("Enable LUT", Float) = 0
    [NoScaleOffset]     _LUT("LUT Texture", 2D) = "grey" {}
                        _ScrollLUT("Scroll LUT", Float) = 0
[Space]
    [Header(Detail)]
                        _ShearX ("Shear U", Float ) = 0
                        _ShearY ("Shear V", Float ) = 0
                        _ScrollX ("Scroll X", Float) = 0
                        _ScrollY ("Scroll Y", Float) = 0
                        _DetailMultiplier ("Detail Multiplier", Float) = 0
                        _ScrollDetail ("XY Scroll direction / ZW Tiling Multiplier", Vector) = (0, 0, 0, 0)
    [Header(Alpha)]
                        _DetailAlphaMultiplier("Alpha Detail", Range(0, 1)) = 0
                        _ScrollAlpha ("XY Scroll Alpha / ZW Tiling Alpha", Vector) = (0, 0, 1, 1)
                        [KeywordEnum(Dissolve, Alpha, Both)]    _AlphaType ("Fade Way", Float) = 1
                        _DRamp ("Dissolve Ramp", Range(0.0001, 1)) = 0.1
    [Toggle(ALPHA_MULTIPLIES_RGB)] _AlphaMultipliesRGB("RGB * ALPHA", Float) = 0
    [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Blend source", Int) = 3
    [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Blend destination", Int) = 9
	[Enum(UnityEngine.Rendering.CullMode)]  _CullMode("Cull mode", Int) = 2
}

Category {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
	Blend [_SrcBlend] [_DstBlend]    
    ColorMask RGB
    Cull [_CullMode]
    Lighting Off 
    ZWrite Off

    SubShader {
        Pass {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fwdbase
            #pragma multi_compile_particles
            #pragma multi_compile_fog

            #pragma multi_compile _ALPHATYPE_DISSOLVE _ALPHATYPE_ALPHA _ALPHATYPE_BOTH

            #pragma shader_feature USE_LUT
        	#pragma shader_feature ALPHA_MULTIPLIES_RGB

            #include "UnityCG.cginc"

            sampler2D   _MainTex;
            sampler2D   _LUT;
            fixed4      _EmissiveColor;
            fixed       _EmissiveMul;
            fixed       _ScrollLUT;
            float       _ShearX;
            float       _ShearY;
            float4      _ScrollDetail;
            fixed       _DetailMultiplier;
            float       _ScrollX;
            float       _ScrollY;
            fixed       _DRamp;
            fixed4      _MainTex_ST;
            fixed4      _ScrollAlpha;
            fixed       _DetailAlphaMultiplier;


            struct appdata_t {
                float4  vertex :    POSITION;
                fixed4  color :     COLOR;
                float2  texcoord :  TEXCOORD0;
                float2  texcoord1 : TEXCOORD1;
                float2  texcoord2 : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4  vertex :    SV_POSITION;
                fixed4  color :     COLOR;
                float2  texcoord :  TEXCOORD0;
                float2  texcoord1 : TEXCOORD1;
                float2  texcoord2 : TEXCOORD2;
                UNITY_FOG_COORDS(1)

                UNITY_VERTEX_OUTPUT_STEREO
            };


            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);

                o.color = v.color;

                float2   UShear = float2(_ShearX * v.texcoord.g, _ShearY * v.texcoord.r);

                float2  UVOffset = float2(_ScrollX, _ScrollY) * _Time.x;
                float2  UVBase = TRANSFORM_TEX(v.texcoord,_MainTex);
                o.texcoord = UVBase + UVOffset + UShear;

                float2  UVAnim = float2(_ScrollDetail.xy) * _Time.x;
                float2  UVTiling = float2(_ScrollDetail.zw);
                o.texcoord1 = (o.texcoord * UVTiling)+ UVAnim;

                float2  AlphaAnim = float2(_ScrollAlpha.xy) * _Time.x;
                float2  AlphaTiling = float2(_ScrollAlpha.zw);
                o.texcoord2 = (o.texcoord * AlphaTiling)+ AlphaAnim;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {

//          BASES

                fixed4  TXTB = tex2D(_MainTex, i.texcoord);
                fixed4  TXTD = tex2D(_MainTex, i.texcoord1);
                fixed4  TXTA = lerp(1, tex2D(_MainTex, i.texcoord2), _DetailAlphaMultiplier) ;

//          ALPHA

                fixed	p = _DRamp * 2;

                fixed   low1 = 0;
                fixed   low2 = 0-p;
                fixed   high1 = 1;
                fixed   high2 = 1 + p;
                fixed   DALPHA = low2 + (i.color.a - low1) * (high2 - low2) / (high1 - low1);

                fixed   baseAlpha = 1 - (TXTB.a * TXTA.b);
				fixed	pPlus = saturate(DALPHA + p);
				fixed	pMinus = saturate(DALPHA - p);
				fixed	dissolve = smoothstep(pMinus, pPlus, baseAlpha);

                #if _ALPHATYPE_DISSOLVE
                    fixed   ALPHA = 1 - dissolve;
                #endif

                #if _ALPHATYPE_ALPHA
                    fixed   ALPHA = i.color.a * TXTB.a * TXTA.b;
                #endif

                #if _ALPHATYPE_BOTH
                    fixed   ALPHA = (1 - dissolve) * i.color.a;
                #endif

//          COLOR

                fixed   TXT = TXTB.r + (TXTB * TXTD.b * _DetailMultiplier);

                float   sTime = _Time.g * _ScrollLUT;
                float2	lutUV = float2(TXT + sTime, 0);
				fixed4	LUT = tex2D(_LUT, lutUV);

                #ifdef  USE_LUT
                    fixed4  DIFFUSE = LUT;
                #else
                    fixed4  DIFFUSE = TXT.r;
                #endif

			    #if ALPHA_MULTIPLIES_RGB
                    DIFFUSE.rgb *= ALPHA;
                #endif

                fixed4  EMISSIVE = TXTB.g * _EmissiveColor * _EmissiveMul * ALPHA;

//          COMPLETE

                fixed4  col = (DIFFUSE * i.color) + EMISSIVE;
                col.a = saturate(ALPHA);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
}
