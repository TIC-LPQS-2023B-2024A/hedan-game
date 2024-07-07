extends Area2D

var card_name = "Empty"
var card_face = preload("res://assets/minigames/memory/box.png")
var card_back = preload("res://assets/minigames/memory/box.png")
var click_enabled = true

func _ready():
    get_node("Sprite").texture = card_back

func _input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
        on_click()

func on_click():
    if click_enabled:
        SfxPlayer.play_sfx("card.wav", -12)
        click_enabled = false
        get_node("Sprite").texture = card_face
        _handle_card_click()

func _handle_card_click():
    var parent = get_parent()
    var card_one_name_node = parent.get_node("CardOneName")
    var card_two_name_node = parent.get_node("CardTwoName")

    if parent.last_try_was_pair:
        parent.last_try_was_pair = false
        parent._reset_card_name_strings_and_check_box()

    if card_one_name_node.text == "Card 1":
        card_one_name_node.text = card_name
        parent.card_one_checked_if_pairing = name
    elif card_two_name_node.text == "Card 2":
        card_two_name_node.text = card_name
        parent.card_two_checked_if_pairing = name
        parent._check_if_pair()
