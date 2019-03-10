<?php
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_POST, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_post", "user_name", "user_password"]);
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$appDatabaseName = $parameters["app_database_name"];
$databaseServerHost = $parameters["database_server_host"];
$userName = $parameters["user_name"];
$userPassword = $parameters["user_password"];
$dsn = "mysql:host={$databaseServerHost};dbname={$appDatabaseName};charset=utf8";
try {
    $options = [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION];
    $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
    $insert_user = "INSERT INTO user(name, password) VALUES(?, ?)";
    $stm = $pdo->prepare($insert_user);
    $stm->bindValue(1, $userName, PDO::PARAM_STR);
    $stm->bindValue(2, $userPassword, PDO::PARAM_STR);
    $stm->execute();
    echo "OK";
} catch (Exception $exception) {
    echo $exception->getMessage();
}
