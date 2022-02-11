extends Node
class_name StateMachine
signal activated
signal before_updated
signal updated
signal changed_state(prev,current)

onready var current_state = $RootState
export var history_size = 3
var target setget set_target
var state_history = []

# Machine starts once target is set
func set_target(value):
	assert(value)
	target = value
	initialise_states(self)
	init_conditions()
	
	emit_signal("activated")


func init_conditions():
	$TransitConditions.Target = target
	$TransitConditions.root_state = $RootState
	$TransitConditions.SM = self
	


# Sets required parameters for all states via recursion
func initialise_states(root):
	for child in root.get_children():
		if child is State:
			child.Target = target
			child.SM = self
			child.conditions_lib = $TransitConditions
			child._add_transitions()
			child._blacklist_transitions()
#			child.inherit_transitions()
			child.sort_transitions()
			child._on_activate()
			initialise_states(child) # Recurse


func add_to_history(state:State):
	state_history.push_front(state)
	if state_history.size() > history_size:
		state_history.pop_back()


func change_state(new_state:State, allow_reenter=false):
	if current_state != new_state || allow_reenter:
		if new_state.is_leaf():
			current_state._exit()
			new_state._enter()
			var previous_state = current_state
			current_state = new_state
			
			add_to_history(previous_state)
			emit_signal("changed_state",previous_state,current_state)
		else:
			change_state(new_state._choose_substate(), allow_reenter) # Recurse until leaf state


# Change state to the previous state
func pop_state():
		current_state._exit()
		var new_state = state_history.pop_front()
		new_state._enter()
		current_state = new_state
		emit_signal("changed_state")


# Periodically called by the owner/target of the machine,
# from either _process or _physics_process
func update(delta):
	if current_state.is_leaf():
		emit_signal("before_updated")
		current_state._update(delta)
		current_state.try_transition()
		emit_signal("updated")
	else:
		change_state(current_state._choose_substate())
		update(delta)

func previous_state():
	return state_history[state_history.size()-1]
