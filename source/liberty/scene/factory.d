/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/scene/factory.d)
 * Documentation:
 * Coverage:
**/
module liberty.scene.factory;

import liberty.scene.impl;
import liberty.scene.serializer;

/**
 * This is the scene factory interface used by all scene objects.
**/
interface ISceneFactory {
  /**
   * Create a new scene instance using relative path of the scene file.
  **/
  static Scene create(string relativePath) {
    return new Scene(new SceneSerializer(relativePath));
  }

  /**
   * Destroy an existing scene from memory.
  **/
  static void kill(Scene scene) {
    scene.destroy();
    scene = null;
  }
}