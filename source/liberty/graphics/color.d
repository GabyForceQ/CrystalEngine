/**
 * Copyright:   Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:     $(Gabriel Gheorghe)
 * License:     $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:      $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/color.d, _color.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.color;

/**
 *
**/
struct Color {
  /**
   *
  **/
  ubyte r;
  
  /**
   *
  **/
  ubyte g;
  
  /**
   *
  **/  
  ubyte b;

  /**
   *
  **/  
  ubyte a;

  /**
   *
  **/
  string toString() {
    import std.conv : to;
    return "[r: " ~ r.to!string ~ "; g: " ~ g.to!string ~
      "; b: " ~ b.to!string ~ "; a: " ~ a.to!string ~ "]";
  }
}