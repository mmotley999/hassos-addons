#!/usr/bin/with-contenv bashio
set -e

HEYUCONFIG="/etc/heyu/x10.conf"

bashio::log.info "Configuring Heyu..."

# Generate basic X10 configuration file, only need TTY port

SERIAL=$(bashio::config "serial_port")
echo -e "TTY\t\t  ${SERIAL}\n" > "${HEYUCONFIG}"

# Export enviornment variables for the main script

export MQTTBROKER=$(bashio::config "mqtt_host")
export MQTTPORT=$(bashio::config "mqtt_port")
export MQTTUSER=$(bashio::config "mqtt_user")
export MQTTPASS=$(bashio::config "mqtt_pass")
export MQTTCMDTOPIC=$(bashio::config "cmd_topic")
export MQTTSTATTOPIC=$(bashio::config "stat_topic")

# Export environement if CM17 is defined

if bashio::config.true "cm17_in_use" ; then
  bashio::log.info "CM17 is enabled"
  export CM17="True"
else
  bashio::log.info "CM11 is enabled"
fi
  
# Start heyu engine
heyu engine

# Run main script
python3 -u /usr/local/bin/x10mqtt.py
