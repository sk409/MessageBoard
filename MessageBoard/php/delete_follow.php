<?php
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_POST);
$parameters = filterInputs(INPUT_POST, ["following_user_name", "followed_user_name"]);
$followingUserName = $parameters["following_user_name"];
$followedUserName = $parameters["followed_user_name"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "DELETE FROM follow WHERE following_user_name = ? AND followed_user_name = ?";
    $bindValues = [$followingUserName, $followedUserName];
    $bindParams = [PDO::PARAM_STR, PDO::PARAM_STR];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        echo "OK";
    } else {
        echo $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}

