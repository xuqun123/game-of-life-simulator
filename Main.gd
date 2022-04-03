extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MuteButton_pressed():
	if $AudioStreamPlayer.playing:
		$AudioStreamPlayer.stop()
		$MuteButton.text = "UNMUTE"
	else:
		$AudioStreamPlayer.play()
		$MuteButton.text = "MUTE"


func _on_FollowModeButton_pressed():
	var camera = $Robot.get_node("Camera")
	if !camera.enabled:
		camera.enabled = true
		camera.make_current()
		$FollowModeButton.text = "UNFOLLOW"
	else:
		camera.enabled = false
		camera.clear_current()
		$FollowModeButton.text = "FOLLOW BOT"
