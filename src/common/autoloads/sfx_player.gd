extends Node

const _sfx_folder = "res://assets/sfx/"

func play_sfx(sfx_name: String, volume_db: float = 0):
    var sfx = load(_sfx_folder + sfx_name)
    var audio_stream_player = AudioStreamPlayer.new()
    audio_stream_player.stream = sfx
    audio_stream_player.volume_db = volume_db
    audio_stream_player.finished.connect(audio_stream_player.queue_free)
    add_child(audio_stream_player)
    audio_stream_player.play()