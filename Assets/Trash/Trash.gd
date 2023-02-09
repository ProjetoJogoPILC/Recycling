tool
extends Node2D


var item: Item = Item.new()

const trash_types = ["metal", "plastic", "glass", "electric"]
export(String, "metal", "plastic", "glass", "electric") var type
var tool_last_type

onready var sprite = get_node("Sprite")
onready var pre_select_icon = get_node("PreSelect")


func _ready():
    item.set_kind("trash")
    pre_select_icon = get_node("PreSelect")
    update_sprite()
    de_select()


func _process(_delta):
    if Engine.editor_hint:
        if tool_last_type != type:
            sprite = get_node("Sprite")
            set_type(type)
            update_sprite()
            if type == "metal":
                item.set_json_path("res://Assets/Items/MetalTrash.json")
            elif type == "plastic":
                item.set_json_path("res://Assets/Items/PlasticTrash.json")
            elif type == "glass":
                item.set_json_path("res://Assets/Items/GlassTrash.json")
            elif type == "electric":
                item.set_json_path("res://Assets/Items/ElectricTrash.json")
            tool_last_type = type
    else:
        pass


func set_type(n_type):
    if n_type in trash_types:
        type = n_type
        return true
    return false

func update_sprite():
    var i = trash_types.find(type)
    if sprite:
        sprite.set_frame(i)
        return true
    else:
        return false
    

func get_type():
    return type


func pre_select():
    pre_select_icon.show()


func de_select():
    pre_select_icon.hide()
