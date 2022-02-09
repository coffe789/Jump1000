extends Object
class_name SortStateTransition

static func sort_descending(a,b):
	if a.priority > b.priority:
		return true
	return false
