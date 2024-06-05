extends CharacterBody2D

const INITIAL_SPEED = 300.0
const SPEED_INCREMENT = 50.0
const MIN_X_SPEED = 200.0  # 设置最小横向速度

var speed = INITIAL_SPEED
var initial_velocity = Vector2()
var last_paddle_velocity = Vector2()

# 定义信号
signal score_left
signal score_right

func _ready():
	reset_ball()

func _physics_process(delta):
	if get_tree().root.get_node("Pong Arena").game_over:
		return
	
	# 移动小球并处理碰撞
	var collision = move_and_collide(velocity * delta)

	# 确保球在碰撞后反弹
	if collision:
		var collider = collision.get_collider()
		
		if collider is CharacterBody2D:
			last_paddle_velocity = collider.paddle_velocity
			var angle_change = last_paddle_velocity.y * 0.1  # 调整反弹角度的系数
			velocity = velocity.bounce(collision.get_normal()).rotated(angle_change)
		else:
			velocity = velocity.bounce(collision.get_normal())
		
		# 确保速度保持恒定
		velocity = velocity.normalized() * speed
		
		# 限制最小横向速度
		if abs(velocity.x) < MIN_X_SPEED:
			velocity.x = sign(velocity.x) * MIN_X_SPEED
			velocity = velocity.normalized() * speed
	
	# 检查是否得分
	if global_position.x < 0:
		emit_signal("score_right")
		reset_ball()
	elif global_position.x > get_viewport().get_visible_rect().size.x:
		emit_signal("score_left")
		reset_ball()

func reset_ball():
	# 重置球的位置和速度
	global_position = get_viewport().get_visible_rect().size / 2

	# 增加速度
	speed += SPEED_INCREMENT

	# 随机选择初始方向
	var random_angle = randf_range(-PI / 4, PI / 4)
	var initial_direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
	
	# 随机决定向左或向右
	if randi() % 2 == 0:
		initial_direction.x *= -1
	
	# 设置初始速度
	initial_velocity = initial_direction * speed
	velocity = initial_velocity
