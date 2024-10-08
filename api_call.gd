extends Node2D

var code = ""
var isReady = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$rateLimit.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	code = $LineEdit.text

func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	print(str(json))
	$airport.text = json["data"][0]["station"]["name"]
	$density.text = "Density: " + str(json["data"][0]["barometer"]["hg"]) + "hg"
	$visibility.text = "Ceiling: " + str(json["data"][0]["visibility"]["meters"]) + " metres"
	$temperature.text = "Temperature: " + str(json["data"][0]["temperature"]["celsius"]) + " degrees Celsius"
	print(str(json["data"][0]))
	$category.text = "Category: " + json["data"][0]["flight_category"]
	$wind.text = "Wind: " + str(json["data"][0]["wind"]["degrees"]) + " degrees @ " + str(json["data"][0]["wind"]["speed_kts"]) + "kts"
	
	isReady = false
	$rateLimit.start()

func _on_call_button_up():
	if not isReady:
		$airport.text = "SLOW DOWN"
		pass
	elif code.length() == 4:
		$HTTPRequest.request("https://api.checkwx.com/metar/" + code + "/decoded?x-api-key=dc420c7f63f741d89aa62b0f34")
	

func _on_rate_limit_timeout():
	isReady = true
