extends MarginContainer

class_name QuestionContainer

@onready var _question_label = $QuestionLabelContainer/QuestionLabel

signal question_changed()

func set_question(question: String):
    var tween = create_tween().set_parallel(true)
    tween.tween_property(self, "position:x", -get_viewport_rect().size.x - self.size.x, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
    await tween.finished

    self.position.x = get_viewport_rect().size.x + self.size.x
    _question_label.text = question

    tween = create_tween().set_parallel(true)
    tween.tween_property(self, "position:x", 0, 0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
    await tween.finished
    question_changed.emit()

func set_initial_question(question: String):
    _question_label.text = question