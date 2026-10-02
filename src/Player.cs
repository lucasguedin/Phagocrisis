using Godot;

public partial class Player : CharacterBody2D
{
	[Export]
	public float Speed = 250.0f;

	private Sprite2D sprite;

	public override void _Ready()
	{
		sprite = GetNode<Sprite2D>("Player");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 direction = Vector2.Zero;

		if (Input.IsKeyPressed(Key.A) || Input.IsKeyPressed(Key.Left))
			direction.X -= 1;

		if (Input.IsKeyPressed(Key.D) || Input.IsKeyPressed(Key.Right))
			direction.X += 1;

		if (Input.IsKeyPressed(Key.W) || Input.IsKeyPressed(Key.Up))
			direction.Y -= 1;

		if (Input.IsKeyPressed(Key.S) || Input.IsKeyPressed(Key.Down))
			direction.Y += 1;

		AtualizarVisual(direction);

		if (direction != Vector2.Zero)
			direction = direction.Normalized();

		Velocity = direction * Speed;

		MoveAndSlide();
	}

	private void AtualizarVisual(Vector2 direction)
	{
		if (direction.X > 0)
		{
			sprite.FlipH = false;
			sprite.RotationDegrees = 0;
		}
		else if (direction.X < 0)
		{
			sprite.FlipH = true;
			sprite.RotationDegrees = 0;
		}
		else if (direction.Y < 0)
		{
			sprite.FlipH = false;
			sprite.RotationDegrees = -90;
		}
		else if (direction.Y > 0)
		{
			sprite.FlipH = false;
			sprite.RotationDegrees = 90;
		}
	}
}
