extends RigidBody2D

var interactables: Array = []

func _integrate_forces(state: PhysicsDirectBodyState2D):
	for mover in owner.movers:
		state.linear_velocity = mover.calc_mover_velocity(state.linear_velocity, state.step)

func enter_range(interactable):
	interactables.push_back(interactable)
	
func exit_range(interactable):
	interactables.erase(interactable)
