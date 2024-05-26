extends CharacterBody2D

const SPEED = 700.0

var initial_velocity = Vector2()
var last_paddle_velocity = Vector2()

func _ready():
	
	# 随机选择初始方向
	var random_angle = randf_range(-PI / 4, PI / 4)
	var initial_direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
	
	# 随机决定向左或向右
	if randi() % 2 == 0:
		initial_direction.x *= -1
	
	# 设置初始速度
	initial_velocity = initial_direction * SPEED
	velocity = initial_velocity

func _physics_process(delta):
	# 移动小球并处理碰撞
	var collision = move_and_collide(velocity * delta)

	# 确保球在碰撞后反弹
	if collision:
		var collider = collision.get_collider()
		
		if collider is CharacterBody2D:
			last_paddle_velocity = collider.paddle_velocity
			var angle_change = last_paddle_velocity.y * 0.1  # 调整反弹角度的系数
			velocity = velocity.bounce(collision.get_normal()).rotated(angle_change).normalized() * SPEED
		else:
			velocity = velocity.bounce(collision.get_normal()).normalized() * SPEED
