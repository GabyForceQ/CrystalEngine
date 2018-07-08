/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/ui/widget.d, _widget.d)
 * Documentation:
 * Coverage:
 */
module liberty.ui.widget;
import liberty.core.world.node : Node;
import liberty.core.world.entity : Entity;
/// An Widget is a 2d element on the screen.
/// It doesn't depends on world camera.
abstract class Widget : Entity, IListener {
    ///
    enum Update = "Update";
    ///
    enum Render = "Render";
    private {
        void delegate() _onUpdate = null;
    }
    ///
    bool _canListen;
	/// Default constructor.
    this(string id, Node parent) {
        super(id, parent);
    }
    ///
    override void update(in float deltaTime) {
        if (_onUpdate !is null) {
			_onUpdate();
		}
    }
    ///
    void stopListening() {
        _canListen = false;
    }
    ///
    void onUpdate(void delegate() event) pure nothrow @property {
        _onUpdate = event;
    }
}
///
interface IListener {
    ///
    void stopListening();
}