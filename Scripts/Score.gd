extends Node

var score = 0
var checkpoint = 10000

onready var scoreLabel = $Label
onready var animation = $ScoreAnimation
onready var audio = $Audio

func ChangeScore(points):
	
	score += round(points)
	scoreLabel.bbcode_text = "[center]" + str(score) + "[/center]"

	if score >= checkpoint:
		animation.play("Score")
		audio.play()
		checkpoint += 10000
