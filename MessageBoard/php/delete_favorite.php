<?php
 // require_once("utils/utils.php");
// $parameters = filterInputs(INPUT_POST, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host", "user_name", "message_user_name", "message_id"]);
// $appAdminUserName = $parameters["app_admin_user_name"];
// $appAdminUserPassword = $parameters["app_admin_user_password"];
// $appDatabaseName = $parameters["app_database_name"];
// $databaseServerHost = $parameters["database_server_host"];
// $userName = $parameters["user_name"];
// $messageUserName = $parameters["message_user_name"];
// $messageID = $parameters["message_id"];
// $dsn = "mysql:host={$databaseServerHost};dbname={$appDatabaseName};charset=utf8";
// try {
//     $options = [PDO::ATTR_EMULATE_PREPARES => false, PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION];
//     $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
//     $delete_favorite = "DELETE FROM favorite WHERE usr_name = ? AND message_user_name = ? AND message_id = ?";
//     $stm = $pdo->prepare( $delete_favorite);
//     $stm->bindValue(1, $userName, PDO::PARAM_STR);
//     $stm->bindValue(2, $messageUserName, PDO::PARAM_STR);
//     $stm->bindValue(3, $messageID, PDO::PARAM_INT);
//     $stm->execute();
//     echo "OK";
// } catch (Exception $exception) {
//     echo $exception->getMessage();
// }
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_POST);
$parameters = filterInputs(INPUT_POST, ["user_name", "message_user_name", "message_id"]);
$userName = $parameters["user_name"];
$messageUserName = $parameters["message_user_name"];
$messageID = $parameters["message_id"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "DELETE FROM favorite WHERE usr_name = ? AND message_user_name = ? AND message_id = ?";
    $bindValues = [$userName, $messageUserName, $messageID];
    $bindParams = [PDO::PARAM_STR, PDO::PARAM_STR, PDO::PARAM_INT];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        echo "OK";
    } else {
        $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}
