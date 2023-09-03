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

#define DRAGON 10
#define ROCK 11
#define OCEAN 12
#define PORTAL 13

#define SPHERE 0
#define BUNNY  1
#define PLANE  2
#define RING 3
uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;

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

    if ( object_id == SPHERE )
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
    //else if ( object_id == BUNNY )
    //{
        // PREENCHA AQUI as coordenadas de textura do coelho, computadas com
        // projeção planar XY em COORDENADAS DO MODELO. Utilize como referência
        // o slide 111 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf",
        // e também use as variáveis min*/max* definidas abaixo para normalizar
        // as coordenadas de textura U e V dentro do intervalo [0,1]. Para
        // tanto, veja por exemplo o mapeamento da variável 'p_v' utilizando
        // 'h' no slide 154 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // Veja também a Questão 4 do Questionário 4 no Moodle.

       /* float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x-minx)/(maxx-minx);
        V = (position_model.y-miny)/(maxy-miny);
    }*/
    else if ( object_id == PLANE || object_id == BUNNY )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;
    }

    // Obtemos a refletância difusa a partir da leitura da imagem TextureImage0


    // Equação de Iluminação
    float lambert = max(0,dot(n,l));

    // Termo de iluminacao do modelo Blinn-Phong
    float blinn_phong = max(0, pow(dot(n,halfVector),15));

    //Refletancia especular do dragao
    vec3 Ks_ring = vec3(0.9f,0.9f,0.9f);

    vec3 Kd0_moon = texture(TextureImage1, vec2(U,V)).rgb;
    //vec3 Kd0_dragon = texture(TextureImage2, vec2(U,V)).rgb;
    vec3 Kd0_ring = texture(TextureImage3, vec2(U,V)).rgb;

    //

    if ( object_id == BUNNY )
    {
        // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
        vec4 l = normalize(vec4(0.0f, 30.0f, 0.0f, 0.0f));

        // Lambert Shading
        // Radiânciada e reflexão difusa observada é proporcional ao cosseno do ângulo entre a fonte de luz e a normalda superfície.

        // Refletância da superfície
        vec3 Kd0_dragon = texture(TextureImage2, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(0.9f, 0.9f, 0.9f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.1f, 0.1f, 0.1f);

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd0_dragon * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;

        // Cor final utilizando o modelo de iluminação Lambert
        color = LambertDifuseTerm + AmbientTerm;
    }
    if ( object_id == SPHERE )
    {
        color = Kd0_moon * (lambert + 0.01);
    }

    if ( object_id == PLANE ) {
        // Blinn-Phong Shading
        // Reflexão Especular "Glossy"
        // Modela melhor uma reflexão real.

        // Refletância da superfície
        vec3 Kd0_dia = texture(TextureImage0, vec2(U,V)).rgb;
        // Espectro da fonte de luz
        vec3 I = vec3(0.9f, 0.9f, 0.9f);
        // Espectro da luz ambiente
        vec3 I_a = vec3(0.1, 0.1, 0.1);
        // Refletância ambiente da superficíe
        vec3 K_a = vec3(0.1f, 0.1f, 0.1f);
        // Refletância especular da superficíe
        vec3 Ks_plane= vec3(0.3f,0.3f,0.3f);
        // No modelo de Phong, a intensidade da reflexão vista pelo observador é proporcional a pow(cos(beta), q_row), onde q é um parâmetro.
        // beta é o ângulo (produto interno) entre a normal do ponto e "half-vector" (meio do caminho entre o vetor v e o vetor l.
        float q_row = 160;

        // Termo Difuso (Lambert)
        vec3 LambertDifuseTerm = Kd0_dia * I * max(0, dot(n, l));
        // Termo Ambiente
        vec3 AmbientTerm = K_a * I_a;
        // Termo Especular (Blinn-Phong)
        vec3 BlinnPhongEspecularTerm = Ks_plane * I * pow(max(0, dot(n, halfVector)), q_row);

        // Cor final utilizando o modelo de iluminação Blinn-Phong
        color = LambertDifuseTerm + AmbientTerm + BlinnPhongEspecularTerm;
    }

    if ( object_id == RING )
    {
        color = vec3(1,1,0)* (lambert + 0.02)+ Ks_ring * blinn_phong;
    }


    //color = Kd0_dia * (lambert + 0.01) + Kd0_noite * max(0,(1-lambert*8));
    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color = pow(color, vec3(1.0,1.0,1.0)/2.2);
}

