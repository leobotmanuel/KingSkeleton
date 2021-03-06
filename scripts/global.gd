extends Node

#Changed code scene from Godot tutorials! Added function to do fade in/out and level management
var scenedir = "res://scenes/"
var scene_paths = ["Town.tscn", "Catacombs.tscn", "Castle.tscn", "ThroneRoom.tscn", "Credits.tscn"]
var current_scene = null
var scene_index = 0
var next_scene = ""

var elapsed_time = 0.0
var delay_time = 3.0

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	print(current_scene.get_name())


func _fixed_process(delta):
	elapsed_time += delta
	if (elapsed_time > delay_time):
		set_fixed_process(false)
		_deferred_goto_scene(next_scene)

func fade_in():
	get_tree().get_root().get_node("Node2D/CanvasLayer_HUD/fadesprite").show()
	var anim = get_tree().get_root().get_node("Node2D/CanvasLayer_HUD/fadesprite/anim")
	anim.play("fade_in")

func fade_out():
	get_tree().get_root().get_node("Node2D/CanvasLayer_HUD/fadesprite").show()
	var anim = get_tree().get_root().get_node("Node2D/CanvasLayer_HUD/fadesprite/anim")
	anim.play("fade_out")

func repeat_level():
	goto_scene(scenedir + scene_paths[scene_index])

func load_next_level():
	scene_index += 1
	goto_scene(scenedir + scene_paths[scene_index])

func goto_scene(path):
	next_scene = path
	elapsed_time = 0.0
	fade_out()
	set_fixed_process(true)
	#call_deferred("_deferred_goto_scene",path)

func _deferred_goto_scene(path):
    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene
    var s = ResourceLoader.load(path)

    # Instance the new scene
    current_scene = s.instance()

    # Add it to the active scene, as child of root
    get_tree().get_root().add_child(current_scene)

    # optional, to make it compatible with the SceneTree.change_scene() API
    get_tree().set_current_scene( current_scene )

#Exactly the same, but queue free the scene instead of free
func jump_intro(path):

    current_scene.queue_free()

    var s = ResourceLoader.load(path)
    current_scene = s.instance()
    get_tree().get_root().add_child(current_scene)

    get_tree().set_current_scene( current_scene )