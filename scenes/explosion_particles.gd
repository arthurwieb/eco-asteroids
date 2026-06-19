extends CPUParticles2D

func _ready() -> void:
	emitting = true # 1. A bala bate, o asteroide spawna esse nó, e ESSA linha ativa a explosão instantaneamente!
	
	# 2. O script espera o tempo exato de vida da partícula (propriedade 'lifetime', padrão é 1 segundo)
	await get_tree().create_timer(lifetime).timeout
	
	queue_free() # 3. Após 1 segundo, com a explosão finalizada, o nó se deleta para não pesar no PC
