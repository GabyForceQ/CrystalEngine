/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/renderer.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.renderer;

import liberty.scene.node;
import liberty.model;
import liberty.surface.impl;
import liberty.surface.ui.widget;
import liberty.graphics.vertex;
import liberty.meta;
import liberty.surface.model;
import liberty.terrain;
import liberty.primitive.model;

/**
 *
**/
@Component
class Renderer(VERTEX, NODETYPE = SceneNode) {
  private {
    static if (is(VERTEX == PrimitiveVertex))
      alias RendererModel = PrimitiveModel;
    else static if (is(VERTEX == TerrainVertex))
      alias RendererModel = TerrainModel;
    else static if (is(VERTEX == SurfaceVertex))
      alias RendererModel = SurfaceModel;

    static if (is(NODETYPE == SceneNode))
      alias RendererNode = SceneNode;
    else static if (is(NODETYPE == Surface))
      alias RendererNode = Widget;
    
    RendererNode parent;
    RendererModel model;
  }

  /**
   *
  **/
  this(RendererNode parent, RendererModel model) pure nothrow {
    this.parent = parent;
    this.model = model;
  }

  /**
   *
  **/
  void draw() {
    static if (is(VERTEX == PrimitiveVertex))
      parent.getScene().getprimitiveShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == TerrainVertex))
      parent.getScene().getTerrainShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else static if (is(VERTEX == SurfaceVertex))
      parent.getSurface().getScene().getSurfaceShader().loadModelMatrix(parent.getTransform().getModelMatrix());
    else
      assert(0, "Unreachable");

    model.draw();
  }

  /**
   *
  **/
  RendererNode getParent() pure nothrow {
    return parent;
  }

  /**
   * Returns reference to this.
  **/
  Renderer!(VERTEX, NODETYPE) setModel(RendererModel model) pure nothrow {
    this.model = model;
    return this;
  }

  /**
   *
  **/
  RendererModel getModel() pure nothrow {
    return model;
  }
}