avrdude -p t24 -c avrisp -P /dev/ttyUSB0 -b19200 -e -Uefuse:w:0xFF:m -Uhfuse:w:0xDF:m -Ulfuse:w:0xE2:m
