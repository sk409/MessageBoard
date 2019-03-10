<?php
require_once("utils/utils.php");

class ApplicationSettings {
    
    private $appAdminUserName = "";
    private $appAdminUserPassword = "";
    private $appDatabaseName = "";
    private $databaseServerHost = "";

    
    function __construct(int $input_type) {
        $parameters = filterInputs($input_type, ["app_admin_user_name", "app_admin_user_password", "app_database_name", "database_server_host"]);
        $this->appAdminUserName = $parameters["app_admin_user_name"];
        $this->appAdminUserPassword = $parameters["app_admin_user_password"];
        $this->appDatabaseName = $parameters["app_database_name"];
        $this->databaseServerHost = $parameters["database_server_host"];
    }

    function getAppAdminUserName() {
        return $this->appAdminUserName;
    }

    function getAppAdminUserPassword() {
        return $this->appAdminUserPassword;
    }

    function getAppDatabaseName() {
        return $this->appDatabaseName;
    }

    function getDatabaseServerHost() {
        return $this->databaseServerHost;
    }

}