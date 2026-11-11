# 📋 Especificação Completa e Exaustiva das Issues — PhagoCrisis (Escopo: Victor Angelo — Programador A, Sprites & Áudio)

**Projeto:** PhagoCrisis — Twin-Stick Shooter / Roguelite Biopunk 2D  
**Disciplina:** OPT010 — Desenvolvimento de Jogos (UTFPR — Câmpus Campo Mourão)  
**Docente Responsável:** Prof. Marcos Silvano Almeida  
**Motor de Jogo:** Godot Engine 4.x (GDScript, Renderizador `gl_compatibility`, Licença MIT)  
**Responsável Técnico deste Caderno de Issues:** **Victor Angelo Souza Santos (Programador A — Jogador, UI, Fluxo de Telas, Sprites do Domínio, Sonoplastia do Jogador/UI e Pipeline de Compilação PC/Web)**  
**Repositório Oficial:** `https://github.com/lucasguedin/Phagocrisis.git`

---

## 🏛️ Os 15 Princípios Fundamentais para Criação e Estruturação de Issues
Criar uma issue bem estruturada é a garantia de entrega sem ambiguidades e com reprodutibilidade técnica absoluta. Cada issue deste projeto segue rigorosamente o padrão das 15 características fundamentais:

1. **Título Claro e Conciso com Prefixo:**
   - Sintaxe padronizada: `### **Issue #XX: [Prefixo] Ação e Escopo**`.
   - Prefixos padronizados: `[Infraestrutura]`, `[Ambiente]`, `[Backend]`, `[Frontend]` e `[Documentação]`.

2. **História de Usuário (User Story):**
   - Define o valor e propósito de negócio em formato de citação:
   > **Como** [persona],
   > **eu quero** [funcionalidade/ação],
   > **para que** [benefício/valor mensurável].

3. **Critérios de Aceitação (AC - Gherkin):**
   - Condições de aprovação verificáveis escritas na sintaxe BDD/Gherkin:
   * **Dado que** [contexto inicial], **quando** [ação executada], **então** [resultado técnico esperado].

4. **Exemplo de Requisição (Código/Payload/CLI):**
   - Trecho executável de chamada de terminal, script GDScript, configuração de cena `.tscn`, `project.godot` ou preset de exportação com dados reais de teste.

5. **Exemplo de Resposta (Saída esperada / Log de Terminal):**
   - Saída esperada no console de depuração da Godot Engine, retorno de sinais ou log de compilação comprovando o sucesso ou tratamento formal de exceções.

6. **Componentes Envolvidos:**
   - Mapeamento exato de arquivos de código (`src/`), cenas (`scenes/`), diretórios de arte (`sprites/`), áudio (`audio/`), recursos (`resources/`) ou configurações de sistema afetadas.

7. **Considerações Técnicas e Arquitetura:**
   - Justificativa arquitetural na Godot 4, padrões de projeto (Observer/Signals, State Machine, Autoloads), diretrizes de performance (60 FPS estáveis, descarte de nós) e vínculos com o Mini GDD e requisitos da disciplina OPT010.

8. **Mockups ou Referências Visuais:**
   - Diagramas ASCII, árvores de nós da Godot (`SceneTree`), layouts de interface 16:9 ou tabelas visuais de sprites/estados (quando não aplicável a rotinas puras de backend/infra, marcado explicitamente como N/A).

9. **Dependências e Bloqueios:**
   - **Depende de:** Issues que devem estar concluídas previamente.
   - **Bloqueia:** Issues subsequentes que aguardam esta entrega.

10. **Como Testar (Plano de Teste Passo a Passo):**
	- Roteiro sequencial de validação para o desenvolvedor ou revisor executar no editor da Godot ou via terminal para comprovar o funcionamento.

11. **Definição de Pronto (Definition of Done - DoD):**
	- Critérios de qualidade técnica (tipagem estática em GDScript, ausência de órfãos/vazamentos na árvore de cenas, paridade Teclado/Mouse + Gamepad, documentação atualizada e zero regressões).

12. **Prioridade e Severidade:**
	- Prioridade de negócio/projeto (Alta, Média, Baixa) e Severidade técnica (Crítica, Alta, Média).

13. **Etiquetas (Labels):**
	- Tags de categorização para filtros no repositório (`backend`, `frontend`, `infraestrutura`, `ambiente`, `documentacao`, `godot-4`, `pixel-art`, `audio`, etc.).

14. **Documentação Relacionada:**
	- Vínculos diretos com os Requisitos Funcionais (RF01 a RF15), Requisitos Não Funcionais (RNF01 a RNF08), Seções do Mini GDD e Diretrizes da Disciplina OPT010.

15. **Estimativa:**
	- Complexidade avaliada em T-Shirt Size (S, M, L) e Story Points (1, 2, 3, 5, 8).

---

## 🎯 Matriz de Requisitos do Sistema (Mini GDD & Regulamento OPT010)

### Requisitos Funcionais (RF — Escopo do Jogador, Arte Associada, Áudio, UI e Fluxo)
* **RF01 - Movimentação Protoplasmática Vetorial:** Locomoção top-down em 8 direções / 360° analógico com velocidade máxima de $220\text{ px/s}$, aceleração ($\text{ACCEL} = 10.0$) e atrito hidrodinâmico ($\text{FRICTION} = 6.0$).
* **RF02 - Paridade Dual de Controles (`InputMap`):** Suporte simultâneo e transparente a Teclado + Mouse e Gamepad (XInput/DirectInput) em 100% do gameplay e menus.
* **RF03 - Mira Contínua em 360°:** Direcionamento angular contínuo via cursor global do mouse ou alavanca analógica direita (com zona morta de $0.25$ e retenção do último ângulo válido).
* **RF04 - Disparo de Enzimas Cáusticas:** Instanciação de projéteis (`Area2D`) a $550\text{ px/s}$ em `Marker2D` frontal ($+16\text{ px}$), cadência base de $0.33\text{ s}$ (3 tiros/s) e dano base de $10$ pontos.
* **RF05 - Esquiva Citoplasmática (Dash com *I-Frames*):** Impulso instantâneo a $480\text{ px/s}$ durante $0.2\text{ s}$ com invulnerabilidade física, feedback translúcido (`modulate.a = 0.4`), custo de $25$ de ATP e recarga (*cooldown*) de $0.8\text{ s}$.
* **RF06 - Gestão Metabólica de ATP:** Barra de energia com capacidade base de $100$ unidades e regeneração passiva contínua de $15\text{ unidades/s}$ após $1.0\text{ s}$ sem uso de dash.
* **RF07 - Quimiotaxia e Fagocitose Tática:** Campo magnético circular (`Area2D`, raio $80\text{ px}$, Layer 6) que atrai glóbulos de ATP e biomassa, restaurando $10\%$ do HP máximo, $+20$ de ATP e somando score ao contato.
* **RF08 - Modificadores de Tiro Temporários (Power-Ups 15s):** Suporte cumulativo aos buffs de *Damage Shot* ($3\times$ dano, cor amarela), *Spread Shot* (leque triplo $-20^\circ, 0^\circ, +20^\circ$) e *Rapid Shot* (cooldown reduzido para $0.16\text{ s}$).
* **RF09 - Adaptações Mitóticas Permanentes (Upgrades de Chefes):** Aplicação persistente de *Membrana Lipídica* ($+25\%$ HP Máx), *Mitocôndria Supercarregada* ($+30\%$ Regen ATP), *Pseudópodes Fortalecidos* ($+15\%$ Velocidade + Imunidade a Muco) e *Glândula Digestiva* ($+20\%$ Dano Base).
* **RF10 - Reação a Perigos Ambientais e Dano:** Redução de $40\%$ de velocidade em Áreas de Muco Viscoso e recepção de dano contínuo ($DoT$) em Poças de Bio-Toxina Cáustica (Layer 7).
* **RF11 - HUD Tático Desacoplado (`CanvasLayer`):** Exibição em tempo real de Barra de Integridade Celular (HP), Medidor de ATP, Contador de Biomassa (Score), 3 Slots de Receptores Moleculares (Chaves) e Temporizador de Buffs Ativos.
* **RF12 - Feedback Sensorial de Câmera e Iluminação:** `Camera2D` suavizada com *Screen Shake* ($0.15\text{ s}$) e *Hurt Vignette* ao sofrer dano, foco bioluminescente (`PointLight2D`) e emissores `GPUParticles2D` (rastro de dash e impacto ácido).
* **RF13 - Máquina de Estados e Fluxo Completo de Telas:** Navegação estruturada com transições de Fade entre *Splash Screen UTFPR* ($2.0\text{ s}$), *Menu Principal*, *Instruções*, *Créditos*, *Pausa In-Game*, *Level Clear*, *Game Over* e *Vitória Final*.
* **RF14 - Arte Autoral em Pixel Art 16-bit:** Criação manual de spritesheets para o fagócito, projéteis, ícones de UI, barras e telas com alto contraste cromático sobre fundo vascular escuro.
* **RF15 - Sonoplastia e Mixagem de Áudio:** Seleção, síntese e integração de efeitos sonoros (SFX) do jogador e da interface gerenciados por pool polifônico em barramentos dedicados (`Master`, `BGM`, `SFX`).

### Requisitos Não Funcionais (RNF)
* **RNF01 - Estabilidade de Taxa de Quadros (60 FPS):** Manutenção de 60 FPS contínuos no PC e 30–60 FPS na Web com descarte obrigatório de projéteis fora da tela via `VisibleOnScreenNotifier2D`.
* **RNF02 - Renderização e Compatibilidade Multiplataforma:** Uso do método de renderização `gl_compatibility` para suporte pleno a WebGL2 / HTML5 e binários nativos Windows/Linux.
* **RNF03 - Fidelidade Pixel-Perfect (16:9):** Resolução base de $1920\times 1080$ (ou escala inteira proporcional) com modo de esticamento `canvas_items` e filtro de textura `Nearest` (sem borramento bilinear).
* **RNF04 - Arquitetura Desacoplada por Sinais:** Proibição de buscas literais por caminhos relativos frágeis (`get_node("../../../")`) dentro de `_process` ou `_physics_process`; comunicação estrita via sinais (`signal`), grupos (`player`) e `@export`.
* **RNF05 - Isolamento de Camadas Físicas (32-bit Collision Matrix):** Particionamento rigoroso das Layers 1 a 8 para evitar colisões acidentais entre projéteis aliados, inimigos, sensores de sala e pickups.
* **RNF06 - Suporte a `SharedArrayBuffer` na Build Web:** Exportação HTML5 compatível com cabeçalhos de isolamento Cross-Origin (COOP/COEP) exigidos pela Godot 4 no Itch.io.
* **RNF07 - Empacotamento Autocontido Desktop:** Distribuição das builds PC em arquivo `.zip` único contendo o executável e o pacote `.pck` validado.
* **RNF08 - Rastreabilidade de Autoria Individual (Critério UTFPR 50%/50%):** Modularização clara de scripts, cenas e commits comprovando a entrega integral das atribuições do Programador A.

---

## 📑 Índice Geral das 45 Issues por Grupo

> **Nota:** Todas as issues abaixo estão desmarcadas (`[ ]`) para controle de implementação completa futura conforme o DoD final. O projeto conta atualmente com o **Protótipo Frugal Funcional** em `scenes/cena_2d.tscn`.

### 🏗️ Grupo 1: Infraestrutura, Ambiente Godot 4 e Arquitetura de Entradas
- [ ] **Issue #01:** `[Infraestrutura]` Configuração do `project.godot`, viewport 1920x1080 (16:9) pixel-perfect e renderizador Compatibility
- [ ] **Issue #02:** `[Infraestrutura]` Padronização da árvore de diretórios (`src/`, `scenes/`, `sprites/`, `audio/`, `resources/`) e `.gitignore`
- [ ] **Issue #03:** `[Ambiente]` Configuração da Matriz de Camadas e Máscaras de Colisão Física de 32 bits (Layers 1 a 8)
- [ ] **Issue #04:** `[Ambiente]` Mapeamento do `InputMap` Dual Paritário (Teclado + Mouse e Gamepad XInput/DirectInput com Deadzone)
- [ ] **Issue #05:** `[Backend]` Refatoração e expansão do Singleton `GameState.gd` (Máquina de Estados Global, Sinais e Persistência)

### 🎨 Grupo 2: Criação Manual de Sprites e Assets Visuais (Pixel Art Autoral)
- [ ] **Issue #06:** `[Frontend]` Criação manual em Pixel Art do Spritesheet do Fagócito Primordial (Idle, Locomoção, Dash e Dano)
- [ ] **Issue #07:** `[Frontend]` Criação manual em Pixel Art dos Sprites de Projéteis Enzimáticos (Padrão, Concentrado 3x e Impacto)
- [ ] **Issue #08:** `[Frontend]` Criação manual em Pixel Art dos Componentes do HUD (Barras de HP/ATP, Molduras e Receptores Moleculares)
- [ ] **Issue #09:** `[Frontend]` Criação manual em Pixel Art dos Ícones de Power-Ups Temporários e das 4 Adaptações Mitóticas
- [ ] **Issue #10:** `[Frontend]` Criação manual de Assets de Telas, Logotipo *PhagoCrisis*, Padronização do Logo UTFPR e Hurt Vignette
- [ ] **Issue #11:** `[Ambiente]` Importação Pixel-Perfect (`Filter = Nearest`) e montagem dos recursos `SpriteFrames` na Godot 4

### 🦠 Grupo 3: Cinemática, Física, Combate e Fagocitose do Jogador (`Player`)
- [ ] **Issue #12:** `[Backend]` Arquitetura da Cena `Player.tscn` (`CharacterBody2D`), Colisor Layer 2 e Máquina de Estados Interna
- [ ] **Issue #13:** `[Backend]` Implementação da Movimentação Protoplasmática Vetorial com Aceleração (`10.0`) e Atrito Hidrodinâmico (`6.0`)
- [ ] **Issue #14:** `[Backend]` Sistema de Mira Contínua em 360° com Alternância Automática Mouse Global vs. Analógico Direito
- [ ] **Issue #15:** `[Backend]` Implementação da Cena `EnzymeProjectile.tscn` (`Area2D`, Layer 4), Balística a `550 px/s` e `VisibleOnScreenNotifier2D`
- [ ] **Issue #16:** `[Backend]` Sistema de Disparo Enzimático no `Marker2D` Frontal, Cadência (`0.33s`) e Power-Ups Cumulativos (Rapid, Spread, Damage)
- [ ] **Issue #17:** `[Backend]` Implementação do Dash Citoplasmático (`480 px/s`, `0.2s`), Janela de *I-Frames*, Translucidez e Cooldown (`0.8s`)
- [ ] **Issue #18:** `[Backend]` Gestão Metabólica da Barra de ATP (Capacidade `100`, Custo `25`, Delay `1.0s` e Regeneração `15 un/s`)
- [ ] **Issue #19:** `[Backend]` Mecânica de Quimiotaxia e Fagocitose Tática (`Area2D` Raio `80 px`, Layer 6) com Atração Exponencial
- [ ] **Issue #20:** `[Backend]` Sistema de Integridade Celular (HP), Dano, Knockback e Reação a Muco Viscoso (`-40%`) e Bio-Toxina ($DoT$)
- [ ] **Issue #21:** `[Backend]` Integração das 4 Adaptações Mitóticas Permanentes no Jogador (+HP, +Regen ATP, Anti-Muco e +Dano)
- [ ] **Issue #22:** `[Frontend]` Anexação da `Camera2D` com Suavização, Trauma de *Screen Shake* (`0.15s`), `PointLight2D` e `GPUParticles2D`

### 🖥️ Grupo 4: Interface Gráfica do Usuário — HUD e Feedback Tático
- [ ] **Issue #23:** `[Frontend]` Estruturação da Cena `HUD.tscn` (`CanvasLayer` Estático) e Layout Responsivo 16:9 nas Extremidades
- [ ] **Issue #24:** `[Frontend]` Implementação da Barra de Integridade Celular (`TextureProgressBar` de HP) via Sinal `player_health_changed`
- [ ] **Issue #25:** `[Frontend]` Implementação do Medidor Dinâmico de ATP com Interpolação (`Tween`) e Alerta Visual de Energia Insuficiente
- [ ] **Issue #26:** `[Frontend]` Implementação do Contador de Biomassa (Score) e Painel dos 3 Slots de Receptores Moleculares
- [ ] **Issue #27:** `[Frontend]` Implementação do Mostrador de Buffs Temporários (`15.0s` a `0.0s`) e Efeito de *Hurt Vignette*

### 🎬 Grupo 5: Fluxo de Telas, Menus e Máquina de Estados de Navegação
- [ ] **Issue #28:** `[Frontend]` Implementação da `SplashScreen.tscn` (Exibição Institucional Obrigatória do Logo UTFPR por `2.0s` com Fade)
- [ ] **Issue #29:** `[Frontend]` Refatoração e Estilização da `MainMenu.tscn` (Logo, Reforço UTFPR, Autores e Navegação por Foco de Gamepad)
- [ ] **Issue #30:** `[Frontend]` Implementação da `InstructionsScreen.tscn` (Esquema Visual Dual Teclado/Mouse + Gamepad e Core Loop)
- [ ] **Issue #31:** `[Frontend]` Implementação da `CreditsScreen.tscn` (Divisão Formal da Equipe, Atribuições e Referências de Áudio)
- [ ] **Issue #32:** `[Frontend]` Refatoração da `PauseOverlay.tscn` (`PROCESS_MODE_WHEN_PAUSED`, Retomar, Instruções e Menu Principal)
- [ ] **Issue #33:** `[Frontend]` Implementação da `LevelClearScreen.tscn` ("Tecido Purificado", Resumo da Fase e Adaptação Conquistada)
- [ ] **Issue #34:** `[Frontend]` Implementação da `GameOverScreen.tscn` ("Falência Imunológica", Tentar Novamente e Menu Principal)
- [ ] **Issue #35:** `[Frontend]` Implementação da `VictoryScreen.tscn` ("Expurgo Completo", Estatísticas Finais da Partida e Créditos)
- [ ] **Issue #36:** `[Frontend]` Sistema Global de Transição entre Cenas (`TransitionLayer.tscn`) com Efeito de Fade In / Fade Out

### 🔊 Grupo 6: Curadoria, Síntese e Engenharia de Áudio do Jogador e UI
- [ ] **Issue #37:** `[Ambiente]` Seleção, Síntese (sfxr.me / Audacity) e Edição dos Efeitos Sonoros (SFX) de Combate e Locomoção do Fagócito
- [ ] **Issue #38:** `[Ambiente]` Seleção, Síntese e Padronização dos Efeitos Sonoros (SFX) de Interface, Menus, Alertas e Transições
- [ ] **Issue #39:** `[Backend]` Arquitetura do Singleton `SoundManager.gd`, Barramentos do `AudioServer` (`Master`, `BGM`, `SFX`) e Pool Polifônico
- [ ] **Issue #40:** `[Backend]` Integração dos Gatilhos Sonoros com Variação de Pitch (`pitch_scale`) no Jogador, Projéteis, HUD e Menus

### 🚀 Grupo 7: Integração dos Marcos (Protótipo e Final), Otimização e Builds PC/Web
- [ ] **Issue #41:** `[Infraestrutura]` Integração e Validação do Marco 2 (Protótipo Jogável: 1 Level + Mecânicas do Player + 1 Inimigo/Item + Dual Input)
- [ ] **Issue #42:** `[Infraestrutura]` Auditoria de Performance para 60 FPS (Prevenção de Vazamento de Nós, `VisibleOnScreenNotifier2D` e Profiling)
- [ ] **Issue #43:** `[Infraestrutura]` Configuração e Exportação das Builds Desktop PC (Windows `.exe` e Linux `.x86_64`) em Pacote `.zip`
- [ ] **Issue #44:** `[Infraestrutura]` Configuração, Exportação e Validação da Build Web (HTML5) com `SharedArrayBuffer` no Itch.io
- [ ] **Issue #45:** `[Documentação]` Consolidação da Documentação Técnica do Programador A, Licenciamento de Áudios e Checklist de Entrega Final

---

# 🏗️ Grupo 1: Infraestrutura, Ambiente Godot 4 e Arquitetura de Entradas

### **Issue #01: [Infraestrutura] Configuração do `project.godot`, viewport 1920x1080 (16:9) pixel-perfect e renderizador Compatibility**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pela interface, câmera e compilação multiplataforma,
> **eu quero** configurar os parâmetros globais do arquivo `project.godot` com resolução base 1920x1080 (16:9), escalonamento `canvas_items`, filtro de textura `Nearest` e renderizador `gl_compatibility`,
> **para que** o jogo mantenha nitidez pixel-perfect sem borramento bilinear e rode a 60 FPS tanto em PC nativo quanto em navegadores WebGL2 no Itch.io.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o projeto é aberto na Godot Engine 4.x, **quando** inspecionadas as configurações de Display (`display/window`), **então** `viewport_width` deve ser `1920`, `viewport_height` deve ser `1080`, `stretch/mode` deve ser `"canvas_items"` e `stretch/aspect` deve ser `"keep"`.
* **Dado que** a arte do projeto é em Pixel Art 16-bit autoral, **quando** qualquer textura 2D for renderizada em tela, **então** o filtro padrão de texturas (`rendering/textures/canvas_textures/default_texture_filter`) deve estar definido como `0` (`Nearest`), eliminando interpolação bilinear.
* **Dado que** a disciplina exige entrega obrigatória para Web (HTML5) e PC, **quando** verificado o método de renderização em `project.godot`, **então** `renderer/rendering_method` deve ser `"gl_compatibility"`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```ini
; Trecho de configuração em project.godot
[application]
config/name="PhagoCrisis"
run/main_scene="res://scenes/ui/SplashScreen.tscn"
config/features=PackedStringArray("4.x", "GL Compatibility")
config/icon="res://sprites/ui/icon_phagocrisis.png"

[display]
window/size/viewport_width=1920
window/size/viewport_height=1080
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"

[rendering]
textures/canvas_textures/default_texture_filter=0
renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
Godot Engine v4.x.stable.official - https://godotengine.org
OpenGL API 3.3.0 - Compatibility - Using Device: GPU
[INFO] Viewport initialized: 1920x1080 (Aspect: keep, Stretch: canvas_items)
[INFO] Default Canvas Texture Filter: NEAREST (0)
```

**5. Componentes Envolvidos**
* `project.godot`: Arquivo mestre de configuração da engine.
* `sprites/icon.svg`: Ícone da aplicação.

**6. Considerações Técnicas e Arquitetura**
* O modo `gl_compatibility` (OpenGL ES 3.0 / WebGL 2.0) é exigência explícita do documento da disciplina (`Projeto_disciplina_2026_1.0.pdf`, Slide 5) para garantir compatibilidade universal na exportação Web HTML5.
* O filtro `Nearest` global evita que o desenvolvedor precise reconfigurar manualmente a propriedade `texture_filter` em cada nó `Sprite2D` ou `TextureRect` instanciado.

**7. Mockups ou Referências Visuais**
```plaintext
+-------------------------------------------------------+ 1920 px
|  [Barra HP/ATP]                      [Score / Chaves] |
|                                                       |
|                     ARENA 16:9                        | 1080 px
|            (Escalonamento Pixel-Perfect)              |
|                                                       |
+-------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Nenhuma (Issue fundacional).
* **Bloqueia:** Issue #06, Issue #11, Issue #23, Issue #43 e Issue #44.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir o projeto na Godot 4 e acessar `Project -> Project Settings -> General`.
2. Verificar em `Display -> Window` se a largura e altura estão em `1920x1080` e o Stretch Mode em `canvas_items`.
3. Redimensionar a janela de execução para modo janela e tela cheia, validando a ausência de distorção de aspecto ou serrilhado borrado nos sprites.

**10. Definição de Pronto (Definition of Done - DoD)**
* `project.godot` atualizado com o nome oficial `"PhagoCrisis"`, resolução 1920x1080, filtro `Nearest` e renderizador `gl_compatibility`.
* Artefatos residuais desnecessários de C# (`lab-game-marcao.csproj` / `.sln`) limpos caso o projeto utilize exclusivamente GDScript conforme o Mini GDD.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`infraestrutura`, `godot-4`, `config`, `pixel-perfect`, `compatibility`.

**13. Documentação Relacionada**
* Requisitos RNF02, RNF03.
* Seção Cabeçalho do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 1

---

### **Issue #02: [Infraestrutura] Padronização da árvore de diretórios (`src/`, `scenes/`, `sprites/`, `audio/`, `resources/`) e `.gitignore`**

**1. História de Usuário (User Story)**
> **Como** Programador A trabalhando em equipe com o Programador B e o Artista Técnico,
> **eu quero** estruturar subdiretórios modulares e semânticos para scripts, cenas, sprites e áudios do jogador e da UI,
> **para que** não ocorram conflitos de merge no Git e a autoria individual (critério 50% individual da UTFPR) fique claramente isolada no repositório.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o repositório possui múltiplos domínios de responsabilidade, **quando** a estrutura de pastas for criada, **então** devem existir subpastas separadas para `src/player/`, `src/ui/`, `src/autoload/`, `scenes/player/`, `scenes/ui/`, `sprites/player/`, `sprites/ui/`, `audio/sfx/player/` e `audio/sfx/ui/`.
* **Dado que** a Godot gera cache local na pasta `.godot/` e pacotes de build temporários, **quando** executado `git status`, **então** o arquivo `.gitignore` deve bloquear `.godot/`, `builds/`, `*.tmp` e arquivos de backup, mantendo rastreados todos os arquivos `.import` essenciais.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```powershell
New-Item -ItemType Directory -Force -Path `
  "src/player", "src/ui", "src/autoload", `
  "scenes/player", "scenes/ui", `
  "sprites/player", "sprites/projectiles", "sprites/ui", `
  "audio/sfx/player", "audio/sfx/ui", "audio/bgm", `
  "resources"
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
res://
├── audio/
│   ├── bgm/
│   └── sfx/
│       ├── player/
│       └── ui/
├── resources/
├── scenes/
│   ├── player/
│   └── ui/
├── sprites/
│   ├── player/
│   ├── projectiles/
│   └── ui/
└── src/
	├── autoload/
	├── enemy/
	├── menu/
	├── player/
	└── ui/
```

**5. Componentes Envolvidos**
* `.gitignore`, `.gitattributes`.
* Diretórios `src/`, `scenes/`, `sprites/`, `audio/`, `resources/`.

**6. Considerações Técnicas e Arquitetura**
* Na Godot 4, cada pasta que receberá recursos na árvore `res://` pode conter um arquivo `.gdignore` se for destinada apenas a arquivos brutos externos (ex: pastas de rascunhos `.aseprite` ou `.wav` não editados), ou um `.gitkeep` para preservar diretórios vazios no Git.
* A divisão modular entre `src/player/` + `src/ui/` (Programador A) e `src/enemy/` + `src/world/` (Programador B) garante zero colisão de edição simultânea.

**7. Mockups ou Referências Visuais**
* N/A (Estrutura de sistema de arquivos demonstrada na seção 4).

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01.
* **Bloqueia:** Todas as issues de criação de cenas, scripts, sprites e áudios (#06 a #40).

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Executar o comando de criação de pastas e verificar no painel `FileSystem` da Godot se os diretórios são reconhecidos.
2. Executar `git status` no terminal para assegurar que a pasta `.godot/` não está listada para commit.

**10. Definição de Pronto (Definition of Done - DoD)**
* Árvore de diretórios criada e versionada no Git.
* `.gitignore` revisado para projetos Godot 4.x + builds `.zip`/HTML5.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`infraestrutura`, `git`, `arquitetura`, `organizacao`.

**13. Documentação Relacionada**
* Requisito RNF08 (Rastreabilidade de Autoria Individual).
* Seção 1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 1

---

### **Issue #03: [Ambiente] Configuração da Matriz de Camadas e Máscaras de Colisão Física de 32 bits (Layers 1 a 8)**

**1. História de Usuário (User Story)**
> **Como** Programador A desenvolvendo o corpo do fagócito, seus projéteis cáusticos e sua área de fagocitose,
> **eu quero** nomear e configurar formalmente as 8 camadas de colisão 2D (`2D Physics Layers`) no `project.godot`,
> **para que** os tiros do jogador atinjam apenas paredes e patógenos, a área magnética atraia apenas coletáveis e os gatilhos de sala detectem exclusivamente o fagócito.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o sistema de física 2D da Godot utiliza 32 bits de máscara, **quando** consultadas as `layer_names/2d_physics` no `project.godot`, **então** as camadas 1 a 8 devem estar nomeadas exatamente como:
  - Layer 1: `World_Solid`
  - Layer 2: `Player_Body`
  - Layer 3: `Enemy_Body`
  - Layer 4: `Player_Projectiles`
  - Layer 5: `Enemy_Projectiles`
  - Layer 6: `Pickups_Collectibles`
  - Layer 7: `Environmental_Hazards`
  - Layer 8: `Triggers_Rooms`
* **Dado que** uma cena de física é configurada no editor, **quando** o desenvolvedor inspecionar `Collision -> Layer` ou `Mask`, **então** os nomes semânticos devem aparecer no lugar de números genéricos.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```ini
; Adição na seção [layer_names] do project.godot
[layer_names]

2d_physics/layer_1="World_Solid"
2d_physics/layer_2="Player_Body"
2d_physics/layer_3="Enemy_Body"
2d_physics/layer_4="Player_Projectiles"
2d_physics/layer_5="Enemy_Projectiles"
2d_physics/layer_6="Pickups_Collectibles"
2d_physics/layer_7="Environmental_Hazards"
2d_physics/layer_8="Triggers_Rooms"
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PHYSICS_AUDIT] Layer 1 (Bit 0, Val 1): World_Solid
[PHYSICS_AUDIT] Layer 2 (Bit 1, Val 2): Player_Body
[PHYSICS_AUDIT] Layer 3 (Bit 2, Val 4): Enemy_Body
[PHYSICS_AUDIT] Layer 4 (Bit 3, Val 8): Player_Projectiles
[PHYSICS_AUDIT] Layer 5 (Bit 4, Val 16): Enemy_Projectiles
[PHYSICS_AUDIT] Layer 6 (Bit 5, Val 32): Pickups_Collectibles
[PHYSICS_AUDIT] Layer 7 (Bit 6, Val 64): Environmental_Hazards
[PHYSICS_AUDIT] Layer 8 (Bit 7, Val 128): Triggers_Rooms
```

**5. Componentes Envolvidos**
* `project.godot` (seção `[layer_names]`).

**6. Considerações Técnicas e Arquitetura**
* Segue estritamente a Seção 3.1 (*Camadas de Colisão - Collision Layers & Masks*) do documento `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Previne bugs clássicos como tiros do próprio jogador colidindo com a `Area2D` de quimiotaxia do fagócito ou inimigos coletando itens de ATP.

**7. Mockups ou Referências Visuais**
| Bit / Layer | Nome Semântico | Valor Decimal | Quem Pertence (`collision_layer`) | Com Quem Colide (`collision_mask`) |
| :---: | :--- | :---: | :--- | :--- |
| **1** | `World_Solid` | `1` | Paredes TileMap, Portas fechadas | Player, Inimigos, Projéteis (Layers 2, 3, 4, 5) |
| **2** | `Player_Body` | `2` | `Player.tscn` (`CharacterBody2D`) | Layers 1, 3, 5, 6, 7, 8 |
| **3** | `Enemy_Body` | `4` | `EnemyBase.tscn` (`CharacterBody2D`) | Layers 1, 2, 3, 4, 7 |
| **4** | `Player_Projectiles` | `8` | `EnzymeProjectile.tscn` (`Area2D`) | Layers 1 (`World_Solid`) e 3 (`Enemy_Body`) |
| **5** | `Enemy_Projectiles` | `16` | Esporos e Toxinas Inimigas (`Area2D`) | Layers 1 (`World_Solid`) e 2 (`Player_Body`) |
| **6** | `Pickups_Collectibles`| `32` | ATP, Biomassa, Receptores (`Area2D`) | Layer 2 (`Player_Body` + Área de Quimiotaxia) |
| **7** | `Environmental_Hazards`| `64` | Muco Viscoso e Bio-Toxina (`Area2D`) | Layer 2 (`Player_Body`) e opcionalmente Layer 3 |
| **8** | `Triggers_Rooms` | `128` | `RoomTrigger.tscn` (`Area2D`) | Exclusivamente Layer 2 (`Player_Body`) |

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01.
* **Bloqueia:** Issue #12, Issue #15, Issue #17, Issue #19 e Issue #20.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `Project -> Project Settings -> Layer Names -> 2D Physics`.
2. Confirmar que os 8 primeiros campos exibem os nomes especificados.
3. Selecionar um `CharacterBody2D` e passar o cursor sobre os quadrados de `Collision -> Layer`, verificando o tooltip com o nome de cada camada.

**10. Definição de Pronto (Definition of Done - DoD)**
* Matriz de 8 camadas configurada no `project.godot` e documentada para toda a equipe.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`ambiente`, `physics`, `collision-layers`, `godot-4`.

**13. Documentação Relacionada**
* Requisito RNF05 (Isolamento de Camadas Físicas).
* Seção 3.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 1

---

### **Issue #04: [Ambiente] Mapeamento do `InputMap` Dual Paritário (Teclado + Mouse e Gamepad XInput/DirectInput com Deadzone)**

**1. História de Usuário (User Story)**
> **Como** jogador utilizando Teclado+Mouse ou Controle (Gamepad Xbox/PlayStation/Genérico),
> **eu quero** que todas as ações de movimentação, mira em 360°, disparo enzimático, esquiva (dash), interação e pausa respondam perfeitamente em ambos os dispositivos sem necessidade de configuração manual,
> **para que** o jogo cumpra a exigência obrigatória da disciplina de paridade total entre Teclado (+Mouse) e Joystick.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador utiliza Teclado+Mouse ou Gamepad, **quando** verificada a seção `[input]` do `project.godot`, **então** devem existir as ações mapeadas: `move_left`, `move_right`, `move_up`, `move_down`, `aim_left`, `aim_right`, `aim_up`, `aim_down`, `shoot`, `dash`, `interact` e `pause`.
* **Dado que** alavancas analógicas de controles sofrem de oscilação mecânica (*stick drift*), **quando** configuradas as ações de movimento e mira no `InputMap`, **então** a zona morta (`deadzone`) deve ser definida em `0.25`.
* **Dado que** o jogador está em qualquer menu do jogo (`MainMenu`, `PauseOverlay`, `GameOver`, `Victory`), **quando** utilizar o D-Pad/Analógico Esquerdo e o botão Sul (Botão A no Xbox / Cruz no PlayStation), **então** as ações nativas `ui_up`, `ui_down`, `ui_left`, `ui_right`, `ui_accept` e `ui_cancel` devem permitir navegação completa sem uso do mouse.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Script utilitário de validação do InputMap (src/autoload/InputValidator.gd)
extends Node

const REQUIRED_ACTIONS: Array[StringName] = [
	&"move_left", &"move_right", &"move_up", &"move_down",
	&"aim_left", &"aim_right", &"aim_up", &"aim_down",
	&"shoot", &"dash", &"interact", &"pause"
]

func validate_input_map() -> bool:
	for action in REQUIRED_ACTIONS:
		if not InputMap.has_action(action):
			push_error("Ação ausente no InputMap: %s" % action)
			return false
	print("[INPUT_OK] Todas as 12 ações dual-input estão registradas com deadzone >= 0.20.")
	return true
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[INPUT_OK] Todas as 12 ações dual-input estão registradas com deadzone >= 0.20.
[INPUT_DEVICE] Teclado/Mouse ativo | Gamepad #0 detectado: XInput Gamepad
```

**5. Componentes Envolvidos**
* `project.godot` (seção `[input]`).
* `src/player/Player.gd`.

**6. Considerações Técnicas e Arquitetura**
* Conforme a Seção 4 (*Esquema de Entradas e Controles*) do Mini GDD:
  - **Movimentação:** Teclas `W, A, S, D` (e Setas) $\leftrightarrow$ Alavanca Analógica Esquerda (`JOY_AXIS_LEFT_X`, `JOY_AXIS_LEFT_Y`).
  - **Mira:** Cursor do Mouse $\leftrightarrow$ Alavanca Analógica Direita (`JOY_AXIS_RIGHT_X`, `JOY_AXIS_RIGHT_Y`).
  - **Disparo Enzimático (`shoot`):** Botão Esquerdo do Mouse (`MOUSE_BUTTON_LEFT`) $\leftrightarrow$ Gatilho Direito (`JOY_AXIS_TRIGGER_RIGHT` / R2 / RT) ou Botão RB/R1 (`JOY_BUTTON_RIGHT_SHOULDER`).
  - **Esquiva (`dash`):** Barra de Espaço (`KEY_SPACE`) ou Botão Direito do Mouse (`MOUSE_BUTTON_RIGHT`) $\leftrightarrow$ Gatilho Esquerdo (`JOY_AXIS_TRIGGER_LEFT` / L2 / LT) ou Botão Sul/Oeste (`JOY_BUTTON_A` / `JOY_BUTTON_X`).
  - **Interagir (`interact`):** Tecla `E` ou `Enter` $\leftrightarrow$ Botão A (Xbox) / Cruz (PlayStation).
  - **Menu de Pausa (`pause`):** Tecla `ESC` (e `P`) $\leftrightarrow$ Botão `Start` / `Options` (`JOY_BUTTON_START`).

**7. Mockups ou Referências Visuais**
| Ação (`InputMap`) | Teclado & Mouse | Gamepad (XInput / DirectInput) | Deadzone |
| :--- | :--- | :--- | :---: |
| `move_up/down/left/right` | `W`, `S`, `A`, `D` | Analógico Esquerdo (Eixos 0 e 1) | `0.25` |
| `aim_up/down/left/right` | Posição Global do Mouse | Analógico Direito (Eixos 2 e 3) | `0.25` |
| `shoot` | Botão Esquerdo do Mouse (LMB) | Gatilho Direito (RT/R2) ou RB/R1 | `0.25` |
| `dash` | `Espaço` ou Botão Direito (RMB) | Gatilho Esquerdo (LT/L2) ou Botão A/X | `0.25` |
| `interact` | Tecla `E` ou `Enter` | Botão A (Xbox) / Cruz (PS) | N/A |
| `pause` | Tecla `ESC` ou `P` | Botão `Start` / `Options` | N/A |

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01.
* **Bloqueia:** Issue #13, Issue #14, Issue #16, Issue #17, Issue #29 e Issue #32.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `Project -> Project Settings -> Input Map` na Godot 4.
2. Conectar um controle USB/Bluetooth (ou emulador XInput) e testar cada ação com `Input.get_vector()` e `Input.is_action_pressed()`.
3. Desconectar o controle em tempo de execução e verificar se o Teclado+Mouse continua respondendo instantaneamente.

**10. Definição de Pronto (Definition of Done - DoD)**
* Todas as 12 ações configuradas no `project.godot` com bindings duplos (Teclado/Mouse + Gamepad).
* Substituição das chamadas hardcoded `Input.is_key_pressed(KEY_W)` existentes em `src/Player.gd` pelas ações abstratas do `InputMap`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica (Requisito eliminatório no Slide 5 e Slide 19 do PDF da disciplina).

**12. Etiquetas (Labels)**
`ambiente`, `input-map`, `gamepad`, `twin-stick`, `acessibilidade`.

**13. Documentação Relacionada**
* Requisito RF02.
* Seção 4 do Mini GDD e Slide 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #05: [Backend] Refatoração e expansão do Singleton `GameState.gd` (Máquina de Estados Global, Sinais e Persistência)**

**1. História de Usuário (User Story)**
> **Como** Programador A construindo o HUD, o jogador e as telas de sistema,
> **eu quero** expandir o Autoload `src/GameState.gd` com barramentos de sinais desacoplados (`EventBus` interno) e variáveis de sessão da run (HP, ATP, Biomassa, Receptores, Adaptações Mitóticas e Tempo de Jogo),
> **para que** a interface gráfica (`HUD.tscn`) e as telas de transição consumam e atualizem o estado global sem acoplamento direto com cenas de inimigos ou fases do Programador B.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o `GameState` é carregado como Singleton (`Autoload`) na inicialização, **quando** o jogo transitar entre fases, **então** ele deve manter o estado atual na enumeração `State { SPLASH, MAIN_MENU, IN_GAME, PAUSED, LEVEL_CLEAR, GAME_OVER, VICTORY }`.
* **Dado que** o jogador coleta biomassa, receptores moleculares, ativa buffs ou sofre dano, **quando** os métodos do `GameState` forem invocados, **então** devem emitir os sinais correspondentes: `player_health_changed(current_hp, max_hp)`, `player_atp_changed(current_atp, max_atp)`, `biomass_changed(new_score)`, `receptors_changed(count)`, `temporary_buff_updated(buff_id, remaining_time)` e `mitotic_adaptation_unlocked(adaptation_id)`.
* **Dado que** o jogador inicia uma nova partida (*Iniciar Jogo* no Menu Principal), **quando** a função `reset_run_state()` for executada, **então** todos os contadores de score, receptores, nível atual (`current_level = 1`) e adaptações devem retornar aos valores base iniciais.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Trecho estrutural de src/GameState.gd
extends Node

enum MatchState { SPLASH, MAIN_MENU, IN_GAME, PAUSED, LEVEL_CLEAR, GAME_OVER, VICTORY }

signal state_changed(new_state: MatchState)
signal player_health_changed(current_hp: float, max_hp: float)
signal player_atp_changed(current_atp: float, max_atp: float)
signal biomass_changed(new_score: int)
signal receptors_changed(count: int)
signal temporary_buff_updated(buff_type: StringName, time_left: float)
signal mitotic_adaptation_unlocked(adaptation_id: StringName)

var current_state: MatchState = MatchState.SPLASH
var current_level: int = 1
var biomass_score: int = 0
var molecular_receptors: int = 0
var run_elapsed_time: float = 0.0
var active_adaptations: Dictionary = {
	&"lipid_membrane": false,      # Chefe 1: +25% HP Max
	&"super_mitochondria": false,  # Chefe 2: +30% ATP Regen
	&"strong_pseudopods": false,   # Chefe 3: +15% Speed e Imune a Muco
	&"digestive_gland": false      # Chefe 4: +20% Dano Base
}

func add_biomass(amount: int) -> void:
	biomass_score += amount
	biomass_changed.emit(biomass_score)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[GAMESTATE] Run inicializada -> Level: 1 | Biomassa: 0 | Receptores: 0/3
[SIGNAL] biomass_changed emitido -> Novo Score: 150
[SIGNAL] mitotic_adaptation_unlocked -> lipid_membrane (HP Max +25%)
```

**5. Componentes Envolvidos**
* `src/GameState.gd` (registrado como Autoload em `project.godot`).

**6. Considerações Técnicas e Arquitetura**
* Preserva os métodos já existentes `save_current_game()` e `continue_game()` em `src/GameState.gd` para compatibilidade retroativa, adicionando a camada de sinais exigida na Seção 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Serve como contrato de interface formal entre o Programador A (Jogador e UI) e o Programador B (Mundo, Spawners e Chefes).

**7. Mockups ou Referências Visuais**
```plaintext
+-------------------+        Sinais (Observer)        +-------------------+
|   Player.tscn     | ------------------------------> |                   |
| (Programador A)   |   player_health_changed         |   GameState.gd    |
+-------------------+   player_atp_changed            |   (Singleton)     |
													  |                   |
+-------------------+        Atualização Reativa      | - biomass_score   |
|     HUD.tscn      | <------------------------------ | - adaptations     |
|  (CanvasLayer)    |   biomass_changed               | - receptors (0..3)|
+-------------------+   receptors_changed             +-------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01 e Issue #02.
* **Bloqueia:** Issue #18, Issue #19, Issue #20, Issue #21, Issues #23 a #35.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Iniciar qualquer cena de teste e invocar no `_ready()`: `GameState.add_biomass(100)`.
2. Conectar um callback de teste ao sinal `GameState.biomass_changed` e verificar a impressão no console.
3. Chamar `GameState.reset_run_state()` e confirmar que `biomass_score == 0` e `molecular_receptors == 0`.

**10. Definição de Pronto (Definition of Done - DoD)**
* `src/GameState.gd` expandido com tipagem estática completa, sinais declarados e métodos públicos documentados.
* Zero erros ou avisos (`warnings`) de sinais não utilizados no debugger da Godot.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `autoload`, `singleton`, `signals`, `architecture`.

**13. Documentação Relacionada**
* Requisitos RF09, RF11, RF13, RNF04.
* Seção 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

# 🎨 Grupo 2: Criação Manual de Sprites e Assets Visuais (Pixel Art Autoral)

### **Issue #06: [Frontend] Criação manual em Pixel Art do Spritesheet do Fagócito Primordial (Idle, Locomoção, Dash e Dano)**

**1. História de Usuário (User Story)**
> **Como** jogador controlando o Fagócito Primordial,
> **eu quero** um spritesheet autoral em Pixel Art 16-bit (32x32 px por quadro) representando uma célula imunológica orgânica com núcleo bioluminescente e membrana deformável,
> **para que** o protagonista tenha identidade visual biopunk única, cumpra a exigência de arte 100% autoral da disciplina e forneça leitura visual imediata de repouso, movimento, dash e dano.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o personagem principal é um macrófago hiperreativo, **quando** a folha de sprites `sprites/player/phagocyte_spritesheet.png` for desenhada à mão no Aseprite/LibreSprite, **então** deve conter 4 linhas de animação em grid de $32\times 32\text{ px}$ com fundo transparente (canal Alpha PNG):
  - Linha 1 (`idle`): 4 quadros de pulsação orgânica da membrana citoplasmática.
  - Linha 2 (`move`): 6 quadros de emissão de pseudópodes e deformação hidrodinâmica.
  - Linha 3 (`dash`): 4 quadros de alongamento elástico em alta velocidade.
  - Linha 4 (`hurt` / `death`): 4 quadros de contração celular e lise de membrana.
* **Dado que** o fundo das fases é escuro (carmesim, roxo necrótico, marrom vascular), **quando** aplicada a paleta de cores do fagócito, **então** deve utilizar tons contrastantes de ciano bioluminescente (`#00F5D4`), azul membranar (`#00BBF9`) e núcleo branco-azulado (`#E0FBFC`) para visibilidade instantânea.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Script de verificação de dimensões do Spritesheet (4 linhas x 6 colunas de 32x32 = 192x128 px)
var tex: Texture2D = load("res://sprites/player/phagocyte_spritesheet.png")
assert(tex.get_width() == 192 and tex.get_height() == 128, "Dimensões inválidas do spritesheet!")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[ASSET_CHECK] res://sprites/player/phagocyte_spritesheet.png carregado com sucesso.
[ASSET_CHECK] Resolução: 192x128 px (Grid: 32x32 px | 6 colunas x 4 linhas | Formato: RGBA8).
```

**5. Componentes Envolvidos**
* `sprites/player/phagocyte_spritesheet.png` (substituindo os placeholders temporários `prota.png` e `ProtaMage.png`).

**6. Considerações Técnicas e Arquitetura**
* O design do fagócito deve incluir um indicador morfológico frontal claro (pseudópode emissor de enzimas na face direita do sprite base, ângulo $0\text{ rad}$) para que a rotação `look_at()` em 360° evidencie com precisão para onde o jogador está mirando.
* Cumpre o requisito obrigatório de *Produzir arte gráfica de autoria própria* (`Projeto_disciplina_2026_1.0.pdf`, Slide 2 e Slide 5).

**7. Mockups ou Referências Visuais**
```plaintext
Grid do Spritesheet: 192 x 128 px (Células de 32x32 px)
+--------+--------+--------+--------+--------+--------+
| Idle 0 | Idle 1 | Idle 2 | Idle 3 | (vazio)| (vazio)| -> Linha 0 (Pulsação)
+--------+--------+--------+--------+--------+--------+
| Move 0 | Move 1 | Move 2 | Move 3 | Move 4 | Move 5 | -> Linha 1 (Pseudópodes)
+--------+--------+--------+--------+--------+--------+
| Dash 0 | Dash 1 | Dash 2 | Dash 3 | (vazio)| (vazio)| -> Linha 2 (Propulsão)
+--------+--------+--------+--------+--------+--------+
| Hurt 0 | Hurt 1 | Dead 0 | Dead 1 | (vazio)| (vazio)| -> Linha 3 (Dano/Lise)
+--------+--------+--------+--------+--------+--------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01 e Issue #02.
* **Bloqueia:** Issue #11 e Issue #12.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `sprites/player/phagocyte_spritesheet.png` no visualizador da Godot 4.
2. Configurar um nó `AnimatedSprite2D` dividindo a textura em `Hframes = 6` e `Vframes = 4`.
3. Reproduzir cada animação a 10 FPS sobre um fundo carmesim escuro (`#2B0912`) para validar contraste e alinhamento do pivô central (`16, 16`).

**10. Definição de Pronto (Definition of Done - DoD)**
* Spritesheet autoral exportado em PNG 32-bit (RGBA) em `sprites/player/phagocyte_spritesheet.png`.
* Pivô centralizado em todos os quadros para evitar trepidação visual ao rotacionar 360°.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `pixel-art`, `spritesheet`, `player`, `autoral`.

**13. Documentação Relacionada**
* Requisito RF14, RNF03.
* Seção 1 e Seção 15 do Mini GDD; Slide 2 e 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** L (Large)
* **Story Points:** 5

---

### **Issue #07: [Frontend] Criação manual em Pixel Art dos Sprites de Projéteis Enzimáticos (Padrão, Concentrado 3x e Impacto)**

**1. História de Usuário (User Story)**
> **Como** jogador disparando contra enxames de patógenos,
> **eu quero** sprites pixel-art luminescentes para os projéteis enzimáticos (padrão verde-ácido e variante amarela fluorescente do *Damage Shot* $3\times$), além de quadros de impacto e textura radial de luz,
> **para que** a trajetória dos meus tiros seja claramente legível a $550\text{ px/s}$ e se diferencie visualmente dos esporos inimigos.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador dispara enzimas cáusticas, **quando** o arquivo `sprites/projectiles/enzyme_projectile_sheet.png` for criado manualmente em grid de $16\times 16\text{ px}$, **então** deve conter:
  - 3 quadros de voo do tiro padrão em verde-ácido neon (`#39FF14` / `#80FF72`);
  - 3 quadros de voo do tiro concentrado (*Damage Shot* $3\times$) em amarelo ácido brilhante (`#FFF700` / `#FFEE32`);
  - 4 quadros de ruptura/respingo cáustico para o momento da colisão.
* **Dado que** projéteis e o fagócito utilizam `PointLight2D` para iluminação dinâmica, **quando** criado o arquivo `sprites/projectiles/light_radial_gradient.png`, **então** deve conter um gradiente radial suave de $256\times 256\text{ px}$ branco sobre fundo preto/transparente para uso como máscara de luz.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Verificação de carregamento dos sprites balísticos
var proj_tex := load("res://sprites/projectiles/enzyme_projectile_sheet.png") as Texture2D
var light_tex := load("res://sprites/projectiles/light_radial_gradient.png") as Texture2D
assert(proj_tex != null and light_tex != null, "Sprites de projétil ou luz não encontrados!")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[ASSET_CHECK] enzyme_projectile_sheet.png (64x32 px, frames 16x16) [OK]
[ASSET_CHECK] light_radial_gradient.png (256x256 px, radial mask) [OK]
```

**5. Componentes Envolvidos**
* `sprites/projectiles/enzyme_projectile_sheet.png` (substituindo `shotProtaMage.png`).
* `sprites/projectiles/light_radial_gradient.png`.

**6. Considerações Técnicas e Arquitetura**
* Conforme a Seção 5.4 e Seção 6.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`, o *Damage Shot* altera a coloração dos tiros para amarelo fluorescente e multiplica o dano por $3\times$. Ter os frames dedicados ou um sprite base de alto contraste permite tanques e enxames serem lidos sem confusão visual.

**7. Mockups ou Referências Visuais**
```plaintext
Formato do Projétil (16x16 px - Orientado para a Direita -> 0 rad):
  . . . . . . . . . . . . . . . .
  . . . . . . # # # # # # . . . .
  . . ~ ~ # # @ @ @ @ @ @ # # . .   @ = Núcleo Branco/Amarelo (#FFFFFF)
  . ~ . # # @ @ @ @ @ @ @ @ # # .   # = Borda Ácida Neon (#39FF14)
  . . ~ ~ # # @ @ @ @ @ @ # # . .   ~ = Cauda de Gotículas
  . . . . . . # # # # # # . . . .
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #11, Issue #15, Issue #16 e Issue #22.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Importar `enzyme_projectile_sheet.png` na Godot 4.
2. Instanciar o sprite sobre a cena de teste e verificar a visibilidade tanto parado quanto em deslocamento a $550\text{ px/s}$.
3. Associar `light_radial_gradient.png` a um nó `PointLight2D` e validar a suavidade da atenuação luminosa nas bordas.

**10. Definição de Pronto (Definition of Done - DoD)**
* Spritesheet dos projéteis e textura de molde luminoso criados manualmente e commitados em `sprites/projectiles/`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `pixel-art`, `projectiles`, `lighting`, `vfx`.

**13. Documentação Relacionada**
* Requisitos RF04, RF08, RF12, RF14.
* Seção 4.1 e Seção 6.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #08: [Frontend] Criação manual em Pixel Art dos Componentes do HUD (Barras de HP/ATP, Molduras e Receptores Moleculares)**

**1. História de Usuário (User Story)**
> **Como** jogador gerenciando minha integridade celular e energia metabólica no calor do combate,
> **eu quero** texturas em Pixel Art para a Barra de HP, o Medidor de ATP e os 3 ícones de Receptores Moleculares (chaves biológicas),
> **para que** o `HUD.tscn` apresente estética histológica orgânica fiel ao tema de *PhagoCrisis* e permita leitura periférica imediata.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o nó `TextureProgressBar` da Godot exige texturas de fundo (`texture_under`), borda (`texture_over`) e preenchimento (`texture_progress`), **quando** criados os assets em `sprites/ui/`, **então** devem existir pares de texturas de $160\times 24\text{ px}$ para a Barra de HP (preenchimento vermelho arterial `#EF233C` segmentado em 5 glóbulos/câmaras) e para a Barra de ATP (preenchimento azul/ciano metabólico `#00BBF9`).
* **Dado que** o jogador pode acumular até 3 Receptores Moleculares para abrir esfíncteres trancados, **quando** desenhados os ícones de chave biológica ($24\times 24\text{ px}$), **então** devem existir duas variações: `receptor_slot_empty.png` (silhueta cinza/escura vazada) e `receptor_slot_filled.png` (receptor ativo em amarelo fosforescente `#FEE440`).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Validação de texturas do HUD
var hp_under := load("res://sprites/ui/hud_hp_under.png")
var hp_fill := load("res://sprites/ui/hud_hp_progress.png")
var atp_fill := load("res://sprites/ui/hud_atp_progress.png")
var key_on := load("res://sprites/ui/receptor_slot_filled.png")
assert(hp_under and hp_fill and atp_fill and key_on, "Assets do HUD incompletos!")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_ASSETS] Texturas de barras (160x24 px) e receptores (24x24 px) validadas com sucesso.
```

**5. Componentes Envolvidos**
* `sprites/ui/hud_hp_under.png`, `sprites/ui/hud_hp_over.png`, `sprites/ui/hud_hp_progress.png`.
* `sprites/ui/hud_atp_under.png`, `sprites/ui/hud_atp_over.png`, `sprites/ui/hud_atp_progress.png`.
* `sprites/ui/receptor_slot_empty.png`, `sprites/ui/receptor_slot_filled.png`.

**6. Considerações Técnicas e Arquitetura**
* As imagens `under`, `over` e `progress` de cada barra devem possuir exatamente a mesma caixa delimitadora ($160\times 24\text{ px}$) para que o preenchimento não desalinhe ao usar `fill_mode = FILL_LEFT_TO_RIGHT` no `TextureProgressBar`.

**7. Mockups ou Referências Visuais**
```plaintext
Layout Superior Esquerdo do HUD (Mockup Seção 3 do Mini GDD):
+---------------------------------------------------+
| SCORE / BIOMASSA: 003492        [Y] [Y] [y]       |  <- [Y] Receptor Ativo / [y] Vazio
| HP:  [###|###|###|###|...]  (Vermelho Arterial)   |
| ATP: [==============.....]  (Ciano Metabólico)    |
+---------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #23, Issue #24, Issue #25 e Issue #26.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Instanciar um `TextureProgressBar` de teste e atribuir `hud_hp_under.png`, `hud_hp_over.png` e `hud_hp_progress.png`.
2. Variar a propriedade `value` de `0` a `100` no Inspector e confirmar que a barra preenche sem vazar para fora da moldura orgânica.

**10. Definição de Pronto (Definition of Done - DoD)**
* Todas as 8 texturas do HUD criadas manualmente em Pixel Art e salvas em `sprites/ui/`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `pixel-art`, `ui`, `hud`, `textures`.

**13. Documentação Relacionada**
* Requisitos RF11, RF14.
* Seção 3 e Seção 7 do Mini GDD; Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #09: [Frontend] Criação manual em Pixel Art dos Ícones de Power-Ups Temporários e das 4 Adaptações Mitóticas**

**1. História de Usuário (User Story)**
> **Como** jogador coletando vacúolos celulares ou derrotando chefes de bioma,
> **eu quero** ícones distintos em Pixel Art ($32\times 32\text{ px}$) para os 3 power-ups temporários de tiro e para as 4 Adaptações Mitóticas permanentes, além dos sprites de Glóbulo de ATP,
> **para que** eu identifique instantaneamente no HUD e na tela de *Level Clear* qual aprimoramento biológico está ativo.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** existem 3 power-ups temporários de 15 segundos, **quando** criados os ícones em `sprites/ui/icons/`, **então** devem existir:
  - `icon_buff_damage.png` (*Enzima Concentrada* — gota cáustica amarela $3\times$);
  - `icon_buff_spread.png` (*Dispersão Citoplasmática* — trifurcação angular de 3 tiros);
  - `icon_buff_rapid.png` (*Hipermetabolismo* — dupla hélice/raio metabólico acelerado).
* **Dado que** derrotar os chefes das Fases 1 a 4 concede upgrades permanentes, **quando** criados os ícones de Adaptação Mitótica ($32\times 32\text{ px}$), **então** devem existir:
  - `icon_adapt_membrane.png` (*Membrana Lipídica Reforçada* — +25% HP);
  - `icon_adapt_mitochondria.png` (*Mitocôndria Supercarregada* — +30% Regen ATP);
  - `icon_adapt_pseudopods.png` (*Pseudópodes Fortalecidos* — +15% Speed e Anti-Muco);
  - `icon_adapt_gland.png` (*Glândula Digestiva Avançada* — +20% Dano Base).
* **Dado que** a mecânica de Quimiotaxia atrai glóbulos de ATP, **quando** criado `sprites/player/atp_globule_sheet.png` ($16\times 16\text{ px}$, 4 frames), **então** deve exibir uma esfera energética pulsante ciano/verde.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
const ICON_PATHS: Array[String] = [
	"res://sprites/ui/icons/icon_buff_damage.png",
	"res://sprites/ui/icons/icon_buff_spread.png",
	"res://sprites/ui/icons/icon_buff_rapid.png",
	"res://sprites/ui/icons/icon_adapt_membrane.png",
	"res://sprites/ui/icons/icon_adapt_mitochondria.png",
	"res://sprites/ui/icons/icon_adapt_pseudopods.png",
	"res://sprites/ui/icons/icon_adapt_gland.png"
]
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[ICON_AUDIT] 7/7 ícones de upgrades (32x32 px) e atp_globule_sheet.png (64x16 px) verificados.
```

**5. Componentes Envolvidos**
* `sprites/ui/icons/icon_buff_*.png` (3 arquivos).
* `sprites/ui/icons/icon_adapt_*.png` (4 arquivos).
* `sprites/player/atp_globule_sheet.png`.

**6. Considerações Técnicas e Arquitetura**
* Os ícones serão reutilizados tanto no mostrador inferior do `HUD.tscn` (Issue #27) quanto na tela de transição `LevelClearScreen.tscn` (Issue #33) e nos drops do mundo (sincronizado com o Programador B).

**7. Mockups ou Referências Visuais**
| Arquivo | Nome no GDD | Cor Dominante | Dimensão |
| :--- | :--- | :--- | :---: |
| `icon_buff_damage.png` | Enzima Concentrada ($3\times$) | Amarelo Ácido (`#FFEE32`) | $32\times 32\text{ px}$ |
| `icon_buff_spread.png` | Dispersão Citoplasmática ($3$ tiros) | Verde Fluorescente (`#39FF14`) | $32\times 32\text{ px}$ |
| `icon_buff_rapid.png` | Hipermetabolismo ($2\times$ cadência) | Ciano Elétrico (`#00F5D4`) | $32\times 32\text{ px}$ |
| `icon_adapt_membrane.png` | Membrana Lipídica (+25% HP) | Carmesim Vivo (`#FF4D6D`) | $32\times 32\text{ px}$ |
| `icon_adapt_mitochondria.png` | Mitocôndria Supercarregada (+30% ATP)| Azul Celeste (`#4EA8DE`) | $32\times 32\text{ px}$ |
| `icon_adapt_pseudopods.png` | Pseudópodes Fortalecidos (Anti-Muco) | Roxo Bioluminescente (`#9B5DE5`)| $32\times 32\text{ px}$ |
| `icon_adapt_gland.png` | Glândula Digestiva (+20% Dano) | Laranja Cáustico (`#F15BB5`) | $32\times 32\text{ px}$ |

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #19, Issue #27 e Issue #33.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Carregar os 7 ícones em nós `TextureRect` lado a lado no editor da Godot.
2. Verificar se as silhuetas são imediatamente distinguíveis umas das outras mesmo em escala reduzida.

**10. Definição de Pronto (Definition of Done - DoD)**
* Todos os 7 ícones de upgrades e o spritesheet do glóbulo de ATP criados à mão e importados sem filtro bilinear.

**11. Prioridade e Severidade**
* **Prioridade:** Média.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `pixel-art`, `icons`, `power-ups`, `ui`.

**13. Documentação Relacionada**
* Requisitos RF07, RF08, RF09, RF14.
* Seção 8 do Mini GDD e Seção 5.4 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #10: [Frontend] Criação manual de Assets de Telas, Logotipo *PhagoCrisis*, Padronização do Logo UTFPR e Hurt Vignette**

**1. História de Usuário (User Story)**
> **Como** jogador iniciando *PhagoCrisis* e navegando pelas telas do sistema,
> **eu quero** um logotipo título em Pixel Art biopunk, fundos celulares estilizados para os menus, o logotipo oficial da UTFPR em alta nitidez, temas de botões orgânicos e uma textura de vinheta avermelhada de dano,
> **para que** o fluxo de telas cumpra todos os requisitos formais de apresentação da UTFPR e transmita imersão visual desde a abertura até a tela de vitória.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o PDF da disciplina (Slide 12) exige Tela de Logo da UTFPR e reforço do logo na Tela de Título, **quando** verificado `sprites/logo_utfpr.png`, **então** deve apresentar transparência limpa e contraste legível sobre fundo escuro/claro institucional.
* **Dado que** o Menu Principal precisa de identidade visual forte, **quando** criado `sprites/ui/title_logo_phagocrisis.png`, **então** deve apresentar tipografia pixel-art customizada com elementos orgânicos/celulares.
* **Dado que** o jogador sofre dano em combate, **quando** exibida a textura `sprites/ui/hurt_vignette.png` ($1920\times 1080\text{ px}$), **então** deve conter bordas periféricas avermelhadas semitransparentes e centro 100% transparente (`Alpha = 0.0`) para não obstruir a mira.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Configuração do Theme global para botões orgânicos (resources/ui_biopunk_theme.tres)
var theme := load("res://resources/ui_biopunk_theme.tres") as Theme
assert(theme != null, "Theme de UI Biopunk não encontrado!")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[UI_THEME] ui_biopunk_theme.tres carregado (StyleBoxTexture para Normal, Hover, Pressed e Focus).
[UI_ASSETS] title_logo_phagocrisis.png, logo_utfpr.png e hurt_vignette.png validados.
```

**5. Componentes Envolvidos**
* `sprites/logo_utfpr.png`.
* `sprites/ui/title_logo_phagocrisis.png`.
* `sprites/ui/menu_background_vascular.png`.
* `sprites/ui/hurt_vignette.png`.
* `sprites/ui/button_membrane_9patch.png`.
* `resources/ui_biopunk_theme.tres`.

**6. Considerações Técnicas e Arquitetura**
* O recurso `ui_biopunk_theme.tres` deve definir explicitamente o estilo `focus` (`StyleBoxFlat` ou `StyleBoxTexture` com borda ciano brilhante de $2\text{ px}$), pois quando o jogador navega pelos menus usando o Gamepad, a Godot destaca o botão focado através do `focus_stylebox`.

**7. Mockups ou Referências Visuais**
```plaintext
Estados Visuais do Botão Orgânico (9-Patch Sprite):
[ Normal ]  -> Membrana Carmesim Escura (#3A0CA3 / #480CA8), Texto Branco
[ Hover ]   -> Membrana Iluminada Ciano (#00BBF9), Texto Amarelo Ácido
[ Focus ]   -> Borda Dupla Fluorescente (#39FF14) -> Essencial para Gamepad!
[ Pressed ] -> Membrana Contraída (#240046)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #27 e Issues #28 a #35.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Aplicar `resources/ui_biopunk_theme.tres` no nó raiz `Control` do Menu Principal.
2. Testar os estados `Normal`, `Hover`, `Pressed` com o mouse e o estado `Focus` usando as setas do teclado ou D-Pad do controle.

**10. Definição de Pronto (Definition of Done - DoD)**
* Logotipo *PhagoCrisis*, fundo de menu, vinheta de dano, logo UTFPR e `ui_biopunk_theme.tres` finalizados e versionados.

**11. Prioridade e Severidade**
* **Prioridade:** Média.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `pixel-art`, `ui-theme`, `menus`, `utfpr`.

**13. Documentação Relacionada**
* Requisitos RF12, RF13, RF14.
* Slide 12 de `Projeto_disciplina_2026_1.0.pdf` e Seção 4.2/4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #11: [Ambiente] Importação Pixel-Perfect (`Filter = Nearest`) e montagem dos recursos `SpriteFrames` na Godot 4**

**1. História de Usuário (User Story)**
> **Como** Programador A integrando as folhas de sprites na Godot 4,
> **eu quero** configurar os arquivos `.import` e montar os recursos `SpriteFrames` (`phagocyte_frames.tres` e `projectile_frames.tres`) com taxas de quadros (FPS) e loops calibrados,
> **para que** os nós `AnimatedSprite2D` do jogador e dos projéteis possam acionar animações via código (`play("move")`, `play("dash")`) sem sobrecarga de configuração na cena.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `phagocyte_spritesheet.png` está importado, **quando** criado o recurso `resources/phagocyte_frames.tres` (`SpriteFrames`), **então** deve conter as animações:
  - `idle` (4 frames, 8 FPS, `loop = true`);
  - `move` (6 frames, 12 FPS, `loop = true`);
  - `dash` (4 frames, 20 FPS, `loop = false`);
  - `hurt` (2 frames, 10 FPS, `loop = false`);
  - `death` (4 frames, 8 FPS, `loop = false`).
* **Dado que** `enzyme_projectile_sheet.png` está importado, **quando** criado `resources/projectile_frames.tres`, **então** deve conter as animações `default` (verde, 12 FPS, `loop = true`), `concentrated` (amarelo $3\times$, 15 FPS, `loop = true`) e `impact` (4 frames, 24 FPS, `loop = false`).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Teste de integridade das animações em resources/phagocyte_frames.tres
var frames: SpriteFrames = load("res://resources/phagocyte_frames.tres")
for anim in [&"idle", &"move", &"dash", &"hurt", &"death"]:
	assert(frames.has_animation(anim), "Animação ausente: %s" % anim)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[SPRITE_FRAMES] phagocyte_frames.tres validado: ["idle", "move", "dash", "hurt", "death"] [OK]
[SPRITE_FRAMES] projectile_frames.tres validado: ["default", "concentrated", "impact"] [OK]
```

**5. Componentes Envolvidos**
* `resources/phagocyte_frames.tres`.
* `resources/projectile_frames.tres`.
* Arquivos `.import` em `sprites/player/` e `sprites/projectiles/`.

**6. Considerações Técnicas e Arquitetura**
* Nos arquivos `.import` de sprites 2D pixel-art, `compress/mode=0` (Lossless) deve ser utilizado para evitar artefatos de compressão com perdas (VRAM/BPTC) em sprites pequenos de $16\times 16$ e $32\times 32\text{ px}$.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #06 e Issue #07.
* **Bloqueia:** Issue #12 e Issue #15.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `resources/phagocyte_frames.tres` no painel inferior `SpriteFrames` da Godot.
2. Verificar cada uma das 5 animações com o botão de preview e checar se `loop` está desativado para `dash`, `hurt` e `death`.

**10. Definição de Pronto (Definition of Done - DoD)**
* Recursos `.tres` de `SpriteFrames` salvos em `resources/`, com compressão Lossless nos `.import` correspondentes.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`ambiente`, `spriteframes`, `animation`, `resources`, `godot-4`.

**13. Documentação Relacionada**
* Requisitos RF14, RNF03.
* Seção 1 e Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

# 🦠 Grupo 3: Cinemática, Física, Combate e Fagocitose do Jogador (`Player`)

### **Issue #12: [Backend] Arquitetura da Cena `Player.tscn` (`CharacterBody2D`), Colisor Layer 2 e Máquina de Estados Interna**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pela entidade do jogador,
> **eu quero** estruturar a árvore de nós da cena `scenes/player/Player.tscn` (`CharacterBody2D`) com colisor circular na Layer 2, pivô de mira com `Marker2D` frontal, área de quimiotaxia, temporizadores e máquina de estados finita,
> **para que** todos os subsistemas do fagócito (locomoção, tiro, dash, dano e fagocitose) operem de forma modular e desacoplada.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** a cena `scenes/player/Player.tscn` é instanciada, **quando** inspecionado o nó raiz `CharacterBody2D`, **então** ele deve pertencer ao grupo `"player"`, possuir `motion_mode = MOTION_MODE_FLOATING` (Top-Down 2D sem gravidade vertical) e `collision_layer = 2` (`Player_Body`) com `collision_mask` ativada para Layers 1, 3, 5, 6, 7 e 8.
* **Dado que** o fagócito possui múltiplos comportamentos mutuamente exclusivos, **quando** o script `src/player/Player.gd` estiver em execução, **então** deve gerenciar a enumeração `PlayerState { NORMAL, DASHING, HURT, DEAD }`.
* **Dado que** o jogador dispara projéteis enzimáticos pela extremidade frontal, **quando** verificado o nó filho `MuzzleMarker` (`Marker2D`), **então** sua posição local deve ser `Vector2(16.0, 0.0)` em relação ao centro do corpo.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Estrutura base em src/player/Player.gd
class_name PhagocytePlayer
extends CharacterBody2D

enum PlayerState { NORMAL, DASHING, HURT, DEAD }

var current_state: PlayerState = PlayerState.NORMAL

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $BodyCollisionShape2D
@onready var muzzle_marker: Marker2D = $AimPivot/MuzzleMarker
@onready var chemotaxis_area: Area2D = $ChemotaxisArea2D
@onready var shoot_timer: Timer = $ShootCooldownTimer
@onready var dash_timer: Timer = $DashDurationTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer

func _ready() -> void:
	add_to_group(&"player")
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PLAYER_INIT] PhagocytePlayer adicionado ao grupo 'player'.
[PLAYER_INIT] MotionMode: FLOATING | Layer: 2 | Muzzle Offset: (16, 0) px | State: NORMAL
```

**5. Componentes Envolvidos**
* `scenes/player/Player.tscn`.
* `src/player/Player.gd` (refatoração estrutural de `src/Player.gd`).

**6. Considerações Técnicas e Arquitetura**
* Definir `motion_mode = MOTION_MODE_FLOATING` na Godot 4 é essencial para jogos Top-Down 2D, pois faz com que `move_and_slide()` trate todas as colisões como paredes (`wall`) em vez de pisos/tetos com gravidade.
* O colisor físico principal deve ser um `CircleShape2D` com raio `12.0 px` (ligeiramente menor que o sprite de $32\times 32\text{ px}$), proporcionando *hitbox* justa (*forgiving hitbox*) para esquiva de projéteis inimigos.

**7. Mockups ou Referências Visuais**
```plaintext
Árvore de Nós de scenes/player/Player.tscn:
Player (CharacterBody2D - Layer 2, Grupo "player")
├── AnimatedSprite2D (phagocyte_frames.tres)
├── BodyCollisionShape2D (CircleShape2D, radius = 12 px)
├── AimPivot (Node2D)
│   └── MuzzleMarker (Marker2D, position = Vector2(16, 0))
├── ChemotaxisArea2D (Area2D - Mask: Layer 6)
│   └── MagnetCollisionShape2D (CircleShape2D, radius = 80 px)
├── HazardDetectorArea2D (Area2D - Mask: Layer 7)
│   └── HazardShape2D (CircleShape2D, radius = 10 px)
├── ShootCooldownTimer (Timer, wait_time = 0.33, one_shot = true)
├── DashDurationTimer (Timer, wait_time = 0.20, one_shot = true)
├── DashCooldownTimer (Timer, wait_time = 0.80, one_shot = true)
├── PointLight2D (Bioluminescência 256x256)
├── DashTrailParticles (GPUParticles2D)
└── PlayerCamera2D (Camera2D, position_smoothing_enabled = true)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #03, Issue #04 e Issue #11.
* **Bloqueia:** Issues #13 a #22.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `scenes/player/Player.tscn` na Godot 4 e validar a hierarquia de nós descrita no mockup.
2. Habilitar `Debug -> Visible Collision Shapes` e rodar a cena para inspecionar os círculos de colisão física (`12 px`) e de quimiotaxia (`80 px`).

**10. Definição de Pronto (Definition of Done - DoD)**
* Cena `scenes/player/Player.tscn` criada, configurada com camadas corretas e instanciável sem erros.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `player`, `scene-tree`, `characterbody2d`, `state-machine`.

**13. Documentação Relacionada**
* Requisitos RF01, RF04, RF05, RF07, RNF05.
* Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #13: [Backend] Implementação da Movimentação Protoplasmática Vetorial com Aceleração (`10.0`) e Atrito Hidrodinâmico (`6.0`)**

**1. História de Usuário (User Story)**
> **Como** jogador controlando o fagócito através dos vasos e tecidos orgânicos,
> **eu quero** que a movimentação em 8 direções / analógico utilize interpolação vetorial com aceleração suave ($\text{ACCEL} = 10.0$), desaceleração por atrito hidrodinâmico ($\text{FRICTION} = 6.0$) e velocidade máxima de $220\text{ px/s}$,
> **para que** o deslocamento transmita a sensação física de uma célula imersa em fluido biológico sem perder a responsividade arcade.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador pressiona as teclas WASD ou inclina o analógico esquerdo no estado `NORMAL`, **quando** `_physics_process(delta)` calcular a direção via `Input.get_vector("move_left", "move_right", "move_up", "move_down")`, **então** a magnitude do vetor $\vec{v}_{dir}$ nunca deve exceder `1.0` nas diagonais.
* **Dado que** existe intenção de movimento ($\vec{v}_{dir} \neq \vec{0}$), **quando** a velocidade for atualizada, **então** deve aplicar `velocity = velocity.lerp(input_dir * get_effective_max_speed(), ACCEL * delta)` com `BASE_MAX_SPEED = 220.0` e `ACCEL = 10.0`.
* **Dado que** o jogador solta os controles de direção ($\vec{v}_{dir} == \vec{0}$), **quando** o fagócito desacelerar, **então** deve aplicar inércia hidrodinâmica `velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)` com `FRICTION = 6.0` antes de invocar `move_and_slide()`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Trecho de cinemática protoplasmática em src/player/Player.gd
const BASE_MAX_SPEED: float = 220.0
const ACCEL: float = 10.0
const FRICTION: float = 6.0

var speed_multiplier: float = 1.0 # Alterado por Muco (0.6) ou Upgrade Pseudópodes (1.15)
var last_move_direction: Vector2 = Vector2.RIGHT

func _apply_protoplasmic_movement(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	var target_max_speed: float = BASE_MAX_SPEED * speed_multiplier
	
	if input_dir != Vector2.ZERO:
		last_move_direction = input_dir.normalized()
		velocity = velocity.lerp(input_dir * target_max_speed, ACCEL * delta)
		anim_sprite.play(&"move")
	else:
		velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)
		if velocity.length() < 5.0:
			velocity = Vector2.ZERO
		anim_sprite.play(&"idle")
	
	move_and_slide()
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[KINEMATICS] Input Diagonal (0.7071, 0.7071) | Magnitude: 1.00 | Vel Escalar Máxima: 220.0 px/s
[KINEMATICS] Input liberado -> Desaceleração hidrodinâmica (FRICTION=6.0) até repouso.
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `scenes/player/Player.tscn`.

**6. Considerações Técnicas e Arquitetura**
* Implementa fielmente a equação matemática da Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`:
  $$\vec{v}_{atual} = \vec{v}_{atual}.\text{lerp}(\vec{v}_{dir} \cdot V_{max}, \text{ACCEL} \cdot delta)$$
* Substitui a movimentação rígida sem inércia e baseada em `Input.is_key_pressed` do antigo `src/Player.gd`, eliminando também a restrição de tela fixa de $1280\times 720$ para permitir navegação livre em arenas multi-salas com `TileMap`.

**7. Mockups ou Referências Visuais**
```plaintext
Curva de Velocidade Escalar (px/s):
220 |        /----------------\
	|       / (ACCEL = 10.0)   \  (FRICTION = 6.0)
  0 +------/--------------------\---------> Tempo (s)
	   Input ON              Input OFF
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #04 e Issue #12.
* **Bloqueia:** Issue #17, Issue #20 e Issue #21.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Executar a cena de teste com o jogador e pressionar `W + D` simultaneamente.
2. Verificar no console (`print(velocity.length())`) se a velocidade estabiliza em `220.0 px/s` e nunca atinge $220 \times \sqrt{2} \approx 311\text{ px/s}$.
3. Soltar as teclas e observar o curto deslize orgânico até parar e trocar a animação para `idle`.

**10. Definição de Pronto (Definition of Done - DoD)**
* Movimentação vetorial com aceleração/atrito implementada, testada em Teclado e Analógico Esquerdo do Gamepad e integrada com as animações `idle` e `move`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `player`, `physics`, `movement`, `kinematics`.

**13. Documentação Relacionada**
* Requisitos RF01, RF02.
* Seção 7 do Mini GDD e Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #14: [Backend] Sistema de Mira Contínua em 360° com Alternância Automática Mouse Global vs. Analógico Direito**

**1. História de Usuário (User Story)**
> **Como** jogador de um Twin-Stick Shooter,
> **eu quero** mirar livremente em 360° utilizando tanto o cursor do mouse quanto a alavanca analógica direita do controle, com detecção automática de qual periférico foi movido por último e retenção do último ângulo válido quando o analógico estiver na zona morta ($< 0.25$),
> **para que** a pontaria seja precisa e contínua sem que a mira volte bruscamente para $0^\circ$ ao soltar o stick direito.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador move o mouse em mais de `2.0 px`, **quando** o modo de mira for `MOUSE`, **então** o vetor de mira deve apontar de `global_position` para `get_global_mouse_position()`, rotacionando o `AimPivot` (e o sprite do fagócito) continuamente em 360°.
* **Dado que** o jogador inclina a alavanca analógica direita com magnitude $\ge 0.25$, **quando** `_physics_process` ler `Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")`, **então** o modo de mira deve comutar automaticamente para `GAMEPAD` e orientar o ângulo para `joy_aim.angle()`.
* **Dado que** o jogador está no modo `GAMEPAD` e solta a alavanca analógica direita (magnitude $< 0.25$), **quando** atualizado o quadro, **então** o fagócito deve preservar o último ângulo válido (`last_valid_aim_angle`) sem resetar a rotação.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Lógica de Mira Contínua 360° Dual-Input em src/player/Player.gd
const AIM_DEADZONE: float = 0.25
var using_gamepad_aim: bool = false
var aim_direction: Vector2 = Vector2.RIGHT
var last_valid_aim_angle: float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.relative.length() > 2.0:
		using_gamepad_aim = false
	elif event is InputEventJoypadMotion and absf(event.axis_value) >= AIM_DEADZONE:
		using_gamepad_aim = true

func _update_aim_360() -> void:
	var joy_aim := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	if joy_aim.length() >= AIM_DEADZONE:
		using_gamepad_aim = true
		aim_direction = joy_aim.normalized()
		last_valid_aim_angle = aim_direction.angle()
	elif not using_gamepad_aim:
		var mouse_dir := global_position.direction_to(get_global_mouse_position())
		if mouse_dir != Vector2.ZERO:
			aim_direction = mouse_dir
			last_valid_aim_angle = aim_direction.angle()
	
	$AimPivot.rotation = last_valid_aim_angle
	anim_sprite.rotation = last_valid_aim_angle
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[AIM_360] Mode: MOUSE | Global Mouse: (1420, 680) | Angle: 24.5 deg
[AIM_360] Mode: GAMEPAD | Stick Right: (0.82, -0.57) | Angle: -34.8 deg
[AIM_360] Stick Right released (< 0.25) -> Preserving last_valid_aim_angle: -34.8 deg
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `scenes/player/Player.tscn` (`AimPivot` e `MuzzleMarker`).

**6. Considerações Técnicas e Arquitetura**
* Cumpre rigorosamente a especificação da Seção 4.1 (*Mira Contínua e Disparo de Enzimas*) do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Substitui o método antigo `atualizar_visual()` de `src/Player.gd`, que limitava a rotação apenas a 4 ângulos ortogonais discretos ($0^\circ, 90^\circ, -90^\circ$ e flip horizontal).

**7. Mockups ou Referências Visuais**
```plaintext
		   -90° (UP)
			  |
 180° (LEFT) -O---> MuzzleMarker (+16 px) -> 0° (RIGHT)
			  |
		   +90° (DOWN)
(Rotação contínua em radianos [-PI, +PI] via last_valid_aim_angle)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #04 e Issue #12.
* **Bloqueia:** Issue #15, Issue #16 e Issue #17.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Mover o cursor do mouse em círculos ao redor do fagócito parado e verificar se o `MuzzleMarker` aponta exatamente para o cursor em 360°.
2. Inclinar o analógico direito do controle para a diagonal superior esquerda e soltá-lo; verificar se a mira permanece apontada para aquela diagonal até que uma nova entrada ocorra.

**10. Definição de Pronto (Definition of Done - DoD)**
* Mira 360° funcionando com transição suave entre Mouse e Gamepad e retenção de ângulo na deadzone (`0.25`).

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `player`, `twin-stick`, `aim-360`, `gamepad`.

**13. Documentação Relacionada**
* Requisitos RF02, RF03.
* Seção 2.1 e Seção 4 do Mini GDD; Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #15: [Backend] Implementação da Cena `EnzymeProjectile.tscn` (`Area2D`, Layer 4), Balística a `550 px/s` e `VisibleOnScreenNotifier2D`**

**1. História de Usuário (User Story)**
> **Como** jogador secretando enzimas corrosivas contra os patógenos,
> **eu quero** que cada projétil se desloque em trajetória retilínea a $550\text{ px/s}$, aplique $10$ de dano base ao atingir inimigos (Layer 3), se destrua ao colidir com paredes vasculares (Layer 1) e execute `queue_free()` automaticamente ao sair da tela,
> **para que** o combate balístico seja responsivo e jamais cause degradação de memória ou queda dos 60 FPS.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `scenes/player/EnzymeProjectile.tscn` é instanciado, **quando** verificada sua configuração de física, **então** deve ser uma `Area2D` na `collision_layer = 4` (`Player_Projectiles`) e `collision_mask = 1 + 4` (colide exclusivamente com Layer 1 `World_Solid` e Layer 3 `Enemy_Body`).
* **Dado que** o projétil está em voo, **quando** `_physics_process(delta)` for executado, **então** deve deslocar sua `global_position` em `direction * speed * delta` com `speed = 550.0 px/s`.
* **Dado que** o projétil sai dos limites do enquadramento da câmera sem atingir obstáculos, **quando** o nó filho `VisibleOnScreenNotifier2D` emitir o sinal `screen_exited`, **então** o projétil deve invocar `queue_free()` imediatamente.
* **Dado que** o projétil intercepta um patógeno na Layer 3, **quando** `body_entered(body)` disparar e o alvo possuir o método `take_damage(amount)`, **então** deve aplicar o dano calculado, emitir partículas cáusticas de impacto e liberar o nó da árvore.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/player/EnzymeProjectile.gd
class_name EnzymeProjectile
extends Area2D

@export var speed: float = 550.0
@export var base_damage: float = 10.0

var direction: Vector2 = Vector2.RIGHT
var damage_multiplier: float = 1.0
var is_concentrated: bool = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func setup(dir: Vector2, dmg_mult: float, concentrated: bool = false) -> void:
	direction = dir.normalized()
	rotation = direction.angle()
	damage_multiplier = dmg_mult
	is_concentrated = concentrated

func _ready() -> void:
	screen_notifier.screen_exited.connect(queue_free)
	body_entered.connect(_on_body_entered)
	anim_sprite.play(&"concentrated" if is_concentrated else &"default")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method(&"take_damage"):
		body.take_damage(base_damage * damage_multiplier)
	queue_free()
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PROJECTILE] Spawned at (416, 300) | Angle: 0.0 rad | Speed: 550 px/s | Damage: 10.0
[PROJECTILE] Hit Enemy1 (Layer 3) -> Applied 10.0 damage -> queue_free()
[PROJECTILE] Exited viewport -> VisibleOnScreenNotifier2D.screen_exited -> queue_free()
```

**5. Componentes Envolvidos**
* `scenes/player/EnzymeProjectile.tscn`.
* `src/player/EnzymeProjectile.gd`.
* `resources/projectile_frames.tres`.

**6. Considerações Técnicas e Arquitetura**
* O uso de `VisibleOnScreenNotifier2D` conectado a `queue_free()` é requisito explícito de otimização tanto no Slide 5 de `Projeto_disciplina_2026_1.0.pdf` quanto na Seção 4.1 e Seção 8 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* O projétil também inclui um nó `PointLight2D` leve (cor verde-ácido `#39FF14` ou amarelo `#FFEE32` quando concentrado) para iluminar os corredores vasculares durante o voo.

**7. Mockups ou Referências Visuais**
```plaintext
Árvore de Nós de scenes/player/EnzymeProjectile.tscn:
EnzymeProjectile (Area2D - Layer 4 | Mask: Layers 1, 3)
├── AnimatedSprite2D (projectile_frames.tres)
├── CollisionShape2D (CircleShape2D, radius = 5 px)
├── VisibleOnScreenNotifier2D (Rect2(-8, -8, 16, 16))
└── ProjectileLight2D (PointLight2D, energy = 0.6, texture_scale = 0.35)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #03, Issue #07 e Issue #11.
* **Bloqueia:** Issue #16 e Issue #22.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Instanciar `EnzymeProjectile.tscn` em uma cena com paredes na Layer 1 e um dummy inimigo na Layer 3.
2. Disparar para fora da tela e monitorar a aba `Debugger -> Monitors -> Object/Node Count` para confirmar que o contador de nós retorna ao valor inicial assim que o projétil cruza a borda da câmera.

**10. Definição de Pronto (Definition of Done - DoD)**
* Cena `EnzymeProjectile.tscn` e script `EnzymeProjectile.gd` implementados, com colisão nas Layers 1 e 3 e descarte automático fora da tela.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `projectiles`, `combat`, `optimization`, `area2d`.

**13. Documentação Relacionada**
* Requisitos RF04, RNF01, RNF05.
* Seção 4.1 e Seção 8 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`; Slide 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #16: [Backend] Sistema de Disparo Enzimático no `Marker2D` Frontal, Cadência (`0.33s`) e Power-Ups Cumulativos (Rapid, Spread, Damage)**

**1. História de Usuário (User Story)**
> **Como** jogador enfrentando hordas crescentes de patógenos,
> **eu quero** disparar enzimas continuamente enquanto mantiver o botão de tiro pressionado (cadência base de $0.33\text{ s}$) e acumular os efeitos dos 3 power-ups temporários de 15 segundos (*Damage Shot* $3\times$, *Spread Shot* $-20^\circ/0^\circ/+20^\circ$ e *Rapid Shot* $0.16\text{ s}$),
> **para que** o combate tenha progressão de poder explosiva e recompensadora ao abrir Vacúolos Celulares nas salas laterais.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador mantém a ação `shoot` pressionada (LMB ou RT/R2), **quando** o `ShootCooldownTimer` estiver disponível, **então** deve instanciar o projétil na posição global do `MuzzleMarker` (`+16 px` à frente do centro do fagócito) e iniciar o cooldown de `0.33s` (3 tiros/s).
* **Dado que** o jogador coleta um power-up temporário de um Vacúolo Celular (`apply_temporary_buff(buff_type, 15.0)`), **quando** o buff for ativado, **então**:
  - Se `DAMAGE_SHOT`: multiplica o dano por $3.0\times$ e ativa o visual amarelo fluorescente por $15.0\text{ s}$.
  - Se `SPREAD_SHOT`: instancia 3 projéteis simultâneos com ângulos de $-20^\circ$, $0^\circ$ e $+20^\circ$ em relação ao vetor de mira por $15.0\text{ s}$.
  - Se `RAPID_SHOT`: reduz o intervalo do `ShootCooldownTimer` de `0.33s` para `0.16s` por $15.0\text{ s}$.
* **Dado que** o jogador coleta múltiplos power-ups em sequência dentro da janela de 15 segundos, **quando** disparar, **então** os efeitos devem operar de forma 100% cumulativa (ex: 3 tiros amarelos em leque com dano $3\times$ a cada $0.16\text{ s}$).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Lógica de disparo e power-ups cumulativos em src/player/Player.gd
const BASE_FIRE_RATE: float = 0.33
const RAPID_FIRE_RATE: float = 0.16
const SPREAD_ANGLES_DEG: Array[float] = [-20.0, 0.0, 20.0]

var buff_timers: Dictionary = {
	&"damage_shot": 0.0,
	&"spread_shot": 0.0,
	&"rapid_shot": 0.0
}

func _try_shoot() -> void:
	if not shoot_timer.is_stopped() or current_state == PlayerState.DEAD:
		return
	
	var is_rapid: bool = buff_timers[&"rapid_shot"] > 0.0
	var is_spread: bool = buff_timers[&"spread_shot"] > 0.0
	var is_damage: bool = buff_timers[&"damage_shot"] > 0.0
	
	shoot_timer.wait_time = RAPID_FIRE_RATE if is_rapid else BASE_FIRE_RATE
	shoot_timer.start()
	
	var total_dmg_mult: float = (3.0 if is_damage else 1.0) * permanent_damage_multiplier
	var angles: Array[float] = SPREAD_ANGLES_DEG if is_spread else [0.0]
	
	for angle_deg in angles:
		var proj := projectile_scene.instantiate() as EnzymeProjectile
		get_tree().current_scene.add_child(proj)
		proj.global_position = muzzle_marker.global_position
		var dir := aim_direction.rotated(deg_to_rad(angle_deg))
		proj.setup(dir, total_dmg_mult, is_damage)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[BUFF_ACTIVE] spread_shot (15.0s) + damage_shot (15.0s) + rapid_shot (15.0s)
[COMBAT] Fired 3 concentrated projectiles (-20°, 0°, +20°) | Cooldown: 0.16s | DmgMult: 3.0x
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `scenes/player/EnzymeProjectile.tscn`.
* `src/GameState.gd` (emissão do sinal `temporary_buff_updated`).

**6. Considerações Técnicas e Arquitetura**
* Os projéteis devem ser adicionados à cena raiz da fase (`get_tree().current_scene.add_child(proj)`) e **nunca** como filhos diretos do `Player`, para que sua trajetória espacial no mundo seja independente das rotações e movimentos subsequentes do fagócito.

**7. Mockups ou Referências Visuais**
```plaintext
Dispersão Citoplasmática (Spread Shot):
			  /  -20° (EnzymeProjectile 1)
   (Fagócito)O===  0° (EnzymeProjectile 2)
			  \  +20° (EnzymeProjectile 3)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #14 e Issue #15.
* **Bloqueia:** Issue #27 e Issue #40.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Manter o botão de tiro pressionado e cronometrar 3 disparos por segundo no estado base.
2. Ativar via código de teste `apply_temporary_buff(&"spread_shot", 15.0)` e `apply_temporary_buff(&"damage_shot", 15.0)` simultaneamente, verificando o leque triplo amarelo e a restauração ao tiro simples após 15 segundos.

**10. Definição de Pronto (Definition of Done - DoD)**
* Disparo contínuo e os 3 buffs temporários cumulativos de 15 segundos funcionais e emitindo sinais de contagem regressiva para o `HUD.tscn`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`backend`, `combat`, `power-ups`, `shooting`, `player`.

**13. Documentação Relacionada**
* Requisitos RF04, RF08.
* Seção 8 do Mini GDD e Seção 4.1 / 5.4 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #17: [Backend] Implementação do Dash Citoplasmático (`480 px/s`, `0.2s`), Janela de *I-Frames*, Translucidez e Cooldown (`0.8s`)**

**1. História de Usuário (User Story)**
> **Como** jogador cercado por enxames virais ou rajadas radiais de esporos,
> **eu quero** executar uma esquiva rápida (Dash Citoplasmático) a $480\text{ px/s}$ por $0.2\text{ s}$ que me torne invulnerável a dano (*I-Frames*), deixe a membrana translúcida (`modulate.a = 0.4`) e respeite uma recarga de $0.8\text{ s}$,
> **para que** eu possa atravessar padrões densos de projéteis e flanquear inimigos blindados com precisão tática.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador está no estado `NORMAL`, possui $\text{ATP} \ge 25.0$ e o `DashCooldownTimer` está parado, **quando** acionar `dash` (Espaço, RMB ou LT/L2), **então** o estado deve mudar para `DASHING` por `0.2s` com velocidade constante de `480.0 px/s` na direção atual do movimento (ou na direção da mira caso o jogador esteja parado).
* **Dado que** o fagócito está no estado `DASHING`, **quando** durar a janela de `0.2s`, **então** `is_invulnerable` deve ser `true`, a máscara de colisão com projéteis/corpos inimigos (Layers 3 e 5) deve ser temporariamente ignorada para dano e `anim_sprite.modulate.a` deve ser `0.4`.
* **Dado que** os `0.2s` de propulsão terminam, **quando** `DashDurationTimer.timeout` disparar, **então** `anim_sprite.modulate.a` deve voltar a `1.0`, o estado deve retornar a `NORMAL` e o `DashCooldownTimer` (`0.8s`) deve iniciar.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Sistema de Dash Citoplasmático em src/player/Player.gd
const DASH_SPEED: float = 480.0
const DASH_DURATION: float = 0.20
const DASH_COOLDOWN: float = 0.80
const DASH_ATP_COST: float = 25.0

var dash_direction: Vector2 = Vector2.RIGHT
var is_invulnerable: bool = false

func _start_cytoplasmic_dash() -> void:
	if current_state != PlayerState.NORMAL or not dash_cooldown_timer.is_stopped():
		return
	if not _consume_atp(DASH_ATP_COST):
		_emit_dash_refused_feedback()
		return
	
	current_state = PlayerState.DASHING
	is_invulnerable = true
	var input_dir := Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	dash_direction = input_dir.normalized() if input_dir != Vector2.ZERO else aim_direction.normalized()
	
	anim_sprite.modulate.a = 0.4
	anim_sprite.play(&"dash")
	$DashTrailParticles.emitting = true
	dash_timer.start(DASH_DURATION)

func _on_dash_duration_timeout() -> void:
	current_state = PlayerState.NORMAL
	is_invulnerable = false
	anim_sprite.modulate.a = 1.0
	$DashTrailParticles.emitting = false
	dash_cooldown_timer.start(DASH_COOLDOWN)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[DASH] Activated! Dir: (1.0, 0.0) | Speed: 480 px/s | Duration: 0.2s | I-Frames: ON | Alpha: 0.4
[DASH] Finished after 0.20s -> I-Frames: OFF | Alpha: 1.0 | Cooldown started: 0.80s
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `scenes/player/Player.tscn` (`DashDurationTimer`, `DashCooldownTimer`, `DashTrailParticles`).

**6. Considerações Técnicas e Arquitetura**
* Diferente do teletransporte instantâneo (`move_and_collide`) do protótipo inicial, o uso de `velocity = dash_direction * 480.0` com `move_and_slide()` durante `0.2s` permite deslizar suavemente ao longo de paredes curvas dos vasos sanguíneos sem travar o dash se houver uma quina no caminho.
* Enquanto em `DASHING`, a colisão com Layer 1 (`World_Solid`) permanece 100% ativa para que o jogador nunca atravesse paredes do cenário.

**7. Mockups ou Referências Visuais**
```plaintext
Linha do Tempo do Dash Citoplasmático:
|-- Propulsão (0.2s @ 480 px/s) --|------ Recarga / Cooldown (0.8s) ------|
|   I-Frames ON | modulate.a=0.4  |   I-Frames OFF | modulate.a=1.0       |
0.0s                             0.2s                                    1.0s
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #12, Issue #13 e Issue #14.
* **Bloqueia:** Issue #18 e Issue #22.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Pressionar `Espaço` enquanto caminha e verificar o impulso rápido de $0.2\text{ s}$ com sprite semitransparente (`0.4`).
2. Parar completamente o fagócito, apontar o mouse para um canto e acionar o dash: confirmar que o impulso ocorre na direção da mira.
3. Atravessar um projétil inimigo durante os $0.2\text{ s}$ do dash e confirmar que nenhum dano é sofrido.

**10. Definição de Pronto (Definition of Done - DoD)**
* Mecânica de Dash Citoplasmático com *I-Frames*, translucidez, partículas e cooldown de `0.8s` implementada conforme o Mini GDD.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `player`, `dash`, `i-frames`, `combat`.

**13. Documentação Relacionada**
* Requisito RF05.
* Seção 7 do Mini GDD e Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #18: [Backend] Gestão Metabólica da Barra de ATP (Capacidade `100`, Custo `25`, Delay `1.0s` e Regeneração `15 un/s`)**

**1. História de Usuário (User Story)**
> **Como** jogador utilizando o Dash Citoplasmático em combate,
> **eu quero** que minha barra de ATP (capacidade 100) consuma 25 unidades por esquiva, bloqueie o dash com alerta sonoro/visual caso o ATP seja $< 25$ e regenere passivamente a $15\text{ unidades/s}$ após $1.0\text{ s}$ sem uso de esquiva,
> **para que** o uso do dash exija gestão metabólica estratégica e crie sinergia com a coleta ativa de glóbulos de ATP na arena.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador inicia a partida, **quando** consultado o ATP inicial, **então** `max_atp` deve ser `100.0` e `current_atp` deve ser `100.0`.
* **Dado que** o jogador executa um dash, **quando** `_consume_atp(25.0)` for chamado, **então** `current_atp` deve ser reduzido em `25.0`, o atraso de regeneração (`atp_regen_delay = 1.0s`) deve ser reiniciado e o sinal `GameState.player_atp_changed` deve ser emitido.
* **Dado que** se passou `1.0s` desde o último gasto de ATP, **quando** `_physics_process(delta)` rodar e `current_atp < max_atp`, **então** o ATP deve regenerar continuamente à taxa de `15.0 * atp_regen_multiplier * delta`.
* **Dado que** `current_atp < 25.0`, **quando** o jogador tentar acionar o dash, **então** a esquiva deve ser recusada e o sinal `GameState.atp_insufficient_triggered` deve ser emitido para piscar a barra no HUD e tocar o SFX de recusa.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Gestão Metabólica de ATP em src/player/Player.gd
const MAX_ATP_BASE: float = 100.0
const ATP_REGEN_RATE_BASE: float = 15.0
const ATP_REGEN_DELAY_TIME: float = 1.0

var max_atp: float = MAX_ATP_BASE
var current_atp: float = MAX_ATP_BASE
var atp_regen_multiplier: float = 1.0 # +30% (1.3) após Chefe 2
var time_since_last_atp_use: float = 1.0

func _process_atp_metabolism(delta: float) -> void:
	if time_since_last_atp_use < ATP_REGEN_DELAY_TIME:
		time_since_last_atp_use += delta
		return
	if current_atp < max_atp:
		current_atp = minf(max_atp, current_atp + (ATP_REGEN_RATE_BASE * atp_regen_multiplier * delta))
		GameState.player_atp_changed.emit(current_atp, max_atp)

func _consume_atp(cost: float) -> bool:
	if current_atp < cost:
		return false
	current_atp -= cost
	time_since_last_atp_use = 0.0
	GameState.player_atp_changed.emit(current_atp, max_atp)
	return true
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[ATP] Dash consumed 25.0 ATP -> Remaining: 75.0/100.0 (Regen paused for 1.0s)
[ATP] Delay elapsed -> Passive regeneration active at 15.0 units/s
[ATP_WARN] Dash refused! Current ATP (12.4) < Required (25.0)
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `src/GameState.gd`.

**6. Considerações Técnicas e Arquitetura**
* Atende à restrição de gameplay exigida pelo PDF da disciplina (Slide 9 — *Restrições: Barra de mana, barra de stamina*) e às métricas exatas da Seção 4.1 e Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Também expõe o método público `drain_atp(amount: float)` para suportar o ataque do patógeno *Sugador de ATP* da Fase 4 (Seção 7 do contexto técnico).

**7. Mockups ou Referências Visuais**
```plaintext
Ciclo Metabólico de ATP:
[100/100] --(Dash -25)--> [75/100] --(Espera 1.0s)--> [+15 un/s até 100/100]
								   --(Glóbulo ATP)--> [+20 un instantâneos!]
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05 e Issue #17.
* **Bloqueia:** Issue #19, Issue #21 e Issue #25.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Executar 4 dashes seguidos (respeitando o cooldown de $0.8\text{ s}$) para esvaziar a barra de ATP.
2. Tentar um 5º dash imediato com $\text{ATP} < 25$ e validar o bloqueio e emissão do sinal de alerta.
3. Aguardar $1.0\text{ s}$ sem tocar no botão de dash e verificar a subida contínua de $15\text{ unidades/s}$.

**10. Definição de Pronto (Definition of Done - DoD)**
* Consumo, bloqueio por insuficiência, delay de $1.0\text{ s}$ e regeneração passiva de ATP implementados e sincronizados com `GameState`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`backend`, `player`, `atp`, `stamina`, `metabolism`.

**13. Documentação Relacionada**
* Requisitos RF05, RF06.
* Seção 7 do Mini GDD e Seção 4.1 / 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #19: [Backend] Mecânica de Quimiotaxia e Fagocitose Tática (`Area2D` Raio `80 px`, Layer 6) com Atração Exponencial**

**1. História de Usuário (User Story)**
> **Como** jogador eliminando patógenos e avançando para recolher seus detritos celulares,
> **eu quero** que minha área de Quimiotaxia (raio de $80\text{ px}$ monitorando a Layer 6) puxe magneticamente os glóbulos de ATP e partículas de biomassa até o corpo do fagócito para fagocitá-los,
> **para que** cada glóbulo absorvido restaure $10\%$ da vida máxima, $+20$ unidades de ATP e incremente o score de biomassa sem exigir colisão pixel-a-pixel manual com itens minúsculos.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `ChemotaxisArea2D` possui um `CircleShape2D` com `radius = 80.0 px` e `collision_mask = 32` (Layer 6 `Pickups_Collectibles`), **quando** um item coletável entrar nessa área, **então** ele deve sair do estado de repouso e sofrer aceleração atrativa contínua em direção ao centro do fagócito:
  $$\vec{v}_{item} = \vec{v}_{item} + (\vec{pos}_{player} - \vec{pos}_{item}).\text{normalized}() \cdot \text{PULL\_FORCE} \cdot delta$$
* **Dado que** o glóbulo de ATP atinge o raio de fagocitose do corpo (`distância <= 14.0 px`), **quando** consumido, **então** deve restaurar `0.10 * max_hp` de vida, adicionar `+20.0` unidades imediatas de ATP, incrementar o score de biomassa no `GameState`, disparar o efeito sonoro de fagocitose e executar `queue_free()`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Script de Coletável / Glóbulo de ATP com Quimiotaxia (src/player/ATPGlobulePickup.gd)
class_name ATPGlobulePickup
extends Area2D

const PULL_FORCE: float = 950.0
const ABSORB_DISTANCE: float = 14.0
const ATP_RESTORE: float = 20.0
const HP_RESTORE_RATIO: float = 0.10
const BIOMASS_VALUE: int = 25

var target_player: Node2D = null
var current_velocity: Vector2 = Vector2.ZERO

func start_chemotaxis_pull(player_node: Node2D) -> void:
	target_player = player_node

func _physics_process(delta: float) -> void:
	if target_player == null or not is_instance_valid(target_player):
		return
	var to_player: Vector2 = target_player.global_position - global_position
	current_velocity += to_player.normalized() * PULL_FORCE * delta
	global_position += current_velocity * delta
	
	if to_player.length() <= ABSORB_DISTANCE:
		if target_player.has_method(&"phagocytose_globule"):
			target_player.phagocytose_globule(HP_RESTORE_RATIO, ATP_RESTORE, BIOMASS_VALUE)
		queue_free()
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[CHEMOTAXIS] ATPGlobule entered 80px radius -> Magnetic pull activated (PULL_FORCE=950)
[PHAGOCYTOSIS] Globule absorbed! +10.0 HP | +20.0 ATP | +25 Biomass Score
```

**5. Componentes Envolvidos**
* `src/player/Player.gd` (métodos `_on_chemotaxis_area_entered` e `phagocytose_globule`).
* `src/player/ATPGlobulePickup.gd` e `scenes/player/ATPGlobulePickup.tscn`.

**6. Considerações Técnicas e Arquitetura**
* Implementa exatamente a fórmula vetorial de atração magnética definida na Seção 4.1 (*Quimiotaxia e Fagocitose Tática*) do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Materializa o pilar de design *Fagocitose Tática e Gestão Metabólica* (Seção 1.3 do Mini GDD), recompensando o jogador que se aproxima das zonas de abate.

**7. Mockups ou Referências Visuais**
```plaintext
		 . - ~ ~ ~ - .
	 . '   Raio 80 px  ' .
   /    (ChemotaxisArea)   \
  |   (o) -----> [Fagócito] |   (o) = Glóbulo de ATP acelerando
   \         <----- (o)    /          exponencialmente ao centro
	 .                 . '
		 ' - _ _ _ - '
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #03, Issue #05, Issue #09, Issue #12 e Issue #18.
* **Bloqueia:** Issue #20 e Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Posicionar 3 instâncias de `ATPGlobulePickup.tscn` na cena de teste com o jogador a $50\%$ de HP e $50\%$ de ATP.
2. Aproximar o fagócito a menos de $80\text{ px}$ dos glóbulos e observar a curva de aceleração magnética até a absorção.
3. Confirmar no console e no HUD o acréscimo de $+10\%$ de HP, $+20$ de ATP e aumento do score.

**10. Definição de Pronto (Definition of Done - DoD)**
* Área de Quimiotaxia (`80 px`, Layer 6) e cena `ATPGlobulePickup.tscn` implementadas e integradas com restauração de HP, ATP e Biomassa.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`backend`, `player`, `chemotaxis`, `phagocytosis`, `pickups`.

**13. Documentação Relacionada**
* Requisito RF07.
* Seção 1.3 e Seção 7 do Mini GDD; Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #20: [Backend] Sistema de Integridade Celular (HP), Dano, Knockback e Reação a Muco Viscoso (`-40%`) e Bio-Toxina ($DoT$)**

**1. História de Usuário (User Story)**
> **Como** jogador enfrentando patógenos e obstáculos de terreno vascular,
> **eu quero** que o fagócito gerencie sua Integridade Celular (`max_hp = 100.0`), sofra dano com breve janela de invencibilidade pós-impacto (`0.5s`) para evitar morte instantânea por múltiplos frames de contato, reduza a velocidade em $40\%$ sobre Muco Viscoso e sofra dano contínuo ($DoT$) sobre Bio-Toxina Ácida,
> **para que** o posicionamento tático no terreno e a esquiva de ameaças sejam justos, claros e desafiadores.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o fagócito não está em dash (`not is_invulnerable`), **quando** `take_damage(amount, source_pos)` for chamado por um inimigo ou projétil hostil, **então** `current_hp` deve diminuir em `amount`, o sinal `GameState.player_health_changed` deve ser emitido, um impulso de *knockback* deve afastar o jogador da origem do golpe e uma janela de invencibilidade de `0.5s` com piscar visual deve ser ativada.
* **Dado que** o jogador pisa em uma `Area2D` da Layer 7 (`Environmental_Hazards`) do tipo `MucusArea`, **quando** não possuir a adaptação *Pseudópodes Fortalecidos*, **então** sua velocidade máxima deve ser reduzida em $40\%$ (`speed_multiplier = 0.60`) enquanto permanecer sobre o muco.
* **Dado que** o jogador permanece sobre uma `BioToxinArea` (Layer 7), **quando** o contato persistir, **então** deve receber dano fracionado por segundo ($DoT$) com pulso avermelhado na tela.
* **Dado que** `current_hp` atinge `<= 0.0`, **quando** o dano fatal ocorrer, **então** o estado deve mudar para `DEAD`, desativar os inputs de combate, tocar a animação `death` e acionar a transição para `GameOverScreen.tscn`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Gestão de HP, Dano e Perigos Ambientais em src/player/Player.gd
const BASE_MAX_HP: float = 100.0
const HURT_INVULN_TIME: float = 0.50

var max_hp: float = BASE_MAX_HP
var current_hp: float = BASE_MAX_HP
var in_mucus_zones: int = 0
var immune_to_mucus: bool = false

func take_damage(amount: float, source_pos: Vector2 = global_position) -> void:
	if is_invulnerable or current_state == PlayerState.DEAD:
		return
	current_hp = maxf(0.0, current_hp - amount)
	GameState.player_health_changed.emit(current_hp, max_hp)
	_trigger_hurt_feedback(source_pos)
	if current_hp <= 0.0:
		_die()

func set_mucus_overlap(entered: bool) -> void:
	in_mucus_zones = maxi(0, in_mucus_zones + (1 if entered else -1))
	_recalculate_speed_multiplier()

func _recalculate_speed_multiplier() -> void:
	var base_mult: float = 1.15 if GameState.active_adaptations[&"strong_pseudopods"] else 1.0
	if in_mucus_zones > 0 and not immune_to_mucus:
		speed_multiplier = base_mult * 0.60
	else:
		speed_multiplier = base_mult
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HAZARD] Entered MucusArea (Layer 7) -> Speed reduced by 40% (132.0 px/s)
[DAMAGE] Player took 15.0 dmg! HP: 85.0/100.0 | Knockback applied | Hurt I-Frames: 0.50s
[PLAYER_DEATH] HP reached 0.0 -> State: DEAD -> Transitioning to GameOverScreen
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `scenes/player/Player.tscn` (`HazardDetectorArea2D`).
* `src/GameState.gd`.

**6. Considerações Técnicas e Arquitetura**
* O contador `in_mucus_zones: int` (em vez de um simples `bool`) garante que, se duas placas de muco estiverem parcialmente sobrepostas no `TileMap`/arena, sair da primeira placa enquanto ainda está pisando na segunda não restaure indevidamente a velocidade normal.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #03, Issue #05, Issue #12 e Issue #13.
* **Bloqueia:** Issue #21, Issue #22, Issue #24 e Issue #34.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Instanciar uma área de teste na Layer 7 (`MucusArea`) e caminhar sobre ela: confirmar que a velocidade cai de `220 px/s` para `132 px/s` (`-40%`) e volta a `220 px/s` ao sair.
2. Chamar `player.take_damage(20.0)` repetidamente em intervalos de `0.1s` e verificar que o segundo golpe dentro da janela de `0.5s` é bloqueado pelos *hurt i-frames*.
3. Zerar o HP e verificar o disparo da animação `death` e chamada de Game Over.

**10. Definição de Pronto (Definition of Done - DoD)**
* Sistema de HP, invulnerabilidade pós-dano, knockback, lentidão por muco (`-40%`), $DoT$ por bio-toxina e morte funcionalmente validados.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`backend`, `player`, `health`, `hazards`, `combat`.

**13. Documentação Relacionada**
* Requisitos RF10, RF11.
* Seção 11 do Mini GDD e Seção 6.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #21: [Backend] Integração das 4 Adaptações Mitóticas Permanentes no Jogador (+HP, +Regen ATP, Anti-Muco e +Dano)**

**1. História de Usuário (User Story)**
> **Como** jogador progredindo pelas 5 fases e derrotando os chefes de cada tecido,
> **eu quero** que as 4 Adaptações Mitóticas permanentes conquistadas (*Membrana Lipídica*, *Mitocôndria Supercarregada*, *Pseudópodes Fortalecidos* e *Glândula Digestiva*) atualizem imediatamente os atributos biológicos do fagócito e persistam até o final da run,
> **para que** minha evolução de poder seja tangível contra os patógenos mais letais das fases avançadas.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador vence o Chefe da Fase 1 (Vírus), **quando** desbloqueada `lipid_membrane`, **então** `max_hp` deve aumentar em $+25\%$ (`100.0 -> 125.0`), curando proporcionalmente o jogador e atualizando o HUD.
* **Dado que** o jogador vence o Chefe da Fase 2 (Bactérias), **quando** desbloqueada `super_mitochondria`, **então** a taxa de regeneração de ATP deve aumentar em $+30\%$ (`15.0 -> 19.5 unidades/s`).
* **Dado que** o jogador vence o Chefe da Fase 3 (Fungos), **quando** desbloqueada `strong_pseudopods`, **então** a velocidade base de movimento deve subir em $+15\%$ (`220.0 -> 253.0 px/s`) e `immune_to_mucus` deve se tornar `true` (anulando os $-40\%$ do muco viscoso).
* **Dado que** o jogador vence o Chefe da Fase 4 (Parasitas), **quando** desbloqueada `digestive_gland`, **então** o dano base dos projéteis enzimáticos deve subir permanentemente em $+20\%$ (`10.0 -> 12.0`, ou `36.0` com *Damage Shot*).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Sincronização de Adaptações Mitóticas em src/player/Player.gd
var permanent_damage_multiplier: float = 1.0

func apply_mitotic_adaptations() -> void:
	var adapts: Dictionary = GameState.active_adaptations
	
	# Fase 1: +25% HP Máximo
	max_hp = BASE_MAX_HP * (1.25 if adapts[&"lipid_membrane"] else 1.0)
	current_hp = minf(current_hp, max_hp)
	GameState.player_health_changed.emit(current_hp, max_hp)
	
	# Fase 2: +30% Regeneração de ATP
	atp_regen_multiplier = 1.30 if adapts[&"super_mitochondria"] else 1.0
	
	# Fase 3: +15% Velocidade Base e Imunidade total ao Muco Viscoso
	immune_to_mucus = adapts[&"strong_pseudopods"]
	_recalculate_speed_multiplier()
	
	# Fase 4: +20% Dano Base permanente
	permanent_damage_multiplier = 1.20 if adapts[&"digestive_gland"] else 1.0
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[ADAPTATION] Aplicando upgrades permanentes do GameState:
 -> Membrana Lipídica: Max HP = 125.0 (+25%)
 -> Mitocôndria Supercarregada: ATP Regen = 19.5/s (+30%)
 -> Pseudópodes Fortalecidos: Max Speed = 253.0 px/s (+15%) | Imune a Muco = TRUE
 -> Glândula Digestiva: Base Projectile Damage = 12.0 (+20%)
```

**5. Componentes Envolvidos**
* `src/player/Player.gd`.
* `src/GameState.gd`.

**6. Considerações Técnicas e Arquitetura**
* Como `Player.tscn` é recriado ao carregar a cena de cada novo tecido (`Level1.tscn` a `Level5.tscn`), o método `apply_mitotic_adaptations()` deve ser invocado tanto no `_ready()` do `Player.gd` (lendo o dicionário persistido no `GameState`) quanto em resposta ao sinal `GameState.mitotic_adaptation_unlocked`.

**7. Mockups ou Referências Visuais**
| Fase Vencida | Adaptação Mitótica | Atributo Modificado | Valor Base $\rightarrow$ Valor Evoluído |
| :---: | :--- | :--- | :--- |
| **Fase 1** | Membrana Lipídica Reforçada | `max_hp` | $100.0 \rightarrow 125.0\text{ HP}$ ($+25\%$) |
| **Fase 2** | Mitocôndria Supercarregada | `atp_regen_rate` | $15.0 \rightarrow 19.5\text{ un/s}$ ($+30\%$) |
| **Fase 3** | Pseudópodes Fortalecidos | `max_speed` / `immune_to_mucus`| $220 \rightarrow 253\text{ px/s}$ ($+15\%$) + Imune |
| **Fase 4** | Glândula Digestiva Avançada | `base_damage` | $10.0 \rightarrow 12.0\text{ dano}$ ($+20\%$) |

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #13, Issue #16, Issue #18 e Issue #20.
* **Bloqueia:** Issue #33.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Ativar individualmente cada chave de `GameState.active_adaptations` e chamar `player.apply_mitotic_adaptations()`.
2. Confirmar que com `strong_pseudopods = true`, pisar em uma `MucusArea` mantém a velocidade em `253.0 px/s` sem sofrer penalidade.

**10. Definição de Pronto (Definition of Done - DoD)**
* Todas as 4 Adaptações Mitóticas integradas, testadas e persistindo entre trocas de cena.

**11. Prioridade e Severidade**
* **Prioridade:** Média.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`backend`, `player`, `progression`, `upgrades`, `roguelite`.

**13. Documentação Relacionada**
* Requisito RF09.
* Seção 8 e Seção 13 do Mini GDD; Seção 5.4 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`; Slide 11 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #22: [Frontend] Anexação da `Camera2D` com Suavização, Trauma de *Screen Shake* (`0.15s`), `PointLight2D` e `GPUParticles2D`**

**1. História de Usuário (User Story)**
> **Como** jogador explorando vasos escuros e trocando tiros intensos,
> **eu quero** uma câmera com acompanhamento suave (`position_smoothing_enabled = true`), tremor de tela (*Screen Shake* de $0.15\text{ s}$) ao tomar dano, iluminação bioluminescente (`PointLight2D`) acoplada ao fagócito e partículas em GPU (`GPUParticles2D`) no rastro do dash e no impacto dos tiros,
> **para que** o jogo atenda aos requisitos visuais de iluminação, sombra e partículas da disciplina e entregue *game feel* visceral.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `PlayerCamera2D` é filha de `Player.tscn`, **quando** o fagócito se deslocar pela arena, **então** `position_smoothing_enabled` deve ser `true` (com `position_smoothing_speed = 8.0`).
* **Dado que** o jogador sofre dano, **quando** `trigger_screen_shake(0.15, 6.0)` for chamado, **então** a câmera deve aplicar deslocamentos aleatórios em `offset` e pequena oscilação angular por `0.15s`, retornando suavemente a `Vector2.ZERO`.
* **Dado que** a disciplina exige iluminação 2D e partículas, **quando** o fagócito e os projéteis estiverem na cena, **então** o `PointLight2D` do fagócito (`shadow_enabled = true`) deve projetar luz e sombras dinâmicas nos `LightOccluder2D` das paredes, e os nós `GPUParticles2D` devem emitir o rastro citoplasmático no dash (`0.2s`) e os respingos ácidos (12 a 16 partículas) no impacto dos projéteis.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Controlador de Camera2D com Screen Shake (src/player/PlayerCamera2D.gd)
extends Camera2D

var shake_time_remaining: float = 0.0
var shake_magnitude: float = 0.0

func trigger_shake(duration: float = 0.15, magnitude: float = 6.0) -> void:
	shake_time_remaining = duration
	shake_magnitude = magnitude

func _process(delta: float) -> void:
	if shake_time_remaining > 0.0:
		shake_time_remaining = maxf(0.0, shake_time_remaining - delta)
		offset = Vector2(
			randf_range(-shake_magnitude, shake_magnitude),
			randf_range(-shake_magnitude, shake_magnitude)
		)
	else:
		offset = Vector2.ZERO
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[CAMERA_VFX] Screen shake triggered (duration: 0.15s, magnitude: 6.0 px)
[LIGHTING_2D] Player PointLight2D active (shadow_enabled=true, texture=256x256 radial)
[GPU_PARTICLES] DashTrail emitting (0.2s) | CausticSplash emitted 14 particles on impact
```

**5. Componentes Envolvidos**
* `src/player/PlayerCamera2D.gd`.
* `scenes/player/Player.tscn` (`PlayerCamera2D`, `PointLight2D`, `DashTrailParticles`).
* `scenes/player/CausticSplashParticles.tscn` (`GPUParticles2D`, `one_shot = true`, `amount = 14`).

**6. Considerações Técnicas e Arquitetura**
* Cumpre diretamente os requisitos do Slide 5 de `Projeto_disciplina_2026_1.0.pdf` (*Partículas: faíscas, detritos, rastro de objeto; Iluminação: tiros, usa imagem com gradiente de molde; Sombra: PointLight2D + LightOccluder2D*) e da Seção 4.2 e Seção 6.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* A cena `CausticSplashParticles.tscn` conecta o sinal `finished` do `GPUParticles2D` diretamente a `queue_free()` para evitar acúmulo de emissores inativos na memória.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #07, Issue #12, Issue #15, Issue #17 e Issue #20.
* **Bloqueia:** Issue #27 e Issue #42.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Rodar a cena com paredes dotadas de `LightOccluder2D` e verificar a projeção de sombras em tempo real ao redor do fagócito e dos projéteis.
2. Acionar o dash e verificar a trilha de glóbulos protoplasmáticos deixada por $0.2\text{ s}$.
3. Sofrer dano de teste e verificar o tremor de $0.15\text{ s}$ na câmera.

**10. Definição de Pronto (Definition of Done - DoD)**
* `Camera2D` com shake de $0.15\text{ s}$, `PointLight2D` com sombras e os sistemas `GPUParticles2D` de rastro e impacto funcionando a 60 FPS no modo `gl_compatibility`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `camera2d`, `pointlight2d`, `gpuparticles2d`, `vfx`, `game-feel`.

**13. Documentação Relacionada**
* Requisito RF12.
* Seção 15 do Mini GDD, Seção 4.2 e 6.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

# 🖥️ Grupo 4: Interface Gráfica do Usuário — HUD e Feedback Tático

### **Issue #23: [Frontend] Estruturação da Cena `HUD.tscn` (`CanvasLayer` Estático) e Layout Responsivo 16:9 nas Extremidades**

**1. História de Usuário (User Story)**
> **Como** jogador precisando de visão desimpedida da arena de combate,
> **eu quero** um `HUD.tscn` construído sobre um `CanvasLayer` estático (desacoplado da `Camera2D`) com contêineres ancorados nas extremidades da janela 16:9,
> **para que** as informações vitais (HP, ATP, Biomassa, Receptores e Buffs) fiquem sempre fixas nas bordas da tela sem tremer durante o *Screen Shake* nem obstruir a mira central.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `scenes/ui/HUD.tscn` é instanciado na cena de gameplay, **quando** a `Camera2D` do jogador se mover ou executar *Screen Shake*, **então** o `HUD` (`CanvasLayer`, `layer = 5`) deve permanecer 100% estacionário no espaço de tela (`1920x1080`).
* **Dado que** o jogador utiliza o mouse para mirar e clicar na arena, **quando** o cursor passar sobre qualquer elemento do `HUD`, **então** todos os nós `Control`, `MarginContainer`, `TextureRect` e `Label` do HUD devem estar com `mouse_filter = Control.MOUSE_FILTER_IGNORE` para jamais interceptar cliques de tiro.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Inicialização estrutural de src/ui/HUD.gd
class_name GameHUD
extends CanvasLayer

@onready var root_margin: MarginContainer = $RootControl/SafeMarginContainer
@onready var hp_bar: TextureProgressBar = %HPProgressBar
@onready var atp_bar: TextureProgressBar = %ATPProgressBar
@onready var biomass_label: Label = %BiomassScoreLabel
@onready var receptors_box: HBoxContainer = %ReceptorsHBox
@onready var active_buffs_box: HBoxContainer = %ActiveBuffsHBox
@onready var hurt_vignette: TextureRect = $RootControl/HurtVignetteRect

func _ready() -> void:
	layer = 5
	_set_mouse_ignore_recursive($RootControl)

func _set_mouse_ignore_recursive(node: Node) -> void:
	if node is Control:
		(node as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in node.get_children():
		_set_mouse_ignore_recursive(child)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_INIT] GameHUD (CanvasLayer 5) initialized | Viewport: 1920x1080 | MouseFilter: IGNORE
```

**5. Componentes Envolvidos**
* `scenes/ui/HUD.tscn`.
* `src/ui/HUD.gd`.

**6. Considerações Técnicas e Arquitetura**
* Segue o Mockup Anotado da Tela de Jogo (Seção 3 do Mini GDD), posicionando os indicadores vitais nas margens com `MarginContainer` de `32 px` nas bordas externas.
* Utiliza `%UniqueNodeNames` (`Scene Unique Nodes`) na Godot 4 para evitar caminhos longos de `get_node` caso o layout interno de `HBoxContainer`/`VBoxContainer` seja refinado.

**7. Mockups ou Referências Visuais**
```plaintext
Layout 1920x1080 (scenes/ui/HUD.tscn):
+-----------------------------------------------------------------------+
| SCORE: 003492   [Y][Y][y] (Receptores)                                |
| HP:  [###|###|###|###|###]                                            |
| ATP: [===================]                                            |
|                                                                       |
|                     (Centro da Arena 100% Livre)                      |
|                                                                       |
|                        [Ícone Buff: 12.4s]                            |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #05 e Issue #08.
* **Bloqueia:** Issues #24, #25, #26 e #27.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Instanciar `HUD.tscn` junto com `Player.tscn` e caminhar pela fase.
2. Clicar diretamente em cima da barra de HP com o botão esquerdo do mouse e confirmar que o fagócito dispara normalmente naquela direção (`MOUSE_FILTER_IGNORE`).

**10. Definição de Pronto (Definition of Done - DoD)**
* Cena `HUD.tscn` estruturada com âncoras `PRESET_FULL_RECT`, margens de segurança de `32 px` e `MOUSE_FILTER_IGNORE` em todos os subnós.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `hud`, `canvaslayer`, `ui`, `layout-16-9`.

**13. Documentação Relacionada**
* Requisito RF11, RNF04.
* Seção 3 e Seção 7 do Mini GDD; Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #24: [Frontend] Implementação da Barra de Integridade Celular (`TextureProgressBar` de HP) via Sinal `player_health_changed`**

**1. História de Usuário (User Story)**
> **Como** jogador monitorando a sobrevivência do fagócito,
> **eu quero** que a Barra de Integridade Celular (`HPProgressBar`) atualize instantaneamente seu preenchimento vermelho vivo e exiba um efeito de transição suave ao sofrer dano, curar com glóbulos de ATP ou expandir em $+25\%$ com a Membrana Lipídica,
> **para que** eu tenha percepção exata da minha reserva vital a qualquer momento.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o `HUD.gd` se conecta ao sinal `GameState.player_health_changed(current_hp, max_hp)`, **quando** o sinal for emitido, **então** `hp_bar.max_value` deve ser ajustado para `max_hp` e `hp_bar.value` deve interpolar via `Tween` (`0.12s`) até `current_hp`.
* **Dado que** `current_hp` cai para $\le 25\%$ do `max_hp`, **quando** o jogador estiver em estado crítico, **então** o rótulo/moldura da barra de HP deve pulsar em alerta vermelho para avisar o risco iminente de lise celular.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Atualização reativa de HP em src/ui/HUD.gd
func _ready() -> void:
	GameState.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(current_hp: float, max_hp: float) -> void:
	hp_bar.max_value = max_hp
	var tween := create_tween()
	tween.tween_property(hp_bar, ^"value", current_hp, 0.12).set_trans(Tween.TRANS_SINE)
	%HPValueLabel.text = "%d / %d" % [ceili(current_hp), roundi(max_hp)]
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_HP] Signal received -> HP: 85 / 100 (Tweening value to 85.0 in 0.12s)
[HUD_HP] Lipid Membrane unlocked -> Max HP updated to 125 / 125
```

**5. Componentes Envolvidos**
* `src/ui/HUD.gd`.
* `scenes/ui/HUD.tscn` (`%HPProgressBar`, `%HPValueLabel`).
* Texturas `sprites/ui/hud_hp_*.png`.

**6. Considerações Técnicas e Arquitetura**
* O uso de `step = 0.1` no `TextureProgressBar` combinado com `create_tween()` garante transições fluidas mesmo quando a cura é fracionária ($10\%$ do HP máximo por glóbulo de ATP).

**7. Mockups ou Referências Visuais**
```plaintext
Estado Normal:  HP [############....] 80 / 100
Pós-Chefe 1:    HP [###############.] 125 / 125 (+25% Membrana Lipídica)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #08, Issue #20 e Issue #23.
* **Bloqueia:** Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Emitir `GameState.player_health_changed.emit(60.0, 100.0)` em cena de teste e verificar se a barra reduz até $60\%$.
2. Emitir `GameState.player_health_changed.emit(125.0, 125.0)` e confirmar que o texto e a escala máxima refletem o upgrade do Chefe 1.

**10. Definição de Pronto (Definition of Done - DoD)**
* Barra de HP conectada por sinal ao `GameState`, sem polling em `_process()`, com interpolação via `Tween`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `hud`, `health-bar`, `signals`, `tween`.

**13. Documentação Relacionada**
* Requisito RF11, RNF04.
* Seção 7 do Mini GDD e Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #25: [Frontend] Implementação do Medidor Dinâmico de ATP com Interpolação (`Tween`) e Alerta Visual de Energia Insuficiente**

**1. História de Usuário (User Story)**
> **Como** jogador utilizando o Dash Citoplasmático repetidamente,
> **eu quero** visualizar em tempo real o gasto de 25 unidades de ATP, a regeneração contínua de $15\text{ unidades/s}$ e um flash de alerta vermelho/amarelo na barra quando eu tentar dar dash com $\text{ATP} < 25$,
> **para que** eu compreenda imediatamente por que uma esquiva foi bloqueada por falta de energia metabólica.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `GameState.player_atp_changed(current_atp, max_atp)` é emitido, **quando** o `HUD.gd` receber o sinal, **então** `atp_bar.max_value` e `atp_bar.value` devem refletir a energia atual instantaneamente.
* **Dado que** `current_atp < 25.0`, **quando** a energia estiver abaixo do custo mínimo de 1 dash, **então** a tonalidade (`tint_progress`) da barra de ATP deve escurecer/mudar de ciano brilhante (`#00F5D4`) para azul opaco (`#3A506B`), sinalizando indisponibilidade de dash.
* **Dado que** o jogador tenta usar o dash sem ATP suficiente, **quando** o sinal `GameState.atp_insufficient_triggered` for emitido, **então** a barra de ATP deve piscar em vermelho/amarelo 2 vezes em `0.2s`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Controle visual da Barra de ATP em src/ui/HUD.gd
const COLOR_ATP_READY := Color("#00F5D4")
const COLOR_ATP_LOW := Color("#3A506B")
const COLOR_ATP_ALERT := Color("#FF0055")

func _on_player_atp_changed(current_atp: float, max_atp: float) -> void:
	atp_bar.max_value = max_atp
	atp_bar.value = current_atp
	atp_bar.tint_progress = COLOR_ATP_READY if current_atp >= 25.0 else COLOR_ATP_LOW

func _on_atp_insufficient_triggered() -> void:
	var tween := create_tween()
	tween.tween_property(atp_bar, ^"modulate", COLOR_ATP_ALERT, 0.06)
	tween.tween_property(atp_bar, ^"modulate", Color.WHITE, 0.06)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_ATP] Value: 15.0 / 100.0 (< 25.0) -> Tint changed to COLOR_ATP_LOW
[HUD_ATP] Insufficient ATP alert triggered -> Flashing bar modulate
```

**5. Componentes Envolvidos**
* `src/ui/HUD.gd`.
* `scenes/ui/HUD.tscn` (`%ATPProgressBar`).
* Texturas `sprites/ui/hud_atp_*.png`.

**6. Considerações Técnicas e Arquitetura**
* Cumpre o requisito de feedback visual imediato de recusa quando $\text{ATP} < 25$, especificado na Seção 4.1 (*Sistema de Esquiva / Dash Citoplasmático*) do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #08, Issue #18 e Issue #23.
* **Bloqueia:** Issue #40 e Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Executar 4 dashes seguidos para deixar o ATP abaixo de 25 e verificar a mudança de cor de ciano vivo para azul opaco.
2. Pressionar `Espaço` com $\text{ATP} = 10$ e confirmar o flash de recusa na barra de ATP.

**10. Definição de Pronto (Definition of Done - DoD)**
* Barra de ATP sincronizada com o jogador, mudando de cor quando $< 25$ e piscando ao recusar dash.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `hud`, `atp-bar`, `feedback`, `ui`.

**13. Documentação Relacionada**
* Requisitos RF05, RF06, RF11.
* Seção 4.1 e 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #26: [Frontend] Implementação do Contador de Biomassa (Score) e Painel dos 3 Slots de Receptores Moleculares**

**1. História de Usuário (User Story)**
> **Como** jogador explorando salas secundárias e eliminando hordas de patógenos,
> **eu quero** visualizar meu Score de Biomassa formatado com 6 dígitos e os 3 slots de Receptores Moleculares (que acendem em amarelo fosforescente ao coletar chaves biológicas),
> **para que** eu acompanhe minha pontuação de purificação e saiba quantas portas de membrana trancadas posso abrir.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `GameState.biomass_changed(new_score)` é emitido, **quando** o `HUD.gd` atualizar o `BiomassScoreLabel`, **então** deve formatar o texto como `"SCORE: %06d" % new_score` e executar um leve pulso de escala (`scale` `1.15 -> 1.0`) para dar feedback de pontuação.
* **Dado que** o painel `ReceptorsHBox` contém 3 nós `TextureRect`, **quando** o sinal `GameState.receptors_changed(count)` for emitido (com `count` de `0` a `3`), **então** os primeiros `count` ícones devem exibir `receptor_slot_filled.png` (amarelo fosforescente) e os demais `receptor_slot_empty.png`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Atualização de Biomassa e Receptores Moleculares em src/ui/HUD.gd
@export var receptor_empty_tex: Texture2D
@export var receptor_filled_tex: Texture2D

func _on_biomass_changed(new_score: int) -> void:
	biomass_label.text = "SCORE: %06d" % new_score

func _on_receptors_changed(count: int) -> void:
	var slots := receptors_box.get_children()
	for i in range(slots.size()):
		var slot_rect := slots[i] as TextureRect
		slot_rect.texture = receptor_filled_tex if i < count else receptor_empty_tex
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_SCORE] Biomass updated -> SCORE: 003492
[HUD_KEYS] Molecular Receptors updated -> 2/3 slots filled (Phosphorescent Yellow)
```

**5. Componentes Envolvidos**
* `src/ui/HUD.gd`.
* `scenes/ui/HUD.tscn` (`%BiomassScoreLabel`, `%ReceptorsHBox`).
* `sprites/ui/receptor_slot_empty.png`, `sprites/ui/receptor_slot_filled.png`.

**6. Considerações Técnicas e Arquitetura**
* Segue exatamente a especificação dos itens 3 e 4 da Seção 4.2 (*Interface do Usuário - HUD.tscn*) do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e o Mockup da Página 5 do Mini GDD (`SCORE: 3492` + 3 ícones de chave ao lado).

**7. Mockups ou Referências Visuais**
```plaintext
Estado 0 chaves:  SCORE: 000150   [o] [o] [o]  (Cinza Vazado)
Estado 2 chaves:  SCORE: 003492   [*] [*] [o]  (* = Amarelo Fosforescente #FEE440)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #08 e Issue #23.
* **Bloqueia:** Issue #33 e Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Chamar `GameState.add_biomass(3492)` e verificar se o rótulo exibe `SCORE: 003492`.
2. Emitir `GameState.receptors_changed.emit(2)` e confirmar que exatamente os 2 primeiros ícones acendem em amarelo fosforescente; em seguida emitir `0` e confirmar que todos apagam.

**10. Definição de Pronto (Definition of Done - DoD)**
* Contador de Biomassa e painel de 3 Receptores Moleculares funcionais e orientados a sinais no `HUD.tscn`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `hud`, `score`, `keys`, `ui`.

**13. Documentação Relacionada**
* Requisito RF11.
* Seção 3 e Seção 7 do Mini GDD; Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #27: [Frontend] Implementação do Mostrador de Buffs Temporários (`15.0s` a `0.0s`) e Efeito de *Hurt Vignette***

**1. História de Usuário (User Story)**
> **Como** jogador coletando power-ups temporários de 15 segundos ou recebendo dano de patógenos,
> **eu quero** um mostrador no centro inferior do HUD que exiba o ícone e a contagem regressiva (`15.0s` a `0.0s`) de cada buff ativo, além de uma vinheta periférica avermelhada (*Hurt Vignette*) que pisque suavemente ao sofrer dano,
> **para que** eu saiba exatamente quantos segundos restam dos meus tiros especiais e receba feedback sensorial imediato quando for atingido.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador coleta *Damage Shot*, *Spread Shot* ou *Rapid Shot*, **quando** o sinal `GameState.temporary_buff_updated(buff_id, time_left)` for emitido, **então** o mostrador no centro inferior do HUD deve exibir o ícone correspondente (`32x32 px`) e o tempo restante formatado como `"%.1fs" % time_left` (ou barra de progresso regressiva de 15 a 0), ocultando o slot assim que `time_left <= 0.0`.
* **Dado que** o jogador sofre dano (`current_hp` diminui), **quando** `HurtVignetteRect` for acionado, **então** sua opacidade (`modulate.a`) deve saltar para `0.75` e decair suavemente até `0.0` em `0.35s` via `Tween`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Mostrador de Buffs Temporários e Hurt Vignette em src/ui/HUD.gd
func trigger_hurt_vignette() -> void:
	hurt_vignette.modulate.a = 0.75
	var tween := create_tween()
	tween.tween_property(hurt_vignette, ^"modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_QUAD)

func _on_temporary_buff_updated(buff_type: StringName, time_left: float) -> void:
	var slot: Control = active_buffs_box.get_node_or_null(NodePath(buff_type))
	if slot == null:
		return
	slot.visible = time_left > 0.0
	if slot.visible:
		(slot.get_node("TimerLabel") as Label).text = "%.1fs" % time_left
		(slot.get_node("DurationBar") as ProgressBar).value = time_left
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[HUD_BUFF] Buff 'spread_shot' active -> Showing icon + timer: 14.9s / 15.0s
[HUD_VIGNETTE] Player damaged -> HurtVignetteRect alpha tweened 0.75 -> 0.0 (0.35s)
[HUD_BUFF] Buff 'spread_shot' expired (0.0s) -> Slot hidden
```

**5. Componentes Envolvidos**
* `src/ui/HUD.gd`.
* `scenes/ui/HUD.tscn` (`%ActiveBuffsHBox`, `HurtVignetteRect`).
* `sprites/ui/hurt_vignette.png` e `sprites/ui/icons/icon_buff_*.png`.

**6. Considerações Técnicas e Arquitetura**
* Como os 3 power-ups temporários são cumulativos (Seção 5.4 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`), usar um `HBoxContainer` centralizado na borda inferior com 3 sub-slots pré-alocados (`damage_shot`, `spread_shot`, `rapid_shot`) evita instanciar/destruir nós de UI em tempo de combate e permite exibir 1, 2 ou os 3 buffs simultaneamente lado a lado.

**7. Mockups ou Referências Visuais**
```plaintext
Centro Inferior da Tela (Quando 2 Power-Ups estão ativos simultaneamente):
          +-----------------------+   +-----------------------+
          | [Ícone 3x]  11.4s     |   | [Ícone Leque]  06.2s  |
          | [=============......] |   | [=======............] |
          +-----------------------+   +-----------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #09, Issue #10, Issue #16, Issue #22 e Issue #23.
* **Bloqueia:** Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Ativar os 3 power-ups no jogador e verificar se os 3 cards aparecem alinhados no centro inferior do HUD contando de `15.0s` até `0.0s`.
2. Causar dano ao jogador e verificar o pulso periférico vermelho (`Hurt Vignette`) sincronizado com o *Screen Shake* da câmera.

**10. Definição de Pronto (Definition of Done - DoD)**
* Mostrador cumulativo de buffs de 15s e *Hurt Vignette* implementados e testados no `HUD.tscn`.

**11. Prioridade e Severidade**
* **Prioridade:** Média.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `hud`, `power-ups`, `vignette`, `vfx`.

**13. Documentação Relacionada**
* Requisitos RF08, RF11, RF12.
* Seção 7 e Seção 8 do Mini GDD; Seção 4.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

# 🎬 Grupo 5: Fluxo de Telas, Menus e Máquina de Estados de Navegação

### **Issue #28: [Frontend] Implementação da `SplashScreen.tscn` (Exibição Institucional Obrigatória do Logo UTFPR por `2.0s` com Fade)**

**1. História de Usuário (User Story)**
> **Como** avaliador da disciplina OPT010 iniciando o jogo,
> **eu quero** que a primeira tela carregada pelo executável/Web seja a `SplashScreen.tscn` exibindo o logotipo oficial da UTFPR centralizado em fundo limpo por $2.0\text{ segundos}$ com transição suave de Fade In e Fade Out para o Menu Principal,
> **para que** o projeto cumpra rigorosamente o primeiro requisito de fluxo de telas da disciplina.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogo é iniciado, **quando** `run/main_scene` for carregada a partir do `project.godot`, **então** deve abrir `scenes/ui/SplashScreen.tscn` no estado `GameState.MatchState.SPLASH`.
* **Dado que** a `SplashScreen.tscn` inicia, **quando** rodar a sequência de abertura, **então** deve executar Fade In (`0.5s`), manter o logotipo `sprites/logo_utfpr.png` visível por `2.0s` e executar Fade Out (`0.5s`), carregando automaticamente `scenes/ui/MainMenu.tscn`.
* **Dado que** o jogador está reabrindo o jogo para testes rápidos, **quando** pressionar qualquer botão de confirmação (`ui_accept`, `Espaço`, `Enter`, clique ou botão `A`/`Start` do controle) durante a splash, **então** deve permitir pular imediatamente para o `MainMenu.tscn`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/SplashScreen.gd
extends Control

const DISPLAY_TIME: float = 2.0
const FADE_TIME: float = 0.5
var _transitioning: bool = false

@onready var logo_rect: TextureRect = $CenterContainer/UTFPRLogoRect

func _ready() -> void:
	GameState.current_state = GameState.MatchState.SPLASH
	logo_rect.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(logo_rect, ^"modulate:a", 1.0, FADE_TIME)
	tween.tween_interval(DISPLAY_TIME)
	tween.tween_property(logo_rect, ^"modulate:a", 0.0, FADE_TIME)
	tween.tween_callback(_go_to_main_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept") or event.is_action_pressed(&"pause"):
		_go_to_main_menu()

func _go_to_main_menu() -> void:
	if _transitioning:
		return
	_transitioning = true
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[STATE]SPLASH -> Exibindo Logotipo Institucional UTFPR (2.0s + Fade 0.5s)
[SCENE_CHANGE] SplashScreen.tscn -> MainMenu.tscn
```

**5. Componentes Envolvidos**
* `scenes/ui/SplashScreen.tscn`.
* `src/ui/SplashScreen.gd`.
* `sprites/logo_utfpr.png`.
* `project.godot` (`run/main_scene="res://scenes/ui/SplashScreen.tscn"`).

**6. Considerações Técnicas e Arquitetura**
* Atende diretamente ao Slide 12 de `Projeto_disciplina_2026_1.0.pdf` (*Tela de logo da UTFPR (tela inicial) com efeito de transição entre telas: Fade*) e à Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**7. Mockups ou Referências Visuais**
```plaintext
+-------------------------------------------------------+
|                                                       |
|                    [ LOGO UTFPR ]                     |
|      Universidade Tecnológica Federal do Paraná       |
|              OPT010 — Desenvolvimento de Jogos        |
|                                                       |
+-------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #05 e Issue #10.
* **Bloqueia:** Issue #29 e Issue #36.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Pressionar `F5` na Godot 4 e cronometrar a abertura com Fade In (`0.5s`), permanência (`2.0s`) e Fade Out (`0.5s`) até o Menu Principal.
2. Rodar novamente com `F5` e pressionar `Enter` ou Botão `A` do Gamepad aos `0.8s`, verificando o avanço imediato sem erros de referência nula.

**10. Definição de Pronto (Definition of Done - DoD)**
* `SplashScreen.tscn` definida como cena principal do projeto, exibindo o logo da UTFPR com Fade e transicionando para `MainMenu.tscn`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta (Item obrigatório de avaliação no PDF da disciplina).

**12. Etiquetas (Labels)**
`frontend`, `splash-screen`, `utfpr`, `ui-flow`, `tween`.

**13. Documentação Relacionada**
* Requisito RF13.
* Seção 14 do Mini GDD, Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 1

---

### **Issue #29: [Frontend] Refatoração e Estilização da `MainMenu.tscn` (Logo, Reforço UTFPR, Autores e Navegação por Foco de Gamepad)**

**1. História de Usuário (User Story)**
> **Como** jogador ou avaliador na tela de título de *PhagoCrisis*,
> **eu quero** visualizar o logotipo do jogo, o reforço do logo da UTFPR, a data/semestre (`2026/2`), a lista dos 3 autores e os botões funcionais (*Iniciar Jogo*, *Instruções*, *Créditos* e *Sair*), com foco inicial automático para navegação via Gamepad ou Teclado,
> **para que** todos os metadados acadêmicos exigidos estejam visíveis e o menu funcione perfeitamente sem depender do mouse.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `MainMenu.tscn` é aberta, **quando** renderizada em tela, **então** deve exibir:
  1. Logotipo estilizado de *PhagoCrisis*;
  2. Reforço do logotipo da UTFPR (`sprites/logo_utfpr.png`);
  3. Identificação da disciplina (`OPT010 — Desenvolvimento de Jogos — 2026/2`) e lista de autores (`Victor Angelo Souza Santos, Lucas Silva Guedin, Lucas Antonio Marcão`);
  4. Botões: *Iniciar Jogo*, *Instruções*, *Créditos* e *Sair*.
* **Dado que** o jogo deve suportar Gamepad em 100% das telas, **quando** `MainMenu.tscn` entrar na árvore (`_ready()`), **então** o botão `PlayButton` (*Iniciar Jogo*) deve invocar `grab_focus()` automaticamente para permitir navegação imediata pelo D-Pad/Analógico.
* **Dado que** na versão Web (HTML5) o navegador não permite fechar a aba via `get_tree().quit()`, **quando** `OS.has_feature("web")` for `true`, **então** o botão *Sair* (`ExitButton`) deve ser ocultado (`visible = false`).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/MainMenu.gd
extends Control

@onready var play_btn: Button = %PlayButton
@onready var instructions_btn: Button = %InstructionsButton
@onready var credits_btn: Button = %CreditsButton
@onready var exit_btn: Button = %ExitButton

func _ready() -> void:
	GameState.current_state = GameState.MatchState.MAIN_MENU
	get_tree().paused = false
	if OS.has_feature("web"):
		exit_btn.visible = false
	play_btn.grab_focus()
	
	play_btn.pressed.connect(_on_play_pressed)
	instructions_btn.pressed.connect(_on_instructions_pressed)
	credits_btn.pressed.connect(_on_credits_pressed)
	exit_btn.pressed.connect(func(): get_tree().quit())

func _on_play_pressed() -> void:
	GameState.reset_run_state()
	TransitionLayer.change_scene("res://scenes/levels/Level1.tscn")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[MAIN_MENU] Loaded | Focus grabbed by: PlayButton | Web build check: Desktop (ExitButton visible)
[MAIN_MENU] 'Iniciar Jogo' acionado -> GameState reset -> Loading Level1.tscn
```

**5. Componentes Envolvidos**
* `scenes/ui/MainMenu.tscn` (evolução e padronização de `scenes/main_menu.tscn`).
* `src/ui/MainMenu.gd` (unificando `src/menu/play_button.gd` e `src/menu/exit_button.gd`).

**6. Considerações Técnicas e Arquitetura**
* Cumpre integralmente o Slide 12 de `Projeto_disciplina_2026_1.0.pdf`:
  - *Tela título do jogo: Reforço do logo da UTFPR + Data e lista de autores*.
* Ocultar o botão *Sair* na Web (`OS.has_feature("web")`) segue a especificação da Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e evita que o jogador clique em um botão que trava o canvas WebAssembly no Itch.io.

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
| [Logo UTFPR]                                       OPT010 — 2026/2    |
|                                                                       |
|                        === PHAGOCRISIS ===                            |
|                  Twin-Stick Biopunk Action Roguelite                  |
|                                                                       |
|                         [ > INICIAR JOGO < ]                          |
|                         [    INSTRUÇÕES    ]                          |
|                         [     CRÉDITOS     ]                          |
|                         [       SAIR       ]                          |
|                                                                       |
|  Autores: Victor Angelo S. Santos | Lucas S. Guedin | Lucas A. Marcão |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #04, Issue #05, Issue #10 e Issue #28.
* **Bloqueia:** Issue #30, Issue #31, Issue #32, Issue #34 e Issue #35.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir `MainMenu.tscn` e usar apenas as setas do teclado ou o D-Pad do controle para percorrer os 4 botões de cima a baixo (validando vizinhança de foco circular).
2. Verificar a presença visual do logo da UTFPR, data `2026/2` e nomes completos dos 3 integrantes.

**10. Definição de Pronto (Definition of Done - DoD)**
* `MainMenu.tscn` completo com logo, reforço UTFPR, autores, data, 4 botões estilizados e suporte total a foco por Gamepad.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`frontend`, `main-menu`, `ui`, `gamepad-focus`, `utfpr`.

**13. Documentação Relacionada**
* Requisitos RF02, RF13.
* Seção 14 do Mini GDD, Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #30: [Frontend] Implementação da `InstructionsScreen.tscn` (Esquema Visual Dual Teclado/Mouse + Gamepad e Core Loop)**

**1. História de Usuário (User Story)**
> **Como** novo jogador acessando a tela de *Instruções* pelo Menu Principal ou pelo Menu de Pausa,
> **eu quero** visualizar de forma gráfica e objetiva o mapeamento dual de comandos (Teclado+Mouse e Gamepad), o funcionamento do ATP/Dash, a Fagocitose e os objetivos de purificação celular,
> **para que** eu domine imediatamente as mecânicas sem precisar ler manuais externos.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador clica em *Instruções* no `MainMenu` ou no `PauseOverlay`, **quando** `InstructionsScreen.tscn` for exibida, **então** deve apresentar duas colunas comparativas claras (*Teclado & Mouse* vs *Gamepad / Joystick*) para Movimentação, Mira 360°, Disparo Enzimático, Esquiva (Dash), Interação e Pausa, além do resumo visual de itens (Glóbulo de ATP, Receptor Molecular e Vacúolos).
* **Dado que** o jogador deseja retornar à tela anterior, **quando** acionar o botão *Voltar* ou a tecla `ESC` / botão `B` (Leste) do controle (`ui_cancel`), **então** a tela de instruções deve fechar e devolver o foco para o botão de origem.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/InstructionsScreen.gd
extends Control

signal closed

@onready var back_btn: Button = %BackButton

func _ready() -> void:
	back_btn.grab_focus()
	back_btn.pressed.connect(_close_screen)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_viewport().set_input_as_handled()
		_close_screen()

func _close_screen() -> void:
	closed.emit()
	if get_tree().current_scene == self:
		TransitionLayer.change_scene("res://scenes/ui/MainMenu.tscn")
	else:
		queue_free()
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[INSTRUCTIONS] Screen opened -> Focus on BackButton
[INSTRUCTIONS] 'ui_cancel' / BackButton pressed -> Returning to caller screen
```

**5. Componentes Envolvidos**
* `scenes/ui/InstructionsScreen.tscn`.
* `src/ui/InstructionsScreen.gd`.

**6. Considerações Técnicas e Arquitetura**
* Projetar `InstructionsScreen.tscn` para funcionar tanto como cena autônoma quanto como modal instanciado dentro do `PauseOverlay.tscn` (`process_mode = Node.PROCESS_MODE_ALWAYS`) permite que o jogador consulte os comandos no meio da partida sem perder o progresso da fase!

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
|                       COMO JOGAR — PHAGOCRISIS                        |
+-----------------------------------+-----------------------------------+
|         TECLADO & MOUSE           |         GAMEPAD / JOYSTICK        |
|  [W,A,S,D] : Movimentação 8-Dir   |  [Stick Esq.] : Movimentação 360° |
|  [Mouse]   : Mira Contínua 360°   |  [Stick Dir.] : Mira Angular 360° |
|  [LMB]     : Disparo Enzimático   |  [RT / R2]    : Disparo Enzimático|
|  [Espaço]  : Esquiva / Dash (ATP) |  [LT / L2 / A]: Esquiva / Dash    |
|  [ESC / P] : Menu de Pausa        |  [Start]      : Menu de Pausa     |
+-----------------------------------+-----------------------------------+
|  OBJETIVO: Elimine os ninhos patogênicos, absorva ATP por fagocitose  |
|  para curar HP e recarregar o Dash, e derrote o Patógeno Alfa!        |
|                              [ VOLTAR ]                               |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #04, Issue #10 e Issue #29.
* **Bloqueia:** Issue #32.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir *Instruções* a partir do Menu Principal e verificar se todos os comandos batem com a Seção 4 do Mini GDD.
2. Pressionar `ESC` ou Botão `B` no controle e confirmar o retorno imediato ao Menu Principal.

**10. Definição de Pronto (Definition of Done - DoD)**
* `InstructionsScreen.tscn` implementada, reutilizável no Menu Principal e na Pausa, com suporte a `ui_cancel`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`frontend`, `instructions`, `ui`, `controls`, `tutorial`.

**13. Documentação Relacionada**
* Requisitos RF02, RF13.
* Seção 4 e Seção 14 do Mini GDD; Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #31: [Frontend] Implementação da `CreditsScreen.tscn` (Divisão Formal da Equipe, Atribuições e Referências de Áudio)**

**1. História de Usuário (User Story)**
> **Como** professor avaliador da disciplina OPT010 verificando a autoria do trabalho,
> **eu quero** uma `CreditsScreen.tscn` detalhando exatamente o que cada integrante fez (Arte, Código, Design do Jogo) e listando todas as referências e licenças das músicas e efeitos sonoros utilizados,
> **para que** a avaliação 50% geral / 50% individual e os direitos autorais de áudio sejam comprovados dentro do próprio jogo.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o Slide 12 de `Projeto_disciplina_2026_1.0.pdf` exige uma Tela de Créditos específica, **quando** o usuário abrir `scenes/ui/CreditsScreen.tscn`, **então** a tela deve apresentar claramente:
  1. **Victor Angelo Souza Santos (Programador A — Jogador e UI):** Cinemática/física do player, controles duais, mira 360°, dash, fagocitose, HUD, fluxo de telas, sprites de UI/player, SFX do jogador e builds PC/Web.
  2. **Lucas Silva Guedin (Programador B — Mundo e Entidades):** `GameManager`, IA polimórfica dos 15 patógenos e 5 chefes, spawners, portas, power-ups, músicas/sons do mundo e textos do Itch.io.
  3. **Lucas Antonio Marcão (Artista Técnico — Arte e Level Design):** Direção de arte Pixel Art 16-bit, TileSets vasculares, animações de inimigos/chefes, Level Design das 5 fases, iluminação/partículas de ambiente e arte da página Itch.io.
  4. **Referências de Músicas e Efeitos Sonoros:** Fontes e ferramentas (`sfxr.me`, `BeepBox`, `Freesound.org`, `Pixabay` / licenças CC0) e menção institucional à **UTFPR — Câmpus Campo Mourão (Prof. Marcos Silvano Almeida)**.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/CreditsScreen.gd
extends Control

@onready var back_btn: Button = %BackButton

func _ready() -> void:
	back_btn.grab_focus()
	back_btn.pressed.connect(_return_to_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		_return_to_menu()

func _return_to_menu() -> void:
	TransitionLayer.change_scene("res://scenes/ui/MainMenu.tscn")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[CREDITS] Exibindo atribuições individuais (Programador A, Programador B, Artista Técnico) e referências de áudio.
```

**5. Componentes Envolvidos**
* `scenes/ui/CreditsScreen.tscn`.
* `src/ui/CreditsScreen.gd`.

**6. Considerações Técnicas e Arquitetura**
* Cumpre literalmente os três tópicos exigidos no Slide 12 de `Projeto_disciplina_2026_1.0.pdf` para a **Tela de Créditos**:
  - *O que cada pessoa fez?*
  - *Arte, código, design do jogo*
  - *Músicas e efeitos (colocar referências)*

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
|                        CRÉDITOS — PHAGOCRISIS                         |
+-----------------------------------------------------------------------+
|  [PROGRAMADOR A: JOGADOR, UI E COMPILAÇÃO]                            |
|  Victor Angelo Souza Santos — Física do Fagócito, Inputs, HUD,        |
|  Fluxo de Telas, Sprites do Jogador/UI, SFX do Player e Builds PC/Web |
|                                                                       |
|  [PROGRAMADOR B: MUNDO, ENTIDADES E IA]                               |
|  Lucas Silva Guedin — GameManager, Spawners, IA dos Patógenos/Chefes, |
|  Sistema de Power-ups, Trilhas Sonoras e Página Itch.io               |
|                                                                       |
|  [ARTISTA TÉCNICO: ARTE GRÁFICA E LEVEL DESIGN]                       |
|  Lucas Antonio Marcão — Spritesheets de Inimigos/Cenários, TileSets,  |
|  Level Design das 5 Fases, Iluminação 2D e Kit Visual Itch.io         |
|                                                                       |
|  [SONOPLASTIA E REFERÊNCIAS DE ÁUDIO]                                 |
|  SFX Sintetizados: sfxr.me / Audacity | BGM: BeepBox / Pixabay (CC0)  |
|  UTFPR Câmpus Campo Mourão — OPT010 (Prof. Marcos Silvano Almeida)    |
|                              [ VOLTAR ]                               |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #10 e Issue #29.
* **Bloqueia:** Issue #35 e Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Clicar no botão *Créditos* no Menu Principal e verificar a legibilidade de todas as seções e referências.
2. Retornar ao Menu Principal via botão *Voltar* ou tecla `ESC`/Gamepad `B`.

**10. Definição de Pronto (Definition of Done - DoD)**
* `CreditsScreen.tscn` completa com papéis individuais, créditos de código/arte/design e referências completas de áudio.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta (Item obrigatório do Slide 12 do PDF da disciplina).

**12. Etiquetas (Labels)**
`frontend`, `credits`, `ui`, `documentation`, `utfpr`.

**13. Documentação Relacionada**
* Requisitos RF13, RNF08.
* Seção 16 do Mini GDD e Slide 6 / Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #32: [Frontend] Refatoração da `PauseOverlay.tscn` (`PROCESS_MODE_WHEN_PAUSED`, Retomar, Instruções e Menu Principal)**

**1. História de Usuário (User Story)**
> **Como** jogador em meio a uma batalha intensa,
> **eu quero** pausar e despausar a partida a qualquer instante pressionando `ESC` (ou `Start` no Gamepad), congelando toda a física de projéteis e patógenos e abrindo o `PauseOverlay.tscn` com as opções *Retomar*, *Instruções* e *Voltar ao Menu Principal*,
> **para que** eu possa interromper a sessão com segurança sem criar instâncias duplicadas do menu de pausa.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogo está no estado `IN_GAME`, **quando** o jogador pressionar a ação `pause` (`ESC`, `P` ou `Start`), **então** `get_tree().paused` deve mudar para `true`, o `PauseOverlay.tscn` (`process_mode = Node.PROCESS_MODE_WHEN_PAUSED`) deve tornar-se visível e o botão *Retomar* deve receber foco automático (`grab_focus()`).
* **Dado que** o `PauseOverlay` já está aberto, **quando** o jogador pressionar `pause` ou `ui_cancel` novamente, **então** o jogo deve retomar (`get_tree().paused = false`) sem instanciar um segundo menu de pausa sobreposto.
* **Dado que** o jogador seleciona *Instruções* dentro da pausa, **quando** a sub-tela `InstructionsScreen.tscn` abrir e fechar, **então** o jogo deve continuar pausado e devolver o foco para o `PauseOverlay`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/PauseOverlay.gd (Refatoração de src/menu/pause_menu.gd)
extends CanvasLayer

@onready var root_panel: Control = $RootControl
@onready var resume_btn: Button = %ResumeButton
@onready var instructions_btn: Button = %InstructionsButton
@onready var main_menu_btn: Button = %MainMenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	root_panel.visible = false
	resume_btn.pressed.connect(toggle_pause)
	instructions_btn.pressed.connect(_on_instructions_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if GameState.current_state in [GameState.MatchState.IN_GAME, GameState.MatchState.PAUSED]:
			get_viewport().set_input_as_handled()
			toggle_pause()

func toggle_pause() -> void:
	var will_pause: bool = not get_tree().paused
	get_tree().paused = will_pause
	root_panel.visible = will_pause
	GameState.current_state = GameState.MatchState.PAUSED if will_pause else GameState.MatchState.IN_GAME
	if will_pause:
		resume_btn.grab_focus()
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PAUSE] Action 'pause' detected -> SceneTree paused = TRUE | State: PAUSED
[PAUSE] ResumeButton pressed -> SceneTree paused = FALSE | State: IN_GAME
```

**5. Componentes Envolvidos**
* `scenes/ui/PauseOverlay.tscn`.
* `src/ui/PauseOverlay.gd` (substituindo `src/menu/pause_menu.gd` e removendo a lógica de instanciação dinâmica `abrir_menu_pausa()` de dentro de `src/Player.gd`).

**6. Considerações Técnicas e Arquitetura**
* No código antigo (`src/Player.gd`, linhas 44–65), cada pressão da tecla `P` criava um `CanvasLayer.new()` adicional sem verificar se já estava pausado. Centralizar o `PauseOverlay.tscn` com `visible = true/false` e `PROCESS_MODE_ALWAYS` corrige esse bug arquitetural e desacopla o menu de pausa do script de física do jogador.

**7. Mockups ou Referências Visuais**
```plaintext
+-------------------------------------------------------+
|          (Gameplay congelado ao fundo - 50% escuro)   |
|               +-----------------------+               |
|               |    JOGO EM PAUSA      |               |
|               |  [ > RETOMAR JOGO < ] |               |
|               |  [    INSTRUÇÕES    ] |               |
|               |  [  MENU PRINCIPAL  ] |               |
|               +-----------------------+               |
+-------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #04, Issue #05, Issue #29 e Issue #30.
* **Bloqueia:** Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Disparar vários projéteis na arena e pressionar `ESC`: verificar que os projéteis e inimigos congelam instantaneamente no ar.
2. Pressionar `ESC` 10 vezes seguidas rapidamente e confirmar que o jogo alterna limpamente entre pausado e ativo sem criar nós órfãos.
3. Clicar em *Menu Principal* com o jogo pausado e verificar que `get_tree().paused` é restaurado para `false` antes de carregar `MainMenu.tscn`.

**10. Definição de Pronto (Definition of Done - DoD)**
* `PauseOverlay.tscn` funcional via Teclado (`ESC`) e Gamepad (`Start`), com opções *Retomar*, *Instruções* e *Menu Principal*.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `pause-menu`, `ui`, `process-mode`, `state-machine`.

**13. Documentação Relacionada**
* Requisito RF13.
* Seção 14 do Mini GDD e Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #33: [Frontend] Implementação da `LevelClearScreen.tscn` ("Tecido Purificado", Resumo da Fase e Adaptação Conquistada)**

**1. História de Usuário (User Story)**
> **Como** jogador derrotando o patógeno alfa (Chefe) das Fases 1 a 4,
> **eu quero** visualizar a tela de transição `LevelClearScreen.tscn` com o título *"TECIDO PURIFICADO (LEVEL CLEAR)"*, o resumo de biomassa acumulada, o tempo decorrido e o card detalhado da nova Adaptação Mitótica permanente desbloqueada,
> **para que** eu sinta a progressão clara entre os biomas e compreenda o novo bônus permanente antes de ingressar no próximo tecido.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o chefe das Fases 1, 2, 3 ou 4 é derrotado, **quando** `LevelClearScreen.tscn` for aberta, **então** deve exibir a mensagem obrigatória de fim de nível (*"TECIDO PURIFICADO — LEVEL CLEAR"*), o índice do tecido concluído, o score atual de biomassa e o tempo parcial da run.
* **Dado que** cada um dos 4 primeiros chefes concede um upgrade específico, **quando** a tela renderizar o card de recompensa, **então** deve mostrar o ícone (`32x32 px`), o nome e a descrição exata da Adaptação Mitótica desbloqueada naquela fase:
  - Fase 1 $\rightarrow$ *Membrana Lipídica Reforçada (+25% HP Máximo)*;
  - Fase 2 $\rightarrow$ *Mitocôndria Supercarregada (+30% Regeneração de ATP)*;
  - Fase 3 $\rightarrow$ *Pseudópodes Fortalecidos (+15% Velocidade e Imunidade a Muco)*;
  - Fase 4 $\rightarrow$ *Glândula Digestiva Avançada (+20% Dano Base Permanente)*.
* **Dado que** o jogador clica no botão *Avançar para o Próximo Tecido* (focado automaticamente), **quando** acionado, **então** `GameState.current_level` deve incrementar (`+1`) e carregar a cena do próximo bioma.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/LevelClearScreen.gd
extends Control

const ADAPTATION_INFO: Dictionary = {
	1: { &"id": &"lipid_membrane", &"title": "Membrana Lipídica Reforçada", &"desc": "+25% de Integridade Celular (HP Máximo) permanente." },
	2: { &"id": &"super_mitochondria", &"title": "Mitocôndria Supercarregada", &"desc": "+30% na taxa de regeneração passiva de ATP." },
	3: { &"id": &"strong_pseudopods", &"title": "Pseudópodes Fortalecidos", &"desc": "+15% de velocidade base e imunidade total ao Muco Viscoso." },
	4: { &"id": &"digestive_gland", &"title": "Glândula Digestiva Avançada", &"desc": "+20% de dano base permanente nos disparos enzimáticos." }
}

func setup_level_clear(completed_level: int) -> void:
	var info: Dictionary = ADAPTATION_INFO.get(completed_level, {})
	if not info.is_empty():
		GameState.active_adaptations[info[&"id"]] = true
		%AdaptationTitleLabel.text = info[&"title"]
		%AdaptationDescLabel.text = info[&"desc"]
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[LEVEL_CLEAR] Fase 1 concluída! Biomassa: 001850 | Tempo: 02:14
[UNLOCK] Adaptação Mitótica ativada: lipid_membrane (Membrana Lipídica Reforçada)
[NEXT_LEVEL] Carregando Fase 2 (Tecido Sanguíneo / Colônia Bacteriana)...
```

**5. Componentes Envolvidos**
* `scenes/ui/LevelClearScreen.tscn`.
* `src/ui/LevelClearScreen.gd`.
* `sprites/ui/icons/icon_adapt_*.png`.

**6. Considerações Técnicas e Arquitetura**
* Atende ao requisito explícito do Slide 12 de `Projeto_disciplina_2026_1.0.pdf` (*Tela ou mensagem de fim de level: "Level clear"*) e à Seção 4.3, 5.4 e Seção 13/14 do Mini GDD.

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
|                   TECIDO PURIFICADO — LEVEL CLEAR!                    |
|                Fase 1: Tecido Linfático Desobstruído                  |
|                                                                       |
|          Biomassa Colhida: 001850    |    Tempo: 02m 14s              |
|                                                                       |
|       +-------------------------------------------------------+       |
|       |  [Ícone]  NOVA ADAPTAÇÃO MITÓTICA CONQUISTADA:        |       |
|       |           MEMBRANA LIPÍDICA REFORÇADA                 |       |
|       |           +25% de HP Máximo permanente!               |       |
|       +-------------------------------------------------------+       |
|                                                                       |
|                   [ > AVANÇAR AO PRÓXIMO TECIDO < ]                   |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #09, Issue #21 e Issue #26.
* **Bloqueia:** Issue #36.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Invocar `setup_level_clear(1)` a `setup_level_clear(4)` em sequência e validar os títulos, ícones e descrições das 4 adaptações.
2. Confirmar que ao avançar para a próxima fase o `Player` já inicia com o atributo evoluído ativo.

**10. Definição de Pronto (Definition of Done - DoD)**
* `LevelClearScreen.tscn` implementada com resumo de fase, exibição da Adaptação Mitótica e transição para o próximo nível.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `level-clear`, `progression`, `ui`, `upgrades`.

**13. Documentação Relacionada**
* Requisitos RF09, RF13.
* Seção 13 e Seção 14 do Mini GDD; Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`; Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #34: [Frontend] Implementação da `GameOverScreen.tscn` ("Falência Imunológica", Tentar Novamente e Menu Principal)**

**1. História de Usuário (User Story)**
> **Como** jogador cujo fagócito teve a integridade celular reduzida a zero,
> **eu quero** que a tela `GameOverScreen.tscn` seja apresentada com o alerta *"FALÊNCIA IMUNOLÓGICA — GAME OVER"*, exibindo minha pontuação até o momento e oferecendo os botões *Tentar Novamente* (reiniciando o tecido atual) e *Menu Principal*,
> **para que** eu possa retomar o desafio imediatamente sem frustração ou retornar ao menu inicial.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o HP do jogador chega a `0`, **quando** a animação de lise celular terminar, **então** `scenes/ui/GameOverScreen.tscn` deve ser carregada no estado `GameState.MatchState.GAME_OVER`, dando foco automático ao botão *Tentar Novamente*.
* **Dado que** o jogador aciona *Tentar Novamente* (`RetryButton`), **quando** o comando for processado, **então** deve recarregar a cena do tecido atual (`GameState.current_level`), restaurando o HP e ATP do fagócito a $100\%$ e mantendo as Adaptações Mitóticas já conquistadas em fases anteriores.
* **Dado que** o jogador aciona *Menu Principal*, **quando** confirmado, **então** deve transicionar para `MainMenu.tscn`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/GameOverScreen.gd
extends Control

@onready var retry_btn: Button = %RetryButton
@onready var menu_btn: Button = %MainMenuButton
@onready var final_score_label: Label = %FinalScoreLabel

func _ready() -> void:
	GameState.current_state = GameState.MatchState.GAME_OVER
	get_tree().paused = false
	final_score_label.text = "BIOMASSA PURIFICADA: %06d | TECIDO ALCANÇADO: FASE %d" % [
		GameState.biomass_score, GameState.current_level
	]
	retry_btn.grab_focus()
	retry_btn.pressed.connect(_on_retry_pressed)
	menu_btn.pressed.connect(_on_menu_pressed)

func _on_retry_pressed() -> void:
	var level_path := "res://scenes/levels/Level%d.tscn" % GameState.current_level
	TransitionLayer.change_scene(level_path)

func _on_menu_pressed() -> void:
	TransitionLayer.change_scene("res://scenes/ui/MainMenu.tscn")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[GAME_OVER] Falência Imunológica registrada na Fase 2 | Score: 002410
[GAME_OVER] 'Tentar Novamente' acionado -> Recarregando res://scenes/levels/Level2.tscn
```

**5. Componentes Envolvidos**
* `scenes/ui/GameOverScreen.tscn`.
* `src/ui/GameOverScreen.gd`.

**6. Considerações Técnicas e Arquitetura**
* Cumpre o requisito do Slide 12 de `Projeto_disciplina_2026_1.0.pdf` (*Tela ou mensagem de fim de jogo: "Game Over"*) e a especificação da Seção 4.3 e Seção 14 do Mini GDD (Fluxograma: *Tela de Game Over $\rightarrow$ Tentar Novamente $\rightarrow$ Reinício da Fase Atual*).

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
|                  FALÊNCIA IMUNOLÓGICA — GAME OVER                     |
|            O organismo hospedeiro sucumbiu à infecção.                |
|                                                                       |
|          BIOMASSA PURIFICADA: 002410  |  TECIDO: FASE 2               |
|                                                                       |
|                      [ > TENTAR NOVAMENTE < ]                         |
|                      [    MENU PRINCIPAL    ]                         |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #20 e Issue #29.
* **Bloqueia:** Issue #36 e Issue #41.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Deixar um inimigo zerar o HP do fagócito e verificar a transição para `GameOverScreen.tscn`.
2. Pressionar `Enter` ou Botão `A` do Gamepad em *Tentar Novamente* e confirmar que a fase reinicia com o jogador vivo.

**10. Definição de Pronto (Definition of Done - DoD)**
* `GameOverScreen.tscn` implementada com estatísticas da tentativa, reinício da fase atual e retorno ao menu.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `game-over`, `ui-flow`, `state-machine`.

**13. Documentação Relacionada**
* Requisito RF13.
* Seção 14 do Mini GDD, Seção 4.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #35: [Frontend] Implementação da `VictoryScreen.tscn` ("Expurgo Completo", Estatísticas Finais da Partida e Créditos)**

**1. História de Usuário (User Story)**
> **Como** jogador erradicando o chefe final da Fase 5 (*O Carcinoma Primordial*),
> **eu quero** ser recompensado com a `VictoryScreen.tscn` anunciando *"EXPURGO COMPLETO — VITÓRIA!"*, apresentando o relatório final da intervenção imunológica (Score Total de Biomassa, Tempo Total de Run, Adaptações Conquistadas) e os créditos da equipe,
> **para que** o jogo tenha um fechamento épico e cumpra a exigência de ciclo completo (*Início, Gameplay e Final*) da disciplina.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o chefe da Fase 5 (Medula Óssea / Neoplasia Maligna) é derrotado, **quando** o evento de conclusão disparar, **então** o jogo deve transicionar para `scenes/ui/VictoryScreen.tscn` no estado `GameState.MatchState.VICTORY`.
* **Dado que** a `VictoryScreen.tscn` está visível, **então** deve apresentar o desfecho narrativo de remissão completa do organismo hospedeiro, o Score Total de Biomassa, o Tempo Total formatado (`MM:SS`), os créditos dos 3 integrantes e os botões *Jogar Novamente* e *Menu Principal*.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/ui/VictoryScreen.gd
extends Control

@onready var score_label: Label = %TotalBiomassLabel
@onready var time_label: Label = %TotalTimeLabel
@onready var play_again_btn: Button = %PlayAgainButton
@onready var menu_btn: Button = %MainMenuButton

func _ready() -> void:
	GameState.current_state = GameState.MatchState.VICTORY
	var mins: int = int(GameState.run_elapsed_time) / 60
	var secs: int = int(GameState.run_elapsed_time) % 60
	score_label.text = "BIOMASSA TOTAL EXPURGADA: %06d" % GameState.biomass_score
	time_label.text = "TEMPO TOTAL DE INTERVENÇÃO: %02d:%02d" % [mins, secs]
	play_again_btn.grab_focus()
	play_again_btn.pressed.connect(func():
		GameState.reset_run_state()
		TransitionLayer.change_scene("res://scenes/levels/Level1.tscn")
	)
	menu_btn.pressed.connect(func():
		TransitionLayer.change_scene("res://scenes/ui/MainMenu.tscn")
	)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[VICTORY] O Carcinoma Primordial foi erradicado! Estado: VICTORY
[VICTORY] Biomassa Total: 014820 | Tempo Total: 14:32
```

**5. Componentes Envolvidos**
* `scenes/ui/VictoryScreen.tscn`.
* `src/ui/VictoryScreen.gd`.

**6. Considerações Técnicas e Arquitetura**
* Cumpre o Objetivo Principal da disciplina no Slide 2 e Slide 12 de `Projeto_disciplina_2026_1.0.pdf` (*O jogo não precisa ser longo, mas deve estar completo: Início, Gameplay e Final; Tela de fim de jogo quando termina/finaliza*) e a Seção 1.2 / 14 do Mini GDD.

**7. Mockups ou Referências Visuais**
```plaintext
+-----------------------------------------------------------------------+
|                    EXPURGO COMPLETO — VITÓRIA FINAL!                  |
|     O Carcinoma Primordial foi neutralizado. O organismo vive!        |
|                                                                       |
|          BIOMASSA TOTAL EXPURGADA: 014820                             |
|          TEMPO TOTAL DE INTERVENÇÃO: 14:32                            |
|          ADAPTAÇÕES MITÓTICAS: [1] [2] [3] [4] (100%)                 |
|                                                                       |
|     Desenvolvido por: Victor Angelo | Lucas Guedin | Lucas Marcão     |
|                      UTFPR — OPT010 (2026/2)                          |
|                                                                       |
|               [ > JOGAR NOVAMENTE < ]   [ MENU PRINCIPAL ]            |
+-----------------------------------------------------------------------+
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #05, Issue #29 e Issue #31.
* **Bloqueia:** Issue #36 e Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Simular a conclusão da Fase 5 e verificar a abertura de `VictoryScreen.tscn` com cálculo correto de minutos/segundos e score total.
2. Acionar *Jogar Novamente* e confirmar que os contadores do `GameState` são zerados para uma nova run limpa.

**10. Definição de Pronto (Definition of Done - DoD)**
* `VictoryScreen.tscn` implementada, integrada ao fluxo final da Fase 5 e navegável por Teclado/Mouse e Gamepad.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`frontend`, `victory-screen`, `ending`, `ui-flow`, `state-machine`.

**13. Documentação Relacionada**
* Requisito RF13.
* Seção 1.2 e Seção 14 do Mini GDD; Slide 2 e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #36: [Frontend] Sistema Global de Transição entre Cenas (`TransitionLayer.tscn`) com Efeito de Fade In / Fade Out**

**1. História de Usuário (User Story)**
> **Como** jogador transitando entre menus, fases, telas de *Level Clear*, *Game Over* e *Vitória*,
> **eu quero** um Autoload `TransitionLayer.tscn` (`CanvasLayer` no topo da hierarquia) que execute um efeito suave de escurecimento (Fade Out $\rightarrow$ Troca de Cena $\rightarrow$ Fade In de $0.3\text{ s}$),
> **para que** não haja cortes secos na tela e o projeto atenda ao requisito explícito de efeito de transição entre telas da disciplina.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o Slide 12 de `Projeto_disciplina_2026_1.0.pdf` exige *Com efeito de transição entre telas: Fade, Varredura Lateral ou Vertical*, **quando** qualquer script chamar `TransitionLayer.change_scene(target_path)`, **então** um `ColorRect` escuro (`#0B0205`, camada `100`) deve fazer Fade para opaco (`Alpha = 1.0` em `0.3s`), executar `get_tree().change_scene_to_file(target_path)` e fazer Fade de volta para transparente (`Alpha = 0.0` em `0.3s`).
* **Dado que** a transição está em andamento, **quando** o jogador clicar repetidamente em um botão de menu, **então** chamadas concorrentes a `change_scene()` devem ser bloqueadas por flag `_is_transitioning` para impedir dupla troca de cena.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/autoload/TransitionLayer.gd
extends CanvasLayer

var _is_transitioning: bool = false
@onready var fade_rect: ColorRect = $FadeColorRect

func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	fade_rect.color = Color(0.04, 0.01, 0.02, 0.0)
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(target_path: String, duration: float = 0.30) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var tween := create_tween()
	tween.tween_property(fade_rect, ^"color:a", 1.0, duration)
	await tween.finished
	
	get_tree().paused = false
	get_tree().change_scene_to_file(target_path)
	
	var tween_in := create_tween()
	tween_in.tween_property(fade_rect, ^"color:a", 0.0, duration)
	await tween_in.finished
	
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_is_transitioning = false
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[TRANSITION] Fade Out (0.30s) -> Changing scene to: res://scenes/levels/Level1.tscn -> Fade In (0.30s) [OK]
```

**5. Componentes Envolvidos**
* `scenes/ui/TransitionLayer.tscn`.
* `src/autoload/TransitionLayer.gd` (registrado como Autoload em `project.godot`).

**6. Considerações Técnicas e Arquitetura**
* Definir `process_mode = Node.PROCESS_MODE_ALWAYS` no `TransitionLayer` garante que o `Tween` de Fade funcione mesmo se for acionado a partir do `PauseOverlay.tscn` enquanto a árvore do jogo ainda estava pausada.

**7. Mockups ou Referências Visuais**
```plaintext
Fluxo de Transição Global (Seção 14 do Mini GDD):
[Cena A Visível] --(0.3s Alpha 0->1)--> [Troca de Cena] --(0.3s Alpha 1->0)--> [Cena B Visível]
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #28, Issue #29, Issue #33, Issue #34 e Issue #35.
* **Bloqueia:** Issue #41 e Issue #44.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Navegar entre `SplashScreen -> MainMenu -> InstructionsScreen -> MainMenu -> Level1 -> Pause -> MainMenu`.
2. Confirmar que todas as transições exibem o Fade suave sem piscar quadros brancos ou travar cliques após o término.

**10. Definição de Pronto (Definition of Done - DoD)**
* Autoload `TransitionLayer` registrado no `project.godot` e integrado a todas as trocas de tela do jogo.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média (Requisito explícito do Slide 12 do PDF da disciplina).

**12. Etiquetas (Labels)**
`frontend`, `transitions`, `autoload`, `fade`, `ui-flow`.

**13. Documentação Relacionada**
* Requisito RF13.
* Seção 14 do Mini GDD e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

# 🔊 Grupo 6: Curadoria, Síntese e Engenharia de Áudio do Jogador e UI

### **Issue #37: [Ambiente] Seleção, Síntese (sfxr.me / Audacity) e Edição dos Efeitos Sonoros (SFX) de Combate e Locomoção do Fagócito**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pela sonoplastia do jogador,
> **eu quero** selecionar, sintetizar (via `sfxr.me` / `Freesound.org`) e normalizar no Audacity os efeitos sonoros orgânicos e cáusticos do fagócito (disparo enzimático, tiro concentrado, dash citoplasmático, fagocitose de ATP, recepção de dano e morte/lise celular),
> **para que** cada ação física e balística do protagonista tenha resposta auditiva imediata e sem distorção ou *clipping*.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o PDF da disciplina (Slide 3 e Slide 4) atribui ao Programador A os *efeitos sonoros associados ao jogador*, **quando** povoado o diretório `audio/sfx/player/`, **então** devem existir os arquivos `.wav` (16-bit PCM, 44.1 kHz, Mono):
  1. `sfx_enzyme_shoot.wav` (duração $0.10\text{ a }0.18\text{ s}$ — timbre ácido curto);
  2. `sfx_enzyme_concentrated.wav` (duração $0.15\text{ a }0.22\text{ s}$ — timbre pesado para *Damage Shot* $3\times$);
  3. `sfx_cytoplasmic_dash.wav` (duração $0.20\text{ s}$ — propulsão fluida *whoosh* orgânico);
  4. `sfx_phagocytosis_pickup.wav` (duração $0.15\text{ s}$ — absorção celular ascendente ao fagocitar ATP);
  5. `sfx_player_hurt.wav` (duração $0.25\text{ s}$ — impacto visceral na membrana);
  6. `sfx_player_death.wav` (duração $0.80\text{ s}$ — ruptura/lise celular em falha imunológica).
* **Dado que** múltiplos tiros ocorrem a cada $0.16\text{ s}$ no *Rapid Shot*, **quando** normalizados os arquivos no Audacity, **então** o pico máximo deve ser ajustado para `-3.0 dBFS` e sem silêncio residual no início (`0 ms` de latência de ataque).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Script de auditoria de SFX do Jogador
const PLAYER_SFX_FILES: Array[String] = [
	"res://audio/sfx/player/sfx_enzyme_shoot.wav",
	"res://audio/sfx/player/sfx_enzyme_concentrated.wav",
	"res://audio/sfx/player/sfx_cytoplasmic_dash.wav",
	"res://audio/sfx/player/sfx_phagocytosis_pickup.wav",
	"res://audio/sfx/player/sfx_player_hurt.wav",
	"res://audio/sfx/player/sfx_player_death.wav"
]
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[AUDIO_AUDIT] 6/6 arquivos WAV do Jogador verificados em res://audio/sfx/player/ (PCM 16-bit, Peak <= -3.0 dBFS).
```

**5. Componentes Envolvidos**
* `audio/sfx/player/sfx_*.wav` (6 arquivos).

**6. Considerações Técnicas e Arquitetura**
* Na Godot 4, efeitos sonoros curtos e de baixa latência devem usar o formato `.wav` descomprimido (com `loop_mode = Disabled` no `.import`), enquanto trilhas longas de música usam `.ogg`. Isso elimina atrasos de decodificação de CPU durante rajadas de tiro na build Web HTML5.

**7. Mockups ou Referências Visuais**
| Arquivo de Áudio | Evento Associado | Duração Alvo | Ferramenta / Fonte |
| :--- | :--- | :---: | :--- |
| `sfx_enzyme_shoot.wav` | Disparo Enzimático Padrão | $0.12\text{ s}$ | `sfxr.me` (Laser/Shoot + Lowpass) |
| `sfx_enzyme_concentrated.wav` | Disparo Concentrado ($3\times$) | $0.18\text{ s}$ | `sfxr.me` + Audacity Pitch/Bass |
| `sfx_cytoplasmic_dash.wav` | Esquiva / Dash ($0.2\text{ s}$) | $0.20\text{ s}$ | `sfxr.me` (Jump/Whoosh) |
| `sfx_phagocytosis_pickup.wav` | Absorção de Glóbulo de ATP | $0.15\text{ s}$ | `sfxr.me` (Pickup/Coin orgânico) |
| `sfx_player_hurt.wav` | Dano Recebido pelo Fagócito | $0.25\text{ s}$ | `sfxr.me` (Hit/Hurt) |
| `sfx_player_death.wav` | Morte / Lise Celular | $0.80\text{ s}$ | `sfxr.me` (Explosion/Lysis) |

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #39, Issue #40 e Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir cada arquivo `.wav` no painel `AudioStreamImporter` da Godot 4 e reproduzir no preview.
2. Confirmar que `Loop Mode` está desabilitado (`Disabled`) em todos os 6 arquivos para evitar repetição infinita do tiro.

**10. Definição de Pronto (Definition of Done - DoD)**
* Os 6 arquivos `.wav` do jogador selecionados/gerados, editados sem silêncio inicial, normalizados a `-3 dBFS` e commitados em `audio/sfx/player/`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`ambiente`, `audio`, `sfx`, `player`, `sound-design`.

**13. Documentação Relacionada**
* Requisito RF15.
* Slide 3 e Slide 4 de `Projeto_disciplina_2026_1.0.pdf`; Seção 1 e Seção 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #38: [Ambiente] Seleção, Síntese e Padronização dos Efeitos Sonoros (SFX) de Interface, Menus, Alertas e Transições**

**1. História de Usuário (User Story)**
> **Como** jogador navegando pelos menus e monitorando alertas do HUD,
> **eu quero** efeitos sonoros dedicados para foco/hover de botão, confirmação de clique, abertura/fechamento de pausa, alerta de ATP insuficiente (`ATP < 25`), coleta de Receptor Molecular, ativação de Power-Up e fanfarras curtas de *Level Clear* e *Game Over*,
> **para que** toda interação de UI e mudança de estado do jogo ofereça feedback sonoro claro e polido.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** todas as telas e elementos do HUD do Programador A requerem feedback auditivo, **quando** povoado o diretório `audio/sfx/ui/`, **então** devem existir os arquivos `.wav`:
  1. `sfx_ui_focus.wav` (mudança de botão via Gamepad/Hover);
  2. `sfx_ui_confirm.wav` (clique/confirmação de botão);
  3. `sfx_ui_pause.wav` (acionamento do menu de pausa);
  4. `sfx_atp_denied.wav` (recusa de dash por $\text{ATP} < 25$);
  5. `sfx_receptor_collected.wav` (coleta de chave biológica / Receptor Molecular);
  6. `sfx_buff_activated.wav` (ativação de power-up temporário de 15s);
  7. `sfx_level_clear.wav` (jingle positivo de *Tecido Purificado*);
  8. `sfx_game_over.wav` (jingle dramático de *Falência Imunológica*).

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Script de auditoria de SFX de UI
const UI_SFX_FILES: Array[String] = [
	"res://audio/sfx/ui/sfx_ui_focus.wav",
	"res://audio/sfx/ui/sfx_ui_confirm.wav",
	"res://audio/sfx/ui/sfx_ui_pause.wav",
	"res://audio/sfx/ui/sfx_atp_denied.wav",
	"res://audio/sfx/ui/sfx_receptor_collected.wav",
	"res://audio/sfx/ui/sfx_buff_activated.wav",
	"res://audio/sfx/ui/sfx_level_clear.wav",
	"res://audio/sfx/ui/sfx_game_over.wav"
]
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[AUDIO_AUDIT] 8/8 arquivos WAV de UI verificados em res://audio/sfx/ui/ [OK].
```

**5. Componentes Envolvidos**
* `audio/sfx/ui/sfx_*.wav` (8 arquivos).

**6. Considerações Técnicas e Arquitetura**
* Cumpre a exigência explícita da Seção 4.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` (*Caso o ATP seja < 25, o dash é bloqueado e emite um breve sinal visual/sonoro de recusa*) e do Slide 3 de `Projeto_disciplina_2026_1.0.pdf`.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #02.
* **Bloqueia:** Issue #39, Issue #40 e Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Reproduzir os 8 arquivos na Godot 4 e validar o equilíbrio de volume entre os sons sutis (`sfx_ui_focus.wav` a `-6 dBFS`) e os alertas principais (`-3 dBFS`).

**10. Definição de Pronto (Definition of Done - DoD)**
* Os 8 arquivos `.wav` de interface selecionados/sintetizados, editados e importados em `audio/sfx/ui/`.

**11. Prioridade e Severidade**
* **Prioridade:** Média.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`ambiente`, `audio`, `sfx`, `ui-sound`, `menus`.

**13. Documentação Relacionada**
* Requisitos RF05, RF11, RF13, RF15.
* Slide 3 e Slide 4 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 2

---

### **Issue #39: [Backend] Arquitetura do Singleton `SoundManager.gd`, Barramentos do `AudioServer` (`Master`, `BGM`, `SFX`) e Pool Polifônico**

**1. História de Usuário (User Story)**
> **Como** Programador A integrando os efeitos sonoros do jogador e da UI com a trilha sonora do jogo,
> **eu quero** implementar o Autoload `SoundManager.gd` gerenciando 3 barramentos (`Master`, `BGM`, `SFX`) e um pool circular de 12 nós `AudioStreamPlayer`,
> **para que** múltiplos disparos, impactos e coletas de ATP toquem simultaneamente sem cortar uns aos outros e continuem funcionando mesmo durante o menu de pausa.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** a Seção 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` especifica o Singleton `SoundManager.gd`, **quando** o jogo inicializar, **então** devem existir os 3 barramentos no `default_bus_layout.tres`: `Master`, `BGM` e `SFX`.
* **Dado que** vários efeitos sonoros podem ser disparados no mesmo quadro (ex: tiro em leque + coleta de ATP + dano), **quando** `SoundManager.play_sfx(stream, pitch_min, pitch_max)` for chamado, **então** ele deve alocar um `AudioStreamPlayer` livre do pool polifônico (12 canais no bus `SFX`) sem interromper os sons já em reprodução.
* **Dado que** os sons de UI precisam tocar enquanto o jogo está pausado (`get_tree().paused = true`), **quando** `SoundManager` for instanciado, **então** seu `process_mode` deve ser `Node.PROCESS_MODE_ALWAYS`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# src/autoload/SoundManager.gd
extends Node

const SFX_POOL_SIZE: int = 12
var _sfx_pool: Array[AudioStreamPlayer] = []
var _bgm_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_audio_buses()
	
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = &"BGM"
	add_child(_bgm_player)
	
	for i in range(SFX_POOL_SIZE):
		var p := AudioStreamPlayer.new()
		p.bus = &"SFX"
		add_child(p)
		_sfx_pool.append(p)

func play_sfx(stream: AudioStream, pitch_min: float = 0.95, pitch_max: float = 1.05, volume_db: float = 0.0) -> void:
	if stream == null:
		return
	for player in _sfx_pool:
		if not player.playing:
			player.stream = stream
			player.pitch_scale = randf_range(pitch_min, pitch_max)
			player.volume_db = volume_db
			player.play()
			return
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[SOUND_MANAGER] Initialized | Buses: [Master, BGM, SFX] | Polyphonic SFX Pool: 12 channels
[SOUND_MANAGER] Playing sfx_enzyme_shoot.wav on channel #3 (pitch_scale: 1.03)
```

**5. Componentes Envolvidos**
* `src/autoload/SoundManager.gd` (registrado como Autoload em `project.godot`).
* `resources/default_bus_layout.tres`.

**6. Considerações Técnicas e Arquitetura**
* Segue rigorosamente a Seção 3.2 (*Singletons / Autoloads do Projeto — 2. SoundManager.gd*) do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* A variação leve de frequência (`pitch_scale` aleatório entre `0.95` e `1.05`) evita a fadiga auditiva (*machine-gun effect*) quando o jogador dispara 6 vezes por segundo com o *Rapid Shot*.

**7. Mockups ou Referências Visuais**
```plaintext
Arquitetura do SoundManager (Autoload):
  [Master Bus (0.0 dB)]
     ├── [BGM Bus (-6.0 dB)] <--- _bgm_player (Loop Musical)
     └── [SFX Bus (-2.0 dB)] <--- Pool [Player #0 ... Player #11] (Polifonia 12 vozes)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #37 e Issue #38.
* **Bloqueia:** Issue #40.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Chamar `SoundManager.play_sfx()` 8 vezes dentro de um mesmo loop `for` e verificar que todas as 8 vozes tocam em paralelo nos canais `#0` a `#7` sem corte.
2. Pausar a árvore (`get_tree().paused = true`) e confirmar que `SoundManager.play_sfx()` continua reproduzindo os sons do menu de pausa.

**10. Definição de Pronto (Definition of Done - DoD)**
* `SoundManager.gd` e `default_bus_layout.tres` configurados e registrados como Autoload no `project.godot`.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`backend`, `audio`, `sound-manager`, `autoload`, `audioserver`.

**13. Documentação Relacionada**
* Requisito RF15.
* Seção 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #40: [Backend] Integração dos Gatilhos Sonoros com Variação de Pitch (`pitch_scale`) no Jogador, Projéteis, HUD e Menus**

**1. História de Usuário (User Story)**
> **Como** jogador controlando o fagócito e interagindo com os menus de *PhagoCrisis*,
> **eu quero** que todos os eventos de tiro, dash, recusa de ATP, fagocitose, dano, morte e navegação de botões acionem automaticamente os SFX correspondentes através do `SoundManager`,
> **para que** a experiência audiovisual do jogador e da UI esteja 100% integrada e coesa.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogador executa ações em `Player.gd`, **quando** disparar enzima, usar dash, absorver glóbulo de ATP, recusar dash por falta de ATP, sofrer dano ou morrer, **então** o `SoundManager` deve tocar o respectivo arquivo de `audio/sfx/player/` ou `audio/sfx/ui/`.
* **Dado que** o usuário navega por qualquer botão nas telas `MainMenu`, `Instructions`, `Credits`, `PauseOverlay`, `LevelClear`, `GameOver` ou `Victory`, **quando** um botão receber foco (`focus_entered` / `mouse_entered`) ou for pressionado (`pressed`), **então** deve tocar `sfx_ui_focus.wav` e `sfx_ui_confirm.wav`.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Helper no SoundManager.gd para vincular áudio automaticamente a todos os botões de uma tela
func bind_ui_buttons(root_node: Node) -> void:
	for child in root_node.find_children("*", "BaseButton", true, false):
		var btn := child as BaseButton
		if not btn.focus_entered.is_connected(_play_ui_focus):
			btn.focus_entered.connect(_play_ui_focus)
			btn.mouse_entered.connect(_play_ui_focus)
			btn.pressed.connect(_play_ui_confirm)
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[SFX_BIND] 4 botões vinculados automaticamente em MainMenu.tscn (focus + pressed)
[SFX_EVENT] Player shoot -> sfx_enzyme_shoot.wav (pitch: 0.98)
[SFX_EVENT] ATP Globule phagocytosed -> sfx_phagocytosis_pickup.wav (pitch: 1.06)
```

**5. Componentes Envolvidos**
* `src/autoload/SoundManager.gd`.
* `src/player/Player.gd`.
* Scripts de telas em `src/ui/`.

**6. Considerações Técnicas e Arquitetura**
* O método utilitário `SoundManager.bind_ui_buttons(self)` chamado no `_ready()` de cada tela de menu garante que todos os botões tenham som de hover, foco de Gamepad e clique com apenas 1 linha de código por tela, evitando repetição de código (*DRY*).

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #16, Issue #17, Issue #19, Issue #20, Issue #25, Issue #37, Issue #38 e Issue #39.
* **Bloqueia:** Issue #41, Issue #43 e Issue #44.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Percorrer todos os menus usando Mouse e Gamepad e validar o som de foco e confirmação em cada botão.
2. Jogar uma sessão de combate validando os sons de tiro normal, tiro concentrado, dash, recusa de ATP, coleta de glóbulo, dano e morte.

**10. Definição de Pronto (Definition of Done - DoD)**
* Todos os 14 efeitos sonoros do escopo do Programador A conectados e testados em gameplay e menus.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Média.

**12. Etiquetas (Labels)**
`backend`, `audio`, `sfx-integration`, `player`, `ui`.

**13. Documentação Relacionada**
* Requisito RF15.
* Slide 3 de `Projeto_disciplina_2026_1.0.pdf` e Seção 1 / 3.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

# 🚀 Grupo 7: Integração dos Marcos (Protótipo e Final), Otimização e Builds PC/Web

### **Issue #41: [Infraestrutura] Integração e Validação do Marco 2 (Protótipo Jogável: 1 Level + Mecânicas do Player + 1 Inimigo/Item + Dual Input)**

**1. História de Usuário (User Story)**
> **Como** equipe apresentando a segunda entrega obrigatória da disciplina (*Protótipo: Como se joga?*),
> **eu quero** integrar a cena completa do `Player.tscn`, `HUD.tscn` e `PauseOverlay.tscn` (Programador A) com o primeiro nível vascular, ao menos 1 patógeno/obstáculo e 1 item coletável (Programador B e Artista Técnico),
> **para que** a entrega do Protótipo cumpra 100% dos critérios avaliativos do Slide 19 do PDF da disciplina.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o Slide 19 de `Projeto_disciplina_2026_1.0.pdf` define o escopo exato do Protótipo, **quando** a cena `scenes/levels/Level1.tscn` (ou `scenes/cena_2d.tscn` integrada) for executada, **então** deve conter e demonstrar funcionalmente:
  1. `1 level completo` navegável com colisões de parede na Layer 1;
  2. `Todas as mecânicas do jogador` (Movimentação vetorial, Mira 360° + Tiro Enzimático, Dash com *I-Frames* + Consumo de ATP e Fagocitose);
  3. `Ao menos 1 inimigo/obstáculo` interagindo com o tiro do jogador e aplicando dano de contato;
  4. `Ao menos 1 item` (Glóbulo de ATP / Vacúolo de Power-Up) sendo coletado e atualizando o `HUD.tscn`;
  5. `Controles Teclado/Mouse + Joystick` funcionando em paridade total.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Checklist automatizado de sanidade na inicialização da cena do Protótipo
func _ready() -> void:
	assert(get_tree().get_first_node_in_group(&"player") != null, "Player ausente no Level!")
	assert(get_node_or_null("HUD") != null, "HUD ausente no Level!")
	print("[PROTOTYPE_OK] Level 1 integrado com Player, HUD, PauseOverlay, Inimigos e Coletáveis.")
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PROTOTYPE_OK] Level 1 integrado com Player, HUD, PauseOverlay, Inimigos e Coletáveis.
[PROTOTYPE_OK] Dual Input (Keyboard/Mouse + Gamepad) verificado a 60 FPS.
```

**5. Componentes Envolvidos**
* `scenes/levels/Level1.tscn` (e integração com `scenes/cena_2d.tscn`).
* `scenes/player/Player.tscn`, `scenes/ui/HUD.tscn`, `scenes/ui/PauseOverlay.tscn`.

**6. Considerações Técnicas e Arquitetura**
* Esta issue consolida a integração entre os módulos de Victor Angelo (Programador A), Lucas Guedin (Programador B) e Lucas Marcão (Artista Técnico), garantindo que as interfaces de sinais (`GameState`) e o método `take_damage(amount)` nos inimigos estejam em total conformidade.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issues #12 a #27, Issue #32, Issue #34, Issue #36 e Issue #40.
* **Bloqueia:** Issue #42, Issue #43 e Issue #44.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Jogar a Fase 1 do início ao fim apenas com Teclado + Mouse, validando tiro, dash, coleta de ATP, abertura de porta e vitória/morte.
2. Repetir o percurso completo da Fase 1 utilizando exclusivamente um Gamepad USB/Bluetooth.

**10. Definição de Pronto (Definition of Done - DoD)**
* Protótipo completo jogável do início ao fim da Fase 1 com todas as mecânicas do jogador, HUD reativo e suporte dual de controles.

**11. Prioridade e Severidade**
* **Prioridade:** Alta (Entrega oficial da disciplina).
* **Severidade:** Crítica.

**12. Etiquetas (Labels)**
`infraestrutura`, `milestone`, `prototype`, `integration`, `opt010`.

**13. Documentação Relacionada**
* Todos os Requisitos Funcionais de Gameplay (RF01 a RF12).
* Slide 19 de `Projeto_disciplina_2026_1.0.pdf` (*Entregas do Projeto — Protótipo: Como se joga?*).

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 5

---

### **Issue #42: [Infraestrutura] Auditoria de Performance para 60 FPS (Prevenção de Vazamento de Nós, `VisibleOnScreenNotifier2D` e Profiling)**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pelo desempenho da compilação final,
> **eu quero** auditar a árvore de cenas em tempo de execução com o Profiler da Godot 4, garantindo zero vazamento de nós (`Orphan Nodes = 0`), descarte imediato de projéteis/partículas via `VisibleOnScreenNotifier2D` e eliminação de buscas `get_node()` dentro de `_process`/`_physics_process`,
> **para que** o jogo sustente 60 FPS contínuos no PC e na Web mesmo durante combates intensos com dezenas de projéteis e partículas.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o jogo está rodando sob estresse (disparo contínuo de *Spread Shot* + *Rapid Shot* por 3 minutos), **quando** monitorado `Performance.get_monitor(Performance.TIME_FPS)` e `Performance.OBJECT_ORPHAN_NODE_COUNT`, **então** o FPS deve permanecer em `60` ($\text{Frame Time} \le 16.6\text{ ms}$) e a contagem de nós órfãos deve ser estritamente `0`.
* **Dado que** a Seção 8 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` proíbe buscas literais de caminhos em loops de quadro, **quando** auditados todos os scripts em `src/`, **então** nenhuma função `_process()` ou `_physics_process()` deve conter chamadas a `get_node()` ou `find_child()`, utilizando apenas referências cacheadas `@onready`, grupos ou sinais.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```gdscript
# Monitor de Telemetria de Performance em modo Debug (src/autoload/PerfMonitor.gd)
extends Node

func _process(_delta: float) -> void:
	if OS.is_debug_build() and Engine.get_process_frames() % 120 == 0:
		var fps: float = Engine.get_frames_per_second()
		var nodes: float = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
		var orphans: float = Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)
		if orphans > 0:
			push_warning("[PERF_WARN] Orphan nodes detected: %d" % int(orphans))
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
[PERF_AUDIT] FPS: 60.0 | Frame Time: 4.2 ms | Physics Time: 1.8 ms | Active Nodes: 142 | Orphans: 0 [OK]
```

**5. Componentes Envolvidos**
* Todos os scripts em `src/player/` e `src/ui/`.
* `scenes/player/EnzymeProjectile.tscn` (`VisibleOnScreenNotifier2D`).
* `scenes/player/CausticSplashParticles.tscn`.

**6. Considerações Técnicas e Arquitetura**
* Cumpre os critérios de otimização do Slide 5 de `Projeto_disciplina_2026_1.0.pdf` (*Performance: mirar 30 ou 60 fps na web; Otimizar process: VisibleOnScreenEnabler2D, VisibleOnScreenNotifier2D*) e da Seção 8.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #15, Issue #22 e Issue #41.
* **Bloqueia:** Issue #43 e Issue #44.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Abrir a aba `Debugger -> Profiler` e `Monitors` na Godot 4 durante uma partida intensa.
2. Disparar ininterruptamente por 60 segundos e verificar que o gráfico de `Node Count` estabiliza em platô assim que os projéteis saem da tela.
3. Verificar que `Orphan Nodes` permanece em `0` após trocar entre todas as telas e reiniciar a fase.

**10. Definição de Pronto (Definition of Done - DoD)**
* Auditoria concluída com 60 FPS constantes, zero nós órfãos e zero chamadas `get_node` em rotinas por frame.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`infraestrutura`, `performance`, `optimization`, `60fps`, `profiling`.

**13. Documentação Relacionada**
* Requisitos RNF01, RNF04.
* Seção 16.1 do Mini GDD, Seção 8.3 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 5 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

### **Issue #43: [Infraestrutura] Configuração e Exportação das Builds Desktop PC (Windows `.exe` e Linux `.x86_64`) em Pacote `.zip`**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pela geração das builds oficiais de PC para o Itch.io (Slide 6 do PDF da disciplina),
> **eu quero** configurar os presets de exportação Desktop (`Windows Desktop` 64-bits e `Linux` `.x86_64`) no `export_presets.cfg`, embutindo todos os recursos `.tres`, fontes, sprites e áudios no pacote `.pck` e gerando o arquivo compactado `.zip` final,
> **para que** qualquer jogador ou avaliador possa baixar, descompactar e executar *PhagoCrisis* nativamente no PC sem instalar a Godot.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** `export_presets.cfg` define os alvos de compilação, **quando** configurado o preset `Windows Desktop` (e `Linux`), **então** `binary_format/architecture` deve ser `"x86_64"`, `package/embed_pck` (ou `.pck` adjacente na mesma pasta) deve empacotar 100% dos assets de `res://` e o ícone do executável deve estar configurado.
* **Dado que** a exportação é concluída na pasta `builds/pc/`, **quando** gerado o pacote `PhagoCrisis_PC_v1.0.zip`, **então** o executável extraído em uma pasta limpa (fora do diretório do projeto) deve iniciar na `SplashScreen.tscn`, carregar todas as 5 fases, tocar todos os áudios e encerrar sem erros no console.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```powershell
# Exportação via CLI Headless da Godot 4 e empacotamento em .zip
New-Item -ItemType Directory -Force -Path "builds/pc"
godot --headless --export-release "Windows Desktop" "builds/pc/PhagoCrisis.exe"
Compress-Archive -Path "builds/pc/*" -DestinationPath "builds/PhagoCrisis_PC_v1.0.zip" -Force
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
Godot Engine v4.x.stable.official -Headless
savepack: begin: Packing 100% of resources into PhagoCrisis.pck
export: Windows Desktop release build succeeded -> builds/pc/PhagoCrisis.exe
[ARCHIVE_OK] builds/PhagoCrisis_PC_v1.0.zip created successfully.
```

**5. Componentes Envolvidos**
* `export_presets.cfg`.
* `builds/PhagoCrisis_PC_v1.0.zip` (ignorado no Git via `.gitignore`, publicado no Itch.io).

**6. Considerações Técnicas e Arquitetura**
* Cumpre a atribuição explícita do Slide 6 de `Projeto_disciplina_2026_1.0.pdf` (*Responsabilidades — Programador A: builds Web e PC corretos; Versões disponibilizadas: PC download em zip*) e da Seção 16 do Mini GDD.
* Certificar-se de que nenhuma referência a caminho de arquivo no código possua discrepância de maiúsculas/minúsculas (*Case Sensitivity*), pois o sistema de arquivos empacotado `.pck` e o Linux diferenciam `Player.tscn` de `player.tscn` mesmo quando compilado no Windows.

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #40, Issue #41 e Issue #42.
* **Bloqueia:** Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Exportar a build `Windows Desktop` em modo `Release` (sem debug).
2. Extrair `PhagoCrisis_PC_v1.0.zip` em `C:\Temp\PhagoCrisis_Test\` e executar `PhagoCrisis.exe`.
3. Verificar se a `SplashScreen` da UTFPR abre em 1920x1080, se o áudio toca, se o Gamepad funciona e se o botão *Sair* fecha o processo limpamente.

**10. Definição de Pronto (Definition of Done - DoD)**
* `export_presets.cfg` configurado e pacote `PhagoCrisis_PC_v1.0.zip` gerado, testado fora do editor e pronto para upload no Itch.io.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica (Entrega final obrigatória do Programador A).

**12. Etiquetas (Labels)**
`infraestrutura`, `export`, `pc-build`, `windows`, `linux`, `itch-io`.

**13. Documentação Relacionada**
* Requisitos RNF02, RNF07.
* Seção 16 e 16.1 do Mini GDD, Seção 8.2 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 5 / Slide 6 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #44: [Infraestrutura] Configuração, Exportação e Validação da Build Web (HTML5) com `SharedArrayBuffer` no Itch.io**

**1. História de Usuário (User Story)**
> **Como** Programador A responsável pela publicação e funcionamento da versão Web no Itch.io,
> **eu quero** configurar o preset `Web` no `export_presets.cfg` gerando `index.html`, `.wasm`, `.pck` e `.js` compactados em `PhagoCrisis_Web_v1.0.zip` e validar a execução no Itch.io com a opção *"SharedArrayBuffer support"* habilitada,
> **para que** o jogo rode diretamente no navegador a 60 FPS com áudio e controles (Teclado/Mouse + Gamepad via HTML5 Gamepad API) sem travar na tela de carregamento.

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o preset `Web` está configurado em `export_presets.cfg`, **quando** a build HTML5 for exportada para `builds/web/index.html`, **então** o arquivo principal deve chamar-se obrigatoriamente `index.html` (exigência do Itch.io para jogos embarcados) e utilizar o renderizador `gl_compatibility`.
* **Dado que** a Godot 4 requer isolamento Cross-Origin (COOP/COEP) quando exportada com suporte a threads/WebAssembly, **quando** o pacote `PhagoCrisis_Web_v1.0.zip` for enviado ao Itch.io e marcado como *"This file will be played in the browser"*, **então** a opção **"SharedArrayBuffer support"** nas configurações de *Embed Options* do Itch.io deve estar habilitada e as dimensões do viewport configuradas para proporção 16:9 (ex: `1280x720` ou `1920x1080` com botão Fullscreen ativo).
* **Dado que** o usuário abre a página do jogo no navegador (Chrome/Firefox/Edge), **quando** clicar em *Run Game*, **então** o jogo deve inicializar sem erros de `SharedArrayBuffer is not defined` ou bloqueio do `AudioContext`, ocultando automaticamente o botão *Sair* do Menu Principal.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```powershell
# Exportação da Build Web HTML5 via CLI e empacotamento com index.html na raiz do .zip
New-Item -ItemType Directory -Force -Path "builds/web"
godot --headless --export-release "Web" "builds/web/index.html"
Compress-Archive -Path "builds/web/*" -DestinationPath "builds/PhagoCrisis_Web_v1.0.zip" -Force
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```plaintext
export: Web release build succeeded -> builds/web/index.html (+ index.wasm, index.pck, index.js)
[WEB_CHECK] Cross-Origin Isolation (COOP: same-origin, COEP: require-corp) -> SharedArrayBuffer ENABLED
[WEB_CHECK] WebGL 2.0 context initialized | AudioServer running | Gamepad API active
```

**5. Componentes Envolvidos**
* `export_presets.cfg` (preset `Web`).
* `builds/PhagoCrisis_Web_v1.0.zip`.
* Configurações de Embed da página do projeto no Itch.io.

**6. Considerações Técnicas e Arquitetura**
* Cumpre a instrução crítica destacada no Slide 6 de `Projeto_disciplina_2026_1.0.pdf` (*Versões disponibilizadas: Web — habilitar: "SharedArrayBuffer support"*) e na Seção 8.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md`.
* Caso deseje compatibilidade adicional em navegadores restritivos, na Godot 4.3+ também é possível testar a flag `variant/thread_support=false` (Single-Threaded Web Export) em conjunto com o `SharedArrayBuffer` no Itch.io, garantindo 100% de confiabilidade de boot e de áudio Web.

**7. Mockups ou Referências Visuais**
```plaintext
Checklist de Configuração no Painel do Itch.io (Edit Game -> Embed Options):
 [x] Kind of project: HTML
 [x] Upload: PhagoCrisis_Web_v1.0.zip -> [x] This file will be played in the browser
 [x] Viewport dimensions: 1280 x 720 px (16:9)
 [x] Frame Options: [x] Fullscreen button | [x] Automatically start on page load (opcional)
 [x] Frame Options -> [x] SharedArrayBuffer support (OBRIGATÓRIO GODOT 4)
```

**8. Dependências e Bloqueios**
* **Depende de:** Issue #01, Issue #29, Issue #40, Issue #41 e Issue #42.
* **Bloqueia:** Issue #45.

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Exportar `builds/web/index.html` e gerar `PhagoCrisis_Web_v1.0.zip` certificando-se de que `index.html` está na raiz do `.zip` (e não dentro de uma subpasta).
2. Subir o `.zip` em modo rascunho (*Draft*) no Itch.io, marcar *SharedArrayBuffer support*, salvar e abrir a página no navegador.
3. Testar o jogo completo no navegador (áudio, tela cheia, Teclado+Mouse e Gamepad) verificando no Console do DevTools (`F12`) a ausência de erros WebGL/WASM.

**10. Definição de Pronto (Definition of Done - DoD)**
* Build Web HTML5 exportada, enviada ao Itch.io com `SharedArrayBuffer` ativo e validada em navegador a 60 FPS.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Crítica (Requisito obrigatório no Slide 5 e Slide 6 do PDF da disciplina).

**12. Etiquetas (Labels)**
`infraestrutura`, `web-build`, `html5`, `wasm`, `sharedarraybuffer`, `itch-io`.

**13. Documentação Relacionada**
* Requisitos RNF01, RNF02, RNF06.
* Seção 16 e 16.1 do Mini GDD, Seção 8.1 do `contexto_t_cnico_e_arquitetural_exhaustivo.md` e Slide 5 / Slide 6 de `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** M (Medium)
* **Story Points:** 3

---

### **Issue #45: [Documentação] Consolidação da Documentação Técnica do Programador A, Licenciamento de Áudios e Checklist de Entrega Final**

**1. História de Usuário (User Story)**
> **Como** Programador A (Victor Angelo Souza Santos) finalizando o projeto para a avaliação da disciplina OPT010,
> **eu quero** atualizar o `README.md` do repositório e o registro de créditos/licenças de áudio, documentando toda a arquitetura de cenas do jogador/UI, a tabela de controles duais, as instruções de compilação PC/Web e o checklist final da página do Itch.io,
> **para que** o professor avaliador tenha rastreabilidade completa da minha contribuição individual (50% da nota) e do cumprimento integral dos requisitos gerais da equipe (50% da nota).

**2. Critérios de Aceitação (AC - Gherkin)**
* **Dado que** o repositório oficial é avaliado pelo docente, **quando** consultado o arquivo `README.md` na raiz do projeto, **então** deve conter:
  1. Sinopse e Conceito de *PhagoCrisis* + Link oficial da página no Itch.io;
  2. Tabela da Divisão Formal de Papéis (Victor Angelo — Programador A, Lucas Guedin — Programador B, Lucas Marcão — Artista Técnico) com os diretórios e cenas de autoria de cada integrante;
  3. Tabela completa de Controles (Teclado+Mouse e Gamepad);
  4. Catálogo de Referências e Licenças de Áudios/SFX utilizados;
  5. Instruções passo a passo para abrir e compilar o projeto na Godot Engine 4.x.
* **Dado que** a página do Itch.io está publicada para a entrega da *Versão Final + Release* (Slide 6 e Slide 19 do PDF da disciplina), **quando** revisada pelo checklist final, **então** deve conter a versão Web funcional com `SharedArrayBuffer`, o download da versão PC em `.zip`, fotos, GIFs de 3 a 5 segundos, descrição dos controles/objetivos, créditos detalhados ("quem fez o que") e menção com logo da UTFPR.

**3. Exemplo de Requisição (Código/Payload/CLI)**
```powershell
Get-Content -Path "README.md" -TotalCount 35
```

**4. Exemplo de Resposta (Saída esperada / Log de Terminal)**
```markdown
# 🦠 PhagoCrisis — Twin-Stick Biopunk Action Roguelite
**Disciplina:** OPT010 — Desenvolvimento de Jogos (UTFPR — Câmpus Campo Mourão, 2026/2)  
**Docente:** Prof. Marcos Silvano Almeida  
**Motor:** Godot Engine 4.x (GDScript | Renderizador Compatibility)  

## 👥 Equipe e Responsabilidades (Critério 50% Geral / 50% Individual)
- **Victor Angelo Souza Santos (Programador A — Jogador, UI, Áudio do Player e Compilação)**
- **Lucas Silva Guedin (Programador B — Mundo, Entidades, IA, Spawners e BGM)**
- **Lucas Antonio Marcão (Artista Técnico — Pixel Art, Animações, TileSets e Level Design)**
```

**5. Componentes Envolvidos**
* `README.md`.
* `scenes/ui/CreditsScreen.tscn`.
* Página pública do projeto no Itch.io.

**6. Considerações Técnicas e Arquitetura**
* Garante alinhamento 100% entre o que está documentado no `README.md`, o que aparece na `CreditsScreen.tscn` dentro do jogo e o que está publicado na descrição da página do Itch.io (Slide 6 e Slide 12 de `Projeto_disciplina_2026_1.0.pdf`).

**7. Mockups ou Referências Visuais**
* N/A.

**8. Dependências e Bloqueios**
* **Depende de:** Todas as issues anteriores (#01 a #44).
* **Bloqueia:** Entrega Oficial Final da Disciplina OPT010 (*Versão Final + Release*).

**9. Como Testar (Plano de Teste Passo a Passo)**
1. Visualizar o `README.md` renderizado no GitHub e validar todos os links, tabelas e referências.
2. Conferir item a item o Slide 5, Slide 6, Slide 8, Slide 12 e Slide 19 de `Projeto_disciplina_2026_1.0.pdf` contra a versão publicada no Itch.io.

**10. Definição de Pronto (Definition of Done - DoD)**
* `README.md` completo e revisado na raiz do repositório.
* Checklist de requisitos da disciplina OPT010 100% cumprido e builds PC (`.zip`) + Web (`HTML5`) publicadas e testadas no Itch.io.

**11. Prioridade e Severidade**
* **Prioridade:** Alta.
* **Severidade:** Alta.

**12. Etiquetas (Labels)**
`documentacao`, `readme`, `release`, `itch-io`, `opt010`, `utfpr`.

**13. Documentação Relacionada**
* Todos os Requisitos Funcionais (RF01 a RF15) e Não Funcionais (RNF01 a RNF08).
* Mini GDD completo (`Relatório Técnico de Game Design (Mini GDD) - PhagoCrisis.pdf`) e `Projeto_disciplina_2026_1.0.pdf`.

**14. Estimativa**
* **T-Shirt Size:** S (Small)
* **Story Points:** 2

---

## 📊 Resumo Quantitativo do Caderno de Issues (Victor Angelo — Programador A)

| Grupo Temático | Quantidade de Issues | Intervalo | Story Points Totais | Escopo Principal Coberto |
| :--- | :---: | :---: | :---: | :--- |
| **Grupo 1: Infraestrutura, Ambiente e Entradas** | 5 | `#01` a `#05` | 8 SP | `project.godot`, 1080p Pixel-Perfect, 8 Layers de Colisão, `InputMap` Dual, `GameState` |
| **Grupo 2: Criação Manual de Sprites (Pixel Art)** | 6 | `#06` a `#11` | 19 SP | Spritesheet do Fagócito, Projéteis, Luz Radial, Barras de HUD, Ícones de Upgrades, Telas e `SpriteFrames` |
| **Grupo 3: Cinemática, Física e Combate do Player** | 11 | `#12` a `#22` | 31 SP | `Player.tscn`, Movimento Hidrodinâmico, Mira 360°, Projéteis, Power-Ups, Dash + *I-Frames*, ATP, Fagocitose, Dano/Muco, Adaptações e Câmera/Luz/Partículas |
| **Grupo 4: Interface Gráfica (HUD Tático)** | 5 | `#23` a `#27` | 11 SP | `HUD.tscn` (`CanvasLayer`), Barra HP, Barra ATP, Score de Biomassa, Receptores e Buffs 15s + *Hurt Vignette* |
| **Grupo 5: Fluxo de Telas e Menus** | 9 | `#28` a `#36` | 19 SP | `SplashScreen` UTFPR, `MainMenu`, `Instructions`, `Credits`, `PauseOverlay`, `LevelClear`, `GameOver`, `Victory` e `TransitionLayer` (Fade) |
| **Grupo 6: Seleção, Síntese e Engenharia de Áudio** | 4 | `#37` a `#40` | 10 SP | Criação/Curadoria de 14 SFX (`.wav`), `SoundManager.gd`, Barramentos `Master/BGM/SFX`, Pool Polifônico e Gatilhos |
| **Grupo 7: Protótipo, Otimização 60 FPS e Builds** | 5 | `#41` a `#45` | 15 SP | Integração do Protótipo (Marco 2), Profiling 60 FPS, Build PC (`.zip`), Build Web (`SharedArrayBuffer`) e Documentação Final |
| **TOTAL GERAL (ESCOPO PROGRAMADOR A)** | **45 Issues** | **`#01` a `#45`** | **113 SP** | **Cobertura 100% de Código, Sprites Manuais, Áudios, UI, Telas e Compilação PC/Web** |
