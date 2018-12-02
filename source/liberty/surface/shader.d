/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/shader.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.shader;

import liberty.math.matrix;
import liberty.graphics.shader;

/**
 *
**/
final class SurfaceShader : GfxShaderProgram {
  private {
    static immutable UI_VERTEX = GFX_SHADER_CORE_VERSION ~ q{
      layout (location = 0) in vec3 lPosition;
      layout (location = 1) in vec2 lTexCoord;

      out vec2 tTexCoord;

      uniform mat4 uModelMatrix;
      uniform mat4 uProjectionMatrix;
      uniform int uZIndex;

      void main() {
        tTexCoord = lTexCoord;

        gl_Position = uProjectionMatrix * uModelMatrix *
          vec4(vec3(lPosition.x, lPosition.y, lPosition.z + uZIndex), 1.0);
      }
    };

    static immutable UI_FRAGMENT = GFX_SHADER_CORE_VERSION ~ q{
      in vec2 tTexCoord;
      
      uniform sampler2D uTexture;

      void main() {
        gl_FragColor = texture(uTexture, tTexCoord) * vec4(1.0, 1.0, 1.0, 1.0);
      }
    };
  }

  /**
   *
  **/
  this() {
    this
      .compileShaders(UI_VERTEX, UI_FRAGMENT)
      .linkShaders()
      .bindAttribute("lPosition")
      .bindAttribute("lTexCoord")
      .bind()
      .addUniform("uModelMatrix")
      .addUniform("uProjectionMatrix")
      .addUniform("uZIndex")
      .addUniform("uTexture")
      .loadTexture(0)
      .unbind();
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadModelMatrix(Matrix4F matrix) {
    super.loadUniform("uModelMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadProjectionMatrix(Matrix4F matrix) {
    super.loadUniform("uProjectionMatrix", matrix);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadZIndex(int value) {
    super.loadUniform("uZIndex", value);
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) loadTexture(int id) {
    super.loadUniform("uTexture", id);
    return this;
  }
}