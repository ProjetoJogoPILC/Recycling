extends Node2D

export(NodePath) var node_to_instantiate_at
onready var node_tree:Node2D = get_node(node_to_instantiate_at)

# Called when the node enters the scene tree for the first time.
func _ready():
    instantiate_item_at("res://Assets/Items/ElectricTrash.json", self.global_position)


func instantiate_item_at(file_path: String, position: Vector2):
    # Opening json file from path
    var fi = File.new()
    fi.open(file_path, File.READ)
    var json_parsed = JSON.parse(fi.get_as_text())
    var scene = json_parsed.result["scene"]
    
    # The block below loads the scene and calls each function and parameters 
    # on it as defined in the json file.
    var item = load(scene).instance()
    item.set_type("electric")
    var item_parameters = json_parsed.result["parameters"]
    for key in item_parameters:
        var f_name = item_parameters[key]["function"]
        var params = item_parameters[key]["values"]
        var call_string:String = build_call_string_function(f_name, params)
        call_string = "item." + call_string 
        var expression = Expression.new()
        var parse_success = expression.parse(call_string, [])
        if parse_success != OK:
            print("Error, cant parse \"" + call_string + "\"!" )
            return
        else:
            expression.execute()
    
    # add the json path to the item and add instance 
    # into the scene at the desired position
    item.item.set_json_path(file_path)
    item.set_global_position(position)
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
