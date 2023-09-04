# FCG-FinalTrab
 _______________
|     Video     |
https://youtu.be/CFuLZZ2gMp0
 _______________
| Contribuições |
> Richard Leal Ramos: Idealização do dragão voador do filme de "Como Treinar o seu Dragão"; 
Busca de objectos e texturas (dragão, cristais, ceu e etc); Movimentação da câmera que acompanha o dragão;
Colisões: esfera/ponto, ponto/cubo e ponto/plano; Criação da cena que envolve o mar e céu; Angulação de animação do dragão quando está dobrando;
Curvas de bezier dos cristais; Modelos de iluminação.

> Laura Cárdenas Grippa: 

 _______________
|    ChatGPT    |
> Richard: Usei para uma única função que foi a colisão entre o ponto e o plano, pra outros tipos de tarefa não adiantou de nada.

> Laura Cárdenas Grippa: 
 _______________________________________________
|    Uso dos Conceitos de Computação Gráfica    |
> Richard: O processo de desenvolvimento se iniciou à partir do Laborátorio 5, todos os nossos modelos foram encontrador no site da Sketchfab (sketchfab.com).
Eu sempre tive interesse por modelagem 3D, então já conhecia o site e sabia que disponobilizava alguns objetos gratuitos, no entanto é preciso ter um básico conheicmento em Blender (blender.org) para exportar os modelos no formato .obj e seus respectivos UV maps.
Ao total tivemos 5 modelos escolhidos (dragão, céu, pedra, oceano e cristal), sendo os cristais foram replicados. A parte mais dificíl foi a movimentação do dragão, que nada mais é a aplicação d euma camera livre que sempre anda pra frente e tem o controle do usuário dos ângulos theta e phi,
esses controles estão nas teclas AWSD. Sendo WS para controlar o ângulo phi e AD para controlar o ângulo theta. Então todo o controle da movimentação do jogo é feita por essas teclas (AWSD).
O jogador ganha o jogo quando coletar um total de 10 cristais e perde o jogo caso colida com a pedra do mapa ou com o oceano. Também, quando o jogador sai fora dos limites do mapa ele pe teletransportado para o lado oposto do mapa.

> Laura Cárdenas Grippa: 

|-----------------------------------------------------+
| Critérios Técnicos                                  |
|-----------------------------------------------------+
| Malhas poligonais complexas                         |
> As malhas mais complexas que temos é o do dragão e do céu. O dragão tem um total de 4.9k de triângulos.

| Transformações geométricas controladas pelo usuário |
> As transformações que temos é o controle da camela e a angulação do dragão ao dobrar para os lados.

| Câmera livre e câmera look-at                       |
> A câmera livre é aplicada na movimentação do dragão com a câmera, mas também temos uma câmera livre quando o jogador colide com a pedra. 
A câmera look-at está implentada quando o jogador colide com o oceano que é um plano, essa câmera fica apontada para o dragão. 

| Instâncias de objetos                               |
> As intâncias que temos são dos objetos dragão (complexo), oceano (plano), céu (esfera de alta poligonagem), pedra (baixa poligonagem) e cristal (baixa poligonagem).
O cristal é o único modelo replicado 10 vezes com uma única instância.

| Três tipos de testes de intersecção                 |
> Temos testes de intersecção de ponto com plano, o ponto é o dragão e os planos são: o oceano e os limites do mapa. Quando o dragão ponto colide com o oceano (plano), ele perde o jogo.
Quando ele colide com os limites do mapa ele é teletransportado para o lado oposto do mapa. Outro teste,é o ponto com esfera em que é usado na coleta dos cristais, em que o dragão é uma esfera e o cristais são pontos para a colisão.
A colisão ponto com cubo é utlizado em que o dragão é um ponto e a pedra é um cubo.

| Modelos de Iluminação Difusa                        |
> A Iluminação Difusa está implementada no dragão, cristais, pedra e o céu.

| Modelos de Iluminação Blinn-Phong                   |
> A Iluminação Blinn-Phong está implementada no oceano.

| Modelos de Interpolação de Phong                    |
> Implementado em todos os objetos.

| Modelos de Interpolação de Gouraud                  |
> Richard: Não consegui implementar de jeito nenhum essa interpolação, acabei desistindo...

| Mapeamento de texturas em todos os objetos          |
> Temos mapeamento UV nos objetos: oceano, dragão, pedra e cristal.

| Movimentação com curva Bézier cúbica                |
> A movimentão de curvas de Bézier cúbica estão implementada nos cristais.

| Animações baseadas no tempo ($\Delta t$)            |
> As animações baseadas no tempo estão na movimentação do dragão e demais objetos que se movem.

|-----------------------------------------------------+

 ________________
|     Imagens    |
> As imagens de funcionamento estão na pasta raiz desse projeto nomeadas de imagem-1.png e imagem-2.png

 _______________
|     Manual    |
> Utilizar as teclas AWSD para movimentar o dragão.

 ________________
|   Compilação   |
1) Abra o arquivo de projeto Fl_Project no no CodeBlocks
2) Rebuild o projeto usando o atalho Ctrl + F11
3) Build e run o projeto untilizando o atalho F9
4) Pronto! O jogo estará rodando.