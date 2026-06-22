extends Node

var card_templates: Dictionary = {}

func _ready() -> void:
	_initialize_cards()

func _initialize_cards() -> void:
	# 攻击卡
	add_card_template("strike", Card.new("strike", "打击", 1, "damage", 6, "common"))
	add_card_template("bash", Card.new("bash", "猛击", 1, "damage", 8, "common"))
	add_card_template("heavy_blow", Card.new("heavy_blow", "重击", 2, "damage", 12, "rare"))
	add_card_template("pummel", Card.new("pummel", "连击", 1, "damage", 4, "common"))
	
	# 防御卡
	add_card_template("defend", Card.new("defend", "防守", 1, "shield", 5, "common"))
	add_card_template("brace", Card.new("brace", "准备", 1, "shield", 7, "common"))
	add_card_template("barrier", Card.new("barrier", "屏障", 2, "shield", 12, "rare"))
	add_card_template("inflame", Card.new("inflame", "激怒", 1, "strength", 2, "rare"))
	
	# 特殊卡
	add_card_template("draw", Card.new("draw", "思考", 1, "draw", 3, "common"))
	add_card_template("heal", Card.new("heal", "疗愈", 2, "heal", 4, "rare"))
	add_card_template("pummel_strike", Card.new("pummel_strike", "快速打击", 0, "damage", 3, "common"))

func add_card_template(card_id: String, card: Card) -> void:
	card_templates[card_id] = card

func get_card_template(card_id: String) -> Card:
	if card_templates.has(card_id):
		return card_templates[card_id].duplicate()
	else:
		push_error("Card template not found: %s" % card_id)
		return null

func get_all_cards_by_rarity(rarity: String) -> Array[Card]:
	var result: Array[Card] = []
	for card in card_templates.values():
		if card.rarity == rarity:
			result.append(card.duplicate())
	return result

func get_random_card(rarity: String = "") -> Card:
	var cards_to_choose = []
	
	if rarity.is_empty():
		cards_to_choose = card_templates.values()
	else:
		cards_to_choose = get_all_cards_by_rarity(rarity)
	
	if cards_to_choose.is_empty():
		return null
	
	return cards_to_choose[randi() % cards_to_choose.size()].duplicate()
