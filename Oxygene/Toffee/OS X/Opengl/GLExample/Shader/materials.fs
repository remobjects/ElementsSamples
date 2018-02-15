struct Material {
  lowp vec3 ambient;
  lowp vec3 diffuse;
  lowp vec3 specular;    
  mediump float shininess;
}; 

struct Light {
  mediump vec3 position;

  lowp vec3 ambient;
  lowp vec3 diffuse;
  lowp vec3 specular;
};

varying mediump vec3 FragPos;  
varying mediump vec3 Normal;  
   
uniform mediump vec3 viewPos;
uniform Material material;
uniform Light light;

void main()
{
  // Ambient
  mediump vec3 ambient = light.ambient * material.ambient;

  // Diffuse 
  mediump vec3 norm = normalize(Normal);
  mediump vec3 lightDir = normalize(light.position - FragPos);
  mediump float diff = max(dot(norm, lightDir), 0.0);
  mediump vec3 diffuse = light.diffuse * (diff * material.diffuse);
    
  // Specular
  mediump vec3 viewDir = normalize(viewPos - FragPos);
  mediump vec3 reflectDir = reflect(-lightDir, norm);  
  mediump float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
  mediump vec3 specular = light.specular * (spec * material.specular);  
        
  mediump vec3 result = ambient + diffuse + specular;
  gl_FragColor = vec4(result, 1.0);
} 