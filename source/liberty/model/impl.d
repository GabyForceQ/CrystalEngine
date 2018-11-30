/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/model/impl.d)
 * Documentation:
 * Coverage:
**/
module liberty.model.impl;

import liberty.graphics.constants;
import liberty.graphics.engine;
import liberty.graphics.factory;
import liberty.material.impl;
import liberty.model.data;
import liberty.services;

/**
 *
**/
class Model : IGfxRendererFactory, IRenderable {
  private {
    // Used to Store wireframe global state
    bool tempWireframeEnabled;
    // isCullingEnabled, setCullingEnabled, swapCulling
    bool cullingEnabled = true;
    // isWireframeEnabled, setWireframeEnabled, swapWireframe
    bool wireframeEnabled;
    // isTransparencyEnabled, setTransparencyEnabled
    bool transparencyEnabled = true;
    // isFakeLightingEnabled, setFakeLightingEnabled
    bool fakeLightingEnabled;
  }

  protected {
    // getRawModel
    RawModel rawModel;
    // getMaterials, setMaterials, swapMaterials
    Material[] materials;
  }

  /**
   *
  **/
  this(RawModel rawModel, Material[] materials) {
    this.rawModel = rawModel;
    this.materials = materials;
  }

  /**
   * Returns the raw model.
  **/
  RawModel getRawModel() pure nothrow const {
    return rawModel;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) swapMaterials(Material[] materialsLhs, Material[] materialsRhs) {
    materials = (materials == materialsLhs) ? materialsRhs : materialsLhs;
    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) swapMaterials(Material[2][] arr) {
    foreach (i, ref material; materials)
      material = (material == arr[i][0]) ? arr[i][1] : arr[i][0];

    return this;
  }

  /**
   *
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setMaterials(Material[] materials) pure nothrow {
    this.materials = materials;
    return this;
  }

  /**
   * Returns an array with materials.
  **/
  Material[] getMaterials() pure nothrow {
    return materials;
  }

  /**
   * Enable or disable culling on the model.
   * It is disabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setCullingEnabled(bool enabled = true) pure nothrow {
    cullingEnabled = enabled;
    return this;
  }

  /**
   * Swap culling values between true and false on the model.
  **/
  typeof(this) swapCulling() pure nothrow {
    cullingEnabled = !cullingEnabled;
    return this;
  }

  /**
   * Returns true if model's culling is enabled.
  **/
  bool isCullingEnabled() pure nothrow const {
    return cullingEnabled;
  }

  /**
   * Enable or disable wireframe on the model.
   * It is disabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setWireframeEnabled(bool enabled = true) pure nothrow {
    wireframeEnabled = enabled;
    return this;
  }

  /**
   * Swap wireframe values between true and false on the model.
  **/
  typeof(this) swapWireframe() pure nothrow {
    wireframeEnabled = !wireframeEnabled;
    return this;
  }

  /**
   * Returns true if model's wireframe is enabled.
  **/
  bool isWireframeEnabled() pure nothrow const {
    return wireframeEnabled;
  }

  /**
   * Enable or disable transparency on the model.
   * It is enabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setTransparencyEnabled(bool enabled = true) pure nothrow {
    transparencyEnabled = enabled;
    return this;
  }

  /**
   * Returns true if model's transparency is enabled.
  **/
  bool isTransparencyEnabled() pure nothrow const {
    return transparencyEnabled;
  }

  /**
   * Enable or disable fake lighting on the model.
   * It is disabled by default when create a new model.
   * Returns reference to this so it can be used in a stream.
  **/
  typeof(this) setFakeLightingEnabled(bool enabled = true) pure nothrow {
    fakeLightingEnabled = enabled;
    return this;
  }

  /**
   * Returns true if fake lighting is enabled on the model.
  **/
  bool isFakeLightingEnabled() pure nothrow const {
    return fakeLightingEnabled;
  }

  /**
   * Render the model to the screen by calling specific draw method from $(D IGfxRendererFactory)
  **/
  void render() {
    // Send culling type to graphics engine
    GfxEngine
      .getBackend
      .setCullingEnabled(cullingEnabled);

    // Send alpha blend to graphics engine
    transparencyEnabled
      ? GfxEngine.enableAlphaBlend()
      : GfxEngine.disableBlend();

    // Store wireframe global state
    tempWireframeEnabled = GfxEngine.getBackend.getOptions.wireframeEnabled;

    // Send wireframe type to graphics engine
    GfxEngine
      .getBackend
      .setWireframeEnabled(tempWireframeEnabled ? !wireframeEnabled : wireframeEnabled);

    // Render
    rawModel.useIndices
      ? drawElements(GfxDrawMode.TRIANGLES, GfxVectorType.UINT, rawModel.vertexCount)
      : drawArrays(GfxDrawMode.TRIANGLES, rawModel.vertexCount);

    // Restore wireframe global state using the stored boolean
    GfxEngine
      .getBackend
      .setWireframeEnabled(tempWireframeEnabled);
  }
}