using Godot;
using System.Collections.Generic;

public partial class Enemy2 : CharacterBody2D
{
	private enum Estado
	{
		Patrulha,
		Perseguindo
	}


	// CONFIGURAÇÕES


	[ExportGroup("Movimento")]

	[Export]
	public float PatrolSpeed = 60.0f;

	[Export]
	public float ChaseSpeed = 80.0f;

	[Export]
	public float Acceleration = 300.0f;

	[Export]
	public float Deceleration = 400.0f;


	[ExportGroup("Detecção do Player")]

	[Export]
	public float DetectionDistance = 96.0f;

	[Export]
	public float LoseDistance = 160.0f;

	[Export]
	public float StopDistance = 20.0f;


	[ExportGroup("Patrulha")]

	[Export]
	public float MinPatrolTime = 1.0f;

	[Export]
	public float MaxPatrolTime = 10.0f;



	// VARIÁVEIS INTERNAS


	private Estado estado = Estado.Patrulha;

	private Node2D player;

	private Vector2 patrolDirection = Vector2.Right;

	private float patrolTimer = 0.0f;

	private Vector2 lastPatrolDirection = Vector2.Zero;

	private RandomNumberGenerator random = new RandomNumberGenerator();



	// INICIALIZAÇÃO


	public override void _Ready()
	{
		random.Randomize();

		EncontrarPlayer();

		EscolherNovaPatrulha();
	}



	// LOOP PRINCIPAL


	public override void _PhysicsProcess(double delta)
	{
		float dt = (float)delta;

		if (player == null)
		{
			ProcurarPlayerNovamente();
		}

		if (player != null)
		{
			AtualizarEstado();
		}

		switch (estado)
		{
			case Estado.Patrulha:
				AtualizarPatrulha(dt);
				break;

			case Estado.Perseguindo:
				AtualizarPerseguicao(dt);
				break;
		}

		MoveAndSlide();

		// Se estava patrulhando e bateu numa parede,
		// muda de direção imediatamente.
		if (estado == Estado.Patrulha && GetSlideCollisionCount() > 0)
		{
			ReagirAColisao();
		}
	}



	// PLAYER


	private void EncontrarPlayer()
	{
		player = GetTree().GetFirstNodeInGroup("player") as Node2D;

		if (player == null)
		{
			GD.PrintErr(
				"Fann: não foi possível encontrar o Player. 2" +
				"Certifique-se de que ele está no grupo 'player'."
			);
		}
	}


	private void ProcurarPlayerNovamente()
	{
		player = GetTree().GetFirstNodeInGroup("player") as Node2D;
	}



	// ESTADO DA IA


	private void AtualizarEstado()
	{
		float distancia = GlobalPosition.DistanceTo(
			player.GlobalPosition
		);


		// PATRULHA -> PERSEGUIÇÃO


		if (estado == Estado.Patrulha)
		{
			if (distancia <= DetectionDistance)
			{
				estado = Estado.Perseguindo;
			}
		}


		// PERSEGUIÇÃO -> PATRULHA


		else if (estado == Estado.Perseguindo)
		{
			if (distancia > LoseDistance)
			{
				estado = Estado.Patrulha;

				EscolherNovaPatrulha();
			}
		}
	}



	// PATRULHA


	private void AtualizarPatrulha(float delta)
	{
		patrolTimer -= delta;

		// Tempo da patrulha acabou.
		if (patrolTimer <= 0.0f)
		{
			EscolherNovaPatrulha();
		}

		Vector2 velocidadeDesejada =
			patrolDirection * PatrolSpeed;

		Velocity = AproximarVelocidade(
			Velocity,
			velocidadeDesejada,
			Acceleration,
			delta
		);
	}



	// ESCOLHER NOVA PATRULHA


	private void EscolherNovaPatrulha()
	{
		Vector2 novaDirecao = GerarDirecaoAleatoria();

		patrolDirection = novaDirecao;

		lastPatrolDirection = novaDirecao;

		patrolTimer = random.RandfRange(
			MinPatrolTime,
			MaxPatrolTime
		);
	}


	private Vector2 GerarDirecaoAleatoria()
	{
		List<Vector2> direcoes = new List<Vector2>
		{
			Vector2.Left,
			Vector2.Right,
			Vector2.Up,
			Vector2.Down
		};

		// Evita escolher imediatamente a mesma direção.
		if (lastPatrolDirection != Vector2.Zero)
		{
			direcoes.Remove(lastPatrolDirection);
		}

		int indice = random.RandiRange(
			0,
			direcoes.Count - 1
		);

		return direcoes[indice];
	}



	// COLISÃO DURANTE A PATRULHA


	private void ReagirAColisao()
	{
		if (GetSlideCollisionCount() == 0)
		{
			return;
		}

		KinematicCollision2D colisao =
			GetSlideCollision(0);

		Vector2 normal =
			colisao.GetNormal();

		List<Vector2> direcoesValidas =
			new List<Vector2>();

		Vector2[] direcoes =
		{
			Vector2.Left,
			Vector2.Right,
			Vector2.Up,
			Vector2.Down
		};

		foreach (Vector2 direcao in direcoes)
		{
			// Não escolhe uma direção que continue
			// empurrando o fantasma contra a parede.
			if (direcao.Dot(normal) > 0.1f)
			{
				// Também evita simplesmente voltar para
				// a mesma direção anterior.
				if (direcao != lastPatrolDirection)
				{
					direcoesValidas.Add(direcao);
				}
			}
		}

		// Caso nenhuma direção seja considerada válida,
		// usa qualquer direção diferente da anterior.
		if (direcoesValidas.Count == 0)
		{
			foreach (Vector2 direcao in direcoes)
			{
				if (direcao != lastPatrolDirection)
				{
					direcoesValidas.Add(direcao);
				}
			}
		}

		int indice = random.RandiRange(
			0,
			direcoesValidas.Count - 1
		);

		patrolDirection =
			direcoesValidas[indice];

		lastPatrolDirection =
			patrolDirection;

		// Reinicia o tempo da nova patrulha.
		patrolTimer = random.RandfRange(
			MinPatrolTime,
			MaxPatrolTime
		);
	}



	// PERSEGUIÇÃO


	private void AtualizarPerseguicao(float delta)
	{
		if (player == null)
		{
			return;
		}

		Vector2 distancia =
			player.GlobalPosition - GlobalPosition;

		float distanciaAtual =
			distancia.Length();

		// Já chegou suficientemente perto.
		// Para de avançar, evitando ficar grudado no Player.
		if (distanciaAtual <= StopDistance)
		{
			Velocity = AproximarVelocidade(
				Velocity,
				Vector2.Zero,
				Deceleration,
				delta
			);

			return;
		}

		Vector2 direcao =
			distancia.Normalized();

		Vector2 velocidadeDesejada =
			direcao * ChaseSpeed;

		Velocity = AproximarVelocidade(
			Velocity,
			velocidadeDesejada,
			Acceleration,
			delta
		);
	}



	// ACELERAÇÃO / DESACELERAÇÃO


	private Vector2 AproximarVelocidade(
		Vector2 atual,
		Vector2 desejada,
		float aceleracao,
		float delta
	)
	{
		return atual.MoveToward(
			desejada,
			aceleracao * delta
		);
	}
}
