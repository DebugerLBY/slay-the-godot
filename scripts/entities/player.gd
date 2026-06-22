class_name Player
extends Node

var max_health: int = 100
var current_health: int
var armor: int = 0
var energy: int = 0
var max_energy: int = 3

var deck: Deck
var hand: Array[Card] = []

signal health_changed(new_health: int)
signal armor_changed(new_armor: int)
signal energy_changed(new_energy: int)

func _ready() -> void:
	current_health = max_health
	deck = Deck.new()
	_initialize_starting_deck()

func _initialize_starting_deck() -> void:
	# 初始卡组
	var card_db = CardDatabase
	deck.add_card(card_db.get_card_template("strike"))
	deck.add_card(card_db.get_card_template("strike"))
	deck.add_card(card_db.get_card_template("defend"))
	deck.add_card(card_db.get_card_template("defend"))
	deck.shuffle_deck()

func take_damage(damage: int) -> void:
	var actual_damage = max(0, damage - armor)
	current_health -= actual_damage
	current_health = max(0, current_health)
	health_changed.emit(current_health)

func add_armor(amount: int) -> void:
	armor += amount
	armor_changed.emit(armor)

func heal(amount: int) -> void:
	current_health += amount
	current_health = min(max_health, current_health)
	health_changed.emit(current_health)

func draw_cards(count: int) -> Array[Card]:
	var drawn = deck.draw_card(count)
	hand.append_array(drawn)
	return drawn

func play_card(card: Card) -> bool:
	if energy < card.cost:
		return false
	
	if card not in hand:
		return false
	
	# 应用卡牌效果
	card.apply_effect(self)
	
	# 移除卡牌并放入弃牌堆
	hand.erase(card)
	deck.discard_card(card)
	
	# 消耗能量
	energy -= card.cost
	energy_changed.emit(energy)
	
	return true

func end_turn() -> void:
	# 清空手牌
	for card in hand:
		deck.discard_card(card)
	hand.clear()
	
	# 重置护甲
	armor = 0
	armor_changed.emit(armor)
	
	# 恢复能量
	energy = max_energy
	energy_changed.emit(energy)

func reset() -> void:
	current_health = max_health
	armor = 0
	energy = max_energy
	hand.clear()
	deck.reset()
	health_changed.emit(current_health)
	armor_changed.emit(armor)
	energy_changed.emit(energy)

func is_alive() -> bool:
	return current_health > 0
