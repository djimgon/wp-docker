# Инструкция к применению #

Небольшой туториал как работать с этим ))

* Для начала клонируем данный проект
* Затем устанавливаем зависимости, подгружаем Wordpress через команду - composer install (само собой composer должен быть установлен)
* Импортируем при первом запуске наш sql с базой (не забываем, что его данные нужно поменять на наши новые)
* Если есть картинки, то не забываем скопировать содержимое папки uploads 

# Чистая установка без БД#

* chmod 777 -R storage
* sudo chown -R goohunter:www-data top-eng

# Устранение ошибки “enter your FTP credentials” в WordPress #


Откройте wp-config.php и добавьте либо измените текущие значения следующего параметра в конце файла:
define('FS_METHOD', "direct");


# Импорт БД в Docker контейнер #

 * mysql:
 *   image: mysql:5.7
 *    volumes:
      - "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"
      - "./storage/docker/mysql:/var/lib/mysql:delegated"

В следующий раз когда делаем docker-compose up не забываем заккоментировать эту строку или удалить, а то база постоянно будет импортироваться при каждом запуске
 * #- "./storage/docker/backups/dump.sql:/docker-entrypoint-initdb.d/dump.sql"

# Описание запросов SQL #

Вообще основных запросов три (на скриншоте есть и четвертый запрос, но о нем чуть позже). Итак, http://test.truemisha.ru — старый домен, https://misha.agency — новый.

Замена site_url и home_url

* UPDATE wp_options SET option_value = REPLACE(option_value, 'http://test.truemisha.ru', 'https://misha.agency') WHERE option_name = 'home' OR option_name = 'siteurl';

Поиск и замена в содержимом постов

* UPDATE wp_posts SET post_content = REPLACE (post_content, 'http://test.truemisha.ru', 'https://misha.agency');

Значения произвольных полей постов

* UPDATE wp_postmeta SET meta_value = REPLACE (meta_value, 'http://test.truemisha.ru','https://misha.agency');

Для чего нужны guid?

Используются для RSS как глобальный идентификатор (больше кстати не используются нигде).

Если вы переносите сайт с локального сервера — меняем все значения guid: 

* UPDATE wp_posts SET guid = REPLACE (guid, 'http://10.0.0.32', 'https://misha.agency');

Если же сайт уже находился в интернете, а вы просто решили поменять домен — меняем guid только для вложений: 

* UPDATE wp_posts SET guid = REPLACE (guid, 'http://test.truemisha.ru', 'https://misha.agency') WHERE post_type = 'attachment';

Ссылки в комментариях

* UPDATE wp_comments SET comment_content = REPLACE (comment_content, 'http://test.truemisha.ru', 'https://misha.agency');
* UPDATE wp_comments SET comment_author_url = REPLACE (comment_author_url, 'http://test.truemisha.ru', 'https://misha.agency');

Данный метод взаимствовал у Мишы Рудастых - https://misha.agency/wordpress/sql-queries-domain.html

# Подключаемся к нашей БД через wp-config #

* define( 'DB_NAME', 'wordpress' );

* /** MySQL database username */
* define( 'DB_USER', 'wordpress' );

* /** MySQL database password */
* define( 'DB_PASSWORD', 'password' );

* /** MySQL hostname */
* define( 'DB_HOST', 'mysql' );

* /** Database Charset to use in creating database tables. */
* define( 'DB_CHARSET', 'utf8' );

* /** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );  
  
Далее наслаждаемся работой связки Docker + Wordpress

# Подключение xdebug к phpstorm #

Взял из статьи на хабре
https://habr.com/ru/company/otus/blog/507982/

# Дебажим PHP-контейнер с помощью Xdebug и PhpStorm #

Я создам очень простую php-страницу и подебажу ее с помощью xdebug и PhpStorm.

Исходные файлы можно найти здесь:
github.com/ikknd/docker-study в папке recipe-09

# 1. Создайте файл «Dockerfile» в папке «docker»: #

FROM php:7.2-fpm

#Install xdebug
RUN pecl install xdebug-2.6.1 && docker-php-ext-enable xdebug

CMD ["php-fpm"]


Выполните эту команду из папки docker для создания образа:

docker build -t php-xdebug-custom -f Dockerfile .


# 2. Создайте файл docker-compose.yml в папке «docker»: #

version: "3.7"

services:

  web:
    image: nginx:1.17
    ports:
      - 80:80
    volumes:
      - /var/www/docker-study.loc/recipe-09/php:/var/www/myapp
      - /var/www/docker-study.loc/recipe-09/docker/site.conf:/etc/nginx/conf.d/site.conf
    depends_on:
      - php

  php:
    image: php-xdebug-custom
    volumes:
      - /var/www/docker-study.loc/recipe-09/php:/var/www/myapp
      - /var/www/docker-study.loc/recipe-09/docker/php.ini:/usr/local/etc/php/php.ini


Здесь я использую образ «php-xdebug-custom» вместо «php:7.2-fpm „

# 3. Внесите в файл php.ini следующие настройки: #

* [xdebug]
* zend_extension=xdebug.so
* xdebug.profiler_enable=1
* xdebug.remote_enable=1
* xdebug.remote_handler=dbgp
* xdebug.remote_mode=req
* xdebug.remote_host=host.docker.internal
* xdebug.remote_port=9000
* xdebug.remote_autostart=1
* xdebug.remote_connect_back=1
* xdebug.idekey=PHPSTORM


# 4. Настройте сервер в PhpStorm: #

File -> Settings -> Languages и Frameworks -> PHP -> Servers
Добавьте новый сервер с помощью иконки + и настройте его, как показано на следующем скриншоте:


Убедитесь, что вы отметили «Использовать сопоставление путей» (“Use path mappings») и сопоставили папку php с /var/www/myapp.

# 5. Настройте удаленный дебагер PHP в PhpStorm: #

Run -> Edit configurations -> PHP Remote Debug

Добавьте новую конфигурацию и присвойте ей значения, как на следующем скриншоте:


6. Выберите конфигурацию дебага на панели дебага PhpStorm

После этих действий у меня все прекрасно заработало.
Удачного дебага!

Мой небольшой сайт по инфопродуктам на Wp с текущей рабочей средой
https://info-guru.ru

