class_name LineDrawer extends Node3D

var mesh_instance: MeshInstance3D
var material: StandardMaterial3D

func _ready() -> void:
	mesh_instance = MeshInstance3D.new()
	material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.material_override = material
	add_child(mesh_instance)

func draw_line(start: Vector3, end: Vector3, color: Color) -> void:
	var immediate_mesh = ImmediateMesh.new()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_set_color(color)
	immediate_mesh.surface_add_vertex(start)
	immediate_mesh.surface_add_vertex(end)
	immediate_mesh.surface_end()
	mesh_instance.mesh = immediate_mesh
