/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source
 * Documentation:
 * Coverage:
 */
module liberty.core.scenegraph.actor;
import liberty.core.scenegraph.node: Node;
/// An actor has action mapping.
abstract class Actor : Node {
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
    }
}