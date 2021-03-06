/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/logger/constants.d)
 * Documentation:
 * Coverage:
**/
module liberty.logger.constants;

/**
 * All types of log that you can use when logging a message.
**/
enum LogType : ubyte {
  /**
   * Used to log an information message.
  **/
  Info = 0x00,

  /**
   * Used to log a warning message.
  **/
  Warning = 0x01,

  /**
   * Used to log an error message.
  **/
  Error = 0x02,
  
  /**
   * Used to log an exception message.
  **/
  Exception = 0x03,
  
  /**
   * Used to log a debug message. Only works in debug mode.
  **/
  Debug = 0x04,
  
  /**
   * Used to log a todo message.
  **/
  Todo = 0x05
}

/**
 *
**/
enum InfoMessage : string {
  /**
   *
  **/
  ServiceStarted = "Service started successfully!",
  
  /**
   *
  **/
  ServiceStopped = "Service stopped successfully!",
	
  /**
   *
  **/
  Creating = "Creating..",
	
  /**
   *
  **/
  Created = "Created",
	
  /**
   *
  **/
  Destroying = "Destroying..",
	
  /**
   *
  **/
  Destroyed = "Destroyed"
}
