extends Control

signal robot_move_request(position)
export(NodePath) var root_node
onready var scene:Node2D = get_node(root_node)


func _ready():
    pass


func _process(_delta):
    pass


func _on_MouseArea_gui_input(event):
    if event is InputEventMouseButton:
        if event.is_action_released("move_request"):
            emit_signal("robot_move_request", scene.get_global_mouse_position())
