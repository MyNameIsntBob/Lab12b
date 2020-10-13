extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const hurtColor = Color(0.5,0.5,0.5)
const normalColor = Color(1,1,1)

onready var player = find_parent('Player')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$heart1.modulate = normalColor
	$heart2.modulate = normalColor
	$heart3.modulate = normalColor
	
	var hp = player.hp
	
	if hp < 3:
		$heart3.modulate = hurtColor
		if hp < 2:
			$heart2.modulate = hurtColor
			if hp < 1:
				$heart1.modulate = hurtColor 
	
	
	player.hp
