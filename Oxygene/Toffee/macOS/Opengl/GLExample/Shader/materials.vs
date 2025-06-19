attribute vec3 position;
attribute vec3 normal;

varying vec3 Normal;
varying vec3 FragPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform mat3 normalMatrix;

void main()
{
    gl_Position = projection * view *  model * vec4(position, 1.0);
    FragPos = vec3(model * vec4(position, 1.0));
    Normal = normalMatrix * normal; 
} 