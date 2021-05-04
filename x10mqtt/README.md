# Home Assistant Community Add-on: X10mqtt



## About

The X10 to MQTT add-on provides for X10 control when using a CM11 or CM17A "Firecracker" serial interface connected to your Home Assistant OS system using MQTT commands.

Key features:

- Allows for Home Assistant OS users to control X10 devices using MQTT, since 'heyu' is not available in the Docker-based Home Assistant
- Monitors for external X10 commands (e.g. from an X10 remote) and updates the status in Home Assistant accordingly when using the CM11 module (the CM17A Firecracker does not support this unless a CM11 is run in-tandem, see the docs).