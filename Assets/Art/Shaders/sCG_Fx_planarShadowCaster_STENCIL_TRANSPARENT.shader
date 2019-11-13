
// IMPORTANT: 
// - This shader only works on y=0 plane.
// - The whole object must be above the y=0 plane.
// - Directional and point lights supported.
// - Supports non-uniform scale.
// - It uses the stencil buffer. The bit can be changed. Some weird devices won't support it.



// QUESTIONS:
// - Do you prefer alpha blend or multiply?
// - Setting floor height to 0 speeds things up a bunch. Is it a problem?
// - The parameters here should be specified globally in the game, not per-material. Besides, only one shadow material is needed.
// - Options for integrating the shadows in the game:
//     a) A new pass in the appropriate shaders.
//     b) Modify the prefabs by duplicating the GameObjects that have the SkinnedMeshRenderer, and assign this material to the new renderer.
//     c) Programatically loop renderers with Cast Shadows ON and render them using this material.
//     d) Programatically loop GameObjects that have a custom component and render them using this material.



Shader "socialPointCG/sCG_Fx_planarShadowCaster_STENCIL_TRANSPARENT" {
	Properties {
		_GlobalPlanarShadowColor("Shadow Color",Color) = (0.275, 0.225, 0.35, 0.25)
		_GlobalPlanarShadowsStencilBitMask("Stencil bit mask", Float) = 1.0
	}
	
	SubShader {
		
		// INI TAGS & PROPERTIES ------------------------------------------------------------------------------------------------------------------------------------
		Tags { 	
			//- HELP: http://docs.unity3d.com/Manual/SL-SubshaderTags.html
			
			//"Queue"="Background " 	// this render queue is rendered before any others. It is used for skyboxes and the like.
			//"Queue"="Geometry" 		// (default) - this is used for most objects. Opaque geometry uses this queue.
			//"Queue"="AlphaTest" 		// alpha tested geometry uses this queue.
			"Queue"="Transparent" 	// alpha blend pixels here!
			//"Queue"="Overlay" 		// Anything rendered last should go in overlays i.e. lens flares
			
			
			//- HELP: http://docs.unity3d.com/Manual/SL-PassTags.html
			
			//"LightMode" = "Always" 			// Always rendered; no lighting is applied.
			"LightMode" = "ForwardBase"			// Used in Forward rendering, ambient, main directional light and vertex/SH lights are applied.
			//"LightMode" = "ForwardAdd"		// Used in Forward rendering; additive per-pixel lights are applied, one pass per light.
			//"LightMode" = "Pixel"				// ??
			//"LightMode" = "PrepassBase"		// deferred only...
			//"LightMode" = "PrepassFinal"		// deferred only...
			//"LightMode" = "Vertex"			// Used in Vertex Lit rendering when object is not lightmapped; all vertex lights are applied.
			//"LightMode" = "VertexLMRGBM"		// VertexLMRGBM: Used in Vertex Lit rendering when object is lightmapped; on platforms where lightmap is RGBM encoded.
			//"LightMode" = "VertexLM"			// Used in Vertex Lit rendering when object is lightmapped; on platforms where lightmap is double-LDR encoded (generally mobile platforms and old dekstop GPUs).
			//"LightMode" = "ShadowCaster"		// Renders object as shadow caster.
			//"LightMode" = "ShadowCollector"	// Gathers object’s shadows into screen-space buffer for Forward rendering path.
						
			//"IgnoreProjector"="True" 
		}
		
		//- HELP: http://docs.unity3d.com/Manual/SL-Blend.html
		
		Blend SrcAlpha OneMinusSrcAlpha 	// Alpha blending
		//Blend One One 					// Additive
		//Blend OneMinusDstColor One 		// Soft Additive (screen)
		//Blend DstColor Zero 				// Multiplicative
		
		Fog {Mode Global} // MODE: Off | Global | Linear | Exp | Exp
		
		//- HELP: http://docs.unity3d.com/Manual/SL-Pass.html
		
	    //Lighting OFF 	//Turn vertex lighting on or off
	    ZWrite OFF	//Set depth writing mode
	    //Cull OFF 		//Back | Front | Off = two sided
		//ZTest Always  //Always = paint always front (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
		//AlphaTest 	//(Less | Greater | LEqual | GEqual | Equal | NotEqual | Always) CutoffValue
		
		// This way shadow is drawn on top of the previous geometry.
		Offset -1.0, -1.0 

		// Stenciling avoids overlapping multiple shadows, but doesn't work with distance falloff.
		Stencil
		{
			Ref [_GlobalPlanarShadowsStencilBitMask]
			Comp NotEqual
			Pass Replace
			Fail Keep
			ZFail Keep
			ReadMask [_GlobalPlanarShadowsStencilBitMask]
			WriteMask [_GlobalPlanarShadowsStencilBitMask]
		}

		// END TAGS & PROPERTIES ------------------------------------------------------------------------------------------------------------------------------------
		
		Pass {
		
        CGPROGRAM
 		
		#pragma vertex vert 
		#pragma fragment frag
		#include "UnityCG.cginc"

		//user defined variables
		uniform fixed4 _GlobalPlanarShadowColor;

		//base input structs
		struct vertexInput {
			float4 vertex : POSITION;
		};
		struct vertexOutput {
			float4 shadowPos : SV_POSITION;
			fixed4 shadowColor : COLOR0;
		};

		//vertex function
		vertexOutput vert(vertexInput v)
		{
			vertexOutput o;

			// Calculations are done in world space.
			float4 posWS = mul(unity_ObjectToWorld, v.vertex);

			// This helps avoid a funky artifact in case the mesh is partially under the y=0 plane.
			posWS.y = max(0.0, posWS.y); 

			half3 lightDirWS;
			if (0.0 != _WorldSpaceLightPos0.w)
			{
				// point or spot light
				lightDirWS = normalize(posWS.xyz - _WorldSpaceLightPos0.xyz);
			}
			else
			{
				// directional light
				lightDirWS = -normalize(_WorldSpaceLightPos0.xyz);				
			}

			// Project the world space vertex to the y=0 plane
			float4 projectedPosWS = posWS;
			projectedPosWS.x -= posWS.y / lightDirWS.y * lightDirWS.x;
			projectedPosWS.z -= posWS.y / lightDirWS.y * lightDirWS.z;
			projectedPosWS.y = 0;
			
			float distanceToPlane = length( posWS.xyz - projectedPosWS.xyz );
			o.shadowColor = _GlobalPlanarShadowColor; //the color we pick in material

			o.shadowPos = mul(UNITY_MATRIX_VP, projectedPosWS);
			
			return o;
		}

		fixed4 frag(vertexOutput i) : COLOR{
			return i.shadowColor;
		}

		ENDCG
      }
	} 
}

