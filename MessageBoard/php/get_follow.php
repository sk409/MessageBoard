<?php
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_GET);
$parameters = filterInputs(INPUT_GET, ["user_name"]);
$userName = $parameters["user_name"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "SELECT followed_user_name userName FROM follow WHERE following_user_name = ?";
    $bindValues = [$userName];
    $bindParams = [PDO::PARAM_STR];
    $databaseHandler->execute($sql, $bindValues, $bindParams);
    $result = $databaseHandler->fetchAll();
    echo json_encode($result);
} else {
    echo $databaseHandler->getErrorMessage();
}
