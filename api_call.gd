extends Node2D

var code = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	code = $LineEdit.text

func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	$density.text = "Density: " + str(json["data"][0]["barometer"]["hg"]) + "hg"
	$ceiling.text = "Ceiling: " + str(json["data"][0]["ceiling"]["feet"]) + "ft"
	$conditions.text = "Conditions: " + json["data"][0]["conditions"][0]["text"]
	$category.text = "Category: " + json["data"][0]["flight_category"]
	#print(json["data"][0]["name"])
	$wind.text = "Wind: " + str(json["data"][0]["wind"]["degrees"]) + " degrees @ " + str(json["data"][0]["wind"]["speed_kts"]) + "kts"
func _on_call_button_up():
	if code.length() == 4:
		$HTTPRequest.request("https://api.checkwx.com/metar/" + code + "/decoded?x-api-key=dc420c7f63f741d89aa62b0f34")
