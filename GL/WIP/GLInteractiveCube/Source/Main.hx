package;


import lime.app.Application;

import lime.graphics.opengl.GL;

import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;

import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLTransformFeedback;
import lime.graphics.opengl.GLVertexArrayObject;
import lime.graphics.opengl.GLFramebuffer;

import lime.graphics.RenderContext;
import lime.graphics.WebGL2RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.graphics.OpenGLRenderContext;
import lime.graphics.opengl.GLContextAttributes;

import lime.math.Vector4;
import lime.math.Matrix4;
import lime.math.Matrix3;
import lime.math.Rectangle;
//import lime.math.RGBA;

import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.utils.DataPointer;
import lime.utils.ArrayBufferView;
import lime.utils.Log;

import lime.ui.MouseButton;
import lime.ui.MouseCursor;
import lime.ui.WindowAttributes;

import lime.system.System;

import lime.ui.Window;

import lime.app.Event;



class Main extends Application {
		
	private var glVertexAttribute:Int;
	private var glMatrixUniform:GLUniformLocation;

	private var bufferData:Float32Array;
	private var vertex_buffer:GLBuffer;
	private var color_buffer:GLBuffer;
	private var index_index:GLBuffer;
	
	private var gl:WebGLRenderContext;

//    private var window:WebGLRenderContext;
	
	public function new () {
		
		super ();

	}
	
	
	public override function render (context:RenderContext):Void {
		
		switch (context.type) {
			
			
			case OPENGL, OPENGLES, WEBGL :


// Step1: Set OpenGL, OpenGLES, WebGL context
				
         var gl = context.webgl;
//var gl:OpenGLRenderContext = context.webgl;

/*========== Defining and storing the geometry ==========*/

         var vertices = [
            -1,-1,-1, 1,-1,-1, 1, 1,-1, -1, 1,-1,
            -1,-1, 1, 1,-1, 1, 1, 1, 1, -1, 1, 1,
            -1,-1,-1, -1, 1,-1, -1, 1, 1, -1,-1, 1,
            1,-1,-1, 1, 1,-1, 1, 1, 1, 1,-1, 1,
            -1,-1,-1, -1,-1, 1, 1,-1, 1, 1,-1,-1,
            -1, 1,-1, -1, 1, 1, 1, 1, 1, 1, 1,-1 
         ];

         var colors = [
            5,3,7, 5,3,7, 5,3,7, 5,3,7,
            1,1,3, 1,1,3, 1,1,3, 1,1,3,
            0,0,1, 0,0,1, 0,0,1, 0,0,1,
            1,0,0, 1,0,0, 1,0,0, 1,0,0,
            1,1,0, 1,1,0, 1,1,0, 1,1,0,
            0,1,0, 0,1,0, 0,1,0, 0,1,0 
         ];

         var indices = [
            0,1,2, 0,2,3, 4,5,6, 4,6,7,
            8,9,10, 8,10,11, 12,13,14, 12,14,15,
            16,17,18, 16,18,19, 20,21,22, 20,22,23 
         ];

   // Create and store data into vertex buffer
         var vertex_buffer = gl.createBuffer ();
         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

   // Create and store data into color buffer
         var color_buffer = gl.createBuffer ();
         gl.bindBuffer(gl.ARRAY_BUFFER, color_buffer);
         gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);

   // Create and store data into index buffer
         var index_buffer = gl.createBuffer ();
         gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, index_buffer);
         gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new UInt16Array(indices), gl.STATIC_DRAW);

/*=================== SHADERS =================== */

         var vertCode = 
            "attribute vec3 position;
             uniform mat4 Pmatrix;
             uniform mat4 Vmatrix;
             uniform mat4 Mmatrix;
             attribute vec3 color; //the color of the point
             varying vec3 vColor;
             void main(void) { //pre-built function
                gl_Position = Pmatrix*Vmatrix*Mmatrix*vec4(position, 1.);
                vColor = color;
             }";

         var fragCode = 
            "precision mediump float;
             varying vec3 vColor;
             void main(void) {
                gl_FragColor = vec4(vColor, 1.);
             }";

         var vertShader = gl.createShader(gl.VERTEX_SHADER);
         gl.shaderSource(vertShader, vertCode);
         gl.compileShader(vertShader);

         var fragShader = gl.createShader(gl.FRAGMENT_SHADER);
         gl.shaderSource(fragShader, fragCode);
         gl.compileShader(fragShader);

         var shaderprogram = gl.createProgram();
         gl.attachShader(shaderprogram, vertShader);
         gl.attachShader(shaderprogram, fragShader);
         gl.linkProgram(shaderprogram);

/*======== Associating attributes to vertex shader =====*/
         var _Pmatrix = gl.getUniformLocation(shaderprogram, "Pmatrix");
         var _Vmatrix = gl.getUniformLocation(shaderprogram, "Vmatrix");
         var _Mmatrix = gl.getUniformLocation(shaderprogram, "Mmatrix");

         gl.bindBuffer(gl.ARRAY_BUFFER, vertex_buffer);
         var _position = gl.getAttribLocation(shaderprogram, "position");
         gl.vertexAttribPointer(_position, 3, gl.FLOAT, false,0,0);
         gl.enableVertexAttribArray(_position);

         gl.bindBuffer(gl.ARRAY_BUFFER, color_buffer);
         var _color = gl.getAttribLocation(shaderprogram, "color");
         gl.vertexAttribPointer(_color, 3, gl.FLOAT, false,0,0) ;
         gl.enableVertexAttribArray(_color);
         gl.useProgram(shaderprogram);


/*==================== MATRIX ====================== */

         function get_projection(angle, a, zMin, zMax) {

            var ang = Math.tan((angle*.5)*Math.PI/180);//angle*.5
            return [
               0.5/ang, 0 , 0, 0,
               0, 0.5*a/ang, 0, 0,
               0, 0, -(zMax+zMin)/(zMax-zMin), -1,
               0, 0, (-2*zMax*zMin)/(zMax-zMin), 0 
			   ];
         }


         var proj_matrix = get_projection(Std.int(40), Std.int(window.width/window.height), Std.int(1), Std.int(100));
         var mo_matrix = new Float32Array([ 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 ]);
         var view_matrix = new Float32Array([ 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 ]);

         view_matrix[14] = view_matrix[14]-6;

/*================= Mouse events ======================*/

         var THETA = 0;
         var PHI = 0;


         var AMORTIZATION = 0.95;
         var drag = false;
         var old_x;
         var old_y;
         var dX = 0;
         var dY = 0;
/*
         var mouseDown = function(e) {
            drag = true;
            old_x = e.pageX;
            old_y = e.pageY;
            e.preventDefault();
            return false;
         };

         var mouseUp = function(e){
            drag = false;
         };

         var mouseMove = function(e) {
            if (!drag) return false;
            dX = (e.pageX-old_x)*2*Std.int(Math.PI/window.width);
            dY = (e.pageY-old_y)*2*Std.int(Math.PI/window.height);
            THETA+= dX;
            PHI+=dY;
            old_x = e.pageX;
            old_y = e.pageY;
            e.preventDefault();
            return false;*/
         };

//var window:Event;

//         window.addEventListener("mousedown", mouseDown, false);
//         window.addEventListener("mouseup", mouseUp, false);
//         window.addEventListener("mouseout", mouseUp, false);
//         window.addEventListener("mousemove", mouseMove, false);

   /*=========================rotation================*/

         function rotateX(m, angle) {

            var m = new Matrix4();

            var c = Math.cos(angle);
            var s = Math.sin(angle);
            var mv1 = m[1], mv5 = m[5], mv9 = m[9];

            m[1] = m[1]*c-m[2]*s;
            m[5] = m[5]*c-m[6]*s;
            m[9] = m[9]*c-m[10]*s;

            m[2] = m[2]*c+mv1*s;
            m[6] = m[6]*c+mv5*s;
            m[10] = m[10]*c+mv9*s;
         }

         function rotateY(m, angle) {

            var m = new Matrix4();

            var c = Math.cos(angle);
            var s = Math.sin(angle);
            var mv0 = m[0], mv4 = m[4], mv8 = m[8];

            m[0] = c*m[0]+s*m[2];
            m[4] = c*m[4]+s*m[6];
            m[8] = c*m[8]+s*m[10];

            m[2] = c*m[2]-s*mv0;
            m[6] = c*m[6]-s*mv4;
            m[10] = c*m[10]-s*mv8;
         }

   /*=================== Drawing =================== */

         var THETA = 0;
         var PHI = 0;
         var time_old = 0;

         var update = function(time) {
            var dt = time-time_old;

            if (!drag) {
               dX *= Std.int(AMORTIZATION);
               dY*= Std.int(AMORTIZATION);
               THETA+=dX;
               PHI+=dY;
            }

   //set model matrix to I4

            mo_matrix[0] = 1; mo_matrix[1] = 0; mo_matrix[2] = 0;
            mo_matrix[3] = 0;

            mo_matrix[4] = 0; mo_matrix[5] = 1; mo_matrix[6] = 0;
            mo_matrix[7] = 0;

            mo_matrix[8] = 0; mo_matrix[9] = 0; mo_matrix[10] = 1;
            mo_matrix[11] = 0;

            mo_matrix[12] = 0; mo_matrix[13] = 0; mo_matrix[14] = 0;
            mo_matrix[15] = 1;



            rotateY(mo_matrix, THETA);
            rotateX(mo_matrix, PHI);

            time_old = time; 
//            gl.enable(gl.DEPTH_TEST);

            gl.depthFunc(gl.LEQUAL);

            gl.clearColor(0.5, 0.5, 0.5, 0.9);
 //           gl.clearDepth(1.0);
            gl.clear( gl.COLOR_BUFFER_BIT );
//            gl.clear( gl.DEPTH_BUFFER_BIT );
            gl.viewport(0, 0, Std.int(window.width), Std.int(window.height));

var matrix = new Matrix4 ();
var proj_matrix = new Matrix4 ();

//var window:OpenGLRenderContext;

// window.createOrtho (0, window.width, window.height, 0, -1000, 1000);

            gl.uniformMatrix4fv(_Pmatrix, false, proj_matrix);
            gl.uniformMatrix4fv(_Vmatrix, false, view_matrix);
            gl.uniformMatrix4fv(_Mmatrix, false, mo_matrix);

            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, index_buffer);
            gl.viewport(Std.int(-100), Std.int(1000), Std.int(window.width), Std.int(window.height));
            gl.drawElements(gl.TRIANGLES, indices.length, gl.UNSIGNED_SHORT, 0);

//           window.onChange(update);
         }
//         update(0);			
			default:
			
		}
		
	}
	
}	
}
