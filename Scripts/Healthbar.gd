extends TextureProgress

onready var tween = $Tween

func onHealthUpdated(health):
	value = health
	#tween.interpolate_property(self, "value", value, health, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	#tween.start()

func onMaxHealthUpdated(maxHealth):
	max_value = maxHealth
