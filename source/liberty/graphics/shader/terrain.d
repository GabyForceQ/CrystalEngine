/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/shader/terrain.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.shader.terrain;

import std.conv : to;

import liberty.math.matrix : Matrix4F;
import liberty.math.vector : Vector2F, Vector3F;
import liberty.graphics.shader.impl : Shader;

/**
 *
**/
class TerrainShader : Shader {
  private {
    static immutable TERRAIN_VERTEX = q{
      #version 450 core

      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec3 lNormal;
      layout (location = 2) in vec2 lTexCoord;

      out vec3 tNormal;
      out vec2 tTexCoord;
      out vec3 tToLightVector[4];
      out vec3 tToCameraVector;
      out float tVisibility;
      
      uniform mat4 uModelMatrix;
      uniform mat4 uViewMatrix;
      uniform mat4 uProjectionMatrix;
      uniform vec3 uLightPosition[4];

      const float density = 0.006;
      const float gradient = 1.2;

      void main() {
        tTexCoord = lTexCoord;
        tNormal = (uModelMatrix * vec4(lNormal, 0.0)).xyz;

        vec4 worldPosition = uModelMatrix * vec4(lPosition, 1.0);
        for (int i = 0; i < 4; i++) {
          tToLightVector[i] = uLightPosition[i] - worldPosition.xyz;
        }
        tToCameraVector = (inverse(uViewMatrix) * vec4(0.0, 0.0, 0.0, 1.0)).xyz - worldPosition.xyz;

        // Compute exponential heigh fog
        vec4 positionRelativeToCamera = uViewMatrix * worldPosition;
        float distance = length(positionRelativeToCamera.xyz);
        tVisibility = exp(-pow((distance * density), gradient));
        tVisibility = clamp(tVisibility, 0.0, 1.0);

        // Compute vertex position
        gl_Position = uProjectionMatrix * uViewMatrix * worldPosition;
      }
    };

    static immutable TERRAIN_FRAGMENT = q{
      #version 450 core

      in vec3 tNormal;
      in vec2 tTexCoord;
      in vec3 tToLightVector[4];
      in vec3 tToCameraVector;
      in float tVisibility;

      uniform sampler2D uBackgroundTexture;
      uniform sampler2D uRTexture;
      uniform sampler2D uGTexture;
      uniform sampler2D uBTexture;
      uniform sampler2D uBlendMap;

      uniform vec2 uTexCoordMultiplier;
      uniform vec3 uLightColor[4];
      uniform vec3 uLightAttenuation[4];
      uniform float uShineDamper;
      uniform float uReflectivity;
      uniform vec3 uSkyColor;
      
      void main() {
        // Compute terrain textures
        vec4 blendMapColor = texture(uBlendMap, tTexCoord);
        float backTextureAmount = 1 - (blendMapColor.r + blendMapColor.g + blendMapColor.b);
        vec2 tiledTexCoords = tTexCoord * uTexCoordMultiplier;
        vec4 backgroundTextureColor = texture(uBackgroundTexture, tiledTexCoords) * backTextureAmount;
        vec4 rTextureColor = texture(uRTexture, tiledTexCoords) * blendMapColor.r;
        vec4 gTextureColor = texture(uGTexture, tiledTexCoords) * blendMapColor.g;
        vec4 bTextureColor = texture(uBTexture, tiledTexCoords) * blendMapColor.b;
        vec4 totalTextureColor = backgroundTextureColor + rTextureColor + gTextureColor + bTextureColor;

        vec3 unitNormal = normalize(tNormal);
        vec3 unitVectorToCamera = normalize(tToCameraVector);

        vec3 totalDiffuse = vec3(0.0);
        vec3 totalSpecular = vec3(0.0);

        for (int i = 0; i < 4; i++) {
          float distance = length(tToLightVector[i]);
          float attenuationFactor = uLightAttenuation[i].x + 
            (uLightAttenuation[i].y * distance) + 
            (uLightAttenuation[i].z * distance * distance);
          vec3 unitLightVector = normalize(tToLightVector[i]);

          float dotComputation = dot(unitNormal, unitLightVector);
          float brightness = max(dotComputation, 0.0);
          vec3 lightDirection = -unitLightVector;
          vec3 reflectedLightDirection = reflect(lightDirection, unitNormal);
          float specularFactor = dot(reflectedLightDirection, unitVectorToCamera);
          specularFactor = max(specularFactor, 0.0);
          float dampedFactor = pow(specularFactor, uShineDamper);
          totalDiffuse += (brightness * uLightColor[i]) / 2*attenuationFactor;
          totalSpecular += (dampedFactor * uReflectivity * uLightColor[i]) / 2*attenuationFactor;
        }

        totalDiffuse = max(totalDiffuse, 0.4);

        // Mix sky color with finalTexture
        gl_FragColor = mix(vec4(uSkyColor, 1.0), vec4(totalDiffuse, 1.0) * totalTextureColor + vec4(totalSpecular, 1.0), tVisibility);
      }
    };
  }

  /**
   *
  **/
  this() {
    compileShaders(TERRAIN_VERTEX, TERRAIN_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lNormal")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uModelMatrix")
      .addUniform("uViewMatrix")
      .addUniform("uProjectionMatrix")
      .addUniform("uLightPosition[0]")
      .addUniform("uLightPosition[1]")
      .addUniform("uLightPosition[2]")
      .addUniform("uLightPosition[3]")
      .addUniform("uLightColor[0]")
      .addUniform("uLightColor[1]")
      .addUniform("uLightColor[2]")
      .addUniform("uLightColor[3]")
      .addUniform("uLightAttenuation[0]")
      .addUniform("uLightAttenuation[1]")
      .addUniform("uLightAttenuation[2]")
      .addUniform("uLightAttenuation[3]")
      .addUniform("uBackgroundTexture")
      .addUniform("uRTexture")
      .addUniform("uGTexture")
      .addUniform("uBTexture")
      .addUniform("uBlendMap")
      .addUniform("uShineDamper")
      .addUniform("uReflectivity")
      .addUniform("uTexCoordMultiplier")
      .addUniform("uSkyColor")
      .unbind();
  }

  /**
   *
  **/
  TerrainShader loadModelMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uModelMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadViewMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uViewMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadProjectionMatrix(Matrix4F matrix) {
    bind();
    loadUniform("uProjectionMatrix", matrix);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadLightPosition(uint index, Vector3F position) {
    bind();
    loadUniform("uLightPosition[" ~ index.to!string ~ "]", position);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadLightColor(uint index, Vector3F color) {
    bind();
    loadUniform("uLightColor[" ~ index.to!string ~ "]", color);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadLightAttenuation(uint index, Vector3F attenuation) {
    bind();
    loadUniform("uLightAttenuation[" ~ index.to!string ~ "]", attenuation);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadBackgroundTexture(int id) {
    bind();
    loadUniform("uBackgroundTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadRTexture(int id) {
    bind();
    loadUniform("uRTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadGTexture(int id) {
    bind();
    loadUniform("uGTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadBTexture(int id) {
    bind();
    loadUniform("uBTexture", id);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadBlendMap(int id) {
    bind();
    loadUniform("uBlendMap", id);
    unbind();
    return this;
  }
  
  /**
   *
  **/
  TerrainShader loadShineDamper(float value) {
    bind();
    loadUniform("uShineDamper", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadReflectivity(float value) {
    bind();
    loadUniform("uReflectivity", value);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadTexCoordMultiplier(Vector2F multiplier) {
    bind();
    loadUniform("uTexCoordMultiplier", multiplier);
    unbind();
    return this;
  }

  /**
   *
  **/
  TerrainShader loadSkyColor(Vector3F color) {
    bind();
    loadUniform("uSkyColor", color);
    unbind();
    return this;
  }
}