extends Node2D


onready var instanceTrash = preload("res://Assets/Trash/Trash.tscn")

func _ready():
    TrashBus.connect("drop_trash", self, "_on_create_trash")


func _on_create_trash(type, location):
    var trash = instanceTrash.instance()
    trash.set_type(type)
    trash.position = location
    var tree = get_node("../")
    tree.add_child(trash)
    TrashBus.emit_signal("trash_dropped")
