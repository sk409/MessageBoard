<?php
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_POST, ["mysql_user_name", "mysql_user_password", "web_server_host", "database_server_host", "app_admin_user_name", "app_admin_user_password", "app_database_name"]);
$mysqlUserName = $parameters["mysql_user_name"];
$mysqlUserPassword = $parameters["mysql_user_password"];
$databaseServerHost = $parameters["database_server_host"];
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$databaseName = $parameters["app_database_name"];
$dsn = "mysql:host={$databaseServerHost};charset=utf8";
try {
    $options = [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION];
    $pdo = new PDO($dsn, $mysqlUserName, $mysqlUserPassword, $options);
    $create_message_board_database = "CREATE DATABASE {$databaseName}";
    $pdo->query($create_message_board_database);
    $create_user_table = "CREATE TABLE {$databaseName}.user(
        name VARCHAR(64) PRIMARY KEY,
        password VARCHAR(32) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )";
    $pdo->query($create_user_table);
    $create_message_table = "CREATE TABLE {$databaseName}.message(
        id INT UNSIGNED,
        usr_name VARCHAR(64),
        contents VARCHAR(1024) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id, usr_name),
        CONSTRAINT foreign_key_user_name_on_message_table
        FOREIGN KEY (usr_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE
        )";
    $pdo->query($create_message_table);
    $create_favorite_table = "CREATE TABLE {$databaseName}.favorite(
        usr_name VARCHAR(64),
        message_user_name VARCHAR(64),
        message_id INT UNSIGNED,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (usr_name, message_user_name, message_id),
        CONSTRAINT foreign_key_user_name_on_favorite
        FOREIGN KEY (usr_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_message_user_name_on_favorite
        FOREIGN KEY (message_user_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_message_id_on_favorite
        FOREIGN KEY (message_id)
        REFERENCES message (id)
        ON DELETE CASCADE ON UPDATE CASCADE
        )";
    $pdo->query($create_favorite_table);
    $create_follow_table = "CREATE TABLE {$databaseName}.follow(
        following_user_name VARCHAR(64),
        followed_user_name VARCHAR(64),
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (following_user_name, followed_user_name),
        CONSTRAINT foreign_key_following_user_name_on_follow
        FOREIGN KEY (following_user_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_followd_user_name_on_follow
        FOREIGN KEY (followed_user_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE
        )";
    $pdo->query($create_follow_table);
    $create_reply_table = "CREATE TABLE {$databaseName}.reply(
        source_message_user_name VARCHAR(64),
        source_message_id INT UNSIGNED,
        dest_message_user_name VARCHAR(64),
        dest_message_id INT UNSIGNED,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (source_message_user_name, source_message_id, dest_message_user_name, dest_message_id),
        CONSTRAINT foreign_key_source_message_user_name_on_reply
        FOREIGN KEY (source_message_user_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_source_message_id_on_reply
        FOREIGN KEY (source_message_id)
        REFERENCES message (id)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_dest_message_user_name_on_reply
        FOREIGN KEY (dest_message_user_name)
        REFERENCES user (name)
        ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT foreign_key_dest_message_id_on_reply
        FOREIGN KEY (dest_message_id)
        REFERENCES message (id)
        ON DELETE CASCADE ON UPDATE CASCADE
    )";
    $pdo->query($create_reply_table);
    $create_admin_user = "CREATE USER {$appAdminUserName}@localhost identified with mysql_native_password by '{$appAdminUserPassword}'";
    $pdo->query($create_admin_user);
    $grant_permissions_to_admin_user = "GRANT ALL ON {$databaseName}.* to {$appAdminUserName}@localhost WITH GRANT OPTION";
    $pdo->query($grant_permissions_to_admin_user);
    echo "OK";
} catch (Exception $exception) {
    echo $exception->getMessage();
}