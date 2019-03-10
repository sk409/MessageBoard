<?
require_once("utils/utils.php");
$parameters = filterInputs(INPUT_POST, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host", "user_name", "image_raw_data"]);
$appAdminUserName = $parameters["app_admin_user_name"];
$appAdminUserPassword = $parameters["app_admin_user_password"];
$appDatabaseName = $parameters["app_database_name"];
$databaseServerHost = $parameters["database_server_host"];
$userName = $parameters["user_name"];
//$imageRawData = $parameters["image_row_data"];
$dsn = "mysql:host={$databaseServerHost};dbname={$appDatabaseName};charset=utf8";
// echo $appAdminUserName;
// echo " ";
// echo $appAdminUserPassword;
var_dump($parameters);
// try {
//     $options = [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION];
//     $pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
//     $insert_user_image = "INSERT INTO user_image(usr_name, raw_data) VALUES(?, ?)";
//     $stm = $pdo->prepare($insert_user_image);
//     $stm->bindValue(1, $userName, PDO::PARAM_STR);
//     $stm->bindValue(2, $imageRawData, PDO::PARAM_STR);
//     $stm->exceute();
//     echo "OK";
// } catch(Exception $exception) {
//     echo $exception->getMessage();
// }