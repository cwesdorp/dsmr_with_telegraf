import os
import sys
from datetime import datetime
from dsmr_parser import obis_references, telegram_specifications
from dsmr_parser.clients import SerialReader, SERIAL_SETTINGS_V5

serial_reader = SerialReader(
    device='/dev/ttyUSB0',
    serial_settings=SERIAL_SETTINGS_V5,
    telegram_specification=telegram_specifications.V5
)

print("Starting DSMR Reader", file = sys.stderr)

def printTelegram(telegram):
    t = str(telegram.P1_MESSAGE_TIMESTAMP)[:25]
    timestamp = datetime.strptime(t, "%Y-%m-%dT%H:%M:%S%z")
    ts = int(timestamp.timestamp() * 1000 * 1000)

    active_tarrif = int(telegram.ELECTRICITY_ACTIVE_TARIFF.value)
    print(F"electricity_active_tarrif value={active_tarrif} {ts}")
    print(F"electricity_total_consumed,tarrif=1 value={telegram.ELECTRICITY_USED_TARIFF_1.value} {ts}")
    print(F"electricity_total_consumed,tarrif=2 value={telegram.ELECTRICITY_USED_TARIFF_2.value} {ts}")
    print(F"electricity_current_use value={telegram.CURRENT_ELECTRICITY_USAGE.value} {ts}")
    print(F"electricity_voltage value={telegram.INSTANTANEOUS_VOLTAGE_L1.value} {ts}")
    print(F"electricity_current value={telegram.INSTANTANEOUS_CURRENT_L1.value} {ts}")

if __name__ == '__main__':
    try:
        for telegram in serial_reader.read_as_object():
            printTelegram(telegram)
    except (KeyboardInterrupt, SystemExit):
        print("Exiting...")
    except Exception as e:
        print("Unexpected error: " + e, sys.stderr)

