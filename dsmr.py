import os
import time
from dsmr_parser import telegram_specifications
from dsmr_parser.clients import SerialReader, SERIAL_SETTINGS_V5

serial_reader = SerialReader(
    device='/dev/ttyUSB0',
    serial_settings=SERIAL_SETTINGS_V5,
    telegram_specification=telegram_specifications.V5
)

telegram = serial_reader.read_as_object()
os.system('clear')
print(telegram)

time.sleep(2)

telegram = serial_reader.read_as_object()
os.system('clear')
print(telegram)

time.sleep(5)

telegram = serial_reader.read_as_object()
os.system('clear')
print(telegram)

