class_name Card
extends Resource

@export var card_id: String
@export var card_name: String
@export var description: String
@export var cost: int
@export var effect_type: String  # "damage", "shield", "draw", etc.
@export var effect_value: int
@export var rarity: String  # "common", "rare", "epic", "legendary"
@export var is_upgraded: bool = false

var upgrades: Dictionary = {
	"cost": 0,
	"effect_value": 0,
	"description": ""
}

func _init(p_id = "", p_name = "", p_cost = 0, p_effect_type = "", p_effect_value = 0, p_rarity = "common"):
	card_id = p_id
	card_name = p_name
	cost = p_cost
	effect_type = p_effect_type
	effect_value = p_effect_value
	rarity = p_rarity

func apply_effect(target: Node) -> void:
	match effect_type:
		"damage":
			if target.has_method("take_damage"):
				target.take_damage(effect_value)
		"shield":
			if target.has_method("add_armor"):
				target.add_armor(effect_value)
		"draw":
			if target.has_method("draw_cards"):
				target.draw_cards(effect_value)
		"heal":
			if target.has_method("heal"):
				target.heal(effect_value)

func upgrade() -> void:
	is_upgraded = true
	# 升级后效果值增加20%
	effect_value = int(effect_value * 1.2)
	# 如果有升级成本，成本减1
	if cost > 0:
		cost -= 1

func get_display_text() -> String:
	return "%s\n成本: %d\n%s" % [card_name, cost, description]
