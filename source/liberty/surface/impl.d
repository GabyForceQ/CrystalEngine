/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/impl.d)
 * Documentation:
 * Coverage:
 */
module liberty.surface.impl;

import liberty.math.matrix;
import liberty.math.util;
import liberty.scene.node;
import liberty.core.platform;
import liberty.scene.impl;
import liberty.surface.ui.widget;
import liberty.services;

/**
 *
**/
abstract class Surface : SceneNode, IRenderable, IUpdatable {
  private {
    int xStart;
    int yStart;
    int width;
    int height;
    int zNear = -1;
    int zFar = 1;

    Matrix4F projectionMatrix = Matrix4F.identity();
    Widget[string] widgets;
  }

  /**
   *
  **/
  this(string id, SceneNode parent) {
    super(id, parent);
    updateProjection();
  }

  /**
   *
  **/
  package final Surface addWidget(Widget widget) {
    widgets[widget.getId()] = widget;
    return this;
  }
  
  /**
   *
  **/
  final Surface updateProjection(bool autoScale = true) {
    if (autoScale) {
      width = Platform.getWindow().getWidth();
      height = Platform.getWindow().getHeight();
    }
    
    projectionMatrix = MathUtils.getOrthographicMatrixFrom(
      cast(float)xStart, cast(float)width,
      cast(float)height, cast(float)yStart,
      cast(float)zNear, cast(float)zFar
    );
    
    getScene().getSurfaceShader().loadProjectionMatrix(projectionMatrix);
    return this;
  }

  /**
   *
  **/
  final Matrix4F getProjectionMatrix() pure nothrow const {
    return projectionMatrix;
  }

  /**
   *
  **/
  final override void render() {
    foreach (w; widgets)
      w.render();
  }

  /**
   *
  **/
  override void update() {
    foreach (w; widgets)
      w.update();
  }

  /**
   *
  **/
  final Widget[string] getWidgets() pure nothrow {
    return widgets;
  }

  /**
   *
  **/
  final Widget getWidget(string id) pure nothrow {
    return widgets[id];
  }
}