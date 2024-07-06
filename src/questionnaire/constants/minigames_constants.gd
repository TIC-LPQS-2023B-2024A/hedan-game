extends RefCounted

class_name MinigamesConstants

const memory = "memory"
const coin_collector = "coin_collector"
const tic_tac_toe = "tic_tac_toe"
const simon_says = "simon_says"

const minigames: Array[String] = [
    memory,
    coin_collector,
    tic_tac_toe,
    simon_says
]

const minigames_packed_scenes = {
    memory: preload ("res://src/minigames/memory/memory.tscn"),
    coin_collector: preload ("res://src/minigames/coin_collector/coin_collector.tscn"),
    tic_tac_toe: preload ("res://src/minigames/tic_tac_toe/tic_tac_toe.tscn"),
    simon_says: preload ("res://src/minigames/simon_says/simon_says.tscn"),
}

const minigames_names = {
    memory: "Memoria",
    coin_collector: "Atrapa monedas",
    tic_tac_toe: "Tres en raya",
    simon_says: "Simón dice",
}

const minigames_how_to_play_texts = {
    memory: "Haz clic en una carta para darle la vuelta. Haz clic en otra carta para encontrar la pareja. Continúa hasta encontrar todas las parejas.",
    coin_collector: "Mueve el mouse de izquierda a derecha para mover el cofre a las monedas.",
    tic_tac_toe: "Eres la \"X\" y juegas primero. Usa el mouse para hacer clic en un cuadro vacío. Luego, el bot pondrá una \"O\". Trata de hacer una fila de tres \"X\" seguidas: en línea recta, hacia arriba y abajo, o en diagonal.",
    simon_says: "Escucha atentamente la secuencia de sonidos y repítela en el mismo orden.",
}

const minigames_goals_texts = {
    memory: "Recoje 100 monedas para ganar.",
    coin_collector: "Encuentra todas las parejas de cartas iguales.",
    tic_tac_toe: "",
    simon_says: "Completa 5 secuencias de sonidos para conseguir la victoria."
}

const minigames_tutorial_videos = {
    memory: preload("res://assets/tutorials/memory.ogv"),
    coin_collector: preload("res://assets/tutorials/coin_collector.ogv"),
    tic_tac_toe: preload("res://assets/tutorials/tic_tac_toe.ogv"),
    simon_says: preload("res://assets/tutorials/simon_says.ogv"),
}

const minigame_breakpoints: Array[int] = [10, 20, 30, 40]