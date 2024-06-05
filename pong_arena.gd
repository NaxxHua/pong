extends Node

var left_score = 0
var right_score = 0

@onready var left_score_label = $LeftScoreLabel
@onready var right_score_label = $RightScoreLabel
@onready var ball = $Ball

func _ready():
	# 连接球的得分信号
	ball.connect("score_left", Callable(self, "_on_score_left"))
	ball.connect("score_right", Callable(self, "_on_score_right"))
	_update_score_labels()

func _on_score_left():
	left_score += 1
	_update_score_labels()

func _on_score_right():
	right_score += 1
	_update_score_labels()

func _update_score_labels():
	left_score_label.text = str(left_score)
	right_score_label.text = str(right_score)
