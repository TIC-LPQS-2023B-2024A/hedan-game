extends Area2D

func _on_body_entered(body: Node2D):
    if body is Coin:
        _handle_coin_death_zone(body)
        return

func _handle_coin_death_zone(coin: Coin):
    coin.queue_free()