extends Node

# IMPORTANT! will not work without initializing GdSerial
# starter code is based off of initial code that came with GdSerial 
var serial: GdSerial

# replace with your own signal
signal sent_message(variable_1, variable_2)

# timer to limit responses
@onready var timer = $Timer

# to initialize port names through the inspector. Default is COM9
@export var port: String = "COM9"

func _ready():
	serial = GdSerial.new()
	
	# list available ports
	var ports = serial.list_ports()
	
	# configure and connect
	serial.set_port(port)  
	serial.set_baud_rate(9600)
	
	if serial.open():
		timer.start()

# every 0.25 seconds, read serial inputs
func _on_timer_timeout() -> void:
	# check if anything has been sent over serial
	var bytesRead = serial.bytes_available()
	
	# if a serial line has been read!
	if bytesRead != 0:
		
		# the exact line read
		var serial_message = serial.readline()
		
		# splitting the message into different variables (if sending multiple variables)
		var split_response = serial_message.split(",")
		var variable_1 = int(split_response[0])
		var variable_2 = int(split_response[1])
		
		# emit signal that carries these variables 
		emit_signal("variable_1", variable_1, variable_2)
		
		# reset bytes 
		bytesRead = 0
