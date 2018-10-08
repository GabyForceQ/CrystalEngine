/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/buffer/impl.d, _impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.buffer.impl;

import derelict.opengl :
  glGenBuffers, glBindBuffer, glDeleteBuffers,
  glBufferData, glBufferSubData, glGetBufferSubData;

import liberty.core.utils : bufferSize;
import liberty.graphics.engine : GfxEngine;

/**
 *
**/
final class GfxBuffer {
  private {
    uint buffer;
    size_t size;
    uint target;
    uint usage;
    bool firstLoad = true;
  }

  /**
   *
  **/
  this(uint target, uint usage) {
    this.target = target;
    this.usage = usage;
    glGenBuffers(1, &buffer);
    debug GfxEngine.runtimeCheck();
  }

  /**
   *
  **/
  this(T)(uint target, uint usage, T[] buffer) {
    this(target, usage);
    setData(buffer);
  }

  ~this() {
    glDeleteBuffers(1, &buffer);
  }

  /**
   *
  **/
  size_t getSize() pure nothrow const {
    return size;
  }

  /**
   *
  **/
  void setData(T)(T[] buffer) {
    setData(buffer.bufferSize(), buffer.ptr);
  }

  /**
   *
  **/
  void setData(size_t size, void* data) {
    bind();
    this.size = size;
    if (firstLoad)
      glBufferData(target, size, data, usage);
    else {
      glBufferData(target, size, null, usage);
      glBufferSubData(target, 0, size, data);
    }
    debug GfxEngine.runtimeCheck();
    firstLoad = false;
  }

  /**
   *
  **/
  void setSubData(size_t offset, size_t size, void* data) {
    bind();
    glBufferSubData(target, offset, size, data);
    debug GfxEngine.runtimeCheck();
  }

  /**
   *
  **/
  void getSubData(size_t offset, size_t size, void* data) {
    bind();
    glGetBufferSubData(target, offset, size, data);
    debug GfxEngine.runtimeCheck();
  }

  /**
   *
  **/
  ubyte[] getBytes() {
    auto buff = new ubyte[size];
    getSubData(0, size, buff.ptr);
    return buff;
  }

  /**
   *
  **/
  void bind() {
    glBindBuffer(target, buffer);
    debug GfxEngine.runtimeCheck();
  }

  /**
   *
  **/
  void unbind() {
    glBindBuffer(target, 0);
  }

  /**
   *
  **/
  uint getHandle() pure nothrow const {
    return buffer;
  }

  /**
   *
  **/
  static void releaseBuffers(uint[] buff) {
    glDeleteBuffers(buff.length, cast(uint*)buff);
  }
}