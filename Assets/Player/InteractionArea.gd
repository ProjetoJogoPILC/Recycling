extends Area2D

var overlapping_items = []
var selected_item: Node2D setget _set_selected_item, get_selected_item
export(Array) var allowed_item_class
export(NodePath) var get_position
onready var pos:Position2D = get_node(get_position)


func _ready():
    pass # Replace with function body.


func _process(_delta):
    if overlapping_items.size() != 0:
        if overlapping_items.size() > 1:
            overlapping_items.sort_custom(self, "_sortDescendingByDistance")
        _set_selected_item(overlapping_items.back())
        deselect_all()
        selected_item.pre_select()
    else:
        _set_selected_item(null)


func _set_selected_item(x):
    selected_item = x


func get_selected_item():
    return selected_item


func pop_selected_item():
    overlapping_items.pop_back()


func can_pick_up():
    return selected_item != null


func deselect_all():
    for i in overlapping_items:
        i.de_select()


func _on_InteractionArea_area_entered(area):
    for i_class in allowed_item_class:
        if area.is_in_group(i_class):
            overlapping_items.append(area)


func _on_InteractionArea_area_exited(area):
    for i_class in allowed_item_class:
        if area.is_in_group(i_class):
            area.de_select()
            overlapping_items.erase(area)


func _sortDescendingByDistance(a, b):
    var da = pos.global_position.distance_to(a.position)
    var db = pos.global_position.distance_to(b.position)
    if da > db:
        return true
    return false
