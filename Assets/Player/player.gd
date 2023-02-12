extends KinematicBody2D


export(float, 0, 1500) var max_speed
export(float, 0, 1   ) var acceleration
export(float, 0, 1   ) var deacceleration
export(int  , 0, 10  ) var inventory_size

var speed = Vector2.ZERO
var inventory = []
var can_drop_item_in_robot = false
var item_pickup_area: Area2D
onready var anim: AnimationTree = $AnimationTree

func _ready():
    ItemBus.connect("item_dropped", self, "_item_dropped_signal")
    item_pickup_area = get_node("InteractionArea")


func _process(_delta):
    _movement()
    if not _item_pick():
        _item_drop()


func _movement():
    var direction = Vector2.ZERO
    if Input.is_action_pressed("move_up"):
        direction += Vector2( 0, -1);
    if Input.is_action_pressed("move_down"):
        direction += Vector2( 0, +1);
    if Input.is_action_pressed("move_left"):
        direction += Vector2(-1,  0);
    if Input.is_action_pressed("move_right"):
        direction += Vector2( 1,  0);
    
    if direction.length() != 0:
        anim.get("parameters/playback").travel("running")
        anim.set("parameters/running/blend_position", direction)
        anim.set("parameters/still/blend_position", direction)
        speed = speed.linear_interpolate(direction.normalized() * max_speed, acceleration)
    else:
        speed = speed.linear_interpolate(direction.normalized(), deacceleration)
    
    speed = move_and_slide(speed)
    if speed.length() < 50:
        anim.get("parameters/playback").travel("still")


func _item_pick():
    if item_pickup_area.can_pick_up() and inventory.size() < inventory_size:
        if Input.is_action_just_released("ui_accept"):
            var item_filename = item_pickup_area.get_selected_item().filename
            inventory.append(item_filename)
            ItemBus.emit_signal("item_pickup", item_filename)
            item_pickup_area.get_selected_item().queue_free()
            return true
    return false


func _item_drop():
    if inventory.size() > 0 and Input.is_action_just_released("ui_accept"):
        ItemBus.emit_signal("drop_item", inventory.back(), self.global_position)


func _item_dropped_signal():
    inventory.pop_back()
