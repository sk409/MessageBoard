<?php
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_POST, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host", "message_contents", "message_id", "user_name"]);
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$appDatabaseName = $parameters["app_database_name"];
$databaseServerHost = $parameters["database_server_host"];
$messageContents = $parameters["message_contents"];
$messageID = $parameters["message_id"];
$userName = $parameters["user_name"];
$dsn = "mysql:host={$databaseHost};dbname={$appDatabaseName};charset=utf8";
try {
    $options = [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION];
    $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
    $insert_message = "INSERT INTO message(id, usr_name, contents) VALUES(?, ?, ?)";
    $stm = $pdo->prepare($insert_message);
    $stm->bindValue(1, $messageID, PDO::PARAM_INT);
    $stm->bindValue(2, $userName, PDO::PARAM_STR);
    $stm->bindValue(3, $messageContents, PDO::PARAM_STR);
    $stm->execute();
    echo "OK";
} catch(Exception $exception) {
    echo $exception->getMessage();
}