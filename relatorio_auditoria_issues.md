# 🔍 Relatório de Auditoria Técnica de Conformidade — PhagoCrisis (Escopo: Programador A — Issues #01 a #45)

**Projeto:** PhagoCrisis — Twin-Stick Shooter / Roguelite Biopunk 2D  
**Disciplina:** OPT010 — Desenvolvimento de Jogos (UTFPR — Câmpus Campo Mourão)  
**Escopo Auditado:** Victor Angelo Souza Santos (Programador A — Issues #01 a #45)  
**Data da Auditoria:** 11/11/2026  

---

## 1. Resumo Executivo de Status

A auditoria técnica inspecionou integralmente os arquivos de configuração (`project.godot`, `export_presets.cfg`, `.gitignore`), as cenas existentes (`scenes/cena_2d.tscn` e `scenes/main_menu.tscn`), todos os scripts GDScript em `src/` e o diretório de assets `sprites/`, confrontando-os linha a linha com o documento `especificacao_completa_das_issues.md`.

> **Observação de Auditoria sobre o Índice do Documento:** Embora o cabeçalho da linha 101 de `especificacao_completa_das_issues.md` declare *"26 de 45 Issues Concluídas (57,8%)"*, a listagem de checkboxes nas linhas 104–160 marca efetivamente **28 issues como `[x]`** e **17 issues como `[ ]`**. Além disso, o índice foi ajustado para descrever o estado do *Protótipo Funcional (Marco 2)*, enquanto o corpo detalhado de cada issue (linhas 166–4085) especifica os parâmetros, caminhos e cenas do *Escopo Final (Mini GDD)*.

### 📊 Contagem Real das 45 Issues (Confronto Código vs. Especificação Teórica Final)

| Categoria de Status Real | Quantidade | % sobre 45 Issues | Issues Enquadradas |
| :--- | :---: | :---: | :--- |
| **Totalmente Implementadas** *(100% idênticas ao DoD teórico final)* | **0** | **0,0%** | Nenhuma issue cumpre 100% dos nomes de arquivos, caminhos modulares e constantes numéricas da especificação teórica sem divergências. *(Obs.: A **Issue #41** cumpre 100% dos requisitos funcionais do Marco 2 em `cena_2d.tscn`, mas diverge nos nomes das cenas modulares do DoD).* |
| **Parcialmente Implementadas / Divergentes** *(funcionalidade existe no protótipo, mas com parâmetros, nomes ou nós diferentes)* | **29** | **64,4%** | `#01`, `#02`, `#03`, `#04`, `#05`, `#06`, `#07`, `#08`, `#10`, `#11`, `#12`, `#13`, `#14`, `#15`, `#16`, `#17`, `#18`, `#19`, `#20`, `#23`, `#24`, `#25`, `#26`, `#29`, `#32`, `#33`, `#34`, `#41`, `#43` |
| **Não Implementadas / Pendentes** *(código, cenas ou assets ausentes no repositório)* | **16** | **35,6%** | `#09`, `#21`, `#22`, `#27`, `#28`, `#30`*, `#31`, `#35`, `#36`, `#37`, `#38`, `#39`, `#40`, `#42`, `#44`, `#45` |
| **TOTAL ANALISADO** | **45** | **100,0%** | Issues `#01` a `#45` |

*\*Nota sobre a Issue #30: Possui uma dica textual de controles no rodapé do HUD em `src/Player.gd` (linhas 182–186), mas a cena `InstructionsScreen.tscn` não existe.*

* **Percentual de Funcionalidade do Protótipo (Marco 2):** **100% jogável** em `scenes/cena_2d.tscn` (**62,2%** das issues com mecânica ativa em cena).
* **Percentual Real de Conclusão Ponderada (frente ao Escopo Final Planejado):** **32,2%** (atribuindo peso `0,5` às 29 entregas parciais/divergentes: $14,5 / 45 = 32,2\%$).

---

### 🎯 Aferição Direta dos 6 Pontos Críticos de Parâmetros e Divergências

1. **Resolução e Viewport (Issue #01):**
   * **Especificação Teórica:** `1920x1080`, `stretch/mode="canvas_items"`, `stretch/aspect="keep"`, nome `"PhagoCrisis"`, cena principal `res://scenes/ui/SplashScreen.tscn`.
   * **Realidade no Código (`project.godot`, linhas 13–26):** Configurado para **`1280x720`** (`window/size/viewport_width=1280`, `window/size/viewport_height=720`), `stretch/mode="canvas_items"` (sem `stretch/aspect="keep"`), `config/name="lab-game-marcao"`, e `run/main_scene="uid://bxpu83qo5c2fj"` (`scenes/main_menu.tscn`). Em `src/Player.gd` (linha 13), `@export var game_size: Vector2 = Vector2(1280.0, 720.0)` e em `src/Projectile.gd` (linha 28) os limites de descarte são hardcoded para `1280x720` (`x > 1312.0`, `y > 752.0`).

2. **Métricas de Vida e Estamina (Issues #18, #20, #24, #25):**
   * **Especificação Teórica:** `BASE_MAX_HP = 100.0`, `MAX_ATP_BASE = 100.0`, custo de dash `25.0`, delay de regeneração `1.0s`, taxa de regeneração `15.0 un/s`, cura por orbe `+10% HP` e `+20.0 ATP`.
   * **Realidade no Código (`src/Player.gd`, linhas 20–23):** Opera em escala reduzida **`max_hp = 6` (`6/6`)** e **`max_atp = 30.0` (`30/30`)**. O dash consome **`6.0` de ATP** (linha 337), a regeneração é contínua a **`4.5 un/s`** sem delay de `1.0s` (linha 244), o dano de contato inimigo subtrai `1` ponto de HP (linha 272), e cada orbe restaura `+1 HP` e `+8.0 ATP` (linhas 366–367).

3. **HUD e Layout (Issues #08, #23, #24, #25, #26, #27):**
   * **Especificação Teórica:** Cena autônoma `scenes/ui/HUD.tscn` (`CanvasLayer`, `layer = 5`) em `1920x1080` com `TextureProgressBar` (`160x24 px`), `SCORE: %06d`, 3 slots de Receptores Moleculares (`receptor_slot_empty/filled.png`) e mostrador inferior de buffs de 15s (`%ActiveBuffsHBox`).
   * **Realidade no Código (`src/Player.gd`, linhas 77–195):** Construído proceduralmente via código no método `_setup_frugal_hud()` instanciando um `CanvasLayer` (`"FrugalHUD"`) filho do `Player`. No canto superior esquerdo exibe: retrato `prota.png` (`68x68 px`), `ProgressBar` vermelha (`6/6`) e azul (`30/30`) com `StyleBoxFlat`, labels `LEVEL: 1` e `SCORE: 0`, **4 slots de ícones estáticos** (`cann.png`, `shotProtaMage.png`, `portalDungeon.png`, `inimigoVermei.png`) e o contador **`PORTAIS: X   INIMIGOS: Y`** em amarelo (`Color(1.0, 0.85, 0.35)`). No rodapé (`y = 688`) exibe um label de ajuda de controles.

4. **Portais / Spawners (Issues #03, #05, #15, #24, #26, #33, #41):**
   * **Realidade no Código (`src/PortalSpawner.gd`, linhas 1–116 e `scenes/cena_2d.tscn`, linhas 57–75):** Existem **4 nós `Sprite2D`** na cena (`PortalDungeon`, `PortalDungeon2`, `PortalDungeon3`, `PortalDungeon4`) usando a textura `sprites/portalDungeon.png` e o script `src/PortalSpawner.gd`. Cada portal entra no grupo `"spawners"`, possui `max_health = 10`, pulsa senoidalmente (`scale = 1.15 + 0.12 * sin(_pulse_time)`), gera inimigos (`Enemy1`, `Enemy2` ou `Enemy3`) a cada `spawn_interval = 3.5s` (respeitando `max_concurrent_enemies = 8`), desenha sua própria **barra de vida roxa local** (`34x5 px`, `Color(0.85, 0.25, 0.95)`) em `_draw()` (linhas 77–83), recebe dano por proximidade (`<= 24.0 px`) em `src/Projectile.gd` (linhas 33–41) e, ao morrer (`_destruir_spawner()`, linhas 58–75), soma `+500` de score, dropa 2 itens (`1 SPREAD_BUFF` + `1 ENERGY_ORB`) e aciona `GameState.check_room_victory()`.

5. **Fluxo de Telas vs. Overlays In-Game (Issues #28 a #36):**
   * **Especificação Teórica:** Cenas autônomas `SplashScreen.tscn`, `MainMenu.tscn`, `InstructionsScreen.tscn`, `CreditsScreen.tscn`, `PauseOverlay.tscn`, `LevelClearScreen.tscn`, `GameOverScreen.tscn`, `VictoryScreen.tscn` e `TransitionLayer.tscn` (Fade).
   * **Realidade no Código:** Apenas `scenes/main_menu.tscn` existe (e é reaproveitada como menu de pausa quando instanciada dentro de um `CanvasLayer` via `abrir_menu_pausa()` em `src/Player.gd`, linhas 214–226, e controlada por `src/menu/pause_menu.gd`). Tanto a **Conclusão de Fase** (`notify_room_cleared()`, linhas 372–377) quanto o **Game Over** (`take_damage()`, linhas 354–359) são exibidos **sobre a própria arena** através do nó `hud_status_label` centralizado (`position = Vector2(340, 320)`), instruindo o jogador a pressionar a tecla **`[R]`** (`get_tree().reload_current_scene()`).

6. **Arsenal e Disparo (Issues #14, #15, #16):**
   * **Especificação Teórica:** Cena `EnzymeProjectile.tscn` (`EnzymeProjectile.gd`, dano `10.0`, `VisibleOnScreenNotifier2D`) instanciada em `AimPivot/MuzzleMarker` (`+16 px`), cadência base `0.33s` e 3 buffs temporários cumulativos de 15s (`damage_shot`, `spread_shot` de 3 tiros `-20°/0°/+20°`, `rapid_shot` `0.16s`).
   * **Realidade no Código (`src/Player.gd`, linhas 66–75 e `src/Projectile.gd`):** Utiliza um `WeaponPivot` (`Node2D`) acoplado com um `Sprite2D` da arma (`sprites/cann.png` em `Vector2(18.0, 2.0)`). O método `_disparar_tiros()` (linhas 305–330) constrói nós `Area2D` em código anexando `src/Projectile.gd` (`speed = 550.0`, `damage = 1`, textura `shotProtaMage.png`). O jogador começa com `spread_mode = true` (**leque de 5 tiros**: `-24°, -12°, 0°, 12°, 24°`, cooldown `0.22s`, cor verde-limão) e pode alternar livremente a qualquer momento com a **tecla `Q`** para o modo de **tiro único** (`[0.0]`, cooldown `0.14s`, cor branca).

---

## 2. Matriz Comparativa Detalhada por Grupo (Issues #01 a #45)

---

### 🏗️ Grupo 1: Infraestrutura, Ambiente Godot 4 e Arquitetura de Entradas

#### **Issue #01: [Infraestrutura] Configuração do `project.godot`, viewport 1920x1080 (16:9) pixel-perfect e renderizador Compatibility**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `project.godot` (linhas 11–42), `lab-game-marcao.csproj`, `lab-game-marcao.sln`.
* **Divergências Identificadas:**
  * A resolução configurada em `project.godot` (linhas 24–25) é `1280x720` (`viewport_width=1280`, `viewport_height=720`) em vez de `1920x1080`.
  * A chave `window/stretch/aspect="keep"` está ausente (usa o padrão da engine).
  * `config/name` ainda é `"lab-game-marcao"` em vez de `"PhagoCrisis"`.
  * `run/main_scene` aponta para `"uid://bxpu83qo5c2fj"` (`scenes/main_menu.tscn`) em vez de `"res://scenes/ui/SplashScreen.tscn"`.
  * Artefatos C# (`lab-game-marcao.csproj`, `lab-game-marcao.sln`, `[dotnet]` e feature `"C#"`) permanecem no projeto.
  * Em conformidade: `window/stretch/mode="canvas_items"`, `textures/canvas_textures/default_texture_filter=0` e `renderer/rendering_method="gl_compatibility"`.
* **O que falta para fechar a issue com fidelidade:** Alterar `config/name="PhagoCrisis"`, ajustar viewport para `1920x1080` com `stretch/aspect="keep"`, remover `.csproj`/`.sln` e a seção `[dotnet]`, e apontar `run/main_scene` para `SplashScreen.tscn`.

#### **Issue #02: [Infraestrutura] Padronização da árvore de diretórios (`src/`, `scenes/`, `sprites/`, `audio/`, `resources/`) e `.gitignore`**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `.gitignore`, `.gitattributes` e diretórios `src/`, `src/enemy/`, `src/menu/`, `scenes/`, `sprites/`.
* **Divergências Identificadas:**
  * Não existem os diretórios `audio/` (`audio/sfx/player/`, `audio/sfx/ui/`, `audio/bgm/`) nem `resources/`.
  * Não existem as subpastas de domínio do Programador A (`src/player/`, `src/ui/`, `src/autoload/`, `scenes/player/`, `scenes/ui/`, `sprites/player/`, `sprites/projectiles/`, `sprites/ui/`); os scripts e sprites estão achatados na raiz de `src/`, `scenes/` e `sprites/`.
  * O `.gitignore` ignora `.godot/` e pastas `z*MarcaoLab/`, mas não inclui `builds/` nem `*.tmp`.
* **O que falta para fechar a issue com fidelidade:** Criar a hierarquia completa de subpastas (`src/player/`, `src/ui/`, `src/autoload/`, `scenes/player/`, `scenes/ui/`, `sprites/player/`, `sprites/projectiles/`, `sprites/ui/`, `audio/sfx/player/`, `audio/sfx/ui/`, `audio/bgm/`, `resources/`) e adicionar `builds/` e `*.tmp` ao `.gitignore`.

#### **Issue #03: [Ambiente] Configuração da Matriz de Camadas e Máscaras de Colisão Física de 32 bits (Layers 1 a 8)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `project.godot`, `scenes/cena_2d.tscn` (linhas 35–37), `src/Projectile.gd` (linhas 32–54).
* **Divergências Identificadas:**
  * A seção `[layer_names]` com as 8 camadas (`2d_physics/layer_1="World_Solid"` até `layer_8="Triggers_Rooms"`) **não existe** em `project.godot`.
  * Apenas a `physics_layer_0/collision_layer = 1` está declarada no `TileSet_h4t55` do nó `parede` em `scenes/cena_2d.tscn` (linha 36).
  * `Player`, `Enemy1..6` e projéteis operam todos na camada padrão (`Layer 1`), diferenciando alvos via grupos (`is_in_group("player")`, `is_in_group("enemies")`, `is_in_group("spawners")`) e checagem de distância (`<= 24.0 px` para spawners, `<= 95.0 px` para drops).
* **O que falta para fechar a issue com fidelidade:** Adicionar a seção `[layer_names]` das Layers 1 a 8 no `project.godot` e atribuir explicitamente os bitmasks de `collision_layer` e `collision_mask` no Player (Layer 2), Inimigos (Layer 3), Projéteis (Layer 4) e Pickups (Layer 6).

#### **Issue #04: [Ambiente] Mapeamento do `InputMap` Dual Paritário (Teclado + Mouse e Gamepad XInput/DirectInput com Deadzone)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `project.godot`, `src/Player.gd` (linhas 196–304).
* **Divergências Identificadas:**
  * Não há seção `[input]` no `project.godot`; nenhuma das 12 ações abstratas (`move_left`, `move_right`, `move_up`, `move_down`, `aim_left`, `aim_right`, `aim_up`, `aim_down`, `shoot`, `dash`, `interact`, `pause`) foi registrada no `InputMap`.
  * O suporte dual funciona em `src/Player.gd` (linhas 248–295) por meio de polling direto de hardware (`Input.is_key_pressed(KEY_W/A/S/D/LEFT/RIGHT/UP/DOWN/SPACE)`, `Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)`, `Input.get_joy_axis(0, JOY_AXIS_LEFT_X/Y)` com deadzone `0.25`, `JOY_AXIS_RIGHT_X/Y` com deadzone `0.25` e `JOY_AXIS_TRIGGER_RIGHT > 0.3`).
  * O Dash e a Pausa em `_input(event)` (linhas 196–213) escutam apenas `InputEventKey` (`KEY_P`, `KEY_ESCAPE`, `KEY_R`, `KEY_Q`, `KEY_E`, `KEY_SHIFT`) e `InputEventMouseButton` (`MOUSE_BUTTON_RIGHT`), faltando gatilho/botão de Gamepad para Dash (`LT/L2` ou `A/X`) e Pausa (`Start`).
* **O que falta para fechar a issue com fidelidade:** Registrar as 12 ações com deadzone `0.25` (Teclado/Mouse + Gamepad) na seção `[input]` do `project.godot` e refatorar `src/Player.gd` para usar `Input.get_vector()` e `Input.is_action_pressed()`.

#### **Issue #05: [Backend] Refatoração e expansão do Singleton `GameState.gd` (Máquina de Estados Global, Sinais e Persistência)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/GameState.gd` (linhas 1–72), `project.godot` (linha 20).
* **Divergências Identificadas:**
  * `src/GameState.gd` está registrado como Autoload e implementa `signal stats_updated`, `score`, `player_level`, `enemies_alive`, `spawners_alive`, `total_spawned`, `reset_room_stats()`, `refresh_counts()`, `check_room_victory()`, `add_score()`, `save_current_game()` e `continue_game()`.
  * Não possui a enumeração `MatchState { SPLASH, MAIN_MENU, IN_GAME, PAUSED, LEVEL_CLEAR, GAME_OVER, VICTORY }`, nem `molecular_receptors`, `run_elapsed_time` ou o dicionário `active_adaptations`.
  * Não possui os sinais granulares exigidos pela issue: `state_changed`, `player_health_changed`, `player_atp_changed`, `biomass_changed`, `receptors_changed`, `temporary_buff_updated` e `mitotic_adaptation_unlocked`.
* **O que falta para fechar a issue com fidelidade:** Adicionar a enumeração `MatchState`, o dicionário `active_adaptations`, `molecular_receptors`, `run_elapsed_time`, `reset_run_state()` e os 7 sinais tipados em `src/GameState.gd`, mantendo os métodos atuais do protótipo para não quebrar a cena.

---

### 🎨 Grupo 2: Criação Manual de Sprites e Assets Visuais (Pixel Art Autoral)

#### **Issue #06: [Frontend] Criação manual em Pixel Art do Spritesheet do Fagócito Primordial (Idle, Locomoção, Dash e Dano)**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `sprites/prota.png`, `sprites/cann.png`, `sprites/ProtaMage.png`, `src/Player.gd` (linhas 5–6).
* **Divergências Identificadas:**
  * O protótipo utiliza o sprite único estático `sprites/prota.png` acoplado ao sprite de arma `sprites/cann.png`.
  * O arquivo `sprites/player/phagocyte_spritesheet.png` ($192\times 128\text{ px}$, 6 colunas $\times$ 4 linhas de $32\times 32\text{ px}$ com animações `idle`, `move`, `dash`, `hurt`/`death`) não existe no repositório.
* **O que falta para fechar a issue com fidelidade:** Exportar a folha de sprites animada `sprites/player/phagocyte_spritesheet.png` ($192\times 128\text{ px}$) com as 4 linhas de animação celular.

#### **Issue #07: [Frontend] Criação manual em Pixel Art dos Sprites de Projéteis Enzimáticos (Padrão, Concentrado 3x e Impacto)**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `sprites/shotProtaMage.png`, `src/Player.gd` (linha 7), `src/DropPickup.gd` (linha 13).
* **Divergências Identificadas:**
  * Utiliza o sprite estático `sprites/shotProtaMage.png` modulado via código (`modulate`) para diferenciar tiro simples, tiro em leque e orbes coletáveis.
  * Os arquivos `sprites/projectiles/enzyme_projectile_sheet.png` ($64\times 32\text{ px}$) e `sprites/projectiles/light_radial_gradient.png` ($256\times 256\text{ px}$) não existem.
* **O que falta para fechar a issue com fidelidade:** Criar e importar `sprites/projectiles/enzyme_projectile_sheet.png` e a máscara de iluminação `sprites/projectiles/light_radial_gradient.png`.

#### **Issue #08: [Frontend] Criação manual em Pixel Art dos Componentes do HUD (Barras de HP/ATP, Molduras e Receptores Moleculares)**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 87–174: uso de `StyleBoxFlat` e sprites `prota.png`, `cann.png`, `shotProtaMage.png`, `portalDungeon.png`, `inimigoVermei.png`).
* **Divergências Identificadas:**
  * As barras do HUD frugal são desenhadas proceduralmente com `StyleBoxFlat` em nós `ProgressBar`, e os 4 slots exibem os próprios sprites das entidades do jogo.
  * Nenhum dos 8 arquivos de textura especificados em `sprites/ui/` (`hud_hp_under.png`, `hud_hp_over.png`, `hud_hp_progress.png`, `hud_atp_under.png`, `hud_atp_over.png`, `hud_atp_progress.png`, `receptor_slot_empty.png`, `receptor_slot_filled.png`) existe no repositório.
* **O que falta para fechar a issue com fidelidade:** Desenhar e exportar as 6 texturas de barras ($160\times 24\text{ px}$) e os 2 ícones de receptores moleculares ($24\times 24\text{ px}$) em `sprites/ui/`.

#### **Issue #09: [Frontend] Criação manual em Pixel Art dos Ícones de Power-Ups Temporários e das 4 Adaptações Mitóticas**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (diretório `sprites/ui/icons/` inexistente).
* **Divergências Identificadas:** Os 7 ícones (`icon_buff_damage.png`, `icon_buff_spread.png`, `icon_buff_rapid.png`, `icon_adapt_membrane.png`, `icon_adapt_mitochondria.png`, `icon_adapt_pseudopods.png`, `icon_adapt_gland.png`) e `sprites/player/atp_globule_sheet.png` ainda não foram criados.
* **O que falta para fechar a issue com fidelidade:** Criar manualmente os 7 ícones $32\times 32\text{ px}$ em `sprites/ui/icons/` e o spritesheet `sprites/player/atp_globule_sheet.png`.

#### **Issue #10: [Frontend] Criação manual de Assets de Telas, Logotipo *PhagoCrisis*, Padronização do Logo UTFPR e Hurt Vignette**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `sprites/logo_utfpr.png`, `scenes/main_menu.tscn` (linhas 29–74).
* **Divergências Identificadas:**
  * `sprites/logo_utfpr.png` existe e está aplicado no nó `LogoUTFPR` em `scenes/main_menu.tscn` (linhas 65–74), enquanto o título usa um `Label` (`TitleLabel`, fonte tamanho 96, cor vermelha com contorno preto).
  * Faltam os arquivos `sprites/ui/title_logo_phagocrisis.png`, `sprites/ui/menu_background_vascular.png`, `sprites/ui/hurt_vignette.png`, `sprites/ui/button_membrane_9patch.png` e o tema `resources/ui_biopunk_theme.tres`.
* **O que falta para fechar a issue com fidelidade:** Criar as texturas de UI (`title_logo_phagocrisis.png`, `menu_background_vascular.png`, `hurt_vignette.png`, `button_membrane_9patch.png`) e configurar o recurso `resources/ui_biopunk_theme.tres` com estilo de foco para Gamepad.

#### **Issue #11: [Ambiente] Importação Pixel-Perfect (`Filter = Nearest`) e montagem dos recursos `SpriteFrames` na Godot 4**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `project.godot` (linha 38), `sprites/prota.png.import` (linhas 18–26, e demais `.import` em `sprites/`).
* **Divergências Identificadas:**
  * A importação Lossless (`compress/mode=0`, `mipmaps/generate=false`) e o filtro global `Nearest` (`default_texture_filter=0`) estão corretamente configurados em todos os `.import`.
  * Os recursos `resources/phagocyte_frames.tres` e `resources/projectile_frames.tres` (`SpriteFrames`) não existem porque o protótipo utiliza `Sprite2D` estático.
* **O que falta para fechar a issue com fidelidade:** Montar e salvar `resources/phagocyte_frames.tres` (animações `idle`, `move`, `dash`, `hurt`, `death`) e `resources/projectile_frames.tres` (`default`, `concentrated`, `impact`).

---

### 🦠 Grupo 3: Cinemática, Física, Combate e Fagocitose do Jogador (`Player`)

#### **Issue #12: [Backend] Arquitetura da Cena `Player.tscn` (`CharacterBody2D`), Colisor Layer 2 e Máquina de Estados Interna**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `scenes/cena_2d.tscn` (linhas 77–87), `src/Player.gd` (linhas 1–76).
* **Divergências Identificadas:**
  * O nó `Player` (`CharacterBody2D`) está embutido diretamente em `scenes/cena_2d.tscn` (linhas 77–87; não existe `scenes/player/Player.tscn` nem `src/player/Player.gd`).
  * Possui `add_to_group("player")` e `motion_mode = CharacterBody2D.MOTION_MODE_FLOATING` (linhas 47–48), mas usa `RectangleShape2D` ($28\times 28\text{ px}$) na Layer 1 em vez de `CircleShape2D` ($r = 12\text{ px}$) na Layer 2.
  * Não possui a enumeração `PlayerState { NORMAL, DASHING, HURT, DEAD }` nem nós filhos `Timer` (`ShootCooldownTimer`, `DashDurationTimer`, `DashCooldownTimer`), gerenciando recargas por variáveis `float` (`_shoot_cooldown`, `_invuln_timer`, `_dash_timer`, `_is_dead`) em `_physics_process(delta)`.
* **O que falta para fechar a issue com fidelidade:** Extrair o jogador para `scenes/player/Player.tscn`, configurar `CircleShape2D` ($r=12\text{ px}$) na Layer 2, adicionar a enum `PlayerState` e os subnós previstos no mockup da issue.

#### **Issue #13: [Backend] Implementação da Movimentação Protoplasmática Vetorial com Aceleração (`10.0`) e Atrito Hidrodinâmico (`6.0`)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linha 11 e linhas 247–263).
* **Divergências Identificadas:**
  * A velocidade máxima escalar é exatamente `@export var speed: float = 220.0`, com vetor normalizado nas diagonais (`direction = direction.normalized()`) e chamada a `move_and_slide()`.
  * Não utiliza interpolação linear (`velocity.lerp(...)`) com `ACCEL = 10.0` e `FRICTION = 6.0`; o movimento é instantâneo (`velocity = direction * speed`).
* **O que falta para fechar a issue com fidelidade:** Substituir `velocity = direction * speed` pela interpolação `velocity = velocity.lerp(direction * target_speed, ACCEL * delta)` ao acelerar e `velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)` ao desacelerar.

#### **Issue #14: [Backend] Sistema de Mira Contínua em 360° com Alternância Automática Mouse Global vs. Analógico Direito**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 66–75 e `_atualizar_mira_e_arma()`, linhas 291–304).
* **Divergências Identificadas:**
  * A mira contínua em 360° funciona rotacionando `weapon_pivot.rotation = ang` (com `weapon_sprite` usando `cann.png`, `flip_v` quando `absf(ang) > PI * 0.5` e `sprite.flip_h = aim_direction.x < 0.0`).
  * Prioriza o analógico direito quando `joy_aim.length() >= 0.25`. Porém, quando o jogador solta o analógico direito (`joy_aim.length() < 0.25`), o código cai imediatamente no bloco `else` (linha 295) e sobrescreve `aim_direction` com a posição do mouse (`get_global_mouse_position() - global_position`), pois não há flag `using_gamepad_aim` alternada via `InputEventMouseMotion` / `InputEventJoypadMotion`.
* **O que falta para fechar a issue com fidelidade:** Implementar a flag `using_gamepad_aim` em `_unhandled_input` para reter `last_valid_aim_angle` quando o stick direito do Gamepad retornar à zona morta (`< 0.25`) sem que o mouse tenha se movido.

#### **Issue #15: [Backend] Implementação da Cena `EnzymeProjectile.tscn` (`Area2D`, Layer 4), Balística a `550 px/s` e `VisibleOnScreenNotifier2D`**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Projectile.gd` (linhas 1–54), `src/Player.gd` (linhas 313–329).
* **Divergências Identificadas:**
  * A velocidade balística bate exatamente com a especificação (`@export var speed: float = 550.0` em `src/Projectile.gd`, linha 3), aplicando dano em inimigos/spawners e destruindo-se ao colidir com `TileMapLayer`/`StaticBody2D`.
  * O dano base é `@export var damage: int = 1` (adaptado para a escala de HP `2..5` dos inimigos e `10` dos portais) em vez de `10.0`.
  * Não existe a cena `scenes/player/EnzymeProjectile.tscn` nem `src/player/EnzymeProjectile.gd`; o `Area2D` é instanciado proceduralmente em `_disparar_tiros()` (linhas 314–329).
  * O auto-descarte fora da tela usa limites de coordenadas hardcoded (`x < -32.0 or x > 1312.0 or y < -32.0 or y > 752.0`) e `_lifetime = 3.0` (linhas 24–30) em vez de um nó `VisibleOnScreenNotifier2D`.
* **O que falta para fechar a issue com fidelidade:** Criar a cena `scenes/player/EnzymeProjectile.tscn` na Layer 4 (Mask 1 e 3) com um nó filho `VisibleOnScreenNotifier2D` conectado a `queue_free()`.

#### **Issue #16: [Backend] Sistema de Disparo Enzimático no `Marker2D` Frontal, Cadência (`0.33s`) e Power-Ups Cumulativos (Rapid, Spread, Damage)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linha 28 e `_disparar_tiros()`, linhas 305–330).
* **Divergências Identificadas:**
  * O disparo nasce em `weapon_sprite.global_position + aim_direction * 12.0` e suporta alternância manual via tecla `Q` (`spread_mode`) ou ativação permanente ao coletar `SPREAD_BUFF`.
  * O modo leque dispara **5 projéteis** (`[-24.0, -12.0, 0.0, 12.0, 24.0]`, cooldown `0.22s`) e o modo simples dispara **1 projétil** (`[0.0]`, cooldown `0.14s`), divergindo da especificação teórica (cadência base `0.33s`, leque de 3 tiros `[-20.0, 0.0, 20.0]`, `rapid_shot` `0.16s` e `damage_shot` $3\times$).
  * Não há temporizador regressivo de `15.0s` para os buffs (`buff_timers` para `damage_shot`, `spread_shot`, `rapid_shot`).
* **O que falta para fechar a issue com fidelidade:** Implementar o dicionário `buff_timers` (`damage_shot`, `spread_shot`, `rapid_shot`) com duração de `15.0s`, emissão do sinal `GameState.temporary_buff_updated` e suporte cumulativo aos 3 modificadores.

#### **Issue #17: [Backend] Implementação do Dash Citoplasmático (`480 px/s`, `0.2s`), Janela de *I-Frames*, Translucidez e Cooldown (`0.8s`)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linha 12 e `_tentar_dash()`, linhas 331–342).
* **Divergências Identificadas:**
  * O dash é acionado por `KEY_E`, `KEY_SHIFT` ou `MOUSE_BUTTON_RIGHT`, verifica colisão prévia com paredes via `test_move(global_transform, movimento_dash)` (reduzindo o alcance pela metade se houver obstáculo), aplica deslocamento imediato via `move_and_collide(movimento_dash)` (`dash_distance = 96.0 px`), concede `_invuln_timer = 0.25s` (com piscar translúcido em `_physics_process`) e `_dash_timer = 0.35s`.
  * Diverge da especificação teórica por ser um deslocamento instantâneo de `96 px` em um único frame (`move_and_collide`) com cooldown de `0.35s`, em vez de velocidade contínua `480.0 px/s` durante `0.20s` (`move_and_slide`) com `modulate.a = 0.4` e cooldown de `0.80s`.
* **O que falta para fechar a issue com fidelidade:** Converter o deslocamento do dash para o estado `DASHING` durante `0.20s` a `480.0 px/s` com `modulate.a = 0.4`, cooldown de `0.80s` e mapeamento também para `KEY_SPACE` e Gamepad (`LT/L2`).

#### **Issue #18: [Backend] Gestão Metabólica da Barra de ATP (Capacidade `100`, Custo `25`, Delay `1.0s` e Regeneração `15 un/s`)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 22–23, 242–245 e 332–337).
* **Divergências Identificadas:**
  * A capacidade máxima codificada é `max_atp = 30.0` (em vez de `100.0`), o custo do dash é `6.0` (em vez de `25.0` — mantendo a proporção de 20% da barra por dash) e a regeneração passiva é de `4.5 un/s` (proporcionalmente 15% da barra/s, equivalente aos `15 un/s` em base 100).
  * Não há atraso (`ATP_REGEN_DELAY_TIME = 1.0s`) após o dash antes de retomar a regeneração, nem emissão de sinal de recusa (`atp_insufficient_triggered`) quando `atp < custo`.
* **O que falta para fechar a issue com fidelidade:** Ajustar a escala para `100.0` (custo `25.0`, regeneração `15.0/s`) — ou manter a conversão proporcional —, adicionar o delay de `1.0s` pós-dash (`time_since_last_atp_use`) e emitir os sinais `player_atp_changed` e `atp_insufficient_triggered` no `GameState`.

#### **Issue #19: [Backend] Mecânica de Quimiotaxia e Fagocitose Tática (`Area2D` Raio `80 px`, Layer 6) com Atração Exponencial**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/DropPickup.gd` (linhas 1–48), `src/Player.gd` (linhas 361–370), `src/enemy/Enemy1.gd` (linhas 146–152), `src/PortalSpawner.gd` (linhas 63–70).
* **Divergências Identificadas:**
  * A atração magnética e coleta funcionam perfeitamente em `src/DropPickup.gd` (linhas 38–47), mas são calculadas por distância euclidiana ao jogador (`dist <= 95.0 px` para puxar com `velocity.move_toward(dir * 320.0, 900.0 * delta)` e `dist <= 18.0 px` para absorver via `player.collect_drop(drop_type)`), em vez de uma `ChemotaxisArea2D` (`Area2D` de raio `80.0 px` na Layer 6) filha do `Player`.
  * Ao absorver `ENERGY_ORB`, restaura `+1 HP` (~16,7% de 6), `+8.0 ATP` (~26,7% de 30) e `+50` score (ou ativa `spread_mode = true` e `+150` score se `SPREAD_BUFF`), divergindo dos valores nominais (`+10% HP`, `+20 ATP`, `+25` biomassa) e do nome `ATPGlobulePickup.gd`.
* **O que falta para fechar a issue com fidelidade:** Adicionar o nó `ChemotaxisArea2D` (`CircleShape2D`, `radius = 80.0`, Layer 6) ao `Player` e alinhar os valores de restauração com a escala de HP/ATP adotada.

#### **Issue #20: [Backend] Sistema de Integridade Celular (HP), Dano, Knockback e Reação a Muco Viscoso (`-40%`) e Bio-Toxina ($DoT$)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 20–21, 265–274 e `take_damage()`, linhas 344–360); `src/enemy/Enemy1.gd` (linhas 111–123).
* **Divergências Identificadas:**
  * O sistema de HP (`max_hp = 6`), dano de contato dos 3 tipos de inimigos (`take_damage(1, global_position)`), janela de invulnerabilidade pós-dano (`_invuln_timer = 0.70s` com piscar avermelhado), *knockback* (`move_and_collide(push_dir * 18.0)`) e estado de morte (`_is_dead = true`) estão implementados e funcionais.
  * Não existem zonas de perigo ambiental na Layer 7 (`MucusArea` com redução de `-40%` de velocidade e `BioToxinArea` com dano contínuo $DoT$), nem os métodos `set_mucus_overlap()` / `HazardDetectorArea2D`.
* **O que falta para fechar a issue com fidelidade:** Implementar a `HazardDetectorArea2D` (Mask Layer 7) no `Player.gd` com suporte à penalidade de `-40%` de velocidade em Muco Viscoso (`speed_multiplier = 0.60`) e recepção de $DoT$ em Bio-Toxina.

#### **Issue #21: [Backend] Integração das 4 Adaptações Mitóticas Permanentes no Jogador (+HP, +Regen ATP, Anti-Muco e +Dano)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (ausente em `src/Player.gd` e `src/GameState.gd`).
* **Divergências Identificadas:** O método `apply_mitotic_adaptations()` e os multiplicadores permanentes (`lipid_membrane`, `super_mitochondria`, `strong_pseudopods`, `digestive_gland`) ainda não foram codificados.
* **O que falta para fechar a issue com fidelidade:** Codificar `apply_mitotic_adaptations()` em `src/Player.gd` lendo `GameState.active_adaptations` no `_ready()` e conectando ao sinal `mitotic_adaptation_unlocked`.

#### **Issue #22: [Frontend] Anexação da `Camera2D` com Suavização, Trauma de *Screen Shake* (`0.15s`), `PointLight2D` e `GPUParticles2D`**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (nenhum nó `Camera2D`, `PointLight2D`, `LightOccluder2D` ou `GPUParticles2D` em `scenes/cena_2d.tscn` ou `src/Player.gd`).
* **Divergências Identificadas:** A câmera atual é a viewport fixa de `1280x720`; não há `PlayerCamera2D.gd` com *Screen Shake*, nem iluminação 2D (`PointLight2D`) ou emissores de partículas (`GPUParticles2D`).
* **O que falta para fechar a issue com fidelidade:** Anexar `PlayerCamera2D` (com `trigger_shake(0.15, 6.0)` ao sofrer dano), `PointLight2D` (com textura radial e sombras) e `GPUParticles2D` (rastro de dash e `CausticSplashParticles.tscn` no impacto dos projéteis).

---

### 🖥️ Grupo 4: Interface Gráfica do Usuário — HUD e Feedback Tático

#### **Issue #23: [Frontend] Estruturação da Cena `HUD.tscn` (`CanvasLayer` Estático) e Layout Responsivo 16:9 nas Extremidades**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 77–195: `_setup_frugal_hud()`).
* **Divergências Identificadas:**
  * Existe um `CanvasLayer` estático (`name = "FrugalHUD"`) com `Control` raiz configurado em `Control.PRESET_FULL_RECT` e `mouse_filter = Control.MOUSE_FILTER_IGNORE` (linhas 78–85).
  * Diverge por ser criado proceduralmente dentro de `src/Player.gd` em vez de uma cena desacoplada `scenes/ui/HUD.tscn` com script `src/ui/HUD.gd` (`class_name GameHUD`), e os subnós filhos (`ColorRect`, `TextureRect`, `ProgressBar`, `Label`) não aplicam recursivamente `MOUSE_FILTER_IGNORE`.
* **O que falta para fechar a issue com fidelidade:** Extrair a construção do HUD para `scenes/ui/HUD.tscn` e `src/ui/HUD.gd` (`layer = 5`) aplicando `_set_mouse_ignore_recursive()` em todos os controles filhos.

#### **Issue #24: [Frontend] Implementação da Barra de Integridade Celular (`TextureProgressBar` de HP) via Sinal `player_health_changed`**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 101–124, 379–383, 391–399); `src/enemy/Enemy1.gd` (linhas 160–165); `src/PortalSpawner.gd` (linhas 77–83).
* **Divergências Identificadas:**
  * Implementa a barra vermelha de HP (`hud_hp_bar` com texto `"6/6"`) no HUD superior esquerdo e, adicionalmente, desenha mini barras de vida locais via `_draw()` sob os pés do `Player` (verde/vermelha), dos `Enemy1..3` (vermelha quando feridos) e dos `PortalSpawner` (roxa).
  * Usa `ProgressBar` com `StyleBoxFlat` (escala `6/6`) atualizada diretamente por `_update_hud()`, em vez de `TextureProgressBar` (escala `100/100`) interpolada por `Tween` via sinal `GameState.player_health_changed`.
* **O que falta para fechar a issue com fidelidade:** Conectar a atualização da barra de HP ao sinal `GameState.player_health_changed`, adicionar interpolação via `create_tween()` (`0.12s`) e aplicar as texturas `hud_hp_*.png` quando criadas.

#### **Issue #25: [Frontend] Implementação do Medidor Dinâmico de ATP com Interpolação (`Tween`) e Alerta Visual de Energia Insuficiente**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 126–145 e 384–385).
* **Divergências Identificadas:**
  * A barra azul de ATP (`hud_atp_bar` + `hud_atp_label` `"30/30"`) funciona em tempo real exibindo o gasto no dash (`-6.0`) e a regeneração contínua (`+4.5/s`).
  * Não possui mudança de tonalidade (`COLOR_ATP_LOW`) quando o ATP está abaixo do custo mínimo de dash (`< 6.0` no protótipo / `< 25.0` na especificação), nem o efeito de piscar em vermelho/amarelo (`_on_atp_insufficient_triggered()`) ao tentar dar dash sem energia suficiente.
* **O que falta para fechar a issue com fidelidade:** Implementar a mudança de cor da barra quando o ATP for insuficiente para 1 dash e adicionar o `Tween` de flash de alerta quando o jogador tentar acionar o dash sem ATP.

#### **Issue #26: [Frontend] Implementação do Contador de Biomassa (Score) e Painel dos 3 Slots de Receptores Moleculares**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 147–180 e 386–389); `src/GameState.gd` (linhas 15–45).
* **Divergências Identificadas:**
  * Exibe `LEVEL: 1`, `SCORE: %d`, 4 slots com ícones dos elementos da arena (`cann.png`, `shotProtaMage.png`, `portalDungeon.png`, `inimigoVermei.png`) e o contador dinâmico de objetivos da sala `PORTAIS: %d   INIMIGOS: %d` reagindo ao sinal `GameState.stats_updated`.
  * Diverge da especificação teórica no formato do score (`"SCORE: %d"` em vez de `"SCORE: %06d"`) e por exibir 4 slots estáticos de ícones em vez dos 3 slots dinâmicos de Receptores Moleculares (`ReceptorsHBox` conectado a `GameState.receptors_changed`).
* **O que falta para fechar a issue com fidelidade:** Formatar o score com 6 dígitos (`"SCORE: %06d"`) com pulso de escala e conectar o painel de receptores moleculares ao sinal `GameState.receptors_changed(count)`.

#### **Issue #27: [Frontend] Implementação do Mostrador de Buffs Temporários (`15.0s` a `0.0s`) e Efeito de *Hurt Vignette***
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (ausente em `src/Player.gd`).
* **Divergências Identificadas:** Não há mostrador inferior de contagem regressiva de 15s para buffs ativos (`%ActiveBuffsHBox`), nem `HurtVignetteRect` em tela cheia ao sofrer dano (apenas o próprio sprite do jogador pisca em vermelho).
* **O que falta para fechar a issue com fidelidade:** Adicionar o `HurtVignetteRect` (com `Tween` de alpha `0.75 -> 0.0` em `0.35s` ao sofrer dano) e os 3 slots de buffs temporários com contagem regressiva de `15.0s` a `0.0s` no HUD.

---

### 🎬 Grupo 5: Fluxo de Telas, Menus e Máquina de Estados de Navegação

#### **Issue #28: [Frontend] Implementação da `SplashScreen.tscn` (Exibição Institucional Obrigatória do Logo UTFPR por `2.0s` com Fade)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (`run/main_scene` em `project.godot`, linha 14, abre diretamente `scenes/main_menu.tscn`).
* **Divergências Identificadas:** A cena `scenes/ui/SplashScreen.tscn` e o script `src/ui/SplashScreen.gd` não existem no repositório.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/SplashScreen.tscn` e `src/ui/SplashScreen.gd` exibindo `sprites/logo_utfpr.png` com Fade In (`0.5s`), retenção (`2.0s`), Fade Out (`0.5s`) e pulo por input (`ui_accept`), definindo-a como `run/main_scene` no `project.godot`.

#### **Issue #29: [Frontend] Refatoração e Estilização da `MainMenu.tscn` (Logo, Reforço UTFPR, Autores e Navegação por Foco de Gamepad)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `scenes/main_menu.tscn` (linhas 1–74), `src/menu/pause_menu.gd`, `src/menu/play_button.gd`, `src/menu/exit_button.gd`.
* **Divergências Identificadas:**
  * `scenes/main_menu.tscn` existe e contém o `TitleLabel` (`"Phagocrisis"`), o `LogoUTFPR` (`sprites/logo_utfpr.png`) e os botões `PlayButton` (`"Jogar"`), `ContinueButton` (`"Continuar"`, visível se `GameState.has_saved_game`), `OptionsButton` (`"Opções"`, sem script conectado) e `ExitButton` (`"Sair"`).
  * Faltam na tela o texto da disciplina/data (`OPT010 — 2026/2`) e os nomes dos 3 autores (exigência do Slide 12 da disciplina).
  * Faltam os botões *Instruções* e *Créditos*, a chamada `play_btn.grab_focus()` para navegação por Gamepad e a ocultação do botão *Sair* na Web (`if OS.has_feature("web"): exit_btn.visible = false`).
* **O que falta para fechar a issue com fidelidade:** Adicionar o rodapé com a data (`2026/2`) e os 3 autores em `scenes/main_menu.tscn`, conectar os botões de *Instruções* e *Créditos*, chamar `grab_focus()` no botão principal e ocultar o botão *Sair* quando `OS.has_feature("web")` for verdadeiro.

#### **Issue #30: [Frontend] Implementação da `InstructionsScreen.tscn` (Esquema Visual Dual Teclado/Mouse + Gamepad e Core Loop)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final; controles exibidos no rodapé do HUD`
* **Status Real no Código:** `Não Implementada` *(com paliativo no rodapé do HUD)*
* **Evidências no Repositório:** `src/Player.gd` (linhas 181–186: `help_lbl` no HUD).
* **Divergências Identificadas:** A cena `scenes/ui/InstructionsScreen.tscn` e o script `src/ui/InstructionsScreen.gd` não existem; atualmente os controles são resumidos em uma linha de texto (`help_lbl`) na posição `(16, 688)` do HUD frugal.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/InstructionsScreen.tscn` e `src/ui/InstructionsScreen.gd` com a tabela comparativa Teclado/Mouse vs. Gamepad e conectá-la ao Menu Principal e ao Menu de Pausa.

#### **Issue #31: [Frontend] Implementação da `CreditsScreen.tscn` (Divisão Formal da Equipe, Atribuições e Referências de Áudio)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A`.
* **Divergências Identificadas:** A cena `scenes/ui/CreditsScreen.tscn` e o script `src/ui/CreditsScreen.gd` não existem no repositório.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/CreditsScreen.tscn` e `src/ui/CreditsScreen.gd` listando as atribuições de Victor Angelo, Lucas Guedin e Lucas Marcão, bem como as referências de áudio e menção à UTFPR.

#### **Issue #32: [Frontend] Refatoração da `PauseOverlay.tscn` (`PROCESS_MODE_WHEN_PAUSED`, Retomar, Instruções e Menu Principal)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 198–200 e `abrir_menu_pausa()`, linhas 214–226); `src/menu/pause_menu.gd` (linhas 1–35); `src/menu/play_button.gd` (linhas 13–22); `src/menu/exit_button.gd` (linhas 19–26).
* **Divergências Identificadas:**
  * O menu de pausa funciona reutilizando `scenes/main_menu.tscn` dentro de um `CanvasLayer` instanciado em `abrir_menu_pausa()` com `PROCESS_MODE_ALWAYS`, bloqueando instâncias duplicadas via `if get_tree().paused: return`. Permite *Continuar* (fecha o overlay), *Reiniciar fase* (`PlayButton`) e *Sair* (salva posição via `GameState.save_current_game()` e volta ao `main_menu.tscn`).
  * Porém, uma vez pausado com `P` ou `ESC`, pressionar `P` ou `ESC` novamente **não despausa** o jogo (é obrigatório clicar com o mouse em `"Continuar"`), não há `grab_focus()` para Gamepad, e não existe a cena dedicada `scenes/ui/PauseOverlay.tscn`.
* **O que falta para fechar a issue com fidelidade:** Permitir despausar pressionando `ESC`/`P`/`Start` dentro de `src/menu/pause_menu.gd`, chamar `continue_button.grab_focus()` ao abrir a pausa e conectar o botão de *Instruções*.

#### **Issue #33: [Frontend] Implementação da `LevelClearScreen.tscn` ("Tecido Purificado", Resumo da Fase e Adaptação Conquistada)**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/GameState.gd` (linhas 33–40: `check_room_victory()`), `src/Player.gd` (linhas 372–377: `notify_room_cleared()`).
* **Divergências Identificadas:**
  * Quando todos os portais (`spawners_alive <= 0`) e inimigos (`enemies_alive <= 0`) são destruídos, `GameState.check_room_victory()` invoca `player.notify_room_cleared()`, que exibe o overlay verde `"TODOS OS PORTAIS E INIMIGOS DESTRUÍDOS!\nFASE CONCLUÍDA! Pressione [R] para Jogar Novamente"` no centro da arena (`hud_status_label`).
  * A cena autônoma `scenes/ui/LevelClearScreen.tscn` e o script `src/ui/LevelClearScreen.gd` (com card de Adaptação Mitótica, tempo decorrido e botão para avançar ao próximo tecido) não existem.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/LevelClearScreen.tscn` e `src/ui/LevelClearScreen.gd` exibindo o resumo da fase, o card da Adaptação Mitótica desbloqueada e o botão de avanço de nível.

#### **Issue #34: [Frontend] Implementação da `GameOverScreen.tscn` ("Falência Imunológica", Tentar Novamente e Menu Principal)**
* **Status Declarado no Documento:** `[x] Concluída no Protótipo`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `src/Player.gd` (linhas 201–204 e 354–360).
* **Divergências Identificadas:**
  * Quando `hp <= 0`, `src/Player.gd` (linhas 354–360) define `_is_dead = true` e exibe no `hud_status_label` sobre a arena o texto `"FALÊNCIA IMUNOLÓGICA (GAME OVER)\nPressione [R] para Tentar Novamente"` em vermelho, permitindo reiniciar a cena com a tecla `R`.
  * A cena autônoma `scenes/ui/GameOverScreen.tscn` e o script `src/ui/GameOverScreen.gd` (com botões navegáveis por Gamepad/Mouse *Tentar Novamente* e *Menu Principal*) não existem.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/GameOverScreen.tscn` e `src/ui/GameOverScreen.gd` com exibição do score atingido e botões *Tentar Novamente* e *Menu Principal*.

#### **Issue #35: [Frontend] Implementação da `VictoryScreen.tscn` ("Expurgo Completo", Estatísticas Finais da Partida e Créditos)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A`.
* **Divergências Identificadas:** A cena `scenes/ui/VictoryScreen.tscn` e o script `src/ui/VictoryScreen.gd` não existem no repositório.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/VictoryScreen.tscn` e `src/ui/VictoryScreen.gd` com estatísticas finais da run, créditos resumidos e botões *Jogar Novamente* e *Menu Principal*.

#### **Issue #36: [Frontend] Sistema Global de Transição entre Cenas (`TransitionLayer.tscn`) com Efeito de Fade In / Fade Out**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (trocas de cena em `src/menu/play_button.gd`, linha 31, e `src/menu/exit_button.gd`, linha 26, chamam `get_tree().change_scene_to_file()` diretamente com corte seco).
* **Divergências Identificadas:** O Autoload `TransitionLayer.tscn` / `src/autoload/TransitionLayer.gd` não existe.
* **O que falta para fechar a issue com fidelidade:** Criar `scenes/ui/TransitionLayer.tscn` e `src/autoload/TransitionLayer.gd` (`layer = 100`, `PROCESS_MODE_ALWAYS`), registrá-lo como Autoload no `project.godot` e substituir as chamadas diretas de `change_scene_to_file()` por `TransitionLayer.change_scene()`.

---

### 🔊 Grupo 6: Curadoria, Síntese e Engenharia de Áudio do Jogador e UI

#### **Issue #37: [Ambiente] Seleção, Síntese (sfxr.me / Audacity) e Edição dos Efeitos Sonoros (SFX) de Combate e Locomoção do Fagócito**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (diretório `audio/sfx/player/` inexistente).
* **Divergências Identificadas:** Nenhum dos 6 arquivos `.wav` do jogador (`sfx_enzyme_shoot.wav`, `sfx_enzyme_concentrated.wav`, `sfx_cytoplasmic_dash.wav`, `sfx_phagocytosis_pickup.wav`, `sfx_player_hurt.wav`, `sfx_player_death.wav`) existe no repositório.
* **O que falta para fechar a issue com fidelidade:** Sintetizar/normalizar os 6 arquivos `.wav` (16-bit PCM, `-3 dBFS`, `loop_mode = Disabled`) e adicioná-los em `audio/sfx/player/`.

#### **Issue #38: [Ambiente] Seleção, Síntese e Padronização dos Efeitos Sonoros (SFX) de Interface, Menus, Alertas e Transições**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (diretório `audio/sfx/ui/` inexistente).
* **Divergências Identificadas:** Nenhum dos 8 arquivos `.wav` de interface (`sfx_ui_focus.wav`, `sfx_ui_confirm.wav`, `sfx_ui_pause.wav`, `sfx_atp_denied.wav`, `sfx_receptor_collected.wav`, `sfx_buff_activated.wav`, `sfx_level_clear.wav`, `sfx_game_over.wav`) existe no repositório.
* **O que falta para fechar a issue com fidelidade:** Sintetizar/normalizar os 8 arquivos `.wav` de UI e adicioná-los em `audio/sfx/ui/`.

#### **Issue #39: [Backend] Arquitetura do Singleton `SoundManager.gd`, Barramentos do `AudioServer` (`Master`, `BGM`, `SFX`) e Pool Polifônico**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (não há `src/autoload/SoundManager.gd` nem `resources/default_bus_layout.tres`).
* **Divergências Identificadas:** O projeto ainda não possui gerenciador de áudio nem barramentos `BGM` e `SFX`.
* **O que falta para fechar a issue com fidelidade:** Criar `src/autoload/SoundManager.gd` com pool polifônico de 12 `AudioStreamPlayer` (`PROCESS_MODE_ALWAYS`), configurar os buses `Master`, `BGM` e `SFX` e registrá-lo como Autoload em `project.godot`.

#### **Issue #40: [Backend] Integração dos Gatilhos Sonoros com Variação de Pitch (`pitch_scale`) no Jogador, Projéteis, HUD e Menus**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (nenhuma chamada de áudio em `src/Player.gd` ou `src/menu/`).
* **Divergências Identificadas:** Os gatilhos sonoros de tiro, dash, coleta, dano, morte e botões de UI não estão conectados.
* **O que falta para fechar a issue com fidelidade:** Invocar `SoundManager.play_sfx()` nos métodos de combate/fagocitose de `src/Player.gd` e `SoundManager.bind_ui_buttons(self)` no `_ready()` das telas de menu.

---

### 🚀 Grupo 7: Integração dos Marcos (Protótipo e Final), Otimização e Builds PC/Web

#### **Issue #41: [Infraestrutura] Integração e Validação do Marco 2 (Protótipo Jogável: 1 Level + Mecânicas do Player + 1 Inimigo/Item + Dual Input)**
* **Status Declarado no Documento:** `[x] Concluída`
* **Status Real no Código:** `Parcial / Divergente` *(100% Funcional no Protótipo `scenes/cena_2d.tscn`, com divergência apenas nos nomes de cenas modulares do DoD)*
* **Evidências no Repositório:** `scenes/cena_2d.tscn`, `src/Player.gd`, `src/PortalSpawner.gd`, `src/Projectile.gd`, `src/DropPickup.gd`, `src/enemy/Enemy1.gd`, `src/enemy/Enemy2.gd`, `src/enemy/Enemy3.gd`.
* **Divergências Identificadas:**
  * Todos os 5 critérios de aceitação do Marco 2 exigidos pela disciplina estão funcionais em `scenes/cena_2d.tscn`: (1) arena completa com paredes `TileMapLayer` na Layer 1; (2) todas as mecânicas do jogador (movimentação 220 px/s, mira 360°, tiro simples/leque, dash com *i-frames* e gasto/regeneração de ATP, coleta magnética); (3) 4 portais spawners destrutíveis + 3 tipos de inimigos com pathfinding `AStarGrid2D` e dano de contato; (4) 2 tipos de drops (`ENERGY_ORB` e `SPREAD_BUFF`) atualizando o HUD; (5) suporte dual Teclado/Mouse + Gamepad.
  * Diverge apenas na estrutura de arquivos citada na seção "Componentes Envolvidos" (`scenes/levels/Level1.tscn`, `scenes/player/Player.tscn`, `scenes/ui/HUD.tscn`, `scenes/ui/PauseOverlay.tscn`), pois está tudo consolidado em `scenes/cena_2d.tscn` e `src/Player.gd`.
* **O que falta para fechar a issue com fidelidade:** Apenas preservar a compatibilidade de `scenes/cena_2d.tscn` quando os subnós forem desacoplados em cenas `.tscn` modulares para o Marco Final.

#### **Issue #42: [Infraestrutura] Auditoria de Performance para 60 FPS (Prevenção de Vazamento de Nós, `VisibleOnScreenNotifier2D` e Profiling)**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `src/Projectile.gd` (linha 33), `src/DropPickup.gd` (linha 34), `src/PortalSpawner.gd` (linha 39).
* **Divergências Identificadas:**
  * Ainda não existe o monitor `src/autoload/PerfMonitor.gd` nem o uso de `VisibleOnScreenNotifier2D` nos projéteis.
  * Embora não haja chamadas `get_node()` dentro de `_process`/`_physics_process` (usa grupos `get_nodes_in_group` e `@onready`), `src/Projectile.gd` (linha 33) percorre `get_tree().get_nodes_in_group("spawners")` a cada frame físico de cada projétil em voo (o que pode ser substituído por colisão nativa de `Area2D` na Layer 3).
* **O que falta para fechar a issue com fidelidade:** Adicionar `VisibleOnScreenNotifier2D` aos projéteis, substituir a iteração por frame de spawners em `src/Projectile.gd` por colisão física (`StaticBody2D`/`Area2D`) e validar `Orphan Nodes = 0` com `PerfMonitor.gd`.

#### **Issue #43: [Infraestrutura] Configuração e Exportação das Builds Desktop PC (Windows `.exe` e Linux `.x86_64`) em Pacote `.zip`**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Parcial / Divergente`
* **Evidências no Repositório:** `export_presets.cfg` (linhas 1–128).
* **Divergências Identificadas:**
  * O arquivo `export_presets.cfg` já existe e define `[preset.0]` (`name="Linux"`, `binary_format/architecture="x86_64"`, `export_path="zLinuxMarcaoLab/appMarcao.x86_64"`) e `[preset.1]` (`name="Windows Desktop"`, `binary_format/architecture="x86_64"`, `export_path="zWinMarcaoLab/labMarcao.exe"`).
  * Os caminhos e nomes dos executáveis ainda usam a nomenclatura antiga (`appMarcao.x86_64` / `labMarcao.exe` em vez de `builds/pc/PhagoCrisis.exe`), o ícone da aplicação não está preenchido no preset (`application/icon=""`) e o pacote final `builds/PhagoCrisis_PC_v1.0.zip` ainda não foi gerado.
* **O que falta para fechar a issue com fidelidade:** Atualizar `export_path` em `export_presets.cfg` para `builds/pc/PhagoCrisis.exe` e `builds/pc/PhagoCrisis.x86_64`, configurar o ícone e gerar `builds/PhagoCrisis_PC_v1.0.zip` na entrega final.

#### **Issue #44: [Infraestrutura] Configuração, Exportação e Validação da Build Web (HTML5) com `SharedArrayBuffer` no Itch.io**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `export_presets.cfg` (linhas 1–6: apenas presets `Android`, `Windows Desktop` e `Linux` estão presentes).
* **Divergências Identificadas:** Não existe preset `Web` configurado em `export_presets.cfg`, nem exportação `builds/web/index.html`.
* **O que falta para fechar a issue com fidelidade:** Adicionar o preset `Web` em `export_presets.cfg` apontando para `builds/web/index.html`, exportar `PhagoCrisis_Web_v1.0.zip` e publicar no Itch.io com *SharedArrayBuffer support* ativo.

#### **Issue #45: [Documentação] Consolidação da Documentação Técnica do Programador A, Licenciamento de Áudios e Checklist de Entrega Final**
* **Status Declarado no Documento:** `[ ] Pendente — Marco Final`
* **Status Real no Código:** `Não Implementada`
* **Evidências no Repositório:** `N/A` (arquivo `README.md` ausente na raiz do repositório).
* **Divergências Identificadas:** Embora existam os documentos de planejamento (`contexto_t_cnico_e_arquitetural_exhaustivo.md` e `especificacao_completa_das_issues.md`), o arquivo `README.md` na raiz do repositório com link do Itch.io, tabela de controles, divisão da equipe e catálogo de licenças de áudio ainda não foi criado.
* **O que falta para fechar a issue com fidelidade:** Criar o `README.md` completo na raiz do projeto e validar o checklist de publicação no Itch.io.

---

## 3. Mapeamento de Débito Técnico e Próximos Passos Imediatos

Para que o protótipo funcional atual (`scenes/cena_2d.tscn`) evolua até **100% de conformidade** com o documento de requisitos da disciplina OPT010 e o Mini GDD **sem quebrar o que já funciona em cena**, recomenda-se executar o plano abaixo em 3 ondas de prioridade:

### 🔴 Prioridade Alta (Requisitos Eliminatórios da Disciplina OPT010 e Contratos de Arquitetura)
1. **Padronização de `InputMap` e Camadas de Física no `project.godot` (Issues #01, #03, #04):**
   * Registrar as 8 camadas `2d_physics/layer_1..8` e as 12 ações de `InputMap` (`move_*`, `aim_*`, `shoot`, `dash`, `interact`, `pause`) com bindings duplos (Teclado/Mouse + Gamepad com deadzone `0.25`), incluindo botão de Dash e Pausa no Gamepad e retenção do último ângulo válido quando o analógico direito voltar ao repouso (Issue #14).
   * Limpar os arquivos residuais de C# (`lab-game-marcao.csproj` e `lab-game-marcao.sln`) e atualizar `config/name="PhagoCrisis"`.
2. **Fluxo Completo de Telas Obrigatórias do Slide 12 (Issues #28, #29, #30, #31, #32, #33, #34, #35, #36):**
   * Criar o Autoload `TransitionLayer.tscn` (`Fade In / Fade Out` de `0.3s`).
   * Criar `SplashScreen.tscn` (`2.0s` com logo da UTFPR) como `run/main_scene`.
   * Completar `scenes/main_menu.tscn` com data (`2026/2`), nomes dos 3 autores, `grab_focus()`, ocultação de *Sair* na Web (`OS.has_feature("web")`) e botões para `InstructionsScreen.tscn` e `CreditsScreen.tscn`.
   * Permitir despausar com `ESC`/`P`/`Start` em `src/menu/pause_menu.gd` e criar as telas `LevelClearScreen.tscn`, `GameOverScreen.tscn` e `VictoryScreen.tscn` (mantendo o atalho `[R]` como opção rápida).
3. **Engenharia de Áudio do Jogador e UI (Issues #37, #38, #39, #40):**
   * Criar a pasta `audio/sfx/player/` (6 arquivos `.wav`) e `audio/sfx/ui/` (8 arquivos `.wav`), implementar o Autoload `SoundManager.gd` (pool polifônico de 12 canais nos barramentos `Master`, `BGM`, `SFX`) e plugar os gatilhos sonoros em `src/Player.gd` e nos botões de menu.
4. **Preset de Exportação Web HTML5 e Builds Finais (Issues #43, #44):**
   * Adicionar o preset `Web` (`builds/web/index.html`) em `export_presets.cfg` e atualizar os caminhos de exportação Desktop (`builds/pc/PhagoCrisis.exe` e `.x86_64`).

### 🟡 Prioridade Média (Alinhamento de Gameplay, VFX, Câmera e Progressão Roguelite)
5. **Câmera, Iluminação 2D e Partículas (Issue #22):**
   * Anexar `Camera2D` suavizada com *Screen Shake* (`0.15s`) ao sofrer dano, `PointLight2D` bioluminescente com textura radial e `GPUParticles2D` para o rastro do dash e respingo de impacto dos projéteis.
6. **Expansão do `src/GameState.gd`, Buffs Temporários de 15s e Adaptações Mitóticas (Issues #05, #16, #20, #21, #27):**
   * Adicionar os sinais granulares e o dicionário `active_adaptations` em `src/GameState.gd` (preservando `stats_updated` e contadores atuais).
   * Implementar os 3 buffs temporários cumulativos de `15.0s` (`damage_shot`, `spread_shot`, `rapid_shot`) com mostrador regressivo no HUD e efeito de *Hurt Vignette*, as 4 Adaptações Mitóticas permanentes pós-chefe e a detecção de Muco Viscoso (`-40%` vel) / Bio-Toxina ($DoT$).
7. **Física Protoplasmática e Temporização de Dash/ATP (Issues #13, #17, #18, #19):**
   * Adicionar interpolação `lerp` (`ACCEL = 10.0`, `FRICTION = 6.0`) na movimentação, delay de `1.0s` antes de regenerar ATP pós-dash, alerta visual/sonoro quando o ATP for insuficiente e unificar a escala de HP/ATP (`100/100` ou manter `6/6` e `30/30` atualizando formalmente a especificação).

### 🟢 Prioridade Baixa (Refatoração Modular de Cenas, Spritesheets Animados e Documentação Final)
8. **Modularização de Cenas e Árvore de Diretórios (Issues #02, #12, #15, #23, #42):**
   * Extrair o `Player`, o `FrugalHUD` e o `Projectile` de `src/Player.gd` para cenas próprias (`scenes/player/Player.tscn`, `scenes/player/EnzymeProjectile.tscn` com `VisibleOnScreenNotifier2D`, `scenes/ui/HUD.tscn`) instanciadas em `scenes/cena_2d.tscn`.
9. **Substituição dos Sprites Estáticos por Spritesheets e Ícones Dedicados (Issues #06, #07, #08, #09, #10, #11):**
   * Criar `phagocyte_spritesheet.png`, `enzyme_projectile_sheet.png`, as texturas de `TextureProgressBar` do HUD e os 7 ícones de upgrades (`32x32 px`), montando os recursos `SpriteFrames` (`.tres`).
10. **Documentação `README.md` e Checklist Final (Issue #45):**
    * Redigir o `README.md` na raiz do repositório consolidando a arquitetura, controles, créditos individuais e licenças de áudio.

