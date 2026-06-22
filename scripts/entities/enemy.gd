class_name Enemy
extends Node

var max_health: int
var current_health: int
var armor: int = 0

var name_text: String
var intent: String  # "attack", "defend", "special"
var intent_value: int

# AI 参数
var attack_turns: int = 0
var defend_turns: int = 0

signal health_changed(new_health: int)
signal armor_changed(new_armor: int)

func _ready() -> void:
	current_health = max_health

func take_damage(damage: int) -> void:
	var actual_damage = max(0, damage - armor)
	current_health -= actual_damage
	current_health = max(0, current_health)
	health_changed.emit(current_health)

func add_armor(amount: int) -> void:
	armor += amount
	armor_changed.emit(armor)

func plan_action() -> void:
	# 改进的AI - 根据血量和状态选择行为
	var health_percentage = float(current_health) / float(max_health)
	
	# 当血量低于30%时，倾向于防守
	if health_percentage < 0.3:
		if randf() > 0.5:
			intent = "defend"
			intent_value = randi_range(8, 15)
		else:
			intent = "attack"
			intent_value = randi_range(3, 8)
	# 血量在30-60%，平衡攻防
	elif health_percentage < 0.6:
		var choice = randi_range(0, 2)
		match choice:
			0:
				intent = "attack"
				intent_value = randi_range(5, 12)
			1:
				intent = "defend"
				intent_value = randi_range(5, 10)
			2:
				intent = "special"
				intent_value = randi_range(4, 10)
	# 血量充足，主要进攻
	else:
		var choice = randi_range(0, 1)
		if choice == 0:
			intent = "attack"
			intent_value = randi_range(6, 15)
		else:
			intent = "special"
			intent_value = randi_range(5, 12)

func execute_action(player: Player) -> void:
	match intent:
		"attack":
			player.take_damage(intent_value)
		"defend":
			add_armor(intent_value)
		"special":
			player.take_damage(int(intent_value * 0.6))
			add_armor(int(intent_value * 0.4))

func is_alive() -> bool:
	return current_health > 0

func reset() -> void:
	current_health = max_health
	armor = 0
	attack_turns = 0
	defend_turns = 0
	health_changed.emit(current_health)
	armor_changed.emit(armor)
