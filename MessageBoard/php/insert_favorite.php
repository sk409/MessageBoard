<?php
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
    $sql = "INSERT INTO favorite(usr_name, message_user_name, message_id) VALUES(?, ?, ?)";
    $bindValues = [$userName, $messageUserName, $messageID];
    $bindParams = [PDO::PARAM_STR, PDO::PARAM_STR, PDO::PARAM_INT];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        echo "OK";
    } else {
        echo $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}