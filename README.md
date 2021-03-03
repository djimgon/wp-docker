# Инструкция #

Небольшой туториал как работать с этим "кораблем"

* Для начала клонируем данный проект
* Затем устанавливаем зависимости, подгружаем Wordpress - composer install
* Импортируем при первом запуске sql (не забываем, что его данные нужно поменять на наши новые) 

# Импорт БД в Docker контейнер #

 * mysql:
 *   image: mysql:5.7
 *    volumes:
      - "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"
      - "./storage/docker/mysql:/var/lib/mysql:delegated"

В следующий раз когда делаем docker-compose up не забываем заккоментировать эту строку или удалить, а то база постоянно будет импортироваться при каждому запуске
 * #- "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"
  
  
Далее наслаждаемся работой связки Docker + Wordpress
