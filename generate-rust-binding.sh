#!/bin/sh

set -xe

echo "#![allow(non_snake_case)]" > bela.rs
echo "#![allow(non_camel_case_types)]" >> bela.rs

bindgen -x c++ -match Bela.h  \
               -match DigitalChannelManager.h  \
               -match digital_gpio_mapping.h  \
               -match DigitalToMessage.h  \
               -match GPIOcontrol.h  \
               -match I2c_Codec.h  \
               -match I2c.h  \
               -match I2c_TouchKey.h  \
               -match IirFilter.h  \
               -match Midi.h  \
               -match OSCClient.h  \
               -match oscpkt.hh  \
               -match OSCServer.h  \
               -match PRU.h  \
               -match pru_rtaudio_bin.h  \
               -match prussdrv.h  \
               -match pruss_intc_mapping.h  \
               -match PulseIn.h  \
               -match Scope.h  \
               -match stats.hpp  \
               -match UdpClient.h  \
               -match UdpServer.h  \
               -match Utilities.h  \
               -match WriteFile.h  \
  Bela.h >> bela.rs
