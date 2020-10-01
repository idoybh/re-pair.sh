#!/bin/bash
RED=$"\033[1;31m"
GREEN=$"\033[1;32m"
YELLOW=$"\033[1;33m"
NC=$"\033[0m"
while [ true ]
do
  echo -e "${RED}Script made by Ido Ben-Hur to save work${NC}"
  echo -e "${RED}Just press ctrl+c any time to exit${NC}"
  echo -e "${GREEN}Killing adb server${NC}"
  adb kill-server
  echo -e "${GREEN}Starting adb server${NC}"
  adb start-server
  echo -en "${YELLOW}over network? [y/n] > ${NC}"
  read NETVAR
  if [ $NETVAR == 'y' ]
  then
    echo -en "${YELLOW}Enter device IP > ${NC}"
    read IPVAR
    adb connect $IPVAR
  elif [ $NETVAR != 'n' ]
  then
    echo -e "${RED}Wrong input!! Asuming it's a no!${NC}"
    NETVAR='n'
  fi
  RET1='n'
  while [ $RET1 == 'n' ]
  do
    echo -e "${GREEN}Make sure you see the device${NC}"
    adb devices
    echo -en "${YELLOW}Continue? Device will reboot! [y/n] > ${NC}"
    read RET1
    if [ $RET1 == 'y' ]
    then
      adb shell 'pm clear com.google.android.gms && reboot'
      if [ $NETVAR = 'y' ]
      then
        echo -en "${YELLOW}Press any key when your device is on and reconnected to ADB over net${NC}"
        read -n1 -r
        echo -en "${YELLOW}IP Changed? [y/n] > ${NC}"
        read IPC
        if [ $IPC = 'y' ]
        then
          echo -en "${YELLOW}Enter device IP > ${NC}"
          read IPVAR
        fi
        adb connect $IPVAR
      else
        echo -e "${GREEN}Waiting for the device to turn on.${NC}"
        echo -e "${RED}Keep it connected.${NC}"
        while [[ $isDet != '0' ]]; do # wait until detected
          adb kill-server &> /dev/null
          adb start-server &> /dev/null
          adb devices | grep -w "device" &> /dev/null
          isDet=$?
          sleep 3
        done
      fi
      RET2='n'
      while [ $RET2 == 'n' ]
      do
        adb devices
        echo -en "${YELLOW}See it? [y/n] > ${NC}"
        read RET2
        if [ $RET2 == 'y' ]
        then
          echo -e "${GREEN}Making device visible. Pair with WearOS app after confirming prompt on watch${NC}"
          adb shell 'am start -a android.bluetooth.adapter.action.REQUEST_DISCOVERABLE'
        elif [ $NETVAR == 'y' ]
        then
          adb connect $IPVAR
        elif [ $RET2 != 'n' ]
        then
          echo -e "${RED}Wrong input!!${NC}"
          RET2='n'
        fi
      done
    elif [ $RET1 != 'n' ]
    then
      echo -e "${RED}Wrong input!!${NC}"
      RET1='n'
    fi
  done
  echo -en "${YELLOW}Restart script? [y/n] > ${NC}"
  read RES1
  if [ $RES1 == 'n' ]
  then
    break
  elif [ $RES1 != 'y' ]
  then
    # yell at the user
    echo -e "${RED}Wrong input! Fuck you!${NC}"
    break
  fi
done
echo -e "${RED}Goodbye!${NC}"
echo -en "${YELLOW}Press any key to exit...${NC}"
read -n1 -r
#FIN
