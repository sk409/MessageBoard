<?php
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_POST);
$parameters = filterInputs(INPUT_POST, ["source_message_user_name", "source_message_id", "dest_message_user_name", "dest_message_id"]);
$sourceMessageUserName = $parameters["source_message_user_name"];
$sourceMessageID = $parameters["source_message_id"];
$destMessageUserName = $parameters["dest_message_user_name"];
$destMessageUserID = $parameters["dest_message_id"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "INSERT INTO reply(source_message_user_name, source_message_id, dest_message_user_name, dest_message_id) values(?, ?, ?, ?)";
    $bindValues = [$sourceMessageUserName, $sourceMessageID, $destMessageUserName, $destMessageUserID];
    $bindParams = [PDO::PARAM_STR, PDO::PARAM_INT, PDO::PARAM_STR, PDO::PARAM_INT];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        echo "OK";
    } else {
        echo $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}