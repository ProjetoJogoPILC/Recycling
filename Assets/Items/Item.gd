extends Area2D
class_name Item

export var pickable: bool
export(String)var kind: String setget set_kind, get_kind
export(String, MULTILINE) var desc: String setget set_desc, get_desc
var sprite: Sprite
var preSelect: Sprite


func _init(k: String = kind, can_pick: bool = true):
    set_kind(k)
    pickable = can_pick


func _ready():
    add_to_group(ItemClasses.collectable)
    add_to_group(ItemClasses.resource)
    sprite = get_node("Sprite")
    preSelect = get_node( "PreSelect" )
    de_select()


func set_kind(k:String):
    kind = k


func get_kind():
    return kind


func set_desc(new_desc):
    desc = new_desc


func get_desc():
    return desc


func pre_select():
    preSelect.show()


func de_select():
    preSelect.hide()
