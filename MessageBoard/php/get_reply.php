<?php
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_GET);
$parameters = filterInputs(INPUT_GET, [ "dest_message_id", "dest_message_user_name", "viewer_user_name"]);
$destMessageID = $parameters["dest_message_id"];
$destMessageUserName = $parameters["dest_message_user_name"];
$viewerUserName = $parameters["viewer_user_name"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "SELECT m.id, m.usr_name userName, m.contents, m.created_at createdAt, f.favorite_count favoriteCount, r.reply_count replyCount, EXISTS(SELECT * FROM favorite WHERE favorite.usr_name = ? AND message_user_name = m.usr_name AND message_id = m.id) isFavorite
    FROM
    (SELECT id, usr_name, contents, created_at FROM message WHERE (?, ?) = (SELECT dest_message_id, dest_message_user_name FROM reply WHERE source_message_id = id AND source_message_user_name = usr_name)) m
    LEFT JOIN
    (SELECT message_id, message_user_name, COUNT(*) favorite_count FROM favorite GROUP BY message_id, message_user_name) f
    ON id = message_id AND usr_name = message_user_name
    LEFT JOIN
    (SELECT dest_message_id, dest_message_user_name, COUNT(*) reply_count FROM reply GROUP BY dest_message_user_name, dest_message_id) r
    ON id = dest_message_id AND usr_name = dest_message_user_name
    ORDER BY createdAt";
    $bindValues = [$viewerUserName, $destMessageID, $destMessageUserName];
    $bindParams = [PDO::PARAM_STR, PDO::PARAM_INT, PDO::PARAM_STR];
    $succeeded = $databaseHandler->execute($sql, $bindValues, $bindParams);
    if ($succeeded) {
        $result = $databaseHandler->fetchAll();
        echo json_encode($result);
    } else {
        echo $databaseHandler->getErrorMessage();
    }
} else {
    echo $databaseHandler->getErrorMessage();
}