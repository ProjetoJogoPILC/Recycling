extends Control

signal robot_move_request(position)


func _ready():
    pass


func _process(_delta):
    pass


func _on_MouseArea_gui_input(event):
    if event is InputEventMouseButton:
        if event.is_action_released("move_request"):
            emit_signal("robot_move_request", get_global_mouse_position())
