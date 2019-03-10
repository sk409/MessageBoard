<?php
require_once("application_settings.php");
require_once("database_handler.php");
require_once("utils/utils.php");
$applicationSettings = new ApplicationSettings(INPUT_GET);
$messageUserNames = $_GET["message_user_names"];
$viewerUserName = $_GET["viewer_user_name"];
$databaseHandler = new DatabaseHandler();
$databaseHandler->initializeWithApplicationSettings($applicationSettings);
if ($databaseHandler->isAvailable()) {
    $sql = "SELECT m.id, m.usr_name userName, m.contents, m.created_at createdAt, f.favorite_count favoriteCount, r.reply_count replyCount, EXISTS(SELECT * FROM favorite WHERE favorite.usr_name = ? AND message_user_name = m.usr_name AND message_id = m.id) isFavorite
    FROM
    (SELECT id, usr_name, contents, created_at FROM message WHERE usr_name IN (%s) AND NOT EXISTS(SELECT * FROM reply WHERE source_message_id = id AND source_message_user_name = usr_name)) m
    LEFT JOIN
    (SELECT message_id, message_user_name, COUNT(*) favorite_count FROM favorite WHERE message_user_name IN (%s) GROUP BY message_id, message_user_name) f
    ON id = message_id
    LEFT JOIN
    (SELECT dest_message_id, COUNT(*) reply_count FROM reply WHERE dest_message_user_name IN (%s) GROUP BY dest_message_user_name, dest_message_id) r
    ON id = dest_message_id
    ORDER BY createdAt";
    $placeholders = implode(",", array_fill(0, count($messageUserNames), "?"));
    $sql = sprintf($sql, $placeholders, $placeholders, $placeholders);
    $bindValues = array_merge(array_merge(array_merge([$viewerUserName], $messageUserNames), $messageUserNames), $messageUserNames);
    $bindParams = array_fill(0, count($messageUserNames) * 3 + 1, PDO::PARAM_STR);
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