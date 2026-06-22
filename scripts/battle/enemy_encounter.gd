class_name EnemyEncounter
extends Node

class EnemyType:
	var name: String
	var max_health: int
	var attack_pattern: Array[String]
	var attack_values: Array[int]
	
	func _init(p_name: String, p_health: int, p_pattern: Array[String], p_values: Array[int]):
		name = p_name
		max_health = p_health
		attack_pattern = p_pattern
		attack_values = p_values

var enemy_types: Dictionary = {}

func _ready() -> void:
	_initialize_enemies()

func _initialize_enemies() -> void:
	# 哥布林 - 弱敌人
	enemy_types["goblin"] = EnemyType.new(
		"哥布林",
		40,
		["attack", "attack", "defend"],
		[5, 6, 4]
	)
	
	# 巨人 - 中等敌人
	enemy_types["giant"] = EnemyType.new(
		"巨人",
		60,
		["attack", "attack", "special"],
		[8, 8, 10]
	)
	
	# 邪恶法师 - 强敌人
	enemy_types["evil_mage"] = EnemyType.new(
		"邪恶法师",
		50,
		["attack", "special", "attack", "defend"],
		[6, 12, 7, 5]
	)

func get_enemy_type(enemy_id: String) -> EnemyType:
	if enemy_types.has(enemy_id):
		return enemy_types[enemy_id]
	return enemy_types["goblin"]

func create_enemy_from_type(enemy_id: String) -> Enemy:
	var enemy_type = get_enemy_type(enemy_id)
	var enemy = Enemy.new()
	enemy.max_health = enemy_type.max_health
	enemy.current_health = enemy_type.max_health
	enemy.name_text = enemy_type.name
	return enemy
