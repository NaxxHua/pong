extends Node

const WINNING_SCORE = 1

var left_score = 0
var right_score = 0
var game_over = false

@onready var left_score_label = $LeftScoreLabel
@onready var right_score_label = $RightScoreLabel
@onready var ball = $Ball
@onready var victory_label = $VictoryLabel

func _ready():
	# 连接球的得分信号
	ball.connect("score_left", Callable(self, "_on_score_left"))
	ball.connect("score_right", Callable(self, "_on_score_right"))
	_update_score_labels()
	victory_label.visible = false  # 隐藏胜利标签

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
		_show_victory_message("电脑胜利！你太逊了！")
	elif right_score >= WINNING_SCORE:
		_show_victory_message("玩家胜利！太酷啦！")

func _show_victory_message(message):
	victory_label.text = message
	victory_label.visible = true
	
	# 停止球的物理处理并释放球
	ball.set_physics_process(false)
	ball.queue_free()
	
	# 设置游戏结束标志
	game_over = true
	ball = null  # 确保不再引用球对象
