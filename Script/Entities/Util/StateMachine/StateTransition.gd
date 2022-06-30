extends Resource
class_name StateTransition

var priority:int # Higher numbers are higher priority
var id:String # Unique ID used to blacklist transitions
var target_state:Node
var condition_func:FuncRef
var allow_reenter:bool

func _init(_priority, _id, _target_state,_condition_func,_allow_reenter=false):
	self.priority = _priority
	self.id = _id
	self.target_state = _target_state
	self.condition_func = _condition_func
	self.allow_reenter = _allow_reenter
