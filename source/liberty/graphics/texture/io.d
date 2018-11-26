/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/graphics/texture/io.d)
 * Documentation:
 * Coverage:
**/
module liberty.graphics.texture.io;

version (__OPENGL__)
  import bindbc.opengl;

import liberty.graphics.texture.constants;
import liberty.graphics.texture.impl;
import liberty.image.format.bmp;
import liberty.resource;

/**
 *
**/
final abstract class TextureIO {
  /**
   *
  **/
  static Texture loadBMP(string resourcePath) {
    Texture texture = new Texture();

    // Load texture form file
    auto image = cast(BMPImage)ResourceManager.loadImage(resourcePath);

    // Generate and bind texture
    texture.generateTextures();
    texture.bind(TextureType.TEX_2D);

    version (__OPENGL__) {
      glTexImage2D(
        GL_TEXTURE_2D, 
        0, 
        GL_RGBA,
        image.getWidth(),
        image.getHeight(),
        0,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        cast(ubyte*)image.getPixelData()
      );

      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    }

    texture
      .setLODBias(-0.4f)
      .generateMipmap()
      .unbind();

    // Set Texture width and height
    texture.setExtent(image.getWidth(), image.getHeight());

    return texture;
  }

  /**
   *
  **/
  static Texture loadBMP(BMPImage image) {
    Texture texture = new Texture();

    // Generate OpenGL texture
    texture.generateTextures();

    version (__OPENGL__) {
      texture.bind(TextureType.TEX_2D);

      glTexImage2D(
        GL_TEXTURE_2D, 
        0, 
        GL_RGBA,
        image.getWidth(),
        image.getHeight(),
        0,
        GL_BGRA,
        GL_UNSIGNED_BYTE,
        cast(ubyte*)image.getPixelData()
      );

      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
      
      texture
        .setLODBias(-0.4f)
        .generateMipmap()
        .unbind();
    }

    // Set Texture width and height
    texture.setExtent(image.getWidth(), image.getHeight());

    return texture;
  }
}