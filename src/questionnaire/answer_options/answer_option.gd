extends TextureButton

class_name AnswerOption

@onready var _tween_manager: TweenManager = $TweenManager
@onready var _gpu_particles: CPUParticles2D = $CPUParticles2D

var is_in_uninterruptible_animation: bool = false
signal uninterruptible_animation(is_in_uninterruptible_animation: bool)

signal in_animation(answer: bool)

func _ready():
    self.pivot_offset = self.size / 2
    self.modulate = Color(1, 1, 1, 0.85)
    connect("mouse_entered", self._on_mouse_entered)
    connect("mouse_exited", self._on_mouse_exited)
    button_down.connect(_play_hover_to_button_down_animation)
    button_up.connect(_play_button_down_to_button_up_animation)
    self._gpu_particles.emitting = false

func _on_mouse_entered():
    self._play_animation("idle_to_hover_animation")

func _on_mouse_exited():
    self._play_animation("hover_to_idle_animation")

func play_idle_to_hover_animation():
    self._play_animation("idle_to_hover_animation")

func play_idle_to_unselected_animation():
    self._play_animation("idle_to_unselected_animation")

func play_hover_to_idle_animation():
    self._play_animation("hover_to_idle_animation")

func _play_hover_to_button_down_animation():
    self._play_animation("hover_to_button_down_animation")

func _play_button_down_to_button_up_animation():
    var tween = self._play_animation("button_down_to_button_up_animation")
    if tween == null:
        return
    
    self.is_in_uninterruptible_animation = true
    self._gpu_particles.emitting = true
    self.uninterruptible_animation.emit(true)
    await tween.finished
    self.is_in_uninterruptible_animation = false
    self.uninterruptible_animation.emit(false)
    self._gpu_particles.emitting = false

func _play_animation(animation_name) -> Tween:
    if self.is_in_uninterruptible_animation:
        return null
    
    self.in_animation.emit(true)
    return _tween_manager.play_animation(animation_name)
