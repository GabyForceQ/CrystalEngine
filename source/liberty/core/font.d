/**
 * Copyright:       Copyright (C) 2018 Gabriel Gheorghe, All Rights Reserved
 * Authors:         $(Gabriel Gheorghe)
 * License:         $(LINK2 https://www.gnu.org/licenses/gpl-3.0.txt, GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007)
 * Source:          $(LINK2 https://github.com/GabyForceQ/LibertyEngine/blob/master/source/liberty/core/font.d, _font.d)
 * Documentation:
 * Coverage:
 */
module liberty.core.font;
import liberty.core.utils : Singleton, IService;
import liberty.core.logger : Logger;
/// A failing FontManager function should <b>always</b> throw a $(D FontManagerEngineException).
final class AIEngineException : Exception {
	/// Default constructor.
	this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) @safe {
		super(msg, file, line, next);     
        import std.conv : to;
        Logger.get.exception("Message: '" ~ msg ~ "'; File: '" ~ file ~ "'; Line:'" ~ line.to!string ~ "'.");
	}
}
///
final class FontManager : Singleton!FontManager, IService {
	private bool _serviceRunning;
	/// Start FontManager service.
    void startService() @safe {
        _serviceRunning = true;
        Logger.get.info("FontManager service started.");
    }
    /// Stop FontManager service.
    void stopService() @safe {
        _serviceRunning = false;
        Logger.get.info("FontManager service stopped.");
    }
    /// Restart FontManager service.
    void restartService() @safe {
        stopService();
        startService();
    }
	/// Returns true if FontManager service is running.
	bool isServiceRunning() pure nothrow const @safe @nogc {
		return _serviceRunning;
	}
}