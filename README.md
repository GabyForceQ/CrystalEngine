# LibertyEngine
##### Description:
A powerful 2D/3D engine written in the D programming language!

##### D compiler versions supported:
* DMD 2.080.1

##### Operating systems supported:
* Windows 10 x86 (32-bits)
* Windows 10 x64 (64-bits)

##### Graphics APIs supported:
* OpenGL 4.5 (Windows)

##### Cool features:
* Tree-based scene (every node is created and registered to the engine with "spawn" or "spawnOnce" templates, "new" is never used in this case).
* Every native script is optimized at compile time. So if you don't define "start", "update", "process" functions, the code for its every frame call is never inserted in the final object file.
* All "start" methods are invoked after all scene objects are instantiated. If you want to do something at construction time, you should use @Constructor attribute.

### Instructions:
* To build an example go to LibertyEngine\examples\Simple3DScene and run the bat files.
* To run it, go to the bin/platform/executable.
* You need Visual C++ SDK for Windows 10 to build the x64 version.

### Future plans:
* LibertyStudio with project templates
* Dynamic scripts loader
* VR/AR capabilities
* Multithreading systems
* Other platforms support
* Vulkan API Wrapper
* HTML5 with WebAssembly Support
* Real-Time Ray Tracing

> *Do not use this framework in production until version 0.1 (scheduled for Q2 2019) is released!*
