extends Node
class_name State

var Target
var FSM
var conditions_lib
var transitions = [] # A list of StateTransitions, includes inherited transitions


func _enter():
	pass


func _exit():
	pass


func _add_transitions():
	pass


# If there are transitions you don't want inherited
func _blacklist_transitions():
	# remove_transition("someID")
	# ...
	pass


# Called every frame while the state is active
func _update(_delta):
	pass


# All non-leaf states must override this
func _choose_substate():
	assert(false) # Override this function
#	change_state($substate)


# Pass own transitions to substates
func inherit_transitions():
	for child in get_children():
		if child.has_method("inherit_transitions"):
			child.transitions.append_array(transitions)
			child.inherit_transitions()


func sort_transitions():
	for t in transitions:
		transitions.sort_custom(SortStateTransition,"sort_descending")


func try_transition():
	for t in transitions:
		if t.condition_func.call_func():
			FSM.change_state(t.target_state)
			return


# Leaf in the context of a tree data structure
func is_leaf():
	return (get_child_count() == 0)


func remove_transition(id:String):
	for t in transitions:
		if t.id == id:
			transitions.remove(t)
			return
	push_warning("Cannot find transition to remove: " + id)
