# Home Assistant Community Add-On:  X10 to MQTT Bridge



This add-on provides MQTT control of X10 devices for the CM11A RS232 Serial interface.  It also monitors for X10 changes that occur outside of Home Assistant (e.g. the use of X10 remote controls) and updates the status in Home Assistant.

Only ON and OFF commands are supported.  Dimming is not currently supported.

## Configuration

Example add-on configuration:



```json
    "serial_port": "/dev/ttyUSB0",
    "mqtt_host": "core-mosquitto",
    "mqtt_port": 1883,
    "mqtt_user": "",
	"mqtt_pass": "",
	"cmd_topic": "x10/cmd",
	"stat_topic": "x10/stat"
```

### Option: `serial_port`

The serial port for the CM11A interface, which is usually connected via a USB-to-Serial device.  You can find this by going to "Supervisor" screen, selecting the "System" tab.   On the "Host" card, select the 3-dot option and select "Hardware"

### Option: `mqtt_host`

The MQTT broker.  If using the Home Assistant OS Mosquitto add-on as your broker, you can leave this as default of `core-mosquitto`.  Otherwise, either your hostname or IP address of the broker you wish to use.

### Option: `mqtt_port`

The port of the broker, typically 1883.  Note that SSL is not currently supported.

### Options: `mqtt_user` and `mqtt_pass`

Used for MQTT authentication.  If left blank, then an anonymous connection will be attempted.

### Option: `cmd_topic`

This is the base topic for X10 commands from Home Assistant.

MQTT topics are composed of the cmd_topic plus the housecode to control.  

For example, to control device with code G7 with the default `cmd_topic` of `x10/cmd`, the topic for that device will be `x10/cmd/g7`.

Publishing a message to that topic with payload of "ON" will turn G7 on, likewise a payload of "OFF" will turn G7 off.  NOTE:  Only payloads of "ON" or "OFF" are supported.

### Option: `stat_topic`

When the status of X10 devices change, either through Home Assistant control or from an X10 remote, a status message is published to update Home Assistant. 

The topic structure follows the same format as `cmd_topic`.  For example, when G7 is turned on, a status message will be published to `x10/stat/g7` with a payload of "ON".

NOTE: status messages are published with the Retain flag so that Home Assistant is able to retrieve the last known state when restarting.

