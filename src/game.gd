extends Node

@onready var error_scene: PackedScene = preload ("res://src/errors/error_screen.tscn")
@onready var title_screen: PackedScene = preload ("res://src/intro/title_screen.tscn")

var _token: String = ""
const game_api_url: String = "${GAME_API_URL}"

@onready var _validate_token_request: HTTPRequest = $ValidateTokenRequest
@onready var _send_answers_request: HTTPRequest = $SendAnswersRequest

func _ready():
	if OS.has_feature("web"):
		_token = JavaScriptBridge.eval('''
			let params = new URL(document.location).searchParams;
			let token = params.get("token") ?? 'null';
			token;
		''')
	if _token == 'null':
		add_child(error_scene.instantiate())
		return
	
	var token_json = JSON.stringify({"token": _token})
	_validate_token_request.request("%s/questionnaires/validate-token" % [game_api_url], ["Content-Type: application/json"], HTTPClient.METHOD_POST, token_json)

func _on_questionnaire_questions_answered(answers: Array[Dictionary]):
	var result = {
		"token": _token,
		"answers": answers
	}
	var result_json = JSON.stringify(result)
	_send_answers_request.request("%s/questionnaires/answers" % [game_api_url], ["Content-Type: application/json"], HTTPClient.METHOD_PATCH, result_json)

func _on_validate_token_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	if response_code != 200:
		add_child(error_scene.instantiate())
		return
	
	add_child(title_screen.instantiate())

func _on_send_answers_request_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray):
	#TODO: Mostrar pantalla final
	get_tree().quit()
