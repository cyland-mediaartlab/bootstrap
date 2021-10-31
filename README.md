1. Образ запускается с параметрами `/boot/cmdline.txt` и `/boot/config.txt`
	* При старте образа показывается экран plymouth (параметры `quiet splash`). Фон лежит в `/usr/local/share/plymouth/themes/bydefault/boot_splash.png`, рядом лежит скрипт plymouth
	* По-умолчанию системный UART отключен от системной консоли
2. `/boot` и `/` монтируются read-only, все каталоги, требующие записи (временные файлы, логи и т.д.) монтируются как tmpfs (в RAM). Параметры монтирования в `/etc/fstab`. Для переключения в режим read-write и обратно используются алиасы `set_rw` и `set_ro` (задаются в `/home/pi/.bashrc`)
3. При первом запуске на остатке sd-карты создается FAT32 раздел, который монтируется в `/data` как read-write, предназначенный для записи данных, медиафайлов и т.д. Создание обеспечивается скриптом `/usr/bin/create_data`, запускающийся one-time сервисом `/etc/systemd/system/create-data.service`. Этот же скрипт устанавливает права на папку `/tmp`.
4. После загрузки служб запускается графическая подсистема, с помощью сервиса `lightdm`. Строка запуска X-сервера `xserver-command` в `/etc/lightdm/lightdm.conf` (по-умолчанию, запускается в режиме без курсора).
5. После запуска X-сервера создается X-сессия и выполняются команды `/home/pi/.xsessionrc`: отключается скринсейвер и устанавливается фон рабочего стола `/boot/bydefault/background.png`
6. После запуска графики запускается сервис `/etc/systemd/system/bydefault.service`, который запускает `/boot/bydefault/start.sh`
7. По-умолчанию, сервис пробует смонтировать флешку, если флешки нет, вызывается функция `default`. Если флешка вставлена, она монтируется. Если на флешке присутствует скрипт `start.sh`, то выполняется этот скрипт (например, можно в формате такого скрипта составить плейлист, добавить кастомные задержки и т.д.). Если скрипта нет, выполняется функция default_usb: по-умолчанию поочередно воспроизводятся с помощью omxplayer все файлы на флешке.

### Полезные команды

* Для просмотра состояния сервиса: `journalctl -u bydefault.service -f`
* Для остановки/перезапуска `sudo service bydefault stop/start/restart/status`
* wpa_supplicant.conf можно разместить в /boot для подключения к необходимой сети, файл будет скопирован при следующей загрузке

### TODO

1. GPIO-switch/jumper для смены режима silent-boot и режима с логгированием загрузки. По тому же jumper происходит переключение на виртуальный терминал, в котором выводятся данные
* о загрузке процессора и памяти
* состоянии файловых систем
* параметрах сети
* параметрах экрана
* температуре
* последних логов сервиса bydefault
2. GPIO-jumper для вывода на экран сетки
3. Периодическая отправка на gateway адрес данных о системе и логов
4. omxplayer-sync
5. Автоматическая установка параметров HDMI для портативного дисплея