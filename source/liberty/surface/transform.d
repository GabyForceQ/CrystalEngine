/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/transform.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.transform;

import liberty.math.vector;
import liberty.math.matrix;
import liberty.math.util;
import liberty.surface.widget;
import liberty.core.platform;
import liberty.scene.meta;

/**
 *
**/
@Component
final class Transform2D {
  private {
    Widget parent;
    Matrix4F modelMatrix = Matrix4F.identity();

    Vector2I position = Vector2I.zero;
    Vector2I extent = Vector2I(100, 100);
  }

  /**
   *
  **/
  this(Widget parent) {
    this.parent = parent;

    position = Vector2I(Platform.getWindow.getWidth / 2, Platform.getWindow.getHeight / 2);
    modelMatrix.setTranslation(Vector3F(position.x, -position.y, 0.0f));
    modelMatrix.setScale(Vector3F(extent.x / 2, extent.y / 2, 1.0f));
  }

  /**
   *
  **/
  Transform2D setPosition(string op = "=")(int x, int y) pure nothrow {
    return setPosition!op(Vector2I(x, y));
  }

  /**
   *
  **/
  Transform2D setPosition(string op = "=")(Vector2I position) pure nothrow {
    static if (op == "=")
      modelMatrix.setTranslation(Vector3F(position.x, -position.y, 0.0f));
    else static if (op == "+=")
      modelMatrix.setTranslation(Vector3F(this.position.x + position.x, -(this.position.y + position.y), 0.0f));
    
    mixin("this.position " ~ op ~ " position;");
    return this;
  }

  /**
   *
  **/
  Vector2I getPosition() pure nothrow const {
    return position;
  }

  /**
   *
  **/
  Transform2D setExtent(string op = "=")(int x, int y) pure nothrow {
    return setExtent!op(Vector2I(x, y));
  }

  /**
   *
  **/
  Transform2D setExtent(string op = "=")(Vector2I extent) pure nothrow {
    static if (op == "=")
      modelMatrix.setScale(Vector3F(extent.x / 2.0f, extent.y / 2.0f, 0.0f));
    else static if (op == "+=")
      modelMatrix.setScale(Vector3F((this.extent.x + extent.x) / 2.0f, (this.extent.y + extent.y) / 2.0f, 0.0f));
    else static if (op == "-=")
      modelMatrix.setScale(Vector3F((this.extent.x - extent.x) / 2.0f, (this.extent.y - extent.y) / 2.0f, 0.0f));

    mixin("this.extent " ~ op ~ " extent;");
    return this;
  }
  
  /**
   *
  **/
  Vector2I getExtent() pure nothrow const {
    return extent;
  }

  /**
   * Returns model matrix for the object representation.
  **/
	ref const(Matrix4F) getModelMatrix() pure nothrow const {
		return modelMatrix;
	}
}