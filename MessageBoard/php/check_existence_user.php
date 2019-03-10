<?php
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_GET, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host", "user_name", "user_password"]);
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$appDatabaseName = $parameters["app_database_name"];
$databaseServerHost = $parameters["database_server_host"];
$userName = $parameters["user_name"];
$password = $parameters["user_password"];
$dsn = "mysql:host={$databaseServerHost};dbname={$appDatabaseName};charset=utf8";
try {
    $options = [PDO::ATTR_EMULATE_PREPARES => false, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
    $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
    $sql = "SELECT name FROM user WHERE name=? AND password=?";
    $stm = $pdo->prepare($sql);
    $stm->bindValue(1, $userName, PDO::PARAM_STR);
    $stm->bindValue(2, $password, PDO::PARAM_STR);
    $stm->execute();
    $result = $stm->fetchAll();
    if (empty($result)) {
        print("false");
    } else {
        print("true");
    } 
} catch (Exception $exception) {
    echo $exception->getMessage();
}