# PhagoCrisis

**PhagoCrisis** é um jogo 2D top-down no estilo *Twin-Stick Shooter / Roguelite* desenvolvido na **Godot Engine 4** para a disciplina **OPT010 — Desenvolvimento de Jogos** (UTFPR — Câmpus Campo Mourão).

No jogo, você controla uma célula de defesa (fagócito) que precisa avançar por diferentes salas infectadas do organismo, destruindo os ninhos de reprodução viral (spawners) e eliminando os patógenos até enfrentar o chefe da fase, o **Bacteriófago**.

---

## Como Rodar o Jogo

### Pré-requisitos
* **Godot Engine 4.x** (configurado com o renderizador `gl_compatibility`).

### Passo a passo
1. Clone este repositório ou baixe os arquivos do projeto:
   ```bash
   git clone https://github.com/lucasguedin/Phagocrisis.git
   ```
2. Abra a **Godot Engine** e clique em **Importar** (*Import*).
3. Selecione o arquivo `project.godot` na raiz da pasta do projeto.
4. Com o projeto aberto no editor, pressione **F5** (ou clique no botão *Play* no canto superior direito) para iniciar pelo menu principal (`scenes/main_menu.tscn`).

---

## Controles

O jogo suporta tanto **Teclado + Mouse** quanto **Controle (Gamepad)**:

| Ação | Teclado e Mouse | Controle (Gamepad) |
| :--- | :--- | :--- |
| **Movimentar** | `W`, `A`, `S`, `D` ou Setas | Analógico Esquerdo |
| **Mirar** | Cursor do Mouse | Analógico Direito |
| **Atirar (rajada de 3 tiros)** | Botão Esquerdo do Mouse ou `Espaço` | Gatilho Direito (`R2` / `RT`) |
| **Dash (Esquiva)** | `E`, `Shift` ou Botão Direito do Mouse | — |
| **Pausar Jogo** | `P` ou `Esc` | — |
| **Reiniciar Run (Sala 1)** | `R` | — |

---

## O que Fizemos Até Agora (Protótipo da Fase 1)

Atualmente o projeto conta com o protótipo jogável completo da **Fase 1 (Infecção Viral)** estruturado em **5 cenas interligadas**, além do menu inicial e sistema de pausa:

### 1. Jogador e Combate (`src/Player.gd` e `src/Projectile.gd`)
* **Movimentação e Mira 360°:** Movimentação em 8 direções com rotação da arma acompanhando o mouse ou analógico direito.
* **Disparo em Linha Reta (3 tiros por clique):** Cada acionamento dispara uma sequência rápida de 3 tiros em linha reta na direção da mira.
* **Sistema de Dash e ATP:** O dash consome `6` pontos de ATP (barra azul), concede um curto período de invencibilidade e impede que o jogador atravesse os limites da tela. O ATP regenera automaticamente ao longo do tempo.
* **Dano e Invencibilidade:** Ao encostar em inimigos ou ser atingido por tiros, o jogador sofre recuo (*knockback*) e fica piscando invulnerável por alguns instantes.

### 2. Inimigos, Pathfinding e Spawners (`src/enemy/` e `src/PortalSpawner.gd`)
* **Vírus Melee (`src/enemy/Enemy1.gd`):** Inimigo rápido de contato com alcance amplo de detecção. Usa `AStarGrid2D` integrado ao `TileMapLayer` da sala para desviar das paredes e perseguir o jogador.
* **Vírus Atirador (`src/enemy/Enemy2.gd`):** Mantém distância do jogador e dispara projéteis (`src/EnemyProjectile.gd`) periodicamente.
* **Boss Bacteriófago (`src/enemy/Enemy3.gd`):** Chefe da última sala com `42` de vida e barra de HP própria. Alterna entre rajadas triplas direcionadas ao jogador e disparos circulares em 8 direções. Cada tiro do Bacteriófago retira **2 pontos de vida** do jogador.
* **Ninhos / Spawners Destrutíveis (`src/PortalSpawner.gd`):** Existem dois tipos de spawners com sprites próprios — um que gera apenas vírus Melee (`spawner_melee.png`) e outro que gera apenas vírus Atiradores (`spawner_ranged.png`). Eles possuem `10 HP` e precisam ser destruídos para estancar a criação de novos inimigos.
* **Drops Raros (`src/DropPickup.gd`):** Inimigos e portais destruídos têm uma chance baixa de dropar orbes que são puxados magneticamente pelo jogador e recuperam vida e ATP.

### 3. Progressão das 5 Salas (`scenes/sala_1.tscn` a `scenes/sala_5.tscn`)
Para destravar a porta no topo da sala (`door_closed.png` -> `door_open.png`), o jogador precisa destruir todos os spawners e eliminar todos os inimigos da cena atual. Ao encostar na porta aberta, o jogo carrega a próxima cena mantendo os status no `GameState`:
* **Sala 1 (`scenes/sala_1.tscn`):** 2 spawners e inimigos exclusivos do tipo **Melee**.
* **Sala 2 (`scenes/sala_2.tscn`):** 2 spawners e inimigos exclusivos do tipo **Atirador**.
* **Sala 3 (`scenes/sala_3.tscn`):** Sala mista com 4 spawners (2 Melee e 2 Atiradores) e inimigos dos dois tipos.
* **Sala 4 (`scenes/sala_4.tscn`):** **Sala do Tesouro** — contém um baú no centro (`chest_treasure.png`) que aumenta a vida máxima do jogador em `+2` (`8/8`), recupera toda a vida/ATP e dobra o dano dos tiros (`2x`, mudando a cor do tiro para verde).
* **Sala 5 (`scenes/sala_5.tscn`):** **Sala do Chefe** — combate final contra o **Bacteriófago** acompanhado dos spawners e inimigos Melee e Atiradores.

### 4. HUD, Menus e Persistência (`src/GameState.gd` e `src/menu/`)
* **HUD na Cena:** Exibe retrato do protagonista, barras de Vida (vermelha) e ATP (azul), indicador de `LEVEL`, `SALA: X/5`, `SCORE`, contador de portais/inimigos vivos e os quadrados de ícones mostrando **apenas os tipos de inimigos presentes na sala atual**.
* **Menu Principal e Pausa (`scenes/main_menu.tscn`):** Permite iniciar um novo jogo, pausar a partida (`P` ou `Esc`), reiniciar a sala atual ou salvar a posição e voltar ao menu principal com opção de *Continuar*.

---

## Estrutura de Pastas

```text
Phagocrisis/
├── scenes/
│   ├── main_menu.tscn       # Menu inicial e overlay de pausa
│   ├── sala_1.tscn          # Sala 1: Spawners e inimigos Melee
│   ├── sala_2.tscn          # Sala 2: Spawners e inimigos Atiradores
│   ├── sala_3.tscn          # Sala 3: Spawners e inimigos mistos (Melee + Atirador)
│   ├── sala_4.tscn          # Sala 4: Sala do Tesouro (Baú de upgrade)
│   └── sala_5.tscn          # Sala 5: Sala do Boss (Bacteriófago + todos os inimigos)
├── sprites/                 # Sprites em pixel art do jogador, vírus, boss, portais, baú e tiles
├── src/
│   ├── enemy/
│   │   ├── Enemy1.gd        # IA, patrulha, AStarGrid2D e ataque do vírus Melee
│   │   ├── Enemy2.gd        # Comportamento e disparo do vírus Atirador
│   │   └── Enemy3.gd        # Padrões de ataque e barra de vida do Boss Bacteriófago
│   ├── menu/
│   │   ├── exit_button.gd   # Botão de sair / salvar partida ao voltar pro menu
│   │   ├── pause_menu.gd    # Controle do menu principal e tela de pausa
│   │   └── play_button.gd   # Botão de iniciar jogo / reiniciar sala
│   ├── DropPickup.gd        # Orbes de recuperação de vida e ATP
│   ├── EnemyProjectile.gd   # Projéteis disparados pelos inimigos e pelo boss
│   ├── GameState.gd         # Autoload que guarda score, status do player e contagem da sala
│   ├── Player.gd            # Movimentação, mira, rajada de 3 tiros, dash, HUD e transição de salas
│   ├── PortalSpawner.gd     # Ninhos geradores de inimigos (Melee ou Atirador)
│   └── Projectile.gd        # Projétil disparado pelo jogador
└── project.godot            # Configurações do projeto na Godot 4
```
