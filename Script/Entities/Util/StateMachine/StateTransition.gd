extends Resource
class_name StateTransition

var priority:int # Higher numbers are higher priority
var id:String # Unique ID used to blacklist transitions
var target_state:Node
var condition_func:FuncRef
var allow_reenter:bool

func _init(priority, id, target_state,condition_func,allow_reenter=false):
	self.priority = priority
	self.id = id
	self.target_state = target_state
	self.condition_func = condition_func
	self.allow_reenter = allow_reenter
