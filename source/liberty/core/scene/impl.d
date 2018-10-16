/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/scene/impl.d)
 * Documentation:
 * Coverage:
 *
 * TODO:
 *  - implement IProcessable
**/
module liberty.core.scene.impl;

import liberty.core.engine : CoreEngine;
import liberty.core.math.vector : Vector3F;
import liberty.core.objects.camera : Camera;
import liberty.core.objects.node : WorldObject, RootObject;
import liberty.core.scene.world : WorldSettings;
import liberty.core.services : IStartable, IUpdatable, IRenderable;
import liberty.graphics.shader : GfxShader, GfxGenericShader, GfxTerrainShader, GfxUIShader;

/**
 *
**/
final class Scene : IUpdatable, IRenderable {
  private {
    string id;
    bool ready;
    bool registered;
    WorldObject tree;
    Vector3F startPoint;
    Camera activeCamera;
    Camera[string] camerasMap;
    bool[string] objectsId;
    IStartable[string] startList;
    IUpdatable[string] updateList;
    IRenderable[string] renderList;

    GfxGenericShader genericShader;
    GfxTerrainShader terrainShader;
    GfxUIShader uiShader;

    WorldSettings worldSettings;
  }

  /**
   * Create a scene using a unique id.
  **/
  this(string id) {
    CoreEngine.loadScene(this);

    id = id;
    tree = new RootObject();

    genericShader = new GfxGenericShader();
    terrainShader = new GfxTerrainShader();
    uiShader = new GfxUIShader();

    worldSettings = new WorldSettings();
  }

  /**
   * Returns scene unique id.
  **/
  string getId() pure nothrow const {
    return this.id;
  }

  /**
   * Returns true if scene is ready to run.
  **/
  bool isReady() pure nothrow const {
    return ready;
  }

  /**
   * Returns true if scene is registered to the engine.
  **/
  bool isRegistered() pure nothrow const {
    return registered;
  }

  /**
   * Returns a scene tree reference.
  **/
  WorldObject getTree() pure nothrow {
    return tree;
  }

  /**
   * Returns the start point coordinates
  **/
  Vector3F getStartPoint() pure nothrow const {
    return startPoint;
  }

  /**
   *
  **/
  Camera getActiveCamera() {
    return activeCamera;
  }

  /**
   *
  **/
  void setActiveCamera(Camera camera) {
    activeCamera = camera;
  }

  /**
   *
  **/
  void registerCamera(Camera camera) {
		camerasMap[camera.getId()] = camera;
	}

  /**
   *
  **/
  IStartable[string] getStartList() pure nothrow {
    return startList;
  }

  /**
   *
  **/
  IUpdatable[string] getUpdateList() pure nothrow {
    return updateList;
  }

  /**
   *
  **/
  IRenderable[string] getRenderList() pure nothrow {
    return renderList;
  }

  /**
   *
  **/
  void setStartList(string id, IStartable node) pure nothrow {
    startList[id] = node;
  }

  /**
   *
  **/
  void setUpdateList(string id, IUpdatable node) pure nothrow {
    updateList[id] = node;
  }

  /**
   *
  **/
  void setRenderList(string id, IRenderable node) pure nothrow {
    renderList[id] = node;
  }

  /**
   * Register scene to the CoreEngine.
	 * Invoke start for all IStartable objects that have an start() method.
  **/
	void register() {
		registered = true;

		if (activeCamera is null)
			activeCamera = tree.spawn!Camera("DefaultCamera");

    foreach (node; startList)
			node.start();
	}

  /**
   * Update all objects that have an update() method.
   * The object should implement IUpdatable.
   * It's called every frame.
  **/
  void update() {
    foreach (node; this.updateList)
      node.update();
  }

  /**
   * Render all objects that have a render() method.
   * The object should implement IRenderable.
   * It's called every frame.
  **/
  void render() {
    worldSettings.updateShaders(this, activeCamera);

    foreach(i, node; this.renderList)
      node.render();
  }

  /**
   *
  **/
  bool[string] getObjectsId() {
    return objectsId;
  }

  /**
   *
  **/
  Scene setObjectId(string key, bool state = true) {
    objectsId[key] = state;
    return this;
  }

  /**
   *
  **/
  Scene setGenericShader(GfxGenericShader shader) {
    genericShader = shader;
    return this;
  }

  /**
   *
  **/
  GfxGenericShader getGenericShader() {
    return genericShader;
  }

  /**
   *
  **/
  Scene setTerrainShader(GfxTerrainShader shader) {
    terrainShader = shader;
    return this;
  }

  /**
   *
  **/
  GfxTerrainShader getTerrainShader() {
    return terrainShader;
  }

  /**
   *
  **/
  Scene setUIShader(GfxUIShader shader) {
    uiShader = shader;
    return this;
  }

  /**
   *
  **/
  GfxUIShader getUIShader() {
    return uiShader;
  }

  /**
   *
  **/
  Scene setWorldSettings(WorldSettings worldSettings) {
    this.worldSettings = worldSettings;
    return this;
  }

  /**
   *
  **/
  WorldSettings getWorldSettings() {
    return worldSettings;
  }
}