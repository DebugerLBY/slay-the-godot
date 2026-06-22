class_name Enemy
extends Node

var max_health: int
var current_health: int
var armor: int = 0

var name_text: String
var intent: String  # "attack", "defend", "special"
var intent_value: int

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
	# 简单的AI - 随机选择意图
	var actions = ["attack", "defend", "special"]
	intent = actions[randi() % actions.size()]
	intent_value = randi_range(5, 15)

func execute_action(player: Player) -> void:
	match intent:
		"attack":
			player.take_damage(intent_value)
		"defend":
			add_armor(intent_value)
		"special":
			player.take_damage(intent_value / 2)
			add_armor(intent_value / 2)

func is_alive() -> bool:
	return current_health > 0

func reset() -> void:
	current_health = max_health
	armor = 0
	health_changed.emit(current_health)
	armor_changed.emit(armor)
