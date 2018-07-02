/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.geometry.shapes;
import liberty.core.engine : CoreEngine;
import liberty.core.components : Renderer;
import liberty.core.scenegraph.services : NodeServices, Constructor;
import liberty.core.scenegraph.entity : Entity;
import liberty.core.scenegraph.node : Node;
import liberty.core.model : Models;
import liberty.graphics.util : RenderUtil;
import liberty.graphics.renderer : DrawMode, VectorType, Vertex;
///
abstract class Shape : Entity {
	///
    this(string id, Node parent) {
        super(id, parent);
    }
}
///
final class RectangleShape : Shape {
	mixin(NodeServices);
	///
	@Constructor 
	private void _() {
		renderer = Renderer!Vertex(this, Models.get.rectangleModel);
	}
	///
    override void render() {
        renderer.pass(() @safe {
            RenderUtil.get.drawElements(DrawMode.Triangles, 6, VectorType.UnsignedInt);
        });
    }
}
///
enum ShapeForm: byte {
	///
	Rectangle = 0x00,
	///
	Circle = 0x01
}