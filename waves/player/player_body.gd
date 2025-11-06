extends RigidBody2D

func _integrate_forces(state: PhysicsDirectBodyState2D):
	for mover in owner.movers:
		state.linear_velocity = mover.calc_mover_velocity(state.linear_velocity, state.step)
