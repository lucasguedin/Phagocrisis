extends Node

const ACOES_OBRIGATORIAS: Array[StringName] = [
	&"move_left", &"move_right", &"move_up", &"move_down",
	&"aim_left", &"aim_right", &"aim_up", &"aim_down",
	&"shoot", &"dash", &"interact", &"pause"
]

func validate_input_map() -> bool:
	for acao in ACOES_OBRIGATORIAS:
		if not InputMap.has_action(acao):
			push_error("Ação ausente no InputMap: %s" % acao)
			return false
	return true
