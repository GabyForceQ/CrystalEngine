/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/framework/primitive/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.framework.primitive.impl;

import liberty.logger.impl;
import liberty.model.impl;
import liberty.scene.entity;
import liberty.graphics.shader.impl;

/**
 *
**/
abstract class Primitive : Entity {
  private {
    Shader shader;
  }

  /**
   *
  **/
  this(string id) {
    super(id);

    shader = Shader
      .getOrCreate("Primitive", (shader) {
        shader
          .addGlobalRenderMethod((program) {
            program.loadUniform("uSkyColor", scene.world.getExpHeightFogColor);
          })
          .addPerEntityRenderMethod((program) {
            program.loadUniform("uUseFakeLighting", model.fakeLightingEnabled);
          });
      });

    shader.registerEntity(this);
    scene.shaderMap[shader.id] = shader;
  }
}

/**
 *
**/
abstract class UniquePrimitive : Primitive {
  private static bool hasInstance;
  /**
   *
  **/
  this(string id) {
    if (this.hasInstance) {
      Logger.error(
        "Cannot have multiple instances", 
        typeof(this).stringof
      );
    }
    super(id);
    this.hasInstance = true;
  }
}