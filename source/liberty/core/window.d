/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/window.d)
 * Documentation:
 * Coverage:
**/
module liberty.core.window;

import bindbc.glfw;

import liberty.core.input.event : Event;
import liberty.core.logger : Logger, InfoMessage;

/**
 *
**/
final class Window {
	private {
		int width;
		int height;
    GLFWwindow* handle;
		int frameBufferWidth;
		int frameBufferHeight;
		bool fullscreen;
		int lastXStartPos;
		int lastYStartPos;
		int lastXSize;
		int lastYSize;
	}

	/**
	 *
	**/
	this(int width, int height, string title) {
		// Set window size
		this.width = width;
		this.height = height;

		Logger.info(InfoMessage.Creating, typeof(this).stringof);
    
		// Create window internally
    handle = glfwCreateWindow(
      width,
      height,
      "Liberty Engine v0.0.15-beta.1",
      null,
      null
    );

		resizeFrameBuffer();
		glfwSetFramebufferSizeCallback(handle, &Event.frameBufferResizeCallback);

		// Create the current context
    glfwMakeContextCurrent(handle);

		// Check if window is created
    if (this.handle is null)
      Logger.error("Failed to create window", typeof(this).stringof);

		Logger.info(InfoMessage.Created, typeof(this).stringof);
	}

	~this() {
		Logger.info(InfoMessage.Destroying, typeof(this).stringof);

		// Destroy the window if not null
		if (handle !is null) {
      glfwTerminate();
      handle = null;
    } else {
      Logger.warning(
        "You are trying to destory a non-existent window",
        typeof(this).stringof
      );
    }

		Logger.info(InfoMessage.Destroyed, typeof(this).stringof);
	}

	/**
	 *
	**/
	int getWidth() pure nothrow const {
		return width;
	}

	/**
	 *
	**/
	int getHeight() pure nothrow const {
		return height;
	}

  /**
   *
  **/
  GLFWwindow* getHandle() pure nothrow {
    return handle;
  }

	/**
	 *
	**/
	int getFrameBufferWidth() pure nothrow const {
		return frameBufferWidth;
	}

	/**
	 *
	**/
	int getFrameBufferHeight() pure nothrow const {
		return frameBufferHeight;
	}

	/**
	 *
	**/
	void resizeFrameBuffer() {
		glfwGetFramebufferSize(handle, &frameBufferWidth, &frameBufferHeight);
	}

	/**
	 *
	**/
	Window setFullscreen(bool fullscreen) {
		if (fullscreen) {
			// Backup window position and window size
			glfwGetWindowPos(handle, &lastXStartPos, &lastYStartPos);
			glfwGetWindowSize(handle, &lastXSize, &lastYSize);

			// Get resolution of monitor
			const(GLFWvidmode)* mode = glfwGetVideoMode(glfwGetPrimaryMonitor());

			// Switch to fullscreen
			glfwSetWindowMonitor(handle, glfwGetPrimaryMonitor(), 0, 0, mode.width, mode.height, 0);
		} else
			// Restore last window size and position
			glfwSetWindowMonitor(handle, null, lastXStartPos, lastYStartPos, lastXSize, lastYSize, 0);

		this.fullscreen = fullscreen;
		return this;
	}

	/**
	 *
	**/
	bool isFullscreen() pure nothrow const {
		return isFullscreen;
	}
}