/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/objects/bsp/cube.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.objects.bsp.cube;

import liberty.core.math.vector : Vector2F, Vector3F;
import liberty.core.engine : CoreEngine;
import liberty.core.components.renderer : Renderer;
import liberty.core.objects.meta : NodeBody;
import liberty.core.model.impl : GenericModel;
import liberty.core.objects.node : WorldObject;
import liberty.core.objects.bsp.impl : BSPVolume;
import liberty.graphics.vertex : Vertex;

/**
 *
**/
final class BSPCube : BSPVolume!"core" {
	mixin(NodeBody);

  /**
   *
  **/
	void constructor() {
    renderer = Renderer!"core"(this, (new GenericModel()
      .build(cubeVertices, "res/textures/default.bmp")));
	}
}

private Vertex[36] cubeVertices = [
  // back
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, 0.0f, -1.0f), Vector2F(0.0f,  0.0f)),

  // front
  Vertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, 0.0f, 1.0f), Vector2F(0.0f,  0.0f)),

  // left
  Vertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F(-0.5f,  0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F(-0.5f,  0.5f,  0.5f), Vector3F(-1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),

  // right
  Vertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F( 0.5f,  0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F( 0.5f,  0.5f,  0.5f), Vector3F(1.0f, 0.0f, 0.0f), Vector2F(0.0f,  1.0f)),

  // bottom
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F( 0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, -0.5f,  0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F(-0.5f, -0.5f, -0.5f), Vector3F(0.0f, -1.0f, 0.0f), Vector2F(1.0f,  0.0f)),

  // top
  Vertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  0.0f)),
  Vertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F( 0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(1.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, 0.5f,  0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  1.0f)),
  Vertex(Vector3F(-0.5f, 0.5f, -0.5f), Vector3F(0.0f, 1.0f, 0.0f), Vector2F(0.0f,  0.0f))
];