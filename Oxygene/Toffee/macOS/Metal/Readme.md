# Metal Example for Oxygene

Hello, here we will show the use of the Metal-Api for MacOS with Oxygene

The solution contains actual 1 Project.

## Metalexample

The Examples are based on the Metal-Examples from Apple. 
see also : <https://developer.apple.com/documentation/metal/fundamental_lessons>

the following examples are used for now:

*  **Devices and Commands:**  
	Demonstrates how to access and interact with the GPU. These is the default Example on start the app.

	
* **Hello Triangle:**  
	Demonstrates how to render a simple 2D triangle. Small extension to the original is the change of the top corner on every Renderfarme.
* **Basic Buffers:**  
	Demonstrates how to manage hundreds of vertices with a vertex buffer.
* **Basic Texturing:**  
	Demonstrates how to load image data and texture a quad. There are 2 examples, First one is switching between 2 textures every 100 Frames, the second is blending the textures together.
	
	
### Needs Elements Compiler > 10.0.0.2293
There is a new Build Options in Ebuild to compile *.metal files as *.metallib 
