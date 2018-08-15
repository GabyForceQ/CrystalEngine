/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/system/surface/wrapper/types.d, _types.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.system.surface.wrapper.types;

import derelict.sdl2.sdl :
  SDL_Surface,
  SDL_PixelFormat,
  SDL_Rect, SDL_FALSE;

/**
 * Pointer to SDL2 Surface.
**/
alias SurfaceHandler = SDL_Surface*;

/**
 *
**/
alias PixelFormat = SDL_PixelFormat*;

/**
 *
**/
alias Rect = SDL_Rect;

/**
 *
**/
alias SurfaceSuccess = SDL_FALSE;