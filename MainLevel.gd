extends Node2D

var debug: bool = true

onready var ship = $UiControl/VBoxContainer/ViewportContainer/Viewport/Spatial/Spatial/Satellite
onready var gimbal = $UiControl/VBoxContainer/HBoxContainer/ViewportContainer/Viewport/Spatial/Gimbal
onready var satCross = $satCrosshair
onready var ray = $UiControl/VBoxContainer/ViewportContainer/Viewport/Spatial/Spatial/Satellite/RayCast
onready var collShape = $UiControl/VBoxContainer/ViewportContainer/Viewport/Spatial/Spatial/Area/CollisionShape
onready var box = collShape.get_shape()
onready var satCluster = $UiControl/VBoxContainer/ViewportContainer/Viewport/Spatial/Spatial
onready var targetBearing = ship.transform.basis.z
var rollRate = PI * -0.01
var pitchRate = PI * 0.01
var rotAccel = 0.60
var pitchMod = 0
var rollMod = 0
var count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if debug:
		rollRate = 0
		pitchRate = 0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var sliderVal = $UiControl/VBoxContainer/HBoxContainer/GridContainer/HSlider.value
#	$UiControl/VBoxContainer/ViewportContainer.stretch_shrink = sliderVal
#	$UiControl/VBoxContainer/ViewportContainer.stretch_shrink = round(range_lerp(abs(rad2deg(Vector3(0, -1, 0).angle_to(ray.cast_to.rotated(Vector3(-1, 0, 0), deg2rad(90))))), 0, 180, 1, 10))

	# https://docs.godotengine.org/en/3.2/tutorials/3d/using_transforms.html
	var bearing = ship.transform.basis.z
	var angle_to_earth = abs(rad2deg(targetBearing.angle_to(bearing)))
	$UiControl/VBoxContainer/ViewportContainer.stretch_shrink = round(range_lerp(angle_to_earth, 0, 180, 1, 10))
	
	satCross.global_position[0] = range_lerp(ray.get_collision_point()[0], satCluster.translation[0] - box.extents[0], satCluster.translation[0] + box.extents[0], 9, 93)
	satCross.global_position[1] = range_lerp(ray.get_collision_point()[2], satCluster.translation[2] - box.extents[2], satCluster.translation[2] + box.extents[2], 207, 291)
	count += 1
	if count % 10 == 0:
		print(str(bearing) + ' ' + str(targetBearing))
		print(angle_to_earth)
	pass


func _physics_process(delta):
	pitchRate += pitchMod * rotAccel * delta
	rollRate += rollMod * rotAccel * delta
	ship.rotate_object_local(Vector3(0, 1, 0), rollRate * delta)
	ship.rotate_object_local(Vector3(1, 0, 0), pitchRate * delta)
	
	gimbal.transform = ship.transform


func _input(event):
	if event.is_action_pressed("pitch_neg"):
		pitchMod -= 1
	if event.is_action_pressed("pitch_pos"):
		pitchMod += 1
	if event.is_action_pressed("roll_pos"):
		rollMod += 1
	if event.is_action_pressed("roll_neg"):
		rollMod -= 1
	if event.is_action_released("pitch_neg"):
		pitchMod += 1
	if event.is_action_released("pitch_pos"):
		pitchMod -= 1
	if event.is_action_released("roll_pos"):
		rollMod -= 1
	if event.is_action_released("roll_neg"):
		rollMod += 1
	pass
