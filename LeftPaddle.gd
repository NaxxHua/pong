extends StaticBody2D

const SPEED = 100.0
var ball = null
var paddle_velocity = Vector2()

# 定义上下边界
const top_boundary = 180
const bottom_boundary = 520

func _ready():
	# 获取球的节点
	ball = get_node("../Ball")

func _process(delta):
	# 检查球是否在屏幕内
	if ball.global_position.x < 0 or ball.global_position.x > get_viewport_rect().size.x:
		return  # 球飞出屏幕，停止更新球拍位置
	
	# 获取球的 Y 轴位置
	var ball_y = ball.global_position.y
	
	# 计算球拍的目标 Y 轴位置
	var direction = 0.0
	if ball_y > global_position.y:
		direction = 1.0
	elif ball_y < global_position.y:
		direction = -1.0
	
	# 移动球拍
	var new_position = global_position
	var old_position = global_position  # 记录旧位置
	new_position.y += direction * SPEED * delta

	# 限制球拍的上下边界
	if new_position.y < top_boundary:
		new_position.y = top_boundary
	elif new_position.y > bottom_boundary:
		new_position.y = bottom_boundary

	# 设置新的位置
	global_position = new_position

	# 计算球拍的速度
	paddle_velocity = (new_position - old_position) / delta
