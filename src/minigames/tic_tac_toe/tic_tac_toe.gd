extends Minigame

const Cell = preload ("res://src/minigames/tic_tac_toe/cell.tscn")

@export_enum("Human", "AI") var play_with: String = "Human"

var cells: Array = []
var turn: int = 0

var is_game_end: bool = false

var transition_player: AnimationPlayer = null
var reset_game_player: AnimationPlayer = null

func _ready():
    for cell_count in range(9):
        var cell = Cell.instantiate()
        cell.main = self
        $Cells.add_child(cell)
        cells.append(cell)
        cell.cell_updated.connect(_on_cell_updated)
    
    transition_player = get_node_or_null("TransitionPlayer")
    reset_game_player = get_node_or_null("ResetGamePlayer")
    if transition_player:
        if not transition_player.is_connected("animation_finished", _on_animation_player_animation_finished):
            transition_player.connect("animation_finished", _on_animation_player_animation_finished)
            reset_game_player.connect("animation_finished", _reset_game)
    else:
        print("Error: TransitionPlayer no encontrado.")

func _on_cell_updated(cell):
    randomize()
    var match_result = check_match()
    
    if match_result:
        is_game_end = true
        start_win_animation(match_result)
    
    elif play_with == "AI" and turn == 1:
        var ai_cell = cells[randi() % cells.size()]
        if ai_cell.cell_value == "":
            ai_cell.draw_cell()
        else:
            _on_cell_updated(cell)

func check_match():
    for h in range(3):
        if cells[0 + 3 * h].cell_value == "X" and cells[1 + 3 * h].cell_value == "X" and cells[2 + 3 * h].cell_value == "X":
            return ["X", 1 + 3 * h, 2 + 3 * h, 3 + 3 * h]
    for v in range(3):
        if cells[0 + v].cell_value == "X" and cells[3 + v].cell_value == "X" and cells[6 + v].cell_value == "X":
            return ["X", 1 + v, 4 + v, 7 + v]
    if cells[0].cell_value == "X" and cells[4].cell_value == "X" and cells[8].cell_value == "X":
        return ["X", 1, 5, 9]
    elif cells[2].cell_value == "X" and cells[4].cell_value == "X" and cells[6].cell_value == "X":
        return ["X", 3, 5, 7]
    
    for h in range(3):
        if cells[0 + 3 * h].cell_value == "O" and cells[1 + 3 * h].cell_value == "O" and cells[2 + 3 * h].cell_value == "O":
            return ["O", 1 + 3 * h, 2 + 3 * h, 3 + 3 * h]
    for v in range(3):
        if cells[0 + v].cell_value == "O" and cells[3 + v].cell_value == "O" and cells[6 + v].cell_value == "O":
            return ["O", 1 + v, 4 + v, 7 + v]
    if cells[0].cell_value == "O" and cells[4].cell_value == "O" and cells[8].cell_value == "O":
        return ["O", 1, 5, 9]
    elif cells[2].cell_value == "O" and cells[4].cell_value == "O" and cells[6].cell_value == "O":
        return ["O", 3, 5, 7]
    
    var full = true
    for cell in cells:
        if cell.cell_value == "":
            full = false
    
    if full: return ["Draw", 0, 0, 0]

func start_win_animation(match_result: Array):
    var color: Color
    
    if match_result[0] == "X":
        color = Color.BLUE
    elif match_result[0] == "O":
        color = Color.RED
    else:
        color = Color.WHITE
    
    for c in range(3):
        cells[match_result[c + 1] - 1].glow(color)
    
    if transition_player:
        transition_player.play("slide_transition")
    else:
        print("Error: TransitionPlayer no encontrado.")

func _on_animation_player_animation_finished(anim_name):
    Global.game_count += 1
    if anim_name == "slide_transition":
        if Global.game_count > 2:
            Global.game_count = 0
            minigame_ended.emit()
        else:
            _reset_game()

func _reset_game():
    turn = 0
    is_game_end = false
    
    for cell in cells:
        cell.reset() # Llama a la función reset() en cada celda
    
    if transition_player:
        transition_player.play("new_game_init") 
