# CONTEXTO TÉCNICO, ARQUITETURAL E ESPECIFICAÇÃO OPERACIONAL — PHAGOCRISIS
**Repositório Oficial:** `https://github.com/lucasguedin/Phagocrisis.git`  
**Disciplina:** OPT010 — Desenvolvimento de Jogos (UTFPR - Câmpus Campo Mourão)  
**Motor de Jogo:** Godot Engine 4.x (Linguagem GDScript, Licença MIT)  
**Gênero:** Twin-Stick Shooter / Roguelite Top-Down 2D  
**Proporção de Tela / Viewport:** 1920x1080 (16:9), escalonamento `canvas_items` ou `viewport` em modo pixel-perfect (sem esticamento bilinear)  
**Público e Plataformas de Entrega:** PC Desktop nativo (pacote `.zip` para Windows/Linux) e Web (HTML5 publicado no Itch.io com cabeçalhos de isolamento cross-origin para suporte a `SharedArrayBuffer`)  
**Taxa de Quadros Alvo:** 60 FPS contínuos e estáveis com controle rigoroso de alocação de nós e descarte por `VisibleOnScreenNotifier2D`  

---

## 1. DIVISÃO FORMAL DE PAPÉIS DA EQUIPE (CRITÉRIO UTFPR: 50% GERAL / 50% INDIVIDUAL)

O repositório e as tarefas devem refletir a separação clara e modular de responsabilidades técnicas, garantindo que os commits e nós na árvore de cenas evidenciem a autoria individual:

1. **Victor Angelo Souza Santos (Programador A — Jogador e UI):**
   * **Domínio de Código e Cenas:** Cinemática e física do player (`CharacterBody2D`), esquema de entradas duplas (`InputMap` com paridade entre Teclado+Mouse e Gamepad analógico), sistema de mira contínua em 360°, instanciação de projéteis enzimáticos cáusticos, esquiva com *i-frames* (dash citoplasmático), mecânica de absorção por quimiotaxia e fagocitose (`Area2D`), HUD desacoplado em camada estática (`CanvasLayer`), máquina de estados das telas (Splash UTFPR, Menu Principal, Tutorial, Pausa in-game com suspensão de física, Game Over e Vitória), sonoplastia do jogador e pipeline de exportação e empacotamento das builds (PC `.zip` e Web HTML5).

2. **Lucas Silva Guedin (Programador B — Mundo e Entidades):**
   * **Domínio de Código e Cenas:** Arquitetura central do `GameManager` (Autoload / Singleton), controle de fluxo de ondas e detecção de contenção de salas (`RoomTrigger` + travas de portas orgânicas), geradores de hordas (`Spawner2D` com temporizadores cíclicos), arquitetura polimórfica de IA dos patógenos (`EnemyBase.gd` com injeção de parâmetros via `EnemyData.tres`), comportamentos específicos dos arquétipos (Perseguidor, Atirador Radial e Tanque), catálogo completo das 5 famílias biológicas e seus 5 chefes, sistema dinâmico de power-ups temporários (15s) e permanentes (adaptações mitóticas pós-chefe), sonoplastia ambiente/músicas e redação do material da página do Itch.io.

3. **Lucas Antonio Marcão (Artista Técnico — Arte e Level Design):**
   * **Domínio de Assets, Cenas e Renderização:** Criação de toda a biblioteca visual em Pixel Art 2D autoral (paleta contrastante de alta saturação sobre fundo orgânico escuro, sem assets de terceiros ou ripados); produção e configuração de animações (`AnimatedSprite2D` e `AnimationPlayer`) para o fagócito, projéteis, 15 patógenos e 5 chefes; montagem do sistema de `TileSets` vasculares com colisões ajustadas e autotiling; Level Design modular das 8 a 14 salas por tecido; integração de perigos de terreno (muco viscoso redutor de velocidade e bio-toxina cáustica contínua); iluminação dinâmica 2D (`PointLight2D` e `LightOccluder2D`); emissores de partículas em GPU (`GPUParticles2D`) para respingos ácidos, rastro de dash e desintegração orgânica; e confecção do kit de marketing do Itch.io (banner, screenshots e GIFs de gameplay).

---

## 2. PILARES DE DESIGN (CORE PILLARS — ACADÊMICO E VIABILIDADE DE ESCOPO)

1. **Loop de Jogo Limpo e Imediato:** O ciclo central é sem atrito: Entrada na câmara $\rightarrow$ Fechamento dos esfíncteres $\rightarrow$ Eliminação das hordas e spawners $\rightarrow$ Coleta de biomassa/recompensas $\rightarrow$ Abertura das passagens. Foco em jogabilidade arcade responsiva.
2. **Simplicidade e Precisão de Controle (Twin-Stick Tradicional):** O eixo esquerdo (ou teclas WASD) governa o deslocamento; o eixo direito (ou posição global do mouse) direciona o ângulo focal em 360°. O jogador não precisa gerenciar inventários complexos em tempo real; a ação é instantânea.
3. **Escalonamento Claro e Legibilidade de Ameaças:** Cada uma das 5 fases introduz uma classe patogênica com silhueta morfológica, padrão de ataque e paleta de cores imediatamente reconhecíveis (vírus velozes de contato, bactérias protegidas por carapaça, fungos emissores de esporos radiais, parasitas segmentados e massas neoplásicas mutantes).
4. **Modularidade Técnica e Orientação a Objetos:** Toda a arquitetura do projeto na Godot 4 é desacoplada. Os inimigos herdam de uma cena/script base comum; balanceamento numérico é injetado via arquivos de recurso `.tres`; salas, portas e colecionáveis são instâncias de cenas `.tscn` plugáveis e reutilizáveis.

---

## 3. ARQUITETURA DE ENGENHARIA NA GODOT 4

### 3.1 Camadas de Colisão (`Collision Layers & Masks`)
Para evitar cruzamento indevido de sinais de física e garantir que tiros e corpos colidam estritamente com seus alvos, a matriz de 32 bits da Godot 4 é particionada da seguinte forma:

* **Layer 1 (`World_Solid`):** Paredes dos TileMaps vasculares, barreiras teciduais intransponíveis e esfíncteres musculares fechados.
* **Layer 2 (`Player_Body`):** Colisor cinemático do fagócito (`CharacterBody2D`).
* **Layer 3 (`Enemy_Body`):** Colisor cinemático dos patógenos comuns e chefes.
* **Layer 4 (`Player_Projectiles`):** Enzimas cáusticas disparadas pelo jogador (`Area2D`). Colidem com Layer 1 e Layer 3.
* **Layer 5 (`Enemy_Projectiles`):** Esporos, toxinas e tiros emitidos por inimigos (`Area2D`). Colidem com Layer 1 e Layer 2.
* **Layer 6 (`Pickups_Collectibles`):** Glóbulos de ATP, fragmentos de biomassa e receptores moleculares (chaves). Detectados apenas pela Layer 2 (e pela área de atração magnética do player).
* **Layer 7 (`Environmental_Hazards`):** Áreas de muco desacelerador e poças de secreção bio-ácida. Detectam Layer 2 (e opcionalmente Layer 3 para patógenos terrestres).
* **Layer 8 (`Triggers_Rooms`):** Gatilhos invisíveis de entrada de sala (`Area2D`) para ativação de portas e despache de hordas. Detectam apenas Layer 2.

### 3.2 Singletons / Autoloads do Projeto
1. **`GameManager.gd`:**
   * Controla a máquina de estados global: `MAIN_MENU`, `IN_GAME`, `PAUSED`, `LEVEL_CLEAR`, `GAME_OVER`, `VICTORY`.
   * Mantém o índice do nível atual (`current_level`: 1 a 5).
   * Armazena e persiste as Adaptações Mitóticas (upgrades permanentes dos chefes).
   * Controla a pontuação de biomassa acumulada e o tempo total de run.
   * Conecta sinais de salas (`room_entered`, `room_cleared`) para coordenar portas e fluxo de combate.
2. **`SoundManager.gd`:**
   * Gerencia 3 barramentos de áudio (`AudioServer`): `Master`, `BGM` (música de fundo em loop) e `SFX` (efeitos sonoros).
   * Contém um pool de nós `AudioStreamPlayer` para tocar múltiplos efeitos sem corte abrupto ou saturação.

---

## 4. ESPECIFICAÇÃO COMPLETA: PROGRAMADOR A (JOGADOR E UI)

### 4.1 Cinemática e Física do Fagócito (`Player.tscn` — `CharacterBody2D`)
* **Movimentação Protoplasmática Vetorial:**
  * Leitura de entrada via `Input.get_vector("move_left", "move_right", "move_up", "move_down")`.
  * Vetor normalizado $\vec{v}_{dir}$ garantindo que a magnitude máxima não exceda $1.0$ nas diagonais.
  * Velocidade escalar máxima: $V_{max} = 220\text{ px/s}$.
  * Fórmula de aceleração e desaceleração por atrito hidrodinâmico no `_physics_process(delta)`:
	$$\vec{v}_{atual} = \vec{v}_{atual}.\text{lerp}(\vec{v}_{dir} \cdot V_{max}, \text{ACCEL} \cdot delta)$$
	Onde $\text{ACCEL} = 10.0$ para arranque e $\text{FRICTION} = 6.0$ para inércia residual após soltar os comandos.
  * Deslocamento final por `move_and_slide()`.

* **Sistema de Esquiva / Dash Citoplasmático:**
  * **Velocidade de Impulso:** $480\text{ px/s}$ aplicados instantaneamente na direção atual do deslocamento (se o jogador estiver estático, o dash ocorre na direção apontada pela mira).
  * **Duração da Propulsão:** $0.2\text{ s}$ controlado por temporizador.
  * **Janela de Invulnerabilidade (*I-Frames*):** Durante os $0.2\text{ s}$, a colisão de dano do jogador é desligada ou marcada como invulnerável; o sprite recebe modulação visual translúcida (`modulate.a = 0.4`) para feedback imediato.
  * **Recarga (*Cooldown*):** $0.8\text{ s}$ contados a partir do término do dash.
  * **Custo Energético:** Consome 25 unidades da barra de ATP (capacidade padrão de 100). Caso o ATP seja $< 25$, o dash é bloqueado e emite um breve sinal visual/sonoro de recusa.

* **Mira Contínua e Disparo de Enzimas:**
  * **Cálculo da Mira 360°:** 
	* No Teclado+Mouse: cálculo angular com `look_at(get_global_mouse_position())`.
	* No Gamepad: rotação direcionada pelo vetor do analógico direito `Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))`. Se a magnitude da inclinação for inferior à zona morta ($0.25$), a mira preserva o último ângulo válido.
  * **Projétil Cáustico (`EnzymeProjectile.tscn` — `Area2D`):**
	* Spawn posicionado em um ponto focal frontal (`Marker2D`) com deslocamento de $16\text{ px}$ em relação ao centro do corpo.
	* Velocidade linear: $550\text{ px/s}$ constante.
	* Cadência padrão: 3 disparos por segundo (`Timer` de $0.33\text{ s}$).
	* Dano base: 10 pontos por projétil.
	* Gerenciamento de memória: nó `VisibleOnScreenNotifier2D` integrado ao projétil conectando o sinal `screen_exited` diretamente à função `queue_free()`.

* **Quimiotaxia e Fagocitose Tática:**
  * O fagócito possui uma `Area2D` circular anexada com raio de $80\text{ px}$ monitorando a Layer 6 (Pickups).
  * Quando um glóbulo de ATP ou partícula de biomassa entra na área, o item perde o estado de repouso e aplica uma força de atração exponencial em direção ao centro do fagócito:
	$$\vec{v}_{item} = \vec{v}_{item} + (\vec{pos}_{player} - \vec{pos}_{item}).\text{normalized}() \cdot \text{PULL\_FORCE} \cdot delta$$
  * Ao colidir com o fagócito: o glóbulo restaura 10% da vida máxima, restabelece instantaneamente 20 unidades de ATP e incrementa o score de biomassa.

### 4.2 Interface do Usuário (`HUD.tscn` — `CanvasLayer`)
A interface gráfica é desacoplada da movimentação espacial da câmera (`Camera2D` anexada com suavização `position_smoothing_enabled = true`):
1. **Barra de Integridade Celular (HP):** Nó `TextureProgressBar` segmentado em 5 glóbulos ou barra cáustica com preenchimento em vermelho vivo, reagindo a sinais de `player_health_changed`.
2. **Medidor de ATP (Energia Metabólica):** Barra dinâmica azul/ciano com regeneração passiva contínua de $15\text{ unidades/s}$ após $1.0\text{ s}$ de retardo sem consumo de dash.
3. **Contador de Biomassa / Score:** Nó `Label` estilizado posicionado no canto superior direito, atualizado via sinal emitido pelo `GameManager`.
4. **Slots de Receptores Moleculares:** 3 ícones vazados que acendem em amarelo fosforescente ao coletar chaves biológicas de portas fechadas.
5. **Notificação de Buff Temporário:** Mostrador no centro inferior da tela com o ícone do power-up ativo e uma barra radial ou numérica em contagem regressiva de 15 a 0 segundos.
6. **Efeitos Visuais de Tela (Screen Shake e Hurt Vignette):**
   * Ao tomar dano, a câmera executa um trauma angular e translacional aleatório de $0.15\text{ s}$.
   * Uma textura de vinheta periférica avermelhada pisca suavemente na tela através de um nó `TextureRect` cobrindo o viewport.

### 4.3 Telas e Menus do Sistema
* **`SplashScreen.tscn`:** Exibição institucional obrigatória do logotipo da UTFPR em fundo limpo por 2.0 segundos, realizando transição por fade out para a tela de título.
* **`MainMenu.tscn`:** Tela inicial com o logotipo estilizado de *PhagoCrisis*, dados da disciplina, data, autores e os botões funcionais: *Iniciar Jogo*, *Instruções*, *Créditos* e *Sair* (apenas compilação desktop).
* **`InstructionsScreen.tscn`:** Exibição gráfica dos controles e explicação objetiva do core loop e das ameaças patogênicas.
* **`PauseOverlay.tscn`:** Menu instanciado sobre a tela de gameplay com `process_mode = PROCESS_MODE_WHEN_PAUSED`, contendo as opções *Retomar*, *Instruções* e *Voltar ao Menu Principal*.
* **`LevelClearScreen.tscn`:** Transição entre biomas com a mensagem de "Tecido Purificado", resumo de tempo, biomassa colhida e apresentação da nova adaptação permanente conquistada.
* **`GameOverScreen.tscn`:** Exibido quando a vida do fagócito atinge 0, com botões para *Tentar Novamente* (reinicia o tecido atual) ou *Menu Principal*.
* **`VictoryScreen.tscn`:** Desfecho vitorioso exibido após a derrota do chefe da Fase 5 (Neoplasia Maligna), exibindo dados finais da partida e créditos da equipe.

---

## 5. ESPECIFICAÇÃO COMPLETA: PROGRAMADOR B (MUNDO, ENTIDADES E IA)

### 5.1 Arquitetura de Classes dos Inimigos
Todos os agentes patogênicos derivam de uma árvore polimórfica comum:
* **`EnemyBase.gd` (`CharacterBody2D`):**
  * Script base contendo a máquina de estados elementar:
	* `IDLE`: Repouso ou pulsação antes da entrada do jogador na câmara.
	* `CHASE`: Perseguição vetorial ou aproximação orbital em direção ao fagócito.
	* `ATTACK`: Execução de investida de contato ou ciclo de disparo de esporos.
	* `HURT`: Flash visual vermelho/branco no material (`ShaderMaterial`) e breve recuo (*knockback*).
	* `DEAD`: Desativação de colisores, disparo de partículas de lise celular, emissão de drops (biomassa/ATP) e chamada a `queue_free()`.
  * **Desacoplamento via Recursos (`EnemyData.gd` / `Resource`):**
	Variáveis injetadas sem necessidade de alteração de código:
	* `max_health: float`
	* `movement_speed: float`
	* `contact_damage: float`
	* `attack_interval: float`
	* `biomass_score_value: int`
	* `drop_atp_chance: float`

### 5.2 Os Três Arquétipos Principais de Comportamento
1. **Arquétipo Perseguidor (Ex: Cápsides Virais, Micro-Nematódeos):**
   * Movimenta-se em linha reta recalculando continuamente o vetor em direção ao centro do fagócito (`global_position.direction_to(player.global_position)`).
   * Alta velocidade de deslocamento ($200 \text{ a } 240\text{ px/s}$).
   * Baixa integridade (morrem com 1 a 3 projéteis).
   * Causam dano imediato ao interceptar o jogador e sofrem destruição por impacto ou repulsão elástica.
2. **Arquétipo Atirador Radial / Controle de Área (Ex: Vírus de Replicação, Esporos Fúngicos):**
   * Movimentação errática lenta ($80 \text{ a } 110\text{ px/s}$), mantendo raio de distância segura ($250 \text{ a } 350\text{ px}$) do fagócito.
   * A cada `attack_interval` (aprox. $2.0\text{ s}$), para a movimentação e emite uma rajada concêntrica de projéteis (4 a 8 esporos distribuídos uniformemente em 360° através da divisão angular $\theta = \frac{2\pi}{N}$).
3. **Arquétipo Tanque / Barreira (Ex: Bacilos de Carapaça):**
   * Velocidade reduzida ($60 \text{ a } 80\text{ px/s}$) com massa elevada e imunidade a knockback frontal.
   * Possuem alta absorção de dano na carapaça anterior, exigindo manobra com dash para atingir a membrana traseira desprotegida ou uso do power-up de tiro concentrado.

### 5.3 O Sistema de Spawners (`Spawner2D.tscn`) e Gatilhos de Sala
* **Estrutura do Ninho Patogênico:** Nó posicionado no centro ou cantos das salas fechadas. Possui temporizador interno com cadência de spawn ajustável ($1.5 \text{ a } 3.0\text{ s}$).
* **Fila Finita e Teto de Entidades:** O spawner possui uma cota máxima de inimigos que pode instanciar por onda (ex: 8 a 15 inimigos por sala) e um limite de concorrência ativa (máximo de 6 entidades simultâneas por spawner para não degradar a taxa de quadros).
* **Gatilho de Contenção (`RoomTrigger.tscn` — `Area2D`):** Posicionado nas passagens de entrada de cada sala. Ao detectar a entrada do fagócito:
  1. Aciona o fechamento instantâneo dos esfíncteres musculares daquela sala (ativando a colisão sólida).
  2. Liga os temporizadores dos spawners vinculados àquela câmara.
  3. Registra a contagem de entidades vivas no `GameManager`.
  4. Quando a cota de todos os spawners da sala for instanciada e todas as entidades ativas forem neutralizadas, o `GameManager` emite o sinal `room_cleared`, abrindo os esfíncteres e permitindo a passagem.

### 5.4 Sistema de Itens, Baús e Power-Ups
* **Consumíveis Imediatos:**
  * `Glóbulo de ATP`: Drop individual com física leve de flutuação; cura 10% de HP e recarrega 20 de ATP ao ser fagocitado.
  * `Receptor Molecular`: Chave biológica recolhida em salas laterais de exploração, consumida ao encostar em portas de membrana trancadas.
* **Vacúolos Celulares (`VacuoleChest.tscn`):** Organelos esféricos estáticos colocados em salas de recompensa. Ao receber dano ou toque, rompem-se emitindo partículas e liberando um dos 3 power-ups temporários:
  1. *Damage Shot (Enzima Concentrada):* Duração de 15 segundos. Multiplica o dano por 3x e altera a coloração dos tiros para amarelo fluorescente.
  2. *Spread Shot (Dispersão Citoplasmática):* Duração de 15 segundos. Dispara 3 enzimas simultâneas com dispersão angular de $-20^\circ$, $0^\circ$ e $+20^\circ$.
  3. *Rapid Shot (Hipermetabolismo):* Duração de 15 segundos. Reduz o cooldown de tiro de $0.33\text{ s}$ para $0.16\text{ s}$ (dobrando a cadência).
  *(Nota técnica: Os power-ups são cumulativos se coletados em sequência).*
* **Adaptações Mitóticas Permanentes (Upgrades de Chefes):**
  * Fase 1 Vencida $\rightarrow$ *Membrana Lipídica Reforçada:* Aumenta o HP Máximo do fagócito em +25%.
  * Fase 2 Vencida $\rightarrow$ *Mitocôndria Supercarregada:* Aumenta a taxa de regeneração do ATP em +30%.
  * Fase 3 Vencida $\rightarrow$ *Pseudópodes Fortalecidos:* +15% de velocidade de movimento base e imunidade completa à lentidão provocada por muco viscoso.
  * Fase 4 Vencida $\rightarrow$ *Glândula Digestiva Avançada:* Aumenta permanentemente o dano base dos tiros em +20% para a batalha neoplásica final.

---

## 6. ESPECIFICAÇÃO COMPLETA: ARTISTA TÉCNICO (ARTE, ANIMAÇÕES E LEVEL DESIGN)

### 6.1 Direção de Arte e Princípios Visuais
* **Estética:** Pixel Art autoral 16-bit com tema biopunk microscópico.
* **Teoria das Cores e Contraste Funcional:**
  * Fundo vascular e paredes teciduais: tons escuros de carmesim, marrom orgânico, roxo necrótico e azul estromal profundo.
  * Entidades hostis e projéteis: cores de alta saturação luminescente (verde tóxico neon, amarelo ácido, ciano elétrico e magenta purulento), garantindo que projéteis e inimigos sejam discerníveis no calor do tiroteio.
* **Software de Criação:** Aseprite / LibreSprite / GIMP (com grid configurado em 16x16 e 32x32 pixels).

### 6.2 Level Design, TileSets e Obstáculos de Terreno
* **TileSets Vasculares Modulares:**
  * Paredes teciduais sólidas com colisão física convexa estrita.
  * Membranas permeáveis no piso com variação cosmética de textura celular.
  * Esfíncteres musculares com animação de 4 quadros (estado de dilatação para passagem livre e estado de contração para barreira fechada).
* **Estrutura das Fases:**
  * Cada um dos 5 tecidos possui entre 8 e 14 salas dispostas em malha não-linear (arenas obrigatórias, bifurcações com salas de vacúolos/baús opcionais e a câmara cavernosa do chefe final).
* **Perigos de Cenário:**
  * `Área de Muco Viscoso` (`Area2D` com camada de colisão 7): Reduz a velocidade instantânea do fagócito em 40% enquanto sobreposto (penalidade anulada caso possua o upgrade de Pseudópodes).
  * `Poça de Bio-Toxina Ácida` (`Area2D` com camada de colisão 7): Aplica dano fracionado por segundo ($DoT$) com pulso avermelhado enquanto o corpo do jogador permanecer em contato com o fluido corrosivo.

### 6.3 Iluminação Dinâmica 2D e Sistemas de Partículas em GPU
* **Iluminação com Sombras Suaves (`PointLight2D`):**
  * O fagócito carrega um foco de bioluminescência suave com textura radial suave (gradiente de 256x256 px).
  * Projéteis cáusticos emitem luz pontual amarela/verde em alta velocidade.
  * As paredes do TileMap possuem nós `LightOccluder2D` associados às suas poligonais, bloqueando a luz e gerando sombras dinâmicas que criam atmosfera de tensão nos corredores labirínticos.
* **Sistemas de Partículas (`GPUParticles2D`):**
  1. *Respingos Cáusticos:* Emitidos na colisão do projétil com inimigos ou paredes (12 a 16 partículas com gravidade nula, velocidade explosiva radial e cor verde-ácido decaindo em transparência).
  2. *Rastro de Dash:* Emissor ativado estritamente durante os $0.2\text{ s}$ da esquiva, soltando glóbulos protoplasmáticos ao longo da trajetória percorrida.
  3. *Lise Celular (Morte de Inimigos):* Explosão curta de fragmentos celulares e biomassa luminosa quando qualquer patógeno tem sua integridade zerada.

---

## 7. CATÁLOGO COMPLETO DE INIMIGOS E CHEFES POR BIOMA (15 VARIANTES + 5 CHEFES)

| Fase / Tecido | Patógeno 1 (Comum/Rápido) | Patógeno 2 (Médio/Atirador) | Patógeno 3 (Especial/Tanque) | CHEFE DE BIOMA (Alfa) | Mecânica Central do Chefe |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Fase 1: Tecido Linfático (Infecção Viral)** | **Cápside Menor:** Perseguidor rápido, morre com 1 tiro. | **Bacteriófago:** Movimento saltatório, dispara 2 esporos lineares. | **Vírus de Replicação:** Ao morrer, divide-se em 2 cápsides menores. | **VÍRUS TITÃ ICOSAÉDRICO** | Alterna entre investidas em alta velocidade e rajadas radiais de 12 agulhas protéicas. |
| **Fase 2: Tecido Sanguíneo (Colônia Bacteriana)** | **Micro-Coco:** Agrupa-se em enxames esféricos de contato. | **Bacilo com Flagelo:** Dispara jatos ácidos direcionados. | **Bacilo com Carapaça:** Carapaça frontal impenetrável; vulnerável nas costas. | **SUPER-BACILO BIOFILME** | Gera escudos protetores de biofilme e poças ácidas persistentes na arena. |
| **Fase 3: Tecido Pulmonar (Foco Fúngico)** | **Esporo Flutuante:** Flutuação senoidal lenta com explosão de contato. | **Hifa Sentinela:** Enraizada estaticamente; dispara rajadas radiais regulares de esporos. | **Fungo Corrosivo:** Rastejador que deixa rastro contínuo de muco desacelerador. | **COLOSSAL MICÉLIO CENTRAL** | Enraizado no centro; emite anéis densos de esporos e invoca ninhos patogênicos simultâneos. |
| **Fase 4: Tecido Digestivo (Surto Parasitário)** | **Micro-Nematódeo:** Movimento ondulatório veloz, tentando circundar o fagócito. | **Ameba Proteiforme:** Altera sua hitbox; dispara pseudópodes elásticos. | **Sugador de ATP:** Ataca drenando a barra de ATP antes de retirar vida. | **HELMINTA RAINHA MUTANTE** | Movimentação em segmentos articulados; investe pelas paredes cavando e reaparecendo na arena. |
| **Fase 5: Medula Óssea (Neoplasia Maligna)** | **Célula Anômala:** Divisão celular acelerada se não for eliminada rapidamente. | **Sentinela Neoplásica:** Emite feixes cáusticos concentrados de longo alcance. | **Massa Angiogênica:** Alta integridade; regenera a vida de patógenos próximos. | **O CARCINOMA PRIMORDIAL** | Batalha em 2 fases: forma tecidual angiogênica e núcleo sarcomatoso móvel com disparo contínuo de toxinas. |

---

## 8. PIPELINE DE EXPORTAÇÃO, COMPATIBILIDADE E PUBLICAÇÃO ITCH.IO

1. **Configuração de Build Web (HTML5):**
   * A Godot 4 utiliza threads WebAssembly com requisitos restritos de segurança no navegador.
   * Na página de edição de jogo no Itch.io, nas configurações de "Embed options", deve-se obrigatoriamente marcar a opção:
	 * **"SharedArrayBuffer support (Cross-Origin Isolation)"**
   * Sem este cabeçalho, o jogo travará na tela de carregamento ou não inicializará o servidor de áudio da engine.
2. **Configuração de Build Desktop (PC):**
   * Presets configurados no Godot Export para Windows (`.exe` com binário compilado de 64 bits) e Linux (`.x86_64`).
   * Todos os recursos de mídia, fontes e `.tres` devem ser empacotados dentro do arquivo `.pck` embutido ou adjacente, comprimidos em um único arquivo `.zip` final para distribuição no Itch.io.
3. **Otimização Crítica para Manutenção de 60 FPS:**
   * Nenhum projétil ou inimigo pode permanecer na árvore de cenas (`SceneTree`) após sair do viewport da câmera ou ser destruído. A rotina `queue_free()` deve ser sempre validada.
   * Evitar buscas de nós via caminhos literais de string na rotina `_process` (como `get_node("../../../Player")`). Injetar referências via variáveis exportadas (`@export`), grupos (`add_to_group("player")`) ou sinais desvinculados.
