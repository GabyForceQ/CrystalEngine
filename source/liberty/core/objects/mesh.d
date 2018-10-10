/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/mesh.d, _mesh.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.mesh;

import liberty.core.components.renderer : Renderer;
import liberty.core.model.impl : Model;
import liberty.core.objects.entity : Entity;
import liberty.core.objects.meta : NodeBody;
import liberty.graphics.vertex : Vertex;

/**
 *
**/
final class StaticMesh : Entity {
  mixin(NodeBody);

  /**
   *
  **/
  void constructor() {
    renderer = Renderer(this, (new Model()));
  }

  /**
   *
  **/
  override void render() {
    renderer.draw();
  }
}