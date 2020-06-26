package;


import lime.app.Application;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.RenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.math.RGBA;

class Main extends Application {
		
	private var glVertexAttribute:Int;

	
	public function new () {
		
		super ();

		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		switch (context.type) {
			
			
			case OPENGL, OPENGLES, WEBGL:


//Set OpenGL, OpenGLES, WebGL context
				
         var gl = context.webgl;



// Create Geometry
         var vertices = [
            -0.5,0.5,0.0,
            -0.5,-0.5,0.0,
            0.5,-0.5,0.0,
            0.5,0.5,0.0
         ];

         var colors = [0,0,1, 1,0,0, 0,1,0, 1,0,1,];


// Store Geometry         
         var indices = [3,2,1,3,1,0];
         
         // Create an empty buffer object and store vertex data
         var vertex_buffer = gl.createBuffer();
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);
         gl.bindBuffer(gl.ARRAY_BUFFER, null);

         // Create an empty buffer object and store Index data
         var Index_Buffer = gl.createBuffer();
         gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, Index_Buffer);
         gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt16Array(indices), gl.STATIC_DRAW);
         gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);

         // Create an empty buffer object and store color data
         var color_buffer = gl.createBuffer ();
         gl.bindBuffer(gl.ARRAY_BUFFER, color_buffer);
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);



//Create Shaders

         
// Vertex Shader
         var vertCode = 'attribute vec3 coordinates;'+
            'attribute vec3 color;'+
            'varying vec3 vColor;'+
            'void main(void) {' +
               ' gl_Position = vec4(coordinates, 1.0);' +
               'vColor = color;'+
            '}';
            
         // Create a vertex shader object
         var vertShader = gl.createShader(gl.VERTEX_SHADER);

         // Attach vertex shader source code
         gl.shaderSource(vertShader, vertCode);

         // Compile the vertex shader
         gl.compileShader(vertShader);



// Fragment Shader
         var fragCode = 'precision mediump float;'+
            'varying vec3 vColor;'+
            'void main(void) {'+
               'gl_FragColor = vec4(vColor, 1.);'+
            '}';
            
         // Create fragment shader object
         var fragShader = gl.createShader(gl.FRAGMENT_SHADER);

         // Attach fragment shader source code
         gl.shaderSource(fragShader, fragCode);

         // Compile the fragmentt shader
         gl.compileShader(fragShader);

         // Create a shader program object to
         // store the combined shader program
         var shaderProgram = gl.createProgram();

         // Attach a vertex shader
         gl.attachShader(shaderProgram, vertShader);

         // Attach a fragment shader
         gl.attachShader(shaderProgram, fragShader);

         // Link both the programs
         gl.linkProgram(shaderProgram);

         // Use the combined shader program object
         gl.useProgram(shaderProgram);

         /* ======== Associating shaders to buffer objects =======*/

         // Bind vertex buffer object
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);

         // Bind index buffer object
         gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, Index_Buffer);

         // Get the attribute location
         var coord = gl.getAttribLocation(shaderProgram, "coordinates");

         // point an attribute to the currently bound VBO
         gl.vertexAttribPointer(coord, 3, gl.FLOAT, false, 0, 0);

         // Enable the attribute
         gl.enableVertexAttribArray(coord);

         // bind the color buffer
         gl.bindBuffer(gl.ARRAY_BUFFER, color_buffer);
         
         // get the attribute location
         var color = gl.getAttribLocation(shaderProgram, "color");
 
         // point attribute to the volor buffer object
         gl.vertexAttribPointer(color, 3, gl.FLOAT, false,0,0) ;
 
         // enable the color attribute
         gl.enableVertexAttribArray(color);


// Draw the Geometry to Screen

         // Clear the canvas
         gl.clearColor(0.5, 0.5, 0.5, 0.9);

         // Enable the depth test
         gl.enable(gl.DEPTH_TEST);

         // Clear the color buffer bit
         gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

         // Set the view port
         gl.viewport(0,0,window.width,window.height);

         //Draw the triangle
         gl.drawElements(gl.TRIANGLES, indices.length, gl.UNSIGNED_SHORT,0);
      

					
			
			default:
			
		}
		
	}
	
	
}
