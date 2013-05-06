# Инструкция по настройке проекта Skveez на сервере Hetzner

## Переустановка сервера

Купив сервер у Hetzner, на нем необходимо переустановить систему для изменения
настроек разбивки дисков.

В [панели управления серверами][panel], в разделе [Servers][servers] найдите ваш
сервер. Во вкладке `IPs` сервера запоните первый адрес. Допустим этим адресом
является `144.76.8.196`.

Во вкладке `Rescue` активируйте 64-битную систему восстановления и запомните
пароль выданный после активации.

Во вкладке `Reset` выполните `Execute a automatic hardware reset`.

Через некоторое время сервер перезагрузится со системой востановления.
Присоеденитесь к серверу через ssh используя записаный ранее пароль:

```shell
$ ssh root@144.76.8.196
```

Запустите процесс переустановки системы:

```shell
root@rescue ~ # installimage
```

Выберите систему `Ubuntu`. Выберите версию `Ubuntu-1210-quantal-64-minimal`.
После предупреждения откроется редактор с настройкой процесса установки. В этом
файле удалите следующие строчки:

```
HOSTNAME Ubuntu-1210-quantal-64-minimal
PART swap swap 16G
PART /boot ext3 512M
PART / ext4 1024G
PART /home ext4 all
```

Строчки можно удалять используя клавишу `F8`. Вместо удаленных строчек впишите
следующие:

```
HOSTNAME host0.skveez.net
PART /boot ext2 512M
PART lvm sysvg 48G
PART lvm virvg all
LV sysvg root / ext3 32G
LV sysvg swap swap swap all
```

Сохраните настройки используя клавишу `F10`. Дважды согласитесь с
предупреждениями. После этого начнется установка:

```

                Hetzner Online AG - installimage

  Your server will be installed now, this will take some minutes
             You can abort at any time with CTRL+C ...

         :  Reading configuration                           done 
   1/15  :  Deleting partitions                             done 
   2/15  :  Test partition size                             done 
   3/15  :  Creating partitions and /etc/fstab              done 
   4/15  :  Creating software RAID level 1                  done 
   5/15  :  Creating LVM volumes                            busy   No volume groups found
                                                            done 
   6/15  :  Formatting partitions
         :    formatting /dev/md/0 with ext2                done 
         :    formatting /dev/sysvg/root with ext3          done 
         :    formatting /dev/sysvg/swap with swap          done 
   7/15  :  Mounting partitions                             done 
   8/15  :  Extracting image (local)                        done 
   9/15  :  Setting up network for eth0                     done 
  10/15  :  Executing additional commands
         :    Generating new SSH keys                       done 
         :    Generating mdadm config                       done 
         :    Generating ramdisk                            done 
         :    Generating ntp config                         done 
         :    Setting hostname                              done 
  11/15  :  Setting up miscellaneous files                  done 
  12/15  :  Setting root password                           done 
  13/15  :  Installing bootloader grub                      done 
  14/15  :  Running some ubuntu specific functions          done 
  15/15  :  Clearing log files                              done 

                  INSTALLATION COMPLETE
   You can now reboot and log in to your new system with
  the same password as you logged in to the rescue system.

```

Перезагрузите сервер:

```shell
root@rescue ~ # reboot
```

После перезагрузки сервер будет с нужной версией ОС и правильной разбивкой
дисков.

[panel]: https://robot.your-server.de
[servers]: https://robot.your-server.de/server

## Загрузка данных на сервер Chef

Перед настройкой сервера загрузите все необходимые данные на ваш сервер Chef:

```shell
$ librarian-chef update
$ knife cookbook upload -ao cookbooks
$ knife role from file roles/*
$ knife data bag create skveez_guests
```

Создайте ключ для доступа к репозиторию проекта:

```shell
$ ssh-keygen -N '' -C '' -f deploy
```

Публичный ключ `deploy.pub` загрузите на GitHub [к вашим ключам][github].
Содержимое приватного ключа `deploy` вместе с настройками приложения скопируйте
в специальный data bag item используя следующую комманду:

```shell
$ knife data bag create skveez application
```

Во время запуска комманды откроется текстовый редактор для ввода настроек.
Настройки приложения должны быть в формате JSON и содержать следующие поля:

```json
{
  "id": "application",
  "deploy_key": "",
  "secret": "",
  "facebook_client_id": "",
  "facebook_client_secret": "",
  "vkontakte_client_id": "",
  "vkontakte_client_secret": "",
  "twitter_client_id": "",
  "twitter_client_secret": "",
  "recaptcha_public_key": "",
  "recaptcha_private_key": "",
  "no_reply_password": ""
}
```

В приватном ключе вместо переводов строк должны быть символы `\n`. В поле
`secret` должен быть случайный набор символов.

Удалите ключи со своего компьютера:

```shell
$ rm deploy deploy.pub
```

[github]: https://github.com/rithis/skveez/settings/keys

## Настройка сервера

Если вы используете Linux или OS X, то удалите запись о сервере из файла
`~/.ssh/known_hosts`. Запись начинается примерно так:

`144.76.8.196 ssh-rsa AAAAB3NzaC1yc2EAAAA`.

Выполните первичную настройку сервера используя записаный ранее пароль:

```shell
$ knife bootstrap 144.76.8.196 -N host0.skveez.net -x root -r "recipe[apt],recipe[libvirt]"
$ ssh root@144.76.8.196 "apt-get upgrade -y && reboot"
$ knife bootstrap 144.76.8.196 -N host0.skveez.net -x root -r "role[skveez_host]"
```

## Создание образа диска

Для быстрого развертывания виртуальных машин необходимо создать образ диска,
который будет копироваться для каждой виртуальной машины. Для этого
присоеденитесь к серверу и запустите шаблонную виртуальную машину:

```shell
$ ssh root@144.76.8.196 -L5900:127.0.0.1:5900
root@host0 ~ # virsh start ubuntu-12.10-server-i386
```

Используя свой любимый VNC клиент, подключитесь к адресу `127.0.0.1:5900`
и произведите установку Ubuntu. Во время установки необходимо соблюсти
следующие правила:

* в полях "название машины", "имя пользователя" и "пароль пользователя" 
введите `ubuntu`;
* раздел на диске должен быть только один, занимающий все доступное место;
* во время выбора ролей сервера, выберите только `OpenSSH Server`.

После завершения установки выключите виртуальную машину:

```shell
root@host0 ~ # virsh shutdown ubuntu-12.10-server-i386
root@host0 ~ # exit
```

## Создание виртуальных машин

Для создания виртуальных машин загрузите информацию о них на сервер Chef и
запустите клиент Chef на сервере:

```shell
$ knife data bag from file skveez_guests data_bags/skveez_guests/*
$ knife ssh name:host0.skveez.net sudo chef-client
```

## Настройка виртуальных машин

Произведите настройку этих виртуальных машин используя пароль который вы вводили
при установке Ubuntu на шаге создания образа диска:

```shell
$ knife bootstrap 144.76.8.196 -N database0.host0.skveez.net -p 2210 -x ubuntu --sudo -r "role[skveez_database]"
$ knife bootstrap 144.76.8.196 -N sessions0.host0.skveez.net -p 2220 -x ubuntu --sudo -r "role[skveez_sessions]"
$ knife bootstrap 144.76.8.196 -N search0.host0.skveez.net -p 2230 -x ubuntu --sudo -r "role[skveez_search]"
$ knife bootstrap 144.76.8.196 -N application0.host0.skveez.net -p 2240 -x ubuntu --sudo -r "role[skveez_application]"
$ knife bootstrap 144.76.8.196 -N promo0.host0.skveez.net -p 2250 -x ubuntu --sudo -r "role[skveez_promo]"
$ knife bootstrap 144.76.8.196 -N mail0.host0.skveez.net -p 2260 -x ubuntu --sudo -r "role[skveez_mail]"
```

Сообщите серверу о появлении новой виртуальной машины с ролью
`skveez_application`:

```shell
$ knife ssh name:host0.skveez.net sudo chef-client
```

После этого по адресу http://144.76.8.196/publications должен открываться
сайт Skveez.

## Обновление сайта

При возникновении необходимости обновить исходные коды сайта из репозитория
запустите следующую комманду:

```shell
$ knife ssh name:application0.host0.skveez.net "sudo chef-client" -a skveez_host_connection
```
