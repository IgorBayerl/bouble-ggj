extends AudioStreamPlayer3D

# Base settings
const BASE_VOLUME_DB: float = 5  # Adjust main volume here
const PITCH_DEVIATION: float = 0.7  # Deviation range (e.g., ±0.7 from 1.0)
const VOLUME_DEVIATION: float = 1 # Deviation in dB (e.g., ±3 dB)

var last_pitch: float = 1.0
var last_volume: float = BASE_VOLUME_DB

func play_sound():
	# Get new pitch and volume with sufficient variation
	var new_pitch = get_randomized_value(last_pitch, 1.0, PITCH_DEVIATION, 0.1)
	var new_volume = get_randomized_value(last_volume, BASE_VOLUME_DB, VOLUME_DEVIATION, 0.5)

	# Apply changes
	last_pitch = new_pitch
	last_volume = new_volume
	pitch_scale = new_pitch
	volume_db = new_volume

	play()

# Helper function to randomize values while ensuring a minimum difference
func get_randomized_value(last_value: float, base: float, deviation: float, min_diff: float) -> float:
	var new_value: float
	while true:
		new_value = randf_range(base - deviation, base + deviation)
		if abs(new_value - last_value) >= min_diff:
			break
	return new_value
