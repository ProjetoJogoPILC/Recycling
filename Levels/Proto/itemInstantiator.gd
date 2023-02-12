extends Node2D

export(NodePath) var node_to_instantiate_at
onready var node_tree:Node2D = get_node(node_to_instantiate_at)

var expression = Expression.new()

# Called when the node enters the scene tree for the first time.
func _ready():
    ItemBus.connect("drop_item", self, "_on_create_item")


func _on_create_item(item_scene, location):
    var item = load(item_scene).instance()
    item.set_global_position(location)
    node_tree.add_child(item)
    ItemBus.emit_signal("item_dropped")
