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

var transition_player : AnimationPlayer = null

func _ready():
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
        if number_of_matches == 6:  # All pairs found
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
        get_node("Card" + str(i)).click_enabled = false

func _enable_all_cards_clicks():
    for i in range(1, 13):
        if get_node("Card" + str(i)).get_node("Sprite").texture == default_image:
            get_node("Card" + str(i)).click_enabled = true

func _end_game():
    var animation_player = $AnimationPlayer
    animation_player.play("slide_transition")
    animation_player.connect("animation_finished", _reload_scene)

func _reload_scene(_anim_name):
    get_tree().reload_current_scene()

