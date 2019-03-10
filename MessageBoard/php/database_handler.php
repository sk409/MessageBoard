<?php
require_once("application_settings.php");

class DatabaseHandler {

    private $pdo = null;
    private $statement = null;
    private $errorMessage = "";

    function initialize(string $appAdminUserName, string $appAdminUserPassword, string $appDatabaseName, string $databaseServerHost) {
        $dsn = "mysql:host={$databaseServerHost};dbname={$appDatabaseName};charset=utf8";
        $options = [PDO::ATTR_EMULATE_PREPARES=>false, PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION];
        try {
            $this->pdo = new PDO($dsn, $appAdminUserName, $appAdminUserPassword, $options);
        } catch(Exception $exception) {
            $this->errorMessage = $exception->getMessage();
        }
    }

    function initializeWithApplicationSettings(ApplicationSettings $applicationSettings) {
        $this->initialize($applicationSettings->getAppAdminUserName(),
         $applicationSettings->getAppAdminUserPassword(),
         $applicationSettings->getAppDatabaseName(), 
         $applicationSettings->getDatabaseServerHost()
        );
    }

    function query(string $sql): bool {
        try {
            $this->pdo->query($sql);
            return true;
        } catch(Exception $exception) {
            $this->errorMessage = $exception->getMessage();
            return false;
        }
    }

    function execute(string $sql, array $bindValues, array $bindParams): bool {
        assert(count($bindValues) === count($bindParams));
        try {
            $this->statement = $this->pdo->prepare($sql);
            for ($i = 0; $i < count($bindValues); ++$i) {
                $this->statement->bindValue($i + 1, $bindValues[$i], $bindParams[$i]);
            }
            $this->statement->execute();
            return true;
        } catch (Exception $exception) {
            $this->errorMessage = $exception->getMessage();
            return false;
        }
    }

    function fetchAll(int $fetchStyle = PDO::FETCH_ASSOC): ?array {
        if (is_null($this->statement)) {
            return null;
        }
        return $this->statement->fetchAll($fetchStyle);
    }

    function getJSON() {
        if (is_null($this->statement)) {
            return null;
        }
        return json_encode($this->statement->fetchAll());
    }

    function getStatement() {
        return $this->statement;
    }

    function getErrorMessage() {
        return $this->errorMessage;
    }

    function isAvailable(): bool {
        if (is_null($this->pdo)) {
            return false;
        }
        return true;
    }

}