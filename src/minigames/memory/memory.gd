# memory.gd
extends Minigame

var card_face
var card_back
var init
var number_of_matches
var default_image
var images = []
var names = []
var last_try_was_pair
var card_one_checked_if_pairing
var card_two_checked_if_pairing
var card_one_string
var card_two_string
var all_remaining_cards = []
var random_card
var card_number

var transition_player: AnimationPlayer = null

@onready var _minigame_ended_message_scene: PackedScene = preload ("res://src/common/messages/minigame_ended_message.tscn")
@onready var _block_control: Control = $BlockControl

func _ready():
	_block_control.visible = false
	_block_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_player = $AnimationPlayer
	_initialize_game()

func _initialize_game():
	number_of_matches = 0
	card_one_string = "Card 1"
	card_two_string = "Card 2"
	last_try_was_pair = false
	default_image = preload ("res://assets/minigames/memory/box.png")

	images = [
		preload ("res://assets/minigames/memory/cat.png"),
		preload ("res://assets/minigames/memory/chicken.png"),
		preload ("res://assets/minigames/memory/fox.png"),
		preload ("res://assets/minigames/memory/mouse.png"),
		preload ("res://assets/minigames/memory/pig.png"),
		preload ("res://assets/minigames/memory/rabbit.png")
	]

	names = ["Cat", "Chicken", "Fox", "Mouse", "Pig", "Rabbit"]
	
	randomize()
	init = false
	_shuffle_cards()

func _process(_delta):
	if !init:
		_shuffle_cards()

func _shuffle_cards():
	all_remaining_cards = range(1, 13)
	var pairs = []
	
	for i in range(6):
		var pair_1 = _get_random_card()
		var pair_2 = _get_random_card()
		pairs.append(pair_1)
		pairs.append(pair_2)
		_assign_image_and_name(pair_1, images[i], names[i])
		_assign_image_and_name(pair_2, images[i], names[i])

	init = true

func _get_random_card():
	random_card = randi() % all_remaining_cards.size()
	card_number = all_remaining_cards[random_card]
	all_remaining_cards.remove_at(random_card)
	return "Card" + str(card_number)

func _assign_image_and_name(card, image, card_name):
	get_node(card).card_face = image
	get_node(card).card_name = card_name

func _check_if_pair():
	if get_node("CardOneName").text == get_node("CardTwoName").text:
		get_node("CheckBox").text = "="
		last_try_was_pair = true
		number_of_matches += 1
		get_node("NumberOfMatches").text = "Number of Matches: " + str(number_of_matches)
		if number_of_matches == 6: # All pairs found
			_end_game()
	elif get_node("CardOneName").text != "Card 1" and get_node("CardTwoName").text != "Card 2":
		if get_node("CardOneName").text != get_node("CardTwoName").text:
			_disable_all_cards_clicks()
			get_node("CheckBox").text = "!="
			var waiting_timer = Timer.new()
			waiting_timer.set_wait_time(1)
			waiting_timer.set_one_shot(true)
			self.add_child(waiting_timer)
			waiting_timer.start()
			await waiting_timer.timeout
			_reset_card_name_strings_and_check_box()
			_turn_around_cards()
			_enable_all_cards_clicks()

func _reset_card_name_strings_and_check_box():
	get_node("CardOneName").text = card_one_string
	get_node("CardTwoName").text = card_two_string
	get_node("CheckBox").text = "?"

func _turn_around_cards():
	var card_one_path = NodePath(card_one_checked_if_pairing)
	var card_two_path = NodePath(card_two_checked_if_pairing)
	get_node(card_one_path).get_node("Sprite").texture = default_image
	get_node(card_two_path).get_node("Sprite").texture = default_image

func _disable_all_cards_clicks():
	for i in range(1, 13):
		get_node("Card"+ str(i)).click_enabled = false

func _enable_all_cards_clicks():
	for i in range(1, 13):
		if get_node("Card"+ str(i)).get_node("Sprite").texture == default_image:
			get_node("Card"+ str(i)).click_enabled = true

func _end_game():
	Global.game_count += 1
	if Global.game_count >= 1:
		Global.game_count = 0
		_block_control.visible = true
		_block_control.mouse_filter = Control.MOUSE_FILTER_STOP
		await _show_win_message()
		minigame_ended.emit()
	else:
		_reset_game()

func _reset_game():
	number_of_matches = 0
	card_one_string = "Card 1"
	card_two_string = "Card 2"
	last_try_was_pair = false
	get_node("NumberOfMatches").text = "Number of Matches: 0"
	_reset_card_name_strings_and_check_box()
	_turn_around_all_cards()
	_shuffle_cards()
	_enable_all_cards_clicks()
	if transition_player:
		transition_player.play("new_game_init")

func _turn_around_all_cards():
	for i in range(1, 13):
		get_node("Card"+ str(i)).get_node("Sprite").texture = default_image

func _show_win_message():
	var minigame_ended_message: MinigameEndedMessage = _minigame_ended_message_scene.instantiate()
	minigame_ended_message.main_text = "¡Muy bien!"
	minigame_ended_message.message_text = "Tienes una memoria increíble."
	add_child(minigame_ended_message)
	await minigame_ended_message.animation_tween().finished
