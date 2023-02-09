extends Node2D

export(NodePath) var node_to_instantiate_at
onready var node_tree:Node2D = get_node(node_to_instantiate_at)

var expression = Expression.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    TrashBus.connect("drop_trash", self, "_on_create_trash")


func _on_create_trash(type, location):
    var p 
    if type == "metal":
        p = "res://Assets/Items/MetalTrash.json"
    elif type == "plastic":
        p = "res://Assets/Items/PlasticTrash.json"
    elif type == "glass":
        p = "res://Assets/Items/GlassTrash.json"
    elif type == "electric":
        p = "res://Assets/Items/ElectricTrash.json"
    instantiate_item_at(p, location)
    TrashBus.emit_signal("trash_dropped")


func instantiate_item_at(file_path: String, position: Vector2):
    # Opening json file from path
    var fi = File.new()
    fi.open(file_path, File.READ)
    var json_parsed = JSON.parse(fi.get_as_text())
    var scene = json_parsed.result["scene"]
    
    var item = load(scene).instance()

    var item_parameters = json_parsed.result["parameters"]
    for key in item_parameters:
        var f_name = item_parameters[key]["function"]
        var params = item_parameters[key]["values"]
        item.call(f_name, params[0])

    item.set_global_position(position)
    item.item.set_json_path(file_path)
    node_tree.add_child(item)

# Builds a call string using 'f' as a function name and 'a' as parameters. Best used
# In conjunction with Expression.
#
# Ex: build_call_string_function("sum", [1, 4, 6, 7]) returns "sum(1, 4, 6, 7)"
func build_call_string_function(f: String, a: Array):
    var p = _build_call_string(a, a.size())
    return "{0}{1}".format([f, p])

func _build_call_string(a: Array, s:int):
    var l = a.size()
    if l == 0:
        return ")"
    if l == s and l == 1:
        return "({0})".format([ a[0] ])
    if l == 1:
        var t = _build_call_string(tail(a), s)
        return "{0}{1}".format([ a[0], t ])
    if l < s:
        var t = _build_call_string(tail(a), s)
        return "{0}, {1}".format([ a[0], t ])
    if l == s:
        var t = _build_call_string(tail(a), s)
        return "({0}, {1}".format([ a[0], t ])

func tail(a:Array):
    var l = a.size()
    if l == 0 and l == 1:
        return []
    return a.slice(1, l-1)
