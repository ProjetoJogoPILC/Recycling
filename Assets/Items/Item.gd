class_name Item

var path_to_json: String setget set_json_path, get_json_path
var kind: String setget set_kind, get_kind

func set_json_path(path):
    path_to_json = path

func get_json_path():
    return path_to_json

func set_kind(b):
    kind = b

func get_kind():
    return kind