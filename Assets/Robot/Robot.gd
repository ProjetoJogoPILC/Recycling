extends KinematicBody2D


onready var pre_select_icon = get_node("PreSelect")

onready var metalDisplay   = get_node("Control/HBoxContainer/VBoxContainer2/metalQtd"  )
onready var plasticDisplay = get_node("Control/HBoxContainer/VBoxContainer2/plasticQtd")
onready var glassDisplay   = get_node("Control/HBoxContainer/VBoxContainer2/glassQtd"  )
onready var eletricDisplay = get_node("Control/HBoxContainer/VBoxContainer2/eletricQtd")

var metal_stored = 0 
var plastic_stored = 0 
var glass_stored = 0 
var eletric_stored = 0


var speed: Vector2 = Vector2.ZERO
var path: Array = []
var moving_to_target = false
var target: Vector2 = Vector2.ZERO

export(float, 0, 600) var maxMovSpeed
export(float, 0, 600) var slowMovSpeed
export(float, 0, 1) var acceleration
export(float, 0, 1) var deacceleration
export(NodePath) var navNode
onready var robotNavigation:Navigation2D = get_node(navNode)
onready var line = $Line2D

onready var sprite = $Sprite
var qtd_sprites

func _ready():
    de_select()
    line.hide()
    qtd_sprites = sprite.hframes

    metalDisplay    = get_node("Control/HBoxContainer/VBoxContainer2/metalQtd"  )
    plasticDisplay  = get_node("Control/HBoxContainer/VBoxContainer2/plasticQtd")
    glassDisplay    = get_node("Control/HBoxContainer/VBoxContainer2/glassQtd"  )
    eletricDisplay  = get_node("Control/HBoxContainer/VBoxContainer2/eletricQtd")
    _update_display()


func _process(_delta):
    sprite_direction()
    

func sprite_direction():
    var t_ang = speed.angle()
    t_ang = 2*PI - t_ang
    var x = t_ang - (PI/qtd_sprites)
    var t = (qtd_sprites * x) / (2 * PI)
    t = abs(int(t) + 1 + qtd_sprites / 4) % qtd_sprites 
    sprite.set_frame(t)


func _physics_process(delta):
    line.global_position = Vector2.ZERO
    if moving_to_target:
        generate_path(target)
        navigate()
        move()


func pre_select():
    pre_select_icon.show()


func de_select():
    pre_select_icon.hide()


func _on_InteractionArea_area_entered(area):
    if area.is_in_group("pickable"):
        var trash = area.get_owner()
        var trash_type = trash.get_type()
        if trash_type == 0:
            metal_stored += 1
        if trash_type == 1:
            plastic_stored += 1
        if trash_type == 2:
            glass_stored += 1
        if trash_type == 3:
            eletric_stored += 1
        trash.queue_free()
        _update_display()

func _update_display():
    metalDisplay  .set_text(str(metal_stored  ))
    plasticDisplay.set_text(str(plastic_stored))
    glassDisplay  .set_text(str(glass_stored  ))
    eletricDisplay.set_text(str(eletric_stored))
    pass

func _on_InteractionArea_area_exited(area):
    pass # Replace with function body.


func navigate():
    if path.size() > 0 and global_position.distance_to(path.back()) > 30:
        var direction = global_position.direction_to(path[1])
        var l = 0.0
        for i in range(1, path.size()):
            l += path[i-1].distance_to(path[i])
        if l > 300:
            speed = speed.linear_interpolate(direction * maxMovSpeed, acceleration)
        else:
            speed = speed.linear_interpolate(direction * slowMovSpeed, deacceleration)
        
        if global_position == path[0]:
            path.pop_front()
    else:
        line.hide()
        speed = Vector2.ZERO
        path.clear()
        moving_to_target = false

func _on_Player_robot_move_request(position):
    line.show()
    speed = Vector2.ZERO
    target = position
    moving_to_target = true


func generate_path(target):
    if robotNavigation != null:
        path = robotNavigation.get_simple_path(global_position, target, true)
        line.points = path


func move():
    speed = move_and_slide(speed)
