# Инструкция к применению #

Небольшой туториал как работать с этим ))

* Для начала клонируем данный проект
* Затем устанавливаем зависимости, подгружаем Wordpress через команду - composer install (само собой composer должен быть установлен)
* Импортируем при первом запуске наш sql с базой (не забываем, что его данные нужно поменять на наши новые)
* Если есть картинки, то не забываем скопировать содержимое папки uploads 

# Импорт БД в Docker контейнер #

 * mysql:
 *   image: mysql:5.7
 *    volumes:
      - "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"
      - "./storage/docker/mysql:/var/lib/mysql:delegated"

В следующий раз когда делаем docker-compose up не забываем заккоментировать эту строку или удалить, а то база постоянно будет импортироваться при каждому запуске
 * #- "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"
  
  
Далее наслаждаемся работой связки Docker + Wordpress
