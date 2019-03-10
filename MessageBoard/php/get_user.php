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
    $sql = "SELECT name FROM user WHERE name LIKE(?)";
    $bindValues = ["%" . $userName . "%"];
    $bindParams = [PDO::PARAM_STR];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        $results = $databaseHandler->fetchAll(PDO::FETCH_NUM);
        $values = [];
        foreach ($results as $result) {
            $values[] = $result[0];
        }
        echo json_encode(array_values($values));
    } else {
        echo $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}