extends KinematicBody2D


export(float, 0, 1500) var max_speed      = 272
export(float, 0, 1   ) var acceleration   = 0.2
export(float, 0, 1   ) var deacceleration = 0.7
export(int  , 0, 10  ) var iventory_size  = 1

var speed = Vector2.ZERO
var overlapping_items = []
var iventory = []
var can_drop_item_in_robot = false



func _ready():
    TrashBus.connect("trash_dropped", self, "_trash_dropped_signal")
    pass


func _process(_delta):
    _movement()
    if not _item_pick():
        _item_drop()


func _movement():
    var direction = Vector2.ZERO
    if Input.is_action_pressed("ui_up"):
        direction += Vector2( 0, -1);
    if Input.is_action_pressed("ui_down"):
        direction += Vector2( 0, +1);
    if Input.is_action_pressed("ui_left"):
        direction += Vector2(-1,  0);
    if Input.is_action_pressed("ui_right"):
        direction += Vector2( 1,  0);

    if direction.length() != 0:
        speed = speed.linear_interpolate(direction * max_speed, acceleration)
    else:
        speed = speed.linear_interpolate(direction * max_speed, deacceleration)
    speed = move_and_slide(speed)


func _on_InteractionArea_area_entered(area):
    if area.is_in_group("pickable"):
        overlapping_items.append(area.get_owner())
    elif area.is_in_group("robot"):
        area.get_owner().pre_select()
        can_drop_item_in_robot = true


func _on_InteractionArea_area_exited(area):
    if area.is_in_group("pickable"):
        area.get_owner().de_select()
        overlapping_items.erase(area.get_owner())
    elif area.is_in_group("robot"):
        area.get_owner().de_select()
        can_drop_item_in_robot = false


func _item_pick():
    if overlapping_items.size() != 0 and iventory.size() < iventory_size:
        ##################################
        # Sorts item by distance to player to remove confusion
        # when selecting Items from the floor
        overlapping_items.sort_custom(self, "_sortDescendingByDistance")
        var selected_item = overlapping_items.back()
        for item in overlapping_items:
            item.de_select()
        selected_item.pre_select()
        ##################################
        if Input.is_action_just_released("ui_accept"):
            iventory.append(selected_item.get_type())
            selected_item.de_select()
            selected_item.queue_free()
            return true
    return false


func _item_drop():
    if iventory.size() > 0 and Input.is_action_just_released("ui_accept"):
        TrashBus.emit_signal("drop_trash", iventory.back(), self.global_position)


func _trash_dropped_signal():
    iventory.pop_back()
    

func _sortDescendingByDistance(a, b):
    var da = position.distance_to(a.position)
    var db = position.distance_to(b.position)
    if da > db:
        return true
    return false
