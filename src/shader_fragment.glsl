#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define SKY 0
#define NIGHT_FURY  1
#define OCEAN  2
#define CRISTAL 3
#define ROCK 4

uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImageSky; // SKY 0
uniform sampler2D TextureImageNightFury; // NIGHT_FURY 1
uniform sampler2D TextureImageOcean; // OCEAN  2
uniform sampler2D TextureImageCristal; // CRISTAL 3
uniform sampler2D TextureImageRock; // ROCK 4

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(0.0f, 10.0f, 30.0f, 0.0f));

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);

    //Vetor usado para o modelo de iluminacao Blinn-Phong
    vec4 halfVector = normalize(v + l);

    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    if ( object_id == SKY )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slide 144 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model

        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;
        vec4 p_textura = bbox_center + normalize(position_model-bbox_center);
        vec4 vec_textura = p_textura - bbox_center;
        float teta = atan(vec_textura.x, vec_textura.z);
        float phi = asin(vec_textura.y);

        U = (teta+M_PI)/(2*M_PI);
        V = (phi+M_PI_2)/M_PI;
    }
    else if ( object_id == OCEAN || object_id == NIGHT_FURY || object_id == ROCK || object_id == CRISTAL )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
    }

    // Equação de Iluminação
    float lambert = max(0,dot(n,l));

    if ( object_id == NIGHT_FURY ) {
        // Lambert Shading
        // Radiânciada e reflexão difusa observada é proporcional ao cosseno do ângulo entre a fonte de luz e a normalda superfície.

        // Obtemos a refletância difusa da superfície a partir da leitura da imagem TextureImageNightFury
        vec3 Kd_dragon = texture(TextureImageNightFury, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(1.0f, 1.0f, 1.0f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.5f, 0.5f, 0.5f);

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd_dragon * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;

        // Cor final utilizando o modelo de iluminação Lambert
        color = LambertDifuseTerm + AmbientTerm;
    }

    if(object_id == ROCK) {
        // Lambert Shading
        // Radiânciada e reflexão difusa observada é proporcional ao cosseno do ângulo entre a fonte de luz e a normalda superfície.

        // Obtemos a refletância difusa da superfície a partir da leitura da imagem TextureImageRock
        vec3 Kd_rock = texture(TextureImageRock, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(0.9f, 0.9f, 0.9f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.1f, 0.1f, 0.1f);

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd_rock * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;

        // Cor final utilizando o modelo de iluminação Lambert
        color = LambertDifuseTerm + AmbientTerm;
    }

    if ( object_id == OCEAN ) {
        // Blinn-Phong Shading
        // Reflexão Especular "Glossy"
        // Modela melhor uma reflexão real.

        // Obtemos a refletância difusa da superfície a partir da leitura da imagem TextureImageOcean
        vec3 Kd_ocean = texture(TextureImageOcean, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(0.9f, 0.9f, 0.9f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.5f, 0.5f, 0.5f);
        // Refletância especular da superficíe
        vec3 Ks_ocean = vec3(0.9f,0.9f,0.9f);
        // No modelo de Phong, a intensidade da reflexão vista pelo observador é proporcional a pow(cos(beta), q_row), onde q é um parâmetro.
        // beta é o ângulo (produto interno) entre a normal do ponto e "half-vector" (meio do caminho entre o vetor v e o vetor l.
        float q_row = 160;

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd_ocean * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;
        // Termo Especular (Blinn-Phong)
        vec3 BlinnPhongEspecularTerm = Ks_ocean * I * pow(max(0, dot(n, halfVector)), q_row);

        // Cor final utilizando o modelo de iluminação Blinn-Phong
        color = LambertDifuseTerm + AmbientTerm + BlinnPhongEspecularTerm;
    }

    if ( object_id == SKY ) {
        // Lambert Shading
        // Radiânciada e reflexão difusa observada é proporcional ao cosseno do ângulo entre a fonte de luz e a normalda superfície.

        // Obtemos a refletância difusa da superfície a partir da leitura da imagem TextureImageSky
        vec3 Kd_sky = texture(TextureImageSky, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(1.0f, 1.0f, 1.0f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.5f, 0.5f, 0.5f);

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd_sky * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;

        // Cor final utilizando o modelo de iluminação Lambert
        color = LambertDifuseTerm + AmbientTerm;
    }

    if ( object_id == CRISTAL )
    {
        // Lambert Shading
        // Radiânciada e reflexão difusa observada é proporcional ao cosseno do ângulo entre a fonte de luz e a normalda superfície.

        // Refletância da superfície
        vec3 Kd_cristal = texture(TextureImageCristal, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(1.0f, 1.0f, 1.0f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.1f, 0.1f, 0.1f);

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd_cristal * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;

        // Cor final utilizando o modelo de iluminação Lambert
        color = LambertDifuseTerm + AmbientTerm;
    }
}

