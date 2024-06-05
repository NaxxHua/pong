extends Node

const WINNING_SCORE = 5

var left_score = 0
var right_score = 0
var game_over = false

@onready var left_score_label = $LeftScoreLabel
@onready var right_score_label = $RightScoreLabel
@onready var ball = $Ball
@onready var victory_label = $VictoryLabel
@onready var restart_button = $RestartButton

func _ready():
	# 连接球的得分信号
	ball.connect("score_left", Callable(self, "_on_score_left"))
	ball.connect("score_right", Callable(self, "_on_score_right"))
	
	# 连接按钮的按下信号
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	
	_update_score_labels()
	victory_label.visible = false  # 隐藏胜利标签
	restart_button.visible = false  # 隐藏重新开始按钮

func _on_score_left():
	if not game_over:
		left_score += 1
		_update_score_labels()
		_check_victory()

func _on_score_right():
	if not game_over:
		right_score += 1
		_update_score_labels()
		_check_victory()

func _update_score_labels():
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)

func _check_victory():
	if left_score >= WINNING_SCORE:
		_show_victory_message("玩家胜利")
	elif right_score >= WINNING_SCORE:
		_show_victory_message("电脑胜利")

func _show_victory_message(message):
	victory_label.text = message
	victory_label.visible = true
	
	# 停止球的物理处理并隐藏球
	ball.set_physics_process(false)
	ball.hide()
	
	# 设置游戏结束标志
	game_over = true
	
	# 显示重新开始按钮
	restart_button.visible = true

func _on_restart_button_pressed():
	_restart_game()

func _restart_game():
	# 重置游戏状态
	left_score = 0
	right_score = 0
	game_over = false
	_update_score_labels()
	victory_label.visible = false
	restart_button.visible = false

	# 重置球的位置和速度
	ball.global_position = get_viewport().get_visible_rect().size / 2
	ball.show()
	ball.set_physics_process(true)
	ball.speed = ball.INITIAL_SPEED  # 重置速度
	ball.reset_ball()  # 调用ball的reset_ball方法重新初始化速度和方向
