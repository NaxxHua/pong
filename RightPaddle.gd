extends StaticBody2D

const SPEED = 300.0
var paddle_velocity = Vector2()

# 定义上下边界
const top_boundary = 180
const bottom_boundary = 520

func _physics_process(delta):
	# 确保球存在
	if not get_tree().root.get_node("Pong Arena").game_over:
		# 获取输入方向并处理移动
		var direction = Input.get_axis("ui_up", "ui_down")
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
