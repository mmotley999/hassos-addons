# Home Assistant Community Add-On:  X10 to MQTT Bridge



This add-on provides MQTT control of X10 devices for the CM11 and CM17A "Firecracker" RS232 Serial interface to X10.

When using a CM11, the addon also monitors for X10 changes that occur outside of Home Assistant (e.g. the use of X10 remote controls) and updates the status in Home Assistant.

Only ON and OFF commands are supported.  Dimming is not currently supported.

## Configuration

Example add-on configuration:



```json
    "serial_port": "/dev/ttyUSB0",
    "cm17_in_use:" false,
    "mqtt_host": "core-mosquitto",
    "mqtt_port": 1883,
    "mqtt_user": "",
	"mqtt_pass": "",
	"cmd_topic": "x10/cmd",
	"stat_topic": "x10/stat"
```

#### Option: `serial_port`

The serial port for the CM11A interface, which is usually connected via a USB-to-Serial device.  You can find this by going to "Supervisor" screen, selecting the "System" tab.   On the "Host" card, select the 3-dot option and select "Hardware"

#### Option: `cm17_in_use`

Boolean.  

If you are using a CM17A "Firecracker" module as your primary controller, enable this option (set to '**true**').  

If you are *only* using a CM11 module, set to '**false**'. 

Note that you can run the CM11 and CM17A together (see below for details).  Normally you would still set this option to **true** to use the CM17A as the primary X10 controller.

See below for issues with keeping your X10 and HASS environment in-sync.

#### Option: `mqtt_host`

The MQTT broker.  

If using the Home Assistant OS Mosquitto add-on as your broker, you can leave this as the default, `core-mosquitto`.  Otherwise, either the hostname or IP address of the broker you wish to use.

#### Option: `mqtt_port`

The port of the broker, typically 1883.  Note that SSL is not currently supported.

#### Options: `mqtt_user` and `mqtt_pass`

Used for MQTT authentication.  If left blank, then an anonymous connection will be attempted.  

If using the Mosquitto add-on, enter the username and password for a valid Home Assistant user account (or a MQTT internal acccount if you defined that).  See the Mosquitto add-on documentation for details on how user accounts are defined.

#### Option: `cmd_topic`

This is the base topic for X10 commands from Home Assistant.

MQTT topics are composed of the cmd_topic plus the housecode to control.  

For example, to control device with code G7 with the default `cmd_topic` of `x10/cmd`, the topic for that device will be `x10/cmd/g7`.

Publishing a message to that topic with payload of "ON" will turn G7 on, likewise a payload of "OFF" will turn G7 off.  NOTE:  Only payloads of "ON" or "OFF" are supported.

#### Option: `stat_topic`

When the status of X10 devices change, either through Home Assistant control or from an X10 remote, a status message is published to update Home Assistant. 

The topic structure follows the same format as `cmd_topic`.  For example, when G7 is turned on, a status message will be published to `x10/stat/g7` with a payload of "ON".

**NOTE:** Status messages are published with the Retain flag so that Home Assistant is able to retrieve the last known state when restarting.

## Home Assistant Configuration

Setting up a device in Home Assistant can use either the `switch` or `light` integration.  When using `light`, note that brightness is NOT supported.

Here is an example of an X10 `switch` for device with house code G7 and `cmd_topic` set to "x10/cmd" and `stat_topic` set to "x10/stat".

```yaml
switch:
  - platform: mqtt
    name: "X10 Switch"
    state_topic: "x10/stat/g7"
    command_topic: "x10/cmd/g7"
    payload_on: "ON"
    payload_off: "OFF"
    retain: false
```

A `light` is configured in a similar way.  See the Home Assistant documentation for "MQTT Light" for details.

### Potential Sync Issues

Most X10 devices do not have a way to determine their status via a query.  Therefore, it is possible that Home Assistant could get out-of-sync with the status of the device.  

The add-on makes every effort to mitigate this by using retained MQTT status messages.  Additionally, when using a CM11, the add-on monitors for any outside changes to an X10 device via X10 remotes or local toggles (by using 'heyu monitor' and searching for specific events). 

With the CM11, Home Assistant can get out of sync by:

- Making changes to an X10 device when the add-on is not running.
- X10 device changes that do not advertise their change, and hence not picked up by 'heyu monitor'

Note that the CM17A is a transmit-only device and does not report X10 changes, therefore it is much more likely that Home Assistant and your X10 environment can get out-of-sync unless you only make X10 on/off events through Home Assistant.

In most cases, you can resync Home Assistant and your X10 device by toggling the device power in the Home Assistant interface.

### Using a CM17A and a CM11A Together

You can use both the CM17A for transmitting codes and a CM11 for receiving X10 updates simultaenously!  Simply connect the CM11 to the DB9 pass-through port on the CM17A module.

This is helpful if you have a CM11 that is not transmitting properly, or you simply wish to use RF transmission instead of power line for control.  Using the CM11 in tandem allows for X10 commands outside Home Assistant to be read by the add-on to mitigate the out-of-sync issues discussed in the section above.

## Support

At the moment, the best way to obtain support is via the thread on the Home Assistant Community (https://community.home-assistant.io/t/home-assistant-add-on-x10-cm11-to-mqtt-gateway/276064)

## Authors and contributors

The author of this add-on is [Mark Motley](https://github.com/mmotley999/) based some ideas gathered from [kevineye/docker-heyu-mqtt](https://github.com/kevineye/docker-heyu-mqtt), specifically around using 'heyu monitor' to check for changes.

Note that I am a very new to Python, and welcome constructive ideas on how the main script can be improved.

## License

MIT License

Copyright (c) 2021 Mark Motley

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

