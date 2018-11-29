/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/surface/controls.d)
 * Documentation:
 * Coverage:
**/
module liberty.surface.controls;

import liberty.material.impl;
import liberty.math.vector;
import liberty.model.io;
import liberty.surface.event;
import liberty.surface.meta;
import liberty.surface.model;
import liberty.surface.vertex;
import liberty.surface.widget;

/**
 *
**/
final class Canvas : Widget {
  private {
    Widget[string] widgets;
  }

  mixin WidgetConstructor;

  /**
   * Call update for all widgets.
  **/
  override void update() {
    foreach (w; widgets)
      w.update();
  }

  /**
   * Returns the widgets map.
  **/
  Widget[string] getWidgets() pure nothrow {
    return widgets;
  }

  /**
   * Returns a widget by given id
  **/
  Widget getWidget(string id) pure nothrow {
    return widgets[id];
  }

  package Canvas addWidget(Widget widget) {
    // Add a new widget to the canvas
    widgets[widget.getId()] = widget;

    // Returns reference to this and can be used in a stream
    return this;
  }
}

/**
 *
**/
final class CustomControl(alias E) : Widget {
  mixin WidgetEventProps!(E);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class Button : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick,
    Event.MouseMiddleClick,
    Event.MouseRightClick,
    Event.MouseOver,
    Event.MouseMove,
    Event.MouseEnter,
    Event.MouseLeave,
    Event.Update
  ]);

  mixin WidgetConstructor!(q{
    setModel(new SurfaceModel(ModelIO.loadRawModel(uiSquareVertices, uiSquareIndices), [Material.getDefault()]));
  });
  mixin WidgetUpdate;
}

/**
 *
**/
final class CustomButton(alias E) : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick
  ] ~ E);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class CheckBox : Widget {
  mixin WidgetEventProps!([
    Event.MouseLeftClick,
    Event.MouseMiddleClick,
    Event.MouseRightClick,
    Event.MouseOver,
    Event.MouseMove,
    Event.MouseEnter,
    Event.MouseLeave,
    Event.Check,
    Event.Checked,
    Event.Uncheck,
    Event.Unchecked,
    Event.StateChange,
    Event.Update
  ]);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class CustomCheckBox(alias E) : Widget {
  mixin WidgetEventProps!([
    Event.Check,
    Event.Checked,
    Event.Uncheck,
    Event.Unchecked,
  ] ~ E);

  mixin WidgetConstructor;
  mixin WidgetUpdate;
}

/**
 *
**/
final class TextBlock : Widget {
  mixin WidgetConstructor;
}

/*private*/ uint[6] uiSquareIndices = [
  0, 1, 2,
  0, 2, 3
];

/*private*/ SurfaceVertex[] uiSquareVertices = [
  SurfaceVertex(Vector3F(-1.0f,  1.0f, 0.0f), Vector2F(0.0f, 1.0f)),
  SurfaceVertex(Vector3F(-1.0f, -1.0f, 0.0f), Vector2F(0.0f, 0.0f)),
  SurfaceVertex(Vector3F( 1.0f, -1.0f, 0.0f), Vector2F(1.0f, 0.0f)),
  SurfaceVertex(Vector3F( 1.0f,  1.0f, 0.0f), Vector2F(1.0f, 1.0f))
];