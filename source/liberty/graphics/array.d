/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/array.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.array;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.engine : GfxEngine;

/**
 * OpenGL vertex array object.
**/
final class GfxArray {
  private {
    uint handle;
  }

  /**
   * Create a vertex array object.
  **/
  this(bool shouldBind = true) {
    version (__OPENGL__)
      glGenVertexArrays(1, &handle);
    
    debug GfxEngine.runtimeCheckErr();
    
    if (shouldBind)
      bind();
  }

  /**
   * Bind this vertex array object.
  **/
  void bind() {
    version (__OPENGL__)
      glBindVertexArray(handle);
    
    debug GfxEngine.runtimeCheckErr();
  }

  /**
   * Unbind this vertex array object.
  **/
  void unbind() {
    version (__OPENGL__)
      glBindVertexArray(0);
    
    debug GfxEngine.runtimeCheckErr();
  }

  /**
   * Returns wrapped OpenGL resource handle.
  **/
  uint getHandle() pure nothrow const {
    return handle;
  }

  /**
   *
  **/
  static void releaseVertexArrays(uint[] buff) {
    version (__OPENGL__)
      glDeleteVertexArrays(cast(int)buff.length, cast(uint*)buff);
  }
}