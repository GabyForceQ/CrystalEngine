/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/primitive/mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.primitive.mesh;

import liberty.graphics.renderer;
import liberty.primitive.model;
import liberty.graphics.entity;
import liberty.meta;
import liberty.graphics.vertex;
import liberty.graphics.material.impl;

/**
 *
**/
final class StaticMesh : Entity!PrimitiveVertex {
  mixin(NodeBody);

  /**
   *
  **/
  void constructor() {
    renderer = new Renderer!PrimitiveVertex(this, new PrimitiveModel([Material.getDefault()]));
  }

  /**
   *
  **/
  override void render() {
    getScene()
      .getprimitiveShader()
      .loadUseFakeLighting(renderer.getModel().getUseFakeLighting());

    super.render();
  }
}