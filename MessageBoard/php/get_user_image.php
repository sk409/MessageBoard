<?php
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_GET, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host", "user_name"]);
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$appDatabaseName = $parameters["app_database_name"];
$databaseServerHost = $parameters["database_server_host"];
$userName = $parameters["user_name"];
$dsn = "mysql:host={$databaseHost};dbname={$appDatabaseName};charset=utf8";
try {
    $options = [PDO::ATTR_EMULATE_PREPARES => false, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
    $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
    $get_user_image = "SELECT raw_data FROM user_image WHERE usr_name = ?";
    $stm = $pdo->prepare($insert_message);
    $stm->bindValue(1, $userName, PDO::PARAM_STR);
    $stm->execute();
    $result =  $stm->fetchAll();
    echo json_encode($result);
} catch (Exception $exception) {
    echo $exception->getMessage();
}

