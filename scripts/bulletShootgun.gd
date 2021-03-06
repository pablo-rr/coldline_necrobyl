extends KinematicBody2D

export var speed = 28
var damage
var direction
var playerPosition
var hit

func _ready():
	damage = 50
	playerPosition = get_parent().get_parent().get_node("player").position
	# la bala aparece en la posicion del jugador
	position = playerPosition
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	hit = false
	randomize()
	var random1 = rand_range(-0.25, 0.25)
	var random2 = rand_range(-0.25, 0.25)
	
	# la variable "dir" es la direccion a la que va a ir la bala
	# "playerPosition" es la posicion inicial (donde esta el jugador)
	# "get_global_mouse_position()" es la posicion final (donde esta puesto el raton)
	# "normalized()" nos devuelve la direccion del vector (velocidad de X y velocidad de Y)
	direction = ((get_global_mouse_position()-playerPosition)).normalized()
	direction.x += random1
	direction.y += random2

func _physics_process(delta):
	# mover la bala en cada Frame
	var collision = move_and_collide(direction*speed)
	if(collision and collision.collider.collision_layer == 2):
		collision.collider.damage(damage)
	if(collision):
		particles(collision)
		waitAndRemoveBullet(0.15)

# funcion para controlar las particulas en un impacto
func particles(coll):
	# cambiar color a rojo si colisiona con un enemigo
	if(coll.collider.collision_layer == 2):
		$hitParticles.color = Color(255, 0, 0)

	$hitParticles.emitting = true

# esperar "wait" para eliminar la bala
func waitAndRemoveBullet(wait):
	if(!hit):
		hit = true
		speed = 0
		$Sprite.visible = false
		remove_child($CollisionShape2D)
		
		$particlesTimer.start()
		yield($particlesTimer, "timeout")
		$hitParticles.emitting = false
		$particlesTimer.wait_time = wait
		
		$particlesTimer.start()
		yield($particlesTimer, "timeout")
		get_parent().remove_child(self)
		